/// 认证服务
/// 负责设备ID注册/登录、用户信息管理
library;

import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/user.dart';
import 'supabase_service.dart';

/// 认证服务类
class AuthService {
  /// SharedPreferences键名 - 设备ID
  static const String _keyDeviceId = 'device_id';

  /// 获取设备唯一标识
  /// 优先从本地缓存读取，没有则生成新的 UUID 并缓存
  Future<String> getDeviceId() async {
    final prefs = await SharedPreferences.getInstance();
    String? deviceId = prefs.getString(_keyDeviceId);

    if (deviceId != null && deviceId.isNotEmpty) {
      return deviceId;
    }

    // 生成新的设备ID（UUID v4），避免依赖硬件信息导致兼容性问题
    final identifier = const Uuid().v4();

    // 将设备ID写入缓存
    await prefs.setString(_keyDeviceId, identifier);
    return identifier;
  }

  /// 用设备ID注册/登录
  /// 如果设备已注册则登录，否则自动注册
  Future<User?> registerWithDevice() async {
    final deviceId = await getDeviceId();
    final client = SupabaseService.instance.client;

    try {
      // 先查询是否已注册
      final response = await client
          .from('users')
          .select()
          .eq('device_id', deviceId)
          .maybeSingle();

      if (response != null) {
        // 已注册，更新最后活跃时间
        await client.from('users').update({
          'last_active_at': DateTime.now().toIso8601String(),
        }).eq('id', response['id'] as String);

        return User.fromJson(response);
      }

      // 未注册，创建新用户
      final insertResponse = await client.from('users').insert({
        'device_id': deviceId,
        'nickname': '匿名用户',
        'language': 'zh',
        'today_throw_count': 0,
        'today_catch_count': 0,
        'today_translate_count': 0,
      }).select().single();

      return User.fromJson(insertResponse);
    } catch (e) {
      return null;
    }
  }

  /// 获取当前用户信息
  Future<User?> getCurrentUser(String userId) async {
    final client = SupabaseService.instance.client;

    try {
      final response = await client
          .from('users')
          .select()
          .eq('id', userId)
          .maybeSingle();

      if (response == null) return null;
      return User.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  /// 更新用户资料
  /// 可更新昵称、国家、语言
  Future<bool> updateProfile({
    required String userId,
    String? nickname,
    String? countryCode,
    String? countryName,
    String? language,
  }) async {
    final client = SupabaseService.instance.client;

    try {
      final updates = <String, dynamic>{};
      if (nickname != null) updates['nickname'] = nickname;
      if (countryCode != null) updates['country_code'] = countryCode;
      if (countryName != null) updates['country_name'] = countryName;
      if (language != null) updates['language'] = language;

      if (updates.isEmpty) return true;

      await client.from('users').update(updates).eq('id', userId);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// 获取用户今日配额使用情况
  /// 返回包含各配额已使用次数的Map
  Future<Map<String, int>> getUserQuotas(String userId) async {
    final client = SupabaseService.instance.client;

    try {
      final response = await client
          .from('users')
          .select('today_throw_count, today_catch_count, today_translate_count, quota_reset_date')
          .eq('id', userId)
          .single();

      // 检查配额是否需要重置（跨天自动重置）
      final today = DateTime.now().toIso8601String().substring(0, 10);
      final resetDate = response['quota_reset_date'] as String? ?? '';

      if (resetDate != today) {
        // 新的一天，重置配额
        await client.from('users').update({
          'today_throw_count': 0,
          'today_catch_count': 0,
          'today_translate_count': 0,
          'quota_reset_date': today,
        }).eq('id', userId);

        return {
          'throw': 0,
          'catch': 0,
          'translate': 0,
        };
      }

      return {
        'throw': response['today_throw_count'] as int? ?? 0,
        'catch': response['today_catch_count'] as int? ?? 0,
        'translate': response['today_translate_count'] as int? ?? 0,
      };
    } catch (e) {
      return {
        'throw': 0,
        'catch': 0,
        'translate': 0,
      };
    }
  }
}