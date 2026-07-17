/// 翻译服务
/// 支持Google翻译（免费，无需API Key）和DeepL翻译（需API Key）
/// 默认使用Google免费翻译端点，填入对应API Key后自动切换
library;

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/constants.dart';

/// 翻译服务类
class TranslationService {
  /// 翻译文本
  /// [text] 待翻译文本
  /// [sourceLang] 源语言代码（如 'zh', 'en'）
  /// [targetLang] 目标语言代码（如 'en', 'zh'）
  /// 返回翻译后的文本，失败返回null
  Future<String?> translate({
    required String text,
    required String sourceLang,
    required String targetLang,
  }) async {
    // 如果配置了DeepL Key，优先使用DeepL（质量更好）
    if (deeplApiKey.isNotEmpty) {
      return _translateWithDeepL(text, sourceLang, targetLang);
    }
    // 如果配置了Google官方Key，使用官方API
    if (googleApiKey.isNotEmpty) {
      return _translateWithGoogleOfficial(text, sourceLang, targetLang);
    }
    // 都没配置，使用Google免费翻译端点
    return _translateWithGoogleFree(text, sourceLang, targetLang);
  }

  /// 检测文本语言
  /// [text] 待检测文本
  /// 返回语言代码，失败返回null
  Future<String?> detectLanguage({required String text}) async {
    if (deeplApiKey.isNotEmpty) {
      return _detectWithDeepL(text);
    }
    // Google翻译免费端点支持自动检测（source='auto'）
    // 这里通过翻译一次来检测语言
    return _detectWithGoogleFree(text);
  }

  /// 检查翻译配额是否可用
  /// [usedCount] 今日已使用次数
  /// 返回是否还可以翻译
  bool canTranslate({required int usedCount}) {
    return usedCount < dailyTranslateLimit;
  }

  // ==================== Google免费翻译 ====================

  /// 使用Google免费翻译端点（无需API Key）
  Future<String?> _translateWithGoogleFree(
    String text,
    String sourceLang,
    String targetLang,
  ) async {
    try {
      final source = sourceLang == 'auto' ? 'auto' : sourceLang;
      final target = toGoogleLangCode(targetLang);

      final uri = Uri.parse(
        'https://translate.googleapis.com/translate_a/single?'
        'client=gtx&sl=$source&tl=$target&dt=t&q=${Uri.encodeComponent(text)}',
      );

      final response = await http.get(uri, headers: {
        'User-Agent': 'Mozilla/5.0',
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        // Google翻译返回格式：[[[翻译结果, 原文, null, null, ...], ...], ...]
        if (data.isNotEmpty && data[0] is List) {
          final translations = data[0] as List;
          final buffer = StringBuffer();
          for (final t in translations) {
            if (t is List && t.isNotEmpty) {
              buffer.write(t[0]);
            }
          }
          final result = buffer.toString().trim();
          return result.isEmpty ? null : result;
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// 使用Google免费端点检测语言
  Future<String?> _detectWithGoogleFree(String text) async {
    try {
      final uri = Uri.parse(
        'https://translate.googleapis.com/translate_a/single?'
        'client=gtx&sl=auto&tl=en&dt=t&q=${Uri.encodeComponent(text)}',
      );

      final response = await http.get(uri, headers: {
        'User-Agent': 'Mozilla/5.0',
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        // Google翻译返回格式：[[[翻译结果, 原文, null, null, ...], ...], [检测到的语言代码], ...]
        if (data.length >= 3 && data[2] is String) {
          return fromGoogleLangCode(data[2] as String);
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // ==================== Google官方API ====================

  /// 使用Google Cloud Translation API（需API Key）
  Future<String?> _translateWithGoogleOfficial(
    String text,
    String sourceLang,
    String targetLang,
  ) async {
    try {
      final target = toGoogleLangCode(targetLang);
      final uri = Uri.parse(
        'https://translation.googleapis.com/language/translate/v2?key=$googleApiKey',
      );

      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'q': text,
          'source': sourceLang == 'auto' ? null : sourceLang,
          'target': target,
          'format': 'text',
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final translations = data['data']?['translations'] as List?;
        if (translations != null && translations.isNotEmpty) {
          return translations[0]['translatedText'] as String?;
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // ==================== DeepL API ====================

  /// 使用DeepL API翻译
  Future<String?> _translateWithDeepL(
    String text,
    String sourceLang,
    String targetLang,
  ) async {
    try {
      final deeplSourceLang = toDeeplLangCode(sourceLang);
      final deeplTargetLang = toDeeplLangCode(targetLang);

      final uri = Uri.parse('https://api-free.deepl.com/v2/translate');
      final response = await http.post(
        uri,
        headers: {
          'Authorization': 'DeepL-Auth-Key $deeplApiKey',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'text': text,
          'source_lang': deeplSourceLang,
          'target_lang': deeplTargetLang,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final translations = data['translations'] as List;
        if (translations.isNotEmpty) {
          return translations[0]['text'] as String?;
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// 使用DeepL检测语言
  Future<String?> _detectWithDeepL(String text) async {
    try {
      final uri = Uri.parse('https://api-free.deepl.com/v2/translate');
      final response = await http.post(
        uri,
        headers: {
          'Authorization': 'DeepL-Auth-Key $deeplApiKey',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'text': text,
          'target_lang': 'EN',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final translations = data['translations'] as List;
        if (translations.isNotEmpty) {
          final detectedLang =
              translations[0]['detected_source_language'] as String?;
          return fromDeeplLangCode(detectedLang);
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // ==================== 语言代码转换 ====================

  /// 将应用语言代码转换为Google翻译语言代码
  String toGoogleLangCode(String langCode) {
    // Google翻译使用ISO 639-1代码，大部分一致
    switch (langCode.toLowerCase()) {
      case 'zh':
        return 'zh-CN'; // 简体中文
      case 'zh-tw':
        return 'zh-TW'; // 繁体中文
      default:
        return langCode.toLowerCase();
    }
  }

  /// 将Google翻译语言代码转换为应用语言代码
  String? fromGoogleLangCode(String? googleCode) {
    if (googleCode == null) return null;
    switch (googleCode.toLowerCase()) {
      case 'zh-cn':
      case 'zh':
        return 'zh';
      case 'zh-tw':
        return 'zh-tw';
      default:
        return googleCode.toLowerCase();
    }
  }

  /// 将应用语言代码转换为DeepL API语言代码
  String toDeeplLangCode(String langCode) {
    switch (langCode.toLowerCase()) {
      case 'zh':
        return 'ZH';
      case 'en':
        return 'EN';
      case 'ja':
        return 'JA';
      case 'ko':
        return 'KO';
      case 'fr':
        return 'FR';
      case 'de':
        return 'DE';
      case 'es':
        return 'ES';
      case 'pt':
        return 'PT';
      case 'ru':
        return 'RU';
      default:
        return langCode.toUpperCase();
    }
  }

  /// 将DeepL API语言代码转换为应用语言代码
  String? fromDeeplLangCode(String? deeplCode) {
    if (deeplCode == null) return null;
    switch (deeplCode.toUpperCase()) {
      case 'ZH':
        return 'zh';
      case 'EN':
        return 'en';
      case 'JA':
        return 'ja';
      case 'KO':
        return 'ko';
      case 'FR':
        return 'fr';
      case 'DE':
        return 'de';
      case 'ES':
        return 'es';
      case 'PT':
        return 'pt';
      case 'RU':
        return 'ru';
      default:
        return deeplCode.toLowerCase();
    }
  }
}
