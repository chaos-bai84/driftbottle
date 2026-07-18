/// 瓶子状态管理
/// 使用Provider管理当前瓶子相关状态
library;

import 'package:flutter/foundation.dart';
import '../models/bottle.dart';
import '../services/bottle_service.dart';

/// 瓶子状态管理类
class BottleProvider extends ChangeNotifier {
  /// 瓶子服务
  final BottleService _bottleService = BottleService();

  /// 当前捞到的瓶子
  Bottle? _currentBottle;

  /// 是否正在捞瓶子（加载中）
  bool _isCatching = false;

  /// 是否正在扔瓶子
  bool _isThrowing = false;

  /// 操作结果消息
  String? _message;

  /// 消息类型：success / error
  String? _messageType;

  /// 获取当前瓶子
  Bottle? get currentBottle => _currentBottle;

  /// 是否正在捞瓶子
  bool get isCatching => _isCatching;

  /// 是否正在扔瓶子
  bool get isThrowing => _isThrowing;

  /// 获取操作消息
  String? get message => _message;

  /// 获取消息类型
  String? get messageType => _messageType;

  /// 清除当前瓶子（回到海洋页面）
  void clearBottle() {
    _currentBottle = null;
    _message = null;
    _messageType = null;
    notifyListeners();
  }

  /// 清除消息
  void clearMessage() {
    _message = null;
    _messageType = null;
    notifyListeners();
  }

  /// 扔瓶子
  ///
  /// 在写入数据库前会进行内容安全检测：
  /// - 敏感词检测（色情、暴力、违法等）
  /// - 联系方式与导流信息检测（邮箱、URL、IP、手机号、社交平台关键词）
  /// - 根据用户国家/语言应用地区化规则
  ///
  /// 失败时 [_message] 会包含具体的失败原因（本地化文案）。
  ///
  /// [senderId] 发送者ID
  /// [content] 瓶子内容
  /// [tag] 话题标签
  /// [senderNickname] 发送者昵称
  /// [senderCountryCode] 发送者国家代码
  /// [senderCountryName] 发送者国家名称
  /// [senderLanguage] 发送者语言
  Future<bool> throwBottle({
    required String senderId,
    required String content,
    String? tag,
    required String senderNickname,
    String? senderCountryCode,
    String? senderCountryName,
    required String senderLanguage,
  }) async {
    _isThrowing = true;
    _message = null;
    notifyListeners();

    final result = await _bottleService.throwBottle(
      senderId: senderId,
      content: content,
      tag: tag,
      senderNickname: senderNickname,
      senderCountryCode: senderCountryCode,
      senderCountryName: senderCountryName,
      senderLanguage: senderLanguage,
    );

    _isThrowing = false;

    if (result.success) {
      _message = _successMessage(senderLanguage);
      _messageType = 'success';
    } else {
      // 使用服务返回的本地化错误消息
      _message = result.errorMessage ?? _defaultErrorMessage(senderLanguage);
      _messageType = 'error';
    }

    notifyListeners();
    return result.success;
  }

  /// 根据用户语言返回成功消息
  String _successMessage(String language) {
    switch (language.toLowerCase()) {
      case 'en':
        return 'Bottle thrown into the sea';
      case 'ja':
        return 'ボトルを海に投げました';
      case 'ko':
        return '바다에 병을 던졌어요';
      default:
        return '瓶子已扔进大海';
    }
  }

  /// 根据用户语言返回默认错误消息
  String _defaultErrorMessage(String language) {
    switch (language.toLowerCase()) {
      case 'en':
        return 'Failed to send, please try again';
      case 'ja':
        return '送信に失敗しました。もう一度お試しください';
      case 'ko':
        return '전송 실패, 다시 시도해 주세요';
      default:
        return '发送失败，请重试';
    }
  }

  /// 捞瓶子
  /// [catcherId] 捞瓶子的人的ID
  Future<Bottle?> catchBottle({required String catcherId}) async {
    _isCatching = true;
    _currentBottle = null;
    _message = null;
    notifyListeners();

    final bottle = await _bottleService.catchBottle(catcherId: catcherId);

    _isCatching = false;

    if (bottle != null) {
      _currentBottle = bottle;
    } else {
      _message = '暂时没有漂流瓶，稍后再来试试吧';
      _messageType = 'info';
    }

    notifyListeners();
    return bottle;
  }

  /// 按话题标签捞瓶子
  /// [catcherId] 捞瓶子的人的ID
  /// [tags] 话题标签数组（为空时不筛选）
  Future<Bottle?> catchBottleWithTags({
    required String catcherId,
    List<String>? tags,
  }) async {
    _isCatching = true;
    _currentBottle = null;
    _message = null;
    notifyListeners();

    final bottle = await _bottleService.catchBottleWithTags(
      catcherId: catcherId,
      tags: tags,
    );

    _isCatching = false;

    if (bottle != null) {
      _currentBottle = bottle;
    } else {
      final hasTags = tags != null && tags.isNotEmpty;
      _message = hasTags ? '该话题下暂无漂流瓶，试试其他话题吧' : '暂时没有漂流瓶，稍后再来试试吧';
      _messageType = 'info';
    }

    notifyListeners();
    return bottle;
  }

  /// 丢回瓶子
  Future<bool> discardBottle({required String bottleId}) async {
    final success = await _bottleService.discardBottle(bottleId: bottleId);

    if (success) {
      _currentBottle = null;
      _message = '瓶子已放回大海';
      _messageType = 'info';
    } else {
      _message = '操作失败，请重试';
      _messageType = 'error';
    }

    notifyListeners();
    return success;
  }
}