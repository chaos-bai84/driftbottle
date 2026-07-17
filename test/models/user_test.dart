
import 'package:flutter_test/flutter_test.dart';
import 'package:driftbottle/models/user.dart';

void main() {
  group('User 模型测试', () {
    test('注册1小时内的用户是新用户', () {
      final user = User(
        id: 'test-id',
        deviceId: 'device-id',
        nickname: '测试用户',
        language: 'zh',
        createdAt: DateTime.now().subtract(const Duration(hours: 1)),
      );
      expect(user.isNewUser, true);
    });

    test('注册23小时内的用户是新用户', () {
      final user = User(
        id: 'test-id',
        deviceId: 'device-id',
        nickname: '测试用户',
        language: 'zh',
        createdAt: DateTime.now().subtract(const Duration(hours: 23)),
      );
      expect(user.isNewUser, true);
    });

    test('注册25小时后的用户不是新用户', () {
      final user = User(
        id: 'test-id',
        deviceId: 'device-id',
        nickname: '测试用户',
        language: 'zh',
        createdAt: DateTime.now().subtract(const Duration(hours: 25)),
      );
      expect(user.isNewUser, false);
    });

    test('fromJson 能正确解析所有字段', () {
      final json = {
        'id': '550e8400-e29b-41d4-a716-446655440000',
        'device_id': 'device-123',
        'nickname': '测试用户',
        'country_code': 'CN',
        'country_name': '中国',
        'language': 'zh',
        'avatar_url': null,
        'created_at': '2026-07-18T10:00:00.000Z',
        'last_active_at': '2026-07-18T12:00:00.000Z',
        'today_throw_count': 1,
        'today_catch_count': 2,
        'today_translate_count': 3,
        'quota_reset_date': '2026-07-18',
      };
      final user = User.fromJson(json);
      expect(user.id, '550e8400-e29b-41d4-a716-446655440000');
      expect(user.deviceId, 'device-123');
      expect(user.nickname, '测试用户');
      expect(user.countryCode, 'CN');
      expect(user.countryName, '中国');
      expect(user.language, 'zh');
      expect(user.todayThrowCount, 1);
      expect(user.todayCatchCount, 2);
      expect(user.todayTranslateCount, 3);
      expect(user.quotaResetDate, '2026-07-18');
    });
  });
}
