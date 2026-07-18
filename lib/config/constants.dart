/// 全局常量配置
/// 包含API配置、配额限制、话题标签等
library;

// ==================== API配置 ====================

import 'secrets.dart' as secrets;

/// Supabase项目地址
/// 真实值从 lib/config/secrets.dart 读取，公开仓库中不提交该文件
const String supabaseUrl = secrets.supabaseUrl;

/// Supabase匿名密钥
/// 真实值从 lib/config/secrets.dart 读取，公开仓库中不提交该文件
const String supabaseAnonKey = secrets.supabaseAnonKey;

/// DeepL翻译API密钥（留空则使用Google免费翻译，后续可填入切换）
const String deeplApiKey = '';

/// Google Cloud翻译API密钥（留空则使用Google免费翻译端点，后续可填入切换）
const String googleApiKey = '';

// ==================== 每日配额 ====================

/// 每日扔瓶子上限
const int dailyThrowLimit = 20;

/// 每日捞瓶子上限
const int dailyCatchLimit = 20;

/// 每日翻译次数上限
const int dailyTranslateLimit = 20;

// ==================== 新用户限制 ====================

/// 新用户每日扔瓶子上限
const int newUserThrowLimit = 20;

/// 新用户每日捞瓶子上限
const int newUserCatchLimit = 20;

/// 新用户限制持续时长（注册后24小时内）
const Duration newUserRestrictionDuration = Duration(hours: 24);

// ==================== 对话设置 ====================

/// 对话保留天数（超过后自动清理）
const int conversationExpiryDays = 7;

// ==================== 话题标签 ====================

/// 可选话题标签列表
const List<String> tags = [
  '#日常',
  '#旅行',
  '#美食',
  '#文化',
  '#语言交换',
  '#心情',
  '#音乐',
  '#电影',
  '#求助',
  '#其他',
];
