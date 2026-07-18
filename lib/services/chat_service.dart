/// 聊天服务
/// 负责消息发送、历史获取、实时监听、对话列表
library;

import 'dart:async';
import '../config/constants.dart';
import '../models/conversation.dart';
import '../models/message.dart';
import 'filter_service.dart';
import 'supabase_service.dart';
import 'translation_service.dart';

/// 发送消息操作结果
class SendMessageResult {
  /// 发送成功的消息（失败时为null）
  final Message? message;

  /// 错误信息（成功时为null）
  final String? errorMessage;

  /// 是否成功
  final bool success;

  const SendMessageResult._({
    this.message,
    this.errorMessage,
    required this.success,
  });

  /// 成功结果
  factory SendMessageResult.success(Message message) => SendMessageResult._(
        message: message,
        success: true,
      );

  /// 失败结果
  factory SendMessageResult.failure(String message) => SendMessageResult._(
        errorMessage: message,
        success: false,
      );
}

/// 聊天服务类
class ChatService {
  /// 翻译服务
  final TranslationService _translationService = TranslationService();

  /// 实时订阅句柄列表
  final List<StreamSubscription> _subscriptions = [];

  /// 检查用户是否还有翻译配额
  Future<bool> _hasTranslateQuota(String userId) async {
    final client = SupabaseService.instance.client;
    try {
      final response = await client
          .from('users')
          .select('today_translate_count, quota_reset_date')
          .eq('id', userId)
          .single();

      final today = DateTime.now().toIso8601String().substring(0, 10);
      final resetDate = response['quota_reset_date'] as String? ?? '';

      if (resetDate != today) {
        return true;
      }

      final count = response['today_translate_count'] as int? ?? 0;
      return count < dailyTranslateLimit;
    } catch (e) {
      return false;
    }
  }

  /// 递增翻译计数
  Future<void> _incrementTranslateCount(String userId) async {
    final client = SupabaseService.instance.client;
    try {
      await client.rpc('increment_translate_count', params: {
        'user_id': userId,
      });
    } catch (_) {}
  }

  /// 发送消息（仅发送原文，不自动翻译）
  ///
  /// 在写入数据库前会先进行内容安全检测：
  /// - 敏感词检测（色情、暴力、违法等）
  /// - 联系方式与导流信息检测（邮箱、URL、IP、手机号、社交平台关键词）
  /// - 根据发送者国家/语言应用地区化规则
  ///
  /// [conversationId] 对话ID
  /// [senderId] 发送者ID
  /// [content] 消息内容
  /// [senderNickname] 发送者昵称
  /// [sourceLanguage] 发送者语言
  /// [senderCountryCode] 发送者国家代码（用于地区化规则）
  /// 返回发送结果，包含消息或错误信息
  Future<SendMessageResult> sendMessage({
    required String conversationId,
    required String senderId,
    required String content,
    required String senderNickname,
    required String sourceLanguage,
    String? senderCountryCode,
  }) async {
    // 综合安全检测：敏感词 + 联系方式
    final safety = FilterService.checkTextSafety(
      text: content,
      countryCode: senderCountryCode,
      language: sourceLanguage,
    );

    if (!safety.isSafe) {
      return SendMessageResult.failure(safety.errorMessage(sourceLanguage));
    }

    final client = SupabaseService.instance.client;

    try {
      final response = await client.from('messages').insert({
        'conversation_id': conversationId,
        'sender_id': senderId,
        'sender_nickname': senderNickname,
        'content': content.trim(),
        'source_language': sourceLanguage,
        'translated_content': null,
        'target_language': null,
        'is_read': false,
      }).select().single();

      // 更新对话的最后消息、发送者和未读数（失败不影响主流程）
      try {
        final now = DateTime.now().toIso8601String();
        await client.rpc('increment_conversation_unread', params: {
          'p_conversation_id': conversationId,
          'p_sender_id': senderId,
          'p_last_message': content.trim(),
          'p_last_message_at': now,
        });
      } catch (_) {}

      return SendMessageResult.success(Message.fromJson(response));
    } catch (e) {
      return SendMessageResult.failure(_networkErrorMessage(sourceLanguage));
    }
  }

