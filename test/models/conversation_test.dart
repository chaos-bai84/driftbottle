import 'package:flutter_test/flutter_test.dart';
import 'package:driftbottle/models/conversation.dart';

void main() {
  group('Conversation 模型测试', () {
    test('fromJson 能正确解析所有字段，包括 expires_at', () {
      final json = {
        'id': '550e8400-e29b-41d4-a716-446655440000',
        'bottle_id': 'bottle-123',
        'user1_id': 'user-1',
        'user2_id': 'user-2',
        'user1_nickname': '扔瓶人',
        'user1_country_code': 'CN',
        'user1_country_name': '中国',
        'user1_language': 'zh',
        'user2_nickname': '捞瓶人',
        'user2_country_code': 'US',
        'user2_country_name': '美国',
        'user2_language': 'en',
        'last_message': '你好',
        'last_message_at': '2026-07-18T10:00:00.000Z',
        'last_sender_id': 'user-1',
        'unread_count': 1,
        'status': 'active',
        'created_at': '2026-07-18T10:00:00.000Z',
        'expires_at': '2026-07-25T10:00:00.000Z',
      };

      final conversation = Conversation.fromJson(json);

      expect(conversation.id, '550e8400-e29b-41d4-a716-446655440000');
      expect(conversation.bottleId, 'bottle-123');
      expect(conversation.user1Id, 'user-1');
      expect(conversation.user2Id, 'user-2');
      expect(conversation.user1Nickname, '扔瓶人');
      expect(conversation.user2Nickname, '捞瓶人');
      expect(conversation.lastMessage, '你好');
      expect(conversation.unreadCount, 1);
      expect(conversation.status, 'active');
      expect(conversation.expiresAt, isNotNull);
      expect(
        conversation.expiresAt!.toIso8601String(),
        '2026-07-25T10:00:00.000Z',
      );
    });

    test('fromJson 在缺少 expires_at 时返回 null', () {
      final json = {
        'id': '550e8400-e29b-41d4-a716-446655440000',
        'bottle_id': 'bottle-123',
        'user1_id': 'user-1',
        'user2_id': 'user-2',
        'user1_nickname': '扔瓶人',
        'user1_language': 'zh',
        'user2_nickname': '捞瓶人',
        'user2_language': 'en',
        'created_at': '2026-07-18T10:00:00.000Z',
      };

      final conversation = Conversation.fromJson(json);
      expect(conversation.expiresAt, isNull);
    });

    test('toJson 应正确序列化 expires_at', () {
      final expiresAt = DateTime.parse('2026-07-25T10:00:00.000Z');
      final conversation = Conversation(
        id: 'conv-123',
        bottleId: 'bottle-123',
        user1Id: 'user-1',
        user2Id: 'user-2',
        user1Nickname: '扔瓶人',
        user1Language: 'zh',
        user2Nickname: '捞瓶人',
        user2Language: 'en',
        createdAt: DateTime.parse('2026-07-18T10:00:00.000Z'),
        expiresAt: expiresAt,
      );

      final json = conversation.toJson();
      expect(json['expires_at'], '2026-07-25T10:00:00.000Z');
    });

    test('copyWith 能更新 expires_at', () {
      final conversation = Conversation(
        id: 'conv-123',
        bottleId: 'bottle-123',
        user1Id: 'user-1',
        user2Id: 'user-2',
        user1Nickname: '扔瓶人',
        user1Language: 'zh',
        user2Nickname: '捞瓶人',
        user2Language: 'en',
        createdAt: DateTime.parse('2026-07-18T10:00:00.000Z'),
        expiresAt: DateTime.parse('2026-07-25T10:00:00.000Z'),
      );

      final newExpiresAt = DateTime.parse('2026-08-01T10:00:00.000Z');
      final updated = conversation.copyWith(expiresAt: newExpiresAt);

      expect(updated.expiresAt, newExpiresAt);
    });
  });
}
