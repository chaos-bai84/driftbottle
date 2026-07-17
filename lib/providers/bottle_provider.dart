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

    final bottle = await _bottleService.throwBottle(
      senderId: senderId,
      content: content,
      tag: tag,
      senderNickname: senderNickname,
      senderCountryCode: senderCountryCode,
      senderCountryName: senderCountryName,
      senderLanguage: senderLanguage,
    );

    _isThrowing = false;

    if (bottle != null) {
      _message = '瓶子已扔进大海';
      _messageType = 'success';
    } else {
      _message = '发送失败，内容可能包含敏感词汇';
      _messageType = 'error';
    }

    notifyListeners();
    return bottle != null;
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