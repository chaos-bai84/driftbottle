import 'package:flutter_test/flutter_test.dart';
import 'package:driftbottle/services/translation_service.dart';
import 'package:driftbottle/config/constants.dart';

void main() {
  group('TranslationService 语言代码转换测试', () {
    final service = TranslationService();

    test('中文应转换为 Google 的 zh-CN', () {
      expect(service.toGoogleLangCode('zh'), 'zh-CN');
    });

    test('繁体中文应转换为 Google 的 zh-TW', () {
      expect(service.toGoogleLangCode('zh-tw'), 'zh-TW');
      expect(service.toGoogleLangCode('ZH-TW'), 'zh-TW');
    });

    test('其他语言应保持小写', () {
      expect(service.toGoogleLangCode('EN'), 'en');
      expect(service.toGoogleLangCode('Ja'), 'ja');
    });

    test('Google 语言代码应正确转回应用代码', () {
      expect(service.fromGoogleLangCode('zh-CN'), 'zh');
      expect(service.fromGoogleLangCode('zh-TW'), 'zh-tw');
      expect(service.fromGoogleLangCode('en'), 'en');
      expect(service.fromGoogleLangCode(null), null);
    });

    test('中文应转换为 DeepL 的 ZH', () {
      expect(service.toDeeplLangCode('zh'), 'ZH');
    });

    test('DeepL 语言代码应正确转回应用代码', () {
      expect(service.fromDeeplLangCode('ZH'), 'zh');
      expect(service.fromDeeplLangCode('EN'), 'en');
      expect(service.fromDeeplLangCode('JA'), 'ja');
      expect(service.fromDeeplLangCode(null), null);
    });

    test('翻译配额判断应正确', () {
      // 配额上限为 dailyTranslateLimit（当前为 20）
      expect(service.canTranslate(usedCount: 0), true);
      expect(service.canTranslate(usedCount: dailyTranslateLimit - 1), true);
      expect(service.canTranslate(usedCount: dailyTranslateLimit), false);
      expect(service.canTranslate(usedCount: dailyTranslateLimit + 5), false);
    });
  });
}
