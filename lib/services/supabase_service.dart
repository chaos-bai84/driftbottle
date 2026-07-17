/// Supabase服务
/// 负责Supabase客户端的初始化和配置检查
library;

import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/constants.dart';

/// Supabase服务类（单例模式）
class SupabaseService {
  SupabaseService._();

  static final SupabaseService _instance = SupabaseService._();

  /// 获取单例实例
  static SupabaseService get instance => _instance;

  /// Supabase客户端引用
  SupabaseClient? _client;

  /// 初始化状态
  bool _initialized = false;

  /// 初始化是否完成
  bool get isInitialized => _initialized;

  /// Supabase是否已正确配置（URL和Key不为空）
  bool get isConfigured =>
      supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;

  /// 获取Supabase客户端
  SupabaseClient get client {
    if (_client == null) {
      throw StateError('Supabase未初始化，请先调用initialize()');
    }
    return _client!;
  }

  /// 初始化Supabase
  /// 返回是否初始化成功
  Future<bool> initialize() async {
    if (_initialized) return true;

    if (!isConfigured) {
      // 配置不完整，跳过初始化
      return false;
    }

    try {
      await Supabase.initialize(
        url: supabaseUrl,
        publishableKey: supabaseAnonKey,
      );
      _client = Supabase.instance.client;
      _initialized = true;
      return true;
    } catch (e) {
      // 初始化失败
      return false;
    }
  }
}