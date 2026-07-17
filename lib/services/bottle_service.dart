/// 瓶子服务
/// 负责瓶子的创建、捞取、丢弃等操作
library;

import '../models/bottle.dart';
import 'supabase_service.dart';
import 'filter_service.dart';

/// 瓶子服务类
class BottleService {
  /// 扔瓶子
  /// [senderId] 发送者用户ID
  /// [content] 瓶子内容
  /// [tag] 话题标签
  /// [senderNickname] 发送者昵称
  /// [senderCountryCode] 发送者国家代码
  /// [senderCountryName] 发送者国家名称
  /// [senderLanguage] 发送者语言
  /// 返回创建的瓶子，如果内容违规返回null
  Future<Bottle?> throwBottle({
    required String senderId,
    required String content,
    String? tag,
    required String senderNickname,
    String? senderCountryCode,
    String? senderCountryName,
    required String senderLanguage,
  }) async {
    // 敏感词检测
    if (!FilterService.isTextSafe(content)) {
      return null;
    }

    final client = SupabaseService.instance.client;

    try {
      final response = await client.from('bottles').insert({
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
      }).select().single();

      // 更新用户扔瓶子计数（失败不影响主流程）
      try {
        await client.rpc('increment_throw_count', params: {
          'user_id': senderId,
        });
      } catch (_) {}

      return Bottle.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  /// 随机捞一个漂流中的瓶子
  /// [catcherId] 捞瓶子的用户ID
  /// 返回捞到的瓶子，如果没有可捞的瓶子返回null
  Future<Bottle?> catchBottle({
    required String catcherId,
  }) async {
    final client = SupabaseService.instance.client;

    try {
      // 调用RPC随机捞瓶子（排除自己扔的）
      final response = await client.rpc('catch_random_bottle', params: {
        'p_catcher_id': catcherId,
      });

      if (response == null) return null;

      // 更新用户捞瓶子计数（失败不影响主流程）
      try {
        await client.rpc('increment_catch_count', params: {
          'user_id': catcherId,
        });
      } catch (_) {}

      return Bottle.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      return null;
    }
  }

  /// 丢回瓶子（不回复，重新放回海里）
  /// [bottleId] 瓶子ID
  Future<bool> discardBottle({
    required String bottleId,
  }) async {
    final client = SupabaseService.instance.client;

    try {
      await client.from('bottles').update({
        'status': 'floating',
        'catcher_id': null,
        'caught_at': null,
      }).eq('id', bottleId);

      return true;
    } catch (e) {
      return false;
    }
  }

  /// 获取瓶子详情
  /// [bottleId] 瓶子ID
  Future<Bottle?> getBottleDetail({
    required String bottleId,
  }) async {
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
}