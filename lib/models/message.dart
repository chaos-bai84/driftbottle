/// 消息模型
/// 对应Supabase中的messages表
library;

/// 消息数据模型
class Message {
  /// 消息唯一ID
  final String id;

  /// 所属对话ID
  final String conversationId;

  /// 发送者用户ID
  final String senderId;

  /// 发送者昵称
  final String senderNickname;

  /// 原始消息内容（发送者的语言）
  final String content;

  /// 发送者的语言代码
  final String sourceLanguage;

  /// 翻译后的消息内容（接收者的语言）
  final String? translatedContent;

  /// 翻译的目标语言代码
  final String? targetLanguage;

  /// 消息是否已读
  final bool isRead;

  /// 创建时间
  final DateTime createdAt;

  const Message({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.senderNickname,
    required this.content,
    required this.sourceLanguage,
    this.translatedContent,
    this.targetLanguage,
    this.isRead = false,
    required this.createdAt,
  });

  /// 从JSON构造
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] as String,
      conversationId: json['conversation_id'] as String,
      senderId: json['sender_id'] as String,
      senderNickname: json['sender_nickname'] as String? ?? '匿名',
      content: json['content'] as String,
      sourceLanguage: json['source_language'] as String? ?? 'zh',
      translatedContent: json['translated_content'] as String?,
      targetLanguage: json['target_language'] as String?,
      isRead: json['is_read'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'conversation_id': conversationId,
      'sender_id': senderId,
      'sender_nickname': senderNickname,
      'content': content,
      'source_language': sourceLanguage,
      'translated_content': translatedContent,
      'target_language': targetLanguage,
      'is_read': isRead,
      'created_at': createdAt.toIso8601String(),
    };
  }

  /// 复制并修改部分字段
  Message copyWith({
    String? id,
    String? conversationId,
    String? senderId,
    String? senderNickname,
    String? content,
    String? sourceLanguage,
    String? translatedContent,
    String? targetLanguage,
    bool? isRead,
    DateTime? createdAt,
  }) {
    return Message(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      senderId: senderId ?? this.senderId,
      senderNickname: senderNickname ?? this.senderNickname,
      content: content ?? this.content,
      sourceLanguage: sourceLanguage ?? this.sourceLanguage,
      translatedContent: translatedContent ?? this.translatedContent,
      targetLanguage: targetLanguage ?? this.targetLanguage,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}