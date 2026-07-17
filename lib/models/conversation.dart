/// 对话模型
/// 对应Supabase中的conversations表
library;

/// 对话数据模型
class Conversation {
  /// 对话唯一ID
  final String id;

  /// 瓶子ID（关联的原始瓶子）
  final String bottleId;

  /// 扔瓶子的用户ID（user1 = 发送方）
  final String user1Id;

  /// 捞瓶子的用户ID（user2 = 接收方）
  final String user2Id;

  /// user1的昵称（扔瓶人）
  final String user1Nickname;

  /// user1的国家代码
  final String? user1CountryCode;

  /// user1的国家名称
  final String? user1CountryName;

  /// user1的语言
  final String user1Language;

  /// user2的昵称（捞瓶人）
  final String user2Nickname;

  /// user2的国家代码
  final String? user2CountryCode;

  /// user2的国家名称
  final String? user2CountryName;

  /// user2的语言
  final String user2Language;

  /// 最后一条消息内容
  final String? lastMessage;

  /// 最后一条消息时间
  final DateTime? lastMessageAt;

  /// 最后一条消息发送者ID
  final String? lastSenderId;

  /// 未读消息数（最后一条消息接收方的未读数）
  final int unreadCount;

  /// 对话状态：active(活跃)、archived(已归档)、expired(已过期)
  final String status;

  /// 创建时间
  final DateTime createdAt;

  const Conversation({
    required this.id,
    required this.bottleId,
    required this.user1Id,
    required this.user2Id,
    required this.user1Nickname,
    this.user1CountryCode,
    this.user1CountryName,
    required this.user1Language,
    required this.user2Nickname,
    this.user2CountryCode,
    this.user2CountryName,
    required this.user2Language,
    this.lastMessage,
    this.lastMessageAt,
    this.lastSenderId,
    this.unreadCount = 0,
    this.status = 'active',
    required this.createdAt,
  });

  /// 根据当前用户ID获取对方的昵称
  String getPartnerNickname(String currentUserId) {
    if (currentUserId == user1Id) return user2Nickname;
    return user1Nickname;
  }

  /// 根据当前用户ID获取对方的国家代码
  String? getPartnerCountryCode(String currentUserId) {
    if (currentUserId == user1Id) return user2CountryCode;
    return user1CountryCode;
  }

  /// 根据当前用户ID获取对方的国家名称
  String? getPartnerCountryName(String currentUserId) {
    if (currentUserId == user1Id) return user2CountryName;
    return user1CountryName;
  }

  /// 根据当前用户ID获取对方的语言
  String getPartnerLanguage(String currentUserId) {
    if (currentUserId == user1Id) return user2Language;
    return user1Language;
  }

  /// 获取当前用户未读数
  /// 只有最后一条消息是对方发的，unreadCount 才是当前用户的未读
  int getMyUnreadCount(String currentUserId) {
    if (lastSenderId == null) return 0;
    if (lastSenderId == currentUserId) return 0;
    return unreadCount;
  }

  /// 从JSON构造
  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['id'] as String,
      bottleId: json['bottle_id'] as String,
      user1Id: json['user1_id'] as String,
      user2Id: json['user2_id'] as String,
      user1Nickname: json['user1_nickname'] as String? ??
          json['partner_nickname'] as String? ??
          '匿名',
      user1CountryCode: json['user1_country_code'] as String? ??
          json['partner_country_code'] as String?,
      user1CountryName: json['user1_country_name'] as String? ??
          json['partner_country_name'] as String?,
      user1Language: json['user1_language'] as String? ??
          json['partner_language'] as String? ??
          'zh',
      user2Nickname: json['user2_nickname'] as String? ?? '匿名',
      user2CountryCode: json['user2_country_code'] as String?,
      user2CountryName: json['user2_country_name'] as String?,
      user2Language: json['user2_language'] as String? ?? 'zh',
      lastMessage: json['last_message'] as String?,
      lastMessageAt: json['last_message_at'] != null
          ? DateTime.parse(json['last_message_at'] as String)
          : null,
      lastSenderId: json['last_sender_id'] as String?,
      unreadCount: json['unread_count'] as int? ?? 0,
      status: json['status'] as String? ?? 'active',
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bottle_id': bottleId,
      'user1_id': user1Id,
      'user2_id': user2Id,
      'user1_nickname': user1Nickname,
      'user1_country_code': user1CountryCode,
      'user1_country_name': user1CountryName,
      'user1_language': user1Language,
      'user2_nickname': user2Nickname,
      'user2_country_code': user2CountryCode,
      'user2_country_name': user2CountryName,
      'user2_language': user2Language,
      'last_message': lastMessage,
      'last_message_at': lastMessageAt?.toIso8601String(),
      'last_sender_id': lastSenderId,
      'unread_count': unreadCount,
      'status': status,
      'created_at': createdAt.toIso8601String(),
    };
  }

  /// 复制并修改部分字段
  Conversation copyWith({
    String? id,
    String? bottleId,
    String? user1Id,
    String? user2Id,
    String? user1Nickname,
    String? user1CountryCode,
    String? user1CountryName,
    String? user1Language,
    String? user2Nickname,
    String? user2CountryCode,
    String? user2CountryName,
    String? user2Language,
    String? lastMessage,
    DateTime? lastMessageAt,
    String? lastSenderId,
    int? unreadCount,
    String? status,
    DateTime? createdAt,
  }) {
    return Conversation(
      id: id ?? this.id,
      bottleId: bottleId ?? this.bottleId,
      user1Id: user1Id ?? this.user1Id,
      user2Id: user2Id ?? this.user2Id,
      user1Nickname: user1Nickname ?? this.user1Nickname,
      user1CountryCode: user1CountryCode ?? this.user1CountryCode,
      user1CountryName: user1CountryName ?? this.user1CountryName,
      user1Language: user1Language ?? this.user1Language,
      user2Nickname: user2Nickname ?? this.user2Nickname,
      user2CountryCode: user2CountryCode ?? this.user2CountryCode,
      user2CountryName: user2CountryName ?? this.user2CountryName,
      user2Language: user2Language ?? this.user2Language,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
      lastSenderId: lastSenderId ?? this.lastSenderId,
      unreadCount: unreadCount ?? this.unreadCount,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