  /// 根据用户语言返回网络错误消息
  String _networkErrorMessage(String language) {
    switch (language.toLowerCase()) {
      case 'en':
        return 'Failed to send, please check your network';
      case 'ja':
        return '送信に失敗しました。ネットワークを確認してください';
      case 'ko':
        return '전송 실패, 네트워크를 확인해 주세요';
      default:
        return '发送失败，请检查网络后重试';
    }
  }

  /// 翻译单条消息
  /// [messageId] 消息ID
  /// [userId] 执行翻译的用户ID（用于扣除配额）
  /// [content] 原文内容
  /// [sourceLanguage] 原文语言
  /// [targetLanguage] 目标语言
  /// 返回翻译后的文本，null 表示翻译失败或无配额
  Future<String?> translateMessage({
    required String messageId,
    required String userId,
    required String content,
    required String sourceLanguage,
    required String targetLanguage,
  }) async {
    // 同语言无需翻译
    if (sourceLanguage.toLowerCase() == targetLanguage.toLowerCase()) {
      return content;
    }

    // 检查配额
    final hasQuota = await _hasTranslateQuota(userId);
    if (!hasQuota) {
      return null;
    }

    // 调用翻译服务
    final translated = await _translationService.translate(
      text: content,
      sourceLang: sourceLanguage,
      targetLang: targetLanguage,
    );

    if (translated == null || translated.isEmpty) {
      return null;
    }

    final client = SupabaseService.instance.client;

    try {
      // 更新消息翻译结果
      await client.from('messages').update({
        'translated_content': translated,
        'target_language': targetLanguage,
      }).eq('id', messageId);

      // 扣减翻译配额
      await _incrementTranslateCount(userId);

      return translated;
    } catch (_) {
      return translated;
    }
  }

  /// 删除单条消息
  Future<bool> deleteMessage({
    required String messageId,
  }) async {
    final client = SupabaseService.instance.client;
    try {
      await client.from('messages').delete().eq('id', messageId);
      return true;
    } catch (_) {
      return false;
    }
  }

  /// 删除整个对话及其消息
  Future<bool> deleteConversation({
    required String conversationId,
  }) async {
    final client = SupabaseService.instance.client;
    try {
      // 先删除消息，再删除对话
      await client.from('messages').delete().eq('conversation_id', conversationId);
      await client.from('conversations').delete().eq('id', conversationId);
      return true;
    } catch (_) {
      return false;
    }
  }

  /// 获取对话的历史消息
  /// [conversationId] 对话ID
  /// [limit] 获取数量上限
  /// [offset] 偏移量（分页用）
  Future<List<Message>> getMessages({
    required String conversationId,
    int limit = 30,
    int offset = 0,
  }) async {
    final client = SupabaseService.instance.client;

    try {
      final response = await client
          .from('messages')
          .select()
          .eq('conversation_id', conversationId)
          .order('created_at', ascending: true)
          .range(offset, offset + limit - 1);

      return (response as List)
          .map((e) => Message.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  /// 实时监听对话中的新消息
  /// [conversationId] 对话ID
  /// [onNewMessage] 收到新消息的回调（调用方需通过ID去重）
  /// 返回 StreamSubscription，调用 cancel() 取消订阅
  StreamSubscription subscribeToMessages({
    required String conversationId,
    required void Function(Message) onNewMessage,
  }) {
    final client = SupabaseService.instance.client;

    // 使用 stream 监听 messages 表变化
    // stream 会先返回当前数据，再推送增量
    // 调用方通过 ID 去重避免重复显示
    final subscription = client
        .from('messages')
        .stream(primaryKey: ['id'])
        .eq('conversation_id', conversationId)
        .order('created_at')
        .listen((List<Map<String, dynamic>> data) {
      for (final row in data) {
        try {
          final message = Message.fromJson(row);
          onNewMessage(message);
        } catch (_) {}
      }
    });

    _subscriptions.add(subscription);
    return subscription;
  }

  /// 订阅对话列表的实时变化
  /// [userId] 当前用户ID
  /// [onChanged] 对话变化的回调
  /// 返回 StreamSubscription，调用 cancel() 取消订阅
  StreamSubscription subscribeToConversations({
    required String userId,
    required void Function() onChanged,
  }) {
    final client = SupabaseService.instance.client;

    // 监听当前用户作为 user1 (扔瓶人) 的对话
    final stream1 = client
        .from('conversations')
        .stream(primaryKey: ['id'])
        .eq('user1_id', userId);

    // 监听当前用户作为 user2 (捞瓶人) 的对话
    final stream2 = client
        .from('conversations')
        .stream(primaryKey: ['id'])
        .eq('user2_id', userId);

    // 使用 StreamController 合并两个子流，返回统一的订阅
    // cancel 主订阅时会关闭 controller，自动取消子订阅
    final controller = StreamController<void>.broadcast();

    void forward(void _) {
      if (!controller.isClosed) controller.add(null);
    }

    final sub1 = stream1.listen(forward, onError: (Object e) {
      if (!controller.isClosed) controller.addError(e);
    });
    final sub2 = stream2.listen(forward, onError: (Object e) {
      if (!controller.isClosed) controller.addError(e);
    });

    final subscription = controller.stream.listen((_) => onChanged());

    // 包装 cancel 方法，确保关闭 controller 并取消子订阅
    final wrapped = _CompositeSubscription(
      [sub1, sub2, subscription],
      onCancel: controller.close,
    );
    _subscriptions.add(wrapped);
    return wrapped;
  }

  /// 获取用户的对话列表
  /// [userId] 当前用户ID
  /// 返回未过期的活跃对话列表，按最后消息时间降序
  Future<List<Conversation>> getConversations({
    required String userId,
  }) async {
    final client = SupabaseService.instance.client;

    try {
      final response = await client
          .from('conversations')
          .select()
          .or('user1_id.eq.$userId,user2_id.eq.$userId')
          .eq('status', 'active')
          .gt('expires_at', DateTime.now().toIso8601String())
          .order('last_message_at', ascending: false);

      return (response as List)
          .map((e) => Conversation.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  /// 取消所有实时订阅
  void dispose() {
    for (final sub in _subscriptions) {
      sub.cancel();
    }
    _subscriptions.clear();
  }
  /// 标记对话中对方发送的未读消息为已读
  /// [conversationId] 对话ID
  /// [userId] 当前用户ID（只标记对方发的消息）
  Future<void> markMessagesAsRead({
    required String conversationId,
    required String userId,
  }) async {
    final client = SupabaseService.instance.client;

    try {
      // 将对话中对方发送的未读消息标记为已读
      await client.from('messages').update({
        'is_read': true,
      }).eq('conversation_id', conversationId).neq('sender_id', userId).eq(
            'is_read',
            false,
          );

      // 只有当最后一条消息是对方发的时，才重置未读数
      // （如果最后一条是我发的，unread_count 是对方的未读数，不该清零）
      final conv = await client
          .from('conversations')
          .select('last_sender_id')
          .eq('id', conversationId)
          .single();

      final lastSenderId = conv['last_sender_id'] as String?;
      if (lastSenderId != null && lastSenderId != userId) {
        await client.from('conversations').update({
          'unread_count': 0,
        }).eq('id', conversationId);
      }
    } catch (_) {}
  }
}

/// 组合多个 StreamSubscription，cancel 时统一清理
class _CompositeSubscription implements StreamSubscription<dynamic> {
  final List<StreamSubscription> _subs;
  final Future<void> Function()? _onCancel;
  bool _canceled = false;

  _CompositeSubscription(this._subs, {Future<void> Function()? onCancel})
      : _onCancel = onCancel;

  @override
  Future<void> cancel() async {
    if (_canceled) return;
    _canceled = true;
    for (final sub in _subs) {
      await sub.cancel();
    }
    if (_onCancel != null) {
      await _onCancel();
    }
  }

  @override
  bool get isPaused => _subs.any((sub) => sub.isPaused);

  @override
  void onData(void Function(dynamic data)? handleData) {}

  @override
  void onDone(void Function()? handleDone) {}

  @override
  void onError(Function? handleError) {}

  @override
  void pause([Future<void>? resumeSignal]) {
    for (final sub in _subs) {
      sub.pause(resumeSignal);
    }
  }

  @override
  void resume() {
    for (final sub in _subs) {
      sub.resume();
    }
  }

  @override
  Future<E> asFuture<E>([E? futureValue]) {
    final completer = Completer<E>.sync();
    onDone(() {
      if (completer.isCompleted) return;
      if (futureValue != null) {
        completer.complete(futureValue);
      } else {
        completer.complete(futureValue as E);
      }
    });
    onError(completer.completeError);
    return completer.future;
  }
}