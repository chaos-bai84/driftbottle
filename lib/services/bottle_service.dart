/// 瓶子服务
/// 负责瓶子的创建、捞取、丢弃等操作
library;

import 'dart:async';
import '../models/bottle.dart';
import 'supabase_service.dart';
import 'filter_service.dart';

/// 扔瓶子操作结果
class ThrowBottleResult {
  /// 创建成功的瓶子（失败时为null）
  final Bottle? bottle;

  /// 错误信息（成功时为null）
  final String? errorMessage;

  /// 是否成功
  final bool success;

  /// 错误信息所用的语言代码
  final String language;

  const ThrowBottleResult._({
    this.bottle,
    this.errorMessage,
    required this.success,
    required this.language,
  });

  /// 成功结果
  factory ThrowBottleResult.success(Bottle bottle, String language) =>
      ThrowBottleResult._(bottle: bottle, success: true, language: language);

  /// 失败结果
  factory ThrowBottleResult.failure(String message, String language) =>
      ThrowBottleResult._(
        errorMessage: message,
        success: false,
        language: language,
      );

  /// 网络或系统错误
  factory ThrowBottleResult.networkError(String language) {
    const messages = {
      'zh': '发送失败，请检查网络后重试',
      'en': 'Failed to send, please check your network',
      'ja': '送信に失敗しました。ネットワークを確認してください',
      'ko': '전송 실패, 네트워크를 확인해 주세요',
    };
    return ThrowBottleResult._(
      errorMessage: messages[language.toLowerCase()] ?? messages['zh']!,
      success: false,
      language: language,
    );
  }
}

/// 瓶子服务类
class BottleService {
  /// 扔瓶子
  ///
  /// 在写入数据库前会先进行内容安全检测：
  /// - 敏感词检测（色情、暴力、违法等）
  /// - 联系方式与导流信息检测（邮箱、URL、IP、手机号、社交平台关键词）
  /// - 根据用户国家/语言应用地区化规则
  ///
  /// [senderId] 发送者用户ID
  /// [content] 瓶子内容
  /// [tag] 话题标签
  /// [senderNickname] 发送者昵称
  /// [senderCountryCode] 发送者国家代码
  /// [senderCountryName] 发送者国家名称
  /// [senderLanguage] 发送者语言
  Future<ThrowBottleResult> throwBottle({
    required String senderId,
    required String content,
    String? tag,
    required String senderNickname,
    String? senderCountryCode,
    String? senderCountryName,
    required String senderLanguage,
  }) async {
    // 综合安全检测：敏感词 + 联系方式
    final safety = FilterService.checkTextSafety(
      text: content,
      countryCode: senderCountryCode,
      language: senderLanguage,
    );

    if (!safety.isSafe) {
      return ThrowBottleResult.failure(
        safety.errorMessage(senderLanguage),
        senderLanguage,
      );
    }

    final client = SupabaseService.instance.client;

    try {
      final response = await client
          .from('bottles')
          .insert({
            'sender_id': senderId,
            'sender_nickname': senderNickname,
            'sender_country_code': senderCountryCode,
            'sender_country_name': senderCountryName,
            'sender_language': senderLanguage,
            'content': content.trim(),
            'tag': tag,
            'status': 'floating',
            'expires_at': DateTime.now()
                .add(const Duration(days: 7))
                .toIso8601String(),
          })
          .select()
          .single();

      // 更新用户扔瓶子计数（失败不影响主流程）
      try {
        await client.rpc(
          'increment_throw_count',
          params: {'user_id': senderId},
        );
      } catch (_) {}

      final bottle = Bottle.fromJson(response);
      return ThrowBottleResult.success(bottle, senderLanguage);
    } catch (e) {
      return ThrowBottleResult.networkError(senderLanguage);
    }
  }

  /// 随机捞一个漂流中的瓶子
  /// [catcherId] 捞瓶子的用户ID
  /// 返回捞到的瓶子，如果没有可捞的瓶子返回null
  Future<Bottle?> catchBottle({required String catcherId}) async {
    final client = SupabaseService.instance.client;

    try {
      // 调用RPC随机捞瓶子（排除自己扔的）
      final response = await client.rpc(
        'catch_random_bottle',
        params: {'p_catcher_id': catcherId},
      );

      if (response == null) return null;

      // 更新用户捞瓶子计数（失败不影响主流程）
      try {
        await client.rpc(
          'increment_catch_count',
          params: {'user_id': catcherId},
        );
      } catch (_) {}

      return Bottle.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      return null;
    }
  }

  /// 按话题标签捞一个漂流中的瓶子
  /// 如果 [tags] 为空或为 null，则与 catchBottle 行为一致（不筛选）
  ///
  /// 对应需求文档 378 行：话题标签筛选（捞瓶方）
  /// 注意：原需求中此为付费版功能，V1.0 阶段免费开放
  ///
  /// [catcherId] 捞瓶子的用户ID
  /// [tags] 话题标签数组（如 ['#旅行', '#美食']）
  Future<Bottle?> catchBottleWithTags({
    required String catcherId,
    List<String>? tags,
  }) async {
    final client = SupabaseService.instance.client;
    final hasTags = tags != null && tags.isNotEmpty;

    try {
      // 优先尝试调用 catch_bottle_by_tags RPC（需要用户在Supabase中手动应用schema）
      try {
        final response = await client.rpc(
          'catch_bottle_by_tags',
          params: {'p_catcher_id': catcherId, 'p_tags': hasTags ? tags : null},
        );

        if (response == null) return null;

        // 更新用户捞瓶子计数（失败不影响主流程）
        try {
          await client.rpc(
            'increment_catch_count',
            params: {'user_id': catcherId},
          );
        } catch (_) {}

        return Bottle.fromJson(response as Map<String, dynamic>);
      } catch (_) {
        // RPC 不存在时回退到客户端实现
        return await _catchBottleClientImpl(catcherId, tags);
      }
    } catch (e) {
      return null;
    }
  }

  /// 客户端实现的按标签捞瓶子（当 RPC catch_bottle_by_tags 未部署时的后备方案）
  /// 注意：客户端实现存在并发竞态风险，多用户同时捞同一瓶子的概率较低，MVP 阶段可接受
  Future<Bottle?> _catchBottleClientImpl(
    String catcherId,
    List<String>? tags,
  ) async {
    final client = SupabaseService.instance.client;
    final hasTags = tags != null && tags.isNotEmpty;

    try {
      // 查询符合条件的瓶子（最多50条）
      final response = await client
          .from('bottles')
          .select()
          .neq('sender_id', catcherId)
          .eq('status', 'floating')
          .order('created_at', ascending: false)
          .limit(50);

      final List<Map<String, dynamic>> bottlesData = (response as List)
          .cast<Map<String, dynamic>>();

      // 在客户端按标签过滤
      List<Bottle> candidates;
      if (hasTags) {
        final tagsList = tags;
        candidates = bottlesData.map((e) => Bottle.fromJson(e)).where((b) {
          if (b.tag == null || b.tag!.isEmpty) return false;
          for (final t in tagsList) {
            if (b.tag!.toLowerCase().contains(t.toLowerCase())) {
              return true;
            }
          }
          return false;
        }).toList();
      } else {
        candidates = bottlesData.map((e) => Bottle.fromJson(e)).toList();
      }

      // 同时过滤掉已过期的瓶子
      final now = DateTime.now();
      candidates = candidates
          .where((b) => b.expiresAt == null || b.expiresAt!.isAfter(now))
          .toList();

      if (candidates.isEmpty) return null;

      // 随机选一个
      candidates.shuffle();
      final selected = candidates.first;

      // 更新瓶子状态为已捞起
      await client
          .from('bottles')
          .update({'status': 'caught', 'catcher_id': catcherId})
          .eq('id', selected.id);

      // 更新用户捞瓶子计数（失败不影响主流程）
      try {
        await client.rpc(
          'increment_catch_count',
          params: {'user_id': catcherId},
        );
      } catch (_) {}

      // 返回更新后的瓶子
      final updated = await client
          .from('bottles')
          .select()
          .eq('id', selected.id)
          .maybeSingle();

      if (updated == null) return null;
      return Bottle.fromJson(updated);
    } catch (e) {
      return null;
    }
  }

  /// 丢回瓶子（不回复，重新放回海里）
  /// [bottleId] 瓶子ID
  Future<bool> discardBottle({required String bottleId}) async {
    final client = SupabaseService.instance.client;

    try {
      await client
          .from('bottles')
          .update({'status': 'floating', 'catcher_id': null, 'caught_at': null})
          .eq('id', bottleId);

      return true;
    } catch (e) {
      return false;
    }
  }

  /// 获取瓶子详情
  /// [bottleId] 瓶子ID
  Future<Bottle?> getBottleDetail({required String bottleId}) async {
    final client = SupabaseService.instance.client;

    try {
      final response = await client
          .from('bottles')
          .select()
          .eq('id', bottleId)
          .maybeSingle();

      if (response == null) return null;
      return Bottle.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  /// 获取用户扔出的瓶子列表（按创建时间倒序）
  /// [senderId] 发送者用户ID
  /// [limit] 返回数量上限
  Future<List<Bottle>> getMyBottles({
    required String senderId,
    int limit = 50,
  }) async {
    final client = SupabaseService.instance.client;

    try {
      final response = await client
          .from('bottles')
          .select()
          .eq('sender_id', senderId)
          .order('created_at', ascending: false)
          .limit(limit);

      return (response as List)
          .map((e) => Bottle.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  /// 订阅用户瓶子状态变化（瓶子被捞起时触发回调）
  /// [senderId] 发送者用户ID
  /// [onChanged] 瓶子状态变化的回调
  /// 返回 StreamSubscription，调用 cancel() 取消订阅
  StreamSubscription subscribeToMyBottles({
    required String senderId,
    required void Function() onChanged,
  }) {
    final client = SupabaseService.instance.client;

    return client
        .from('bottles')
        .stream(primaryKey: ['id'])
        .eq('sender_id', senderId)
        .listen((_) => onChanged());
  }
}
