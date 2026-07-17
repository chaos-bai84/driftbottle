/// 用户状态管理
/// 使用Provider管理当前用户信息和配额
library;

import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../services/auth_service.dart';
import '../config/constants.dart';

/// 用户状态管理类
class UserProvider extends ChangeNotifier {
  /// 认证服务
  final AuthService _authService = AuthService();

  /// 当前用户
  User? _currentUser;

  /// 是否正在加载
  bool _isLoading = false;

  /// 初始化错误信息
  String? _error;

  /// 今日配额使用情况
  Map<String, int> _quotas = {
    'throw': 0,
    'catch': 0,
    'translate': 0,
  };

  /// 获取当前用户
  User? get currentUser => _currentUser;

  /// 是否正在加载
  bool get isLoading => _isLoading;

  /// 初始化错误信息
  String? get error => _error;

  /// 获取配额信息
  Map<String, int> get quotas => _quotas;

  /// 是否已登录
  bool get isLoggedIn => _currentUser != null;

  /// 获取今日剩余可扔瓶子数
  int get remainingThrowCount {
    if (_currentUser == null) return 0;
    final limit = isNewUser ? newUserThrowLimit : dailyThrowLimit;
    return (limit - (_quotas['throw'] ?? 0)).clamp(0, limit);
  }

  /// 获取今日剩余可捞瓶子数
  int get remainingCatchCount {
    if (_currentUser == null) return 0;
    final limit = isNewUser ? newUserCatchLimit : dailyCatchLimit;
    return (limit - (_quotas['catch'] ?? 0)).clamp(0, limit);
  }

  /// 获取今日剩余翻译次数
  int get remainingTranslateCount {
    if (_currentUser == null) return 0;
    return (dailyTranslateLimit - (_quotas['translate'] ?? 0))
        .clamp(0, dailyTranslateLimit);
  }

  /// 是否为新用户（注册24小时内）
  bool get isNewUser => _currentUser?.isNewUser ?? false;

  /// 初始化：自动注册/登录
  Future<void> init() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final user = await _authService.registerWithDevice();
      if (user != null) {
        _currentUser = user;
        _quotas = await _authService.getUserQuotas(user.id);
      } else {
        _error = '登录失败，请检查网络或后端配置';
      }
    } catch (e) {
      _error = '初始化失败：$e';
    }

    _isLoading = false;
    notifyListeners();
  }

  /// 刷新配额信息
  Future<void> refreshQuotas() async {
    if (_currentUser == null) return;

    _quotas = await _authService.getUserQuotas(_currentUser!.id);
    notifyListeners();
  }

  /// 刷新用户信息
  Future<void> refreshUser() async {
    if (_currentUser == null) return;

    final updated = await _authService.getCurrentUser(_currentUser!.id);
    if (updated != null) {
      _currentUser = updated;
      notifyListeners();
    }
  }

  /// 更新用户资料
  Future<bool> updateProfile({
    String? nickname,
    String? countryCode,
    String? countryName,
    String? language,
  }) async {
    if (_currentUser == null) return false;

    final success = await _authService.updateProfile(
      userId: _currentUser!.id,
      nickname: nickname,
      countryCode: countryCode,
      countryName: countryName,
      language: language,
    );

    if (success) {
      await refreshUser();
    }

    return success;
  }
}