/// 用户模型
/// 对应Supabase中的users表
library;

/// 用户数据模型
class User {
  /// 用户唯一ID（Supabase auth uid）
  final String id;

  /// 设备唯一标识
  final String deviceId;

  /// 昵称
  final String nickname;

  /// 国家代码（如 'CN', 'US'）
  final String? countryCode;

  /// 国家名称（如 '中国', '美国'）
  final String? countryName;

  /// 首选语言代码（如 'zh', 'en'）
  final String language;

  /// 用户头像URL
  final String? avatarUrl;

  /// 注册时间
  final DateTime createdAt;

  /// 最后活跃时间
  final DateTime? lastActiveAt;

  /// 今日已扔瓶子数
  final int todayThrowCount;

  /// 今日已捞瓶子数
  final int todayCatchCount;

  /// 今日已翻译次数
  final int todayTranslateCount;

  /// 配额重置日期
  final String quotaResetDate;

  const User({
    required this.id,
    required this.deviceId,
    required this.nickname,
    this.countryCode,
    this.countryName,
    required this.language,
    this.avatarUrl,
    required this.createdAt,
    this.lastActiveAt,
    this.todayThrowCount = 0,
    this.todayCatchCount = 0,
    this.todayTranslateCount = 0,
    this.quotaResetDate = '',
  });

  /// 从JSON构造
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      deviceId: json['device_id'] as String,
      nickname: json['nickname'] as String? ?? '匿名用户',
      countryCode: json['country_code'] as String?,
      countryName: json['country_name'] as String?,
      language: json['language'] as String? ?? 'zh',
      avatarUrl: json['avatar_url'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      lastActiveAt: json['last_active_at'] != null
          ? DateTime.parse(json['last_active_at'] as String)
          : null,
      todayThrowCount: json['today_throw_count'] as int? ?? 0,
      todayCatchCount: json['today_catch_count'] as int? ?? 0,
      todayTranslateCount: json['today_translate_count'] as int? ?? 0,
      quotaResetDate: json['quota_reset_date'] as String? ?? '',
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'device_id': deviceId,
      'nickname': nickname,
      'country_code': countryCode,
      'country_name': countryName,
      'language': language,
      'avatar_url': avatarUrl,
      'created_at': createdAt.toIso8601String(),
      'last_active_at': lastActiveAt?.toIso8601String(),
      'today_throw_count': todayThrowCount,
      'today_catch_count': todayCatchCount,
      'today_translate_count': todayTranslateCount,
      'quota_reset_date': quotaResetDate,
    };
  }

  /// 是否为新用户（注册24小时内）
  bool get isNewUser {
    final now = DateTime.now();
    final duration = now.difference(createdAt);
    return duration < const Duration(hours: 24);
  }

  /// 复制并修改部分字段
  User copyWith({
    String? id,
    String? deviceId,
    String? nickname,
    String? countryCode,
    String? countryName,
    String? language,
    String? avatarUrl,
    DateTime? createdAt,
    DateTime? lastActiveAt,
    int? todayThrowCount,
    int? todayCatchCount,
    int? todayTranslateCount,
    String? quotaResetDate,
  }) {
    return User(
      id: id ?? this.id,
      deviceId: deviceId ?? this.deviceId,
      nickname: nickname ?? this.nickname,
      countryCode: countryCode ?? this.countryCode,
      countryName: countryName ?? this.countryName,
      language: language ?? this.language,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      createdAt: createdAt ?? this.createdAt,
      lastActiveAt: lastActiveAt ?? this.lastActiveAt,
      todayThrowCount: todayThrowCount ?? this.todayThrowCount,
      todayCatchCount: todayCatchCount ?? this.todayCatchCount,
      todayTranslateCount: todayTranslateCount ?? this.todayTranslateCount,
      quotaResetDate: quotaResetDate ?? this.quotaResetDate,
    );
  }
}