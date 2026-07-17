/// 瓶子模型
/// 对应Supabase中的bottles表
library;

/// 瓶子数据模型
class Bottle {
  /// 瓶子唯一ID
  final String id;

  /// 扔瓶子的用户ID
  final String senderId;

  /// 发送者昵称
  final String senderNickname;

  /// 发送者国家代码
  final String? senderCountryCode;

  /// 发送者国家名称
  final String? senderCountryName;

  /// 发送者语言
  final String senderLanguage;

  /// 瓶子内容
  final String content;

  /// 话题标签
  final String? tag;

  /// 瓶子状态：floating(漂流中)、caught(已被捞起)、expired(已过期)
  final String status;

  /// 捞起者用户ID
  final String? catcherId;

  /// 创建时间
  final DateTime createdAt;

  /// 被捞起的时间
  final DateTime? caughtAt;

  /// 过期时间
  final DateTime? expiresAt;

  const Bottle({
    required this.id,
    required this.senderId,
    required this.senderNickname,
    this.senderCountryCode,
    this.senderCountryName,
    required this.senderLanguage,
    required this.content,
    this.tag,
    required this.status,
    this.catcherId,
    required this.createdAt,
    this.caughtAt,
    this.expiresAt,
  });

  /// 从JSON构造
  factory Bottle.fromJson(Map<String, dynamic> json) {
    return Bottle(
      id: json['id'] as String,
      senderId: json['sender_id'] as String,
      senderNickname: json['sender_nickname'] as String? ?? '匿名',
      senderCountryCode: json['sender_country_code'] as String?,
      senderCountryName: json['sender_country_name'] as String?,
      senderLanguage: json['sender_language'] as String? ?? 'zh',
      content: json['content'] as String,
      tag: json['tag'] as String?,
      status: json['status'] as String? ?? 'floating',
      catcherId: json['catcher_id'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      caughtAt: json['caught_at'] != null
          ? DateTime.parse(json['caught_at'] as String)
          : null,
      expiresAt: json['expires_at'] != null
          ? DateTime.parse(json['expires_at'] as String)
          : null,
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender_id': senderId,
      'sender_nickname': senderNickname,
      'sender_country_code': senderCountryCode,
      'sender_country_name': senderCountryName,
      'sender_language': senderLanguage,
      'content': content,
      'tag': tag,
      'status': status,
      'catcher_id': catcherId,
      'created_at': createdAt.toIso8601String(),
      'caught_at': caughtAt?.toIso8601String(),
      'expires_at': expiresAt?.toIso8601String(),
    };
  }

  /// 复制并修改部分字段
  Bottle copyWith({
    String? id,
    String? senderId,
    String? senderNickname,
    String? senderCountryCode,
    String? senderCountryName,
    String? senderLanguage,
    String? content,
    String? tag,
    String? status,
    String? catcherId,
    DateTime? createdAt,
    DateTime? caughtAt,
    DateTime? expiresAt,
  }) {
    return Bottle(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      senderNickname: senderNickname ?? this.senderNickname,
      senderCountryCode: senderCountryCode ?? this.senderCountryCode,
      senderCountryName: senderCountryName ?? this.senderCountryName,
      senderLanguage: senderLanguage ?? this.senderLanguage,
      content: content ?? this.content,
      tag: tag ?? this.tag,
      status: status ?? this.status,
      catcherId: catcherId ?? this.catcherId,
      createdAt: createdAt ?? this.createdAt,
      caughtAt: caughtAt ?? this.caughtAt,
      expiresAt: expiresAt ?? this.expiresAt,
    );
  }
}