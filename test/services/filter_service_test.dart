import 'package:flutter_test/flutter_test.dart';
import 'package:driftbottle/services/filter_service.dart';

void main() {
  group('FilterService 联系方式检测测试', () {
    group('邮箱地址检测', () {
      test('应检测标准邮箱地址', () {
        final result = FilterService.detectContactInfo(
          text: '联系我：test@example.com',
          language: 'zh',
        );
        expect(result.hasContactInfo, true);
        expect(result.matchedPatterns.contains('邮箱地址'), true);
      });

      test('应检测含子域的邮箱地址', () {
        final result = FilterService.detectContactInfo(
          text: '我的邮箱是 user.name@sub.example.com',
          language: 'zh',
        );
        expect(result.hasContactInfo, true);
        expect(result.matchedPatterns.contains('邮箱地址'), true);
      });

      test('不应误判普通文本为邮箱', () {
        final result = FilterService.detectContactInfo(
          text: '今天天气很好',
          language: 'zh',
        );
        expect(result.hasContactInfo, false);
      });
    });

    group('URL链接检测', () {
      test('应检测 http 链接', () {
        final result = FilterService.detectContactInfo(
          text: '访问 http://example.com 看看',
          language: 'zh',
        );
        expect(result.hasContactInfo, true);
        expect(result.matchedPatterns.contains('链接'), true);
      });

      test('应检测 https 链接', () {
        final result = FilterService.detectContactInfo(
          text: '网站是 https://www.example.com/path',
          language: 'zh',
        );
        expect(result.hasContactInfo, true);
        expect(result.matchedPatterns.contains('链接'), true);
      });

      test('不应误判普通文本为链接', () {
        final result = FilterService.detectContactInfo(
          text: '今天天气很好',
          language: 'zh',
        );
        expect(result.hasContactInfo, false);
      });
    });

    group('IP地址检测', () {
      test('应检测标准IPv4地址', () {
        final result = FilterService.detectContactInfo(
          text: '服务器地址 192.168.1.100',
          language: 'zh',
        );
        expect(result.hasContactInfo, true);
        expect(result.matchedPatterns.contains('IP地址'), true);
      });

      test('应检测公网IP地址', () {
        final result = FilterService.detectContactInfo(
          text: '连接到 8.8.8.8 即可',
          language: 'zh',
        );
        expect(result.hasContactInfo, true);
        expect(result.matchedPatterns.contains('IP地址'), true);
      });
    });

    group('连续数字检测', () {
      test('应检测10位以上连续数字（手机号）', () {
        final result = FilterService.detectContactInfo(
          text: '我的手机号是 13812345678',
          language: 'zh',
        );
        expect(result.hasContactInfo, true);
        expect(result.matchedPatterns.contains('连续数字'), true);
      });

      test('应检测11位手机号', () {
        final result = FilterService.detectContactInfo(
          text: 'call me at 15512345678',
          language: 'en',
        );
        expect(result.hasContactInfo, true);
        expect(result.matchedPatterns.contains('连续数字'), true);
      });

      test('不应误判短数字', () {
        final result = FilterService.detectContactInfo(
          text: '我有 12345 元',
          language: 'zh',
        );
        // 5位数字不应该被检测为联系方式
        expect(result.matchedPatterns.contains('连续数字'), false);
      });
    });

    group('社交平台关键词检测', () {
      test('应检测WhatsApp关键词', () {
        final result = FilterService.detectContactInfo(
          text: 'add me on WhatsApp please',
          language: 'en',
        );
        expect(result.hasContactInfo, true);
      });

      test('应检测Telegram关键词', () {
        final result = FilterService.detectContactInfo(
          text: '我的Telegram是 @username',
          language: 'zh',
        );
        expect(result.hasContactInfo, true);
      });

      test('应检测Discord关键词', () {
        final result = FilterService.detectContactInfo(
          text: 'join my Discord server',
          language: 'en',
        );
        expect(result.hasContactInfo, true);
      });

      test('应检测Instagram关键词', () {
        final result = FilterService.detectContactInfo(
          text: 'follow my Instagram',
          language: 'en',
        );
        expect(result.hasContactInfo, true);
      });
    });

    group('地区化规则检测', () {
      test('中国用户应检测微信关键词', () {
        final result = FilterService.detectContactInfo(
          text: '加我微信聊吧',
          countryCode: 'CN',
          language: 'zh',
        );
        expect(result.hasContactInfo, true);
      });

      test('中国用户应检测VX缩写', () {
        final result = FilterService.detectContactInfo(
          text: '我的VX是 abc123',
          countryCode: 'CN',
          language: 'zh',
        );
        expect(result.hasContactInfo, true);
      });

      test('中国用户应检测QQ关键词', () {
        final result = FilterService.detectContactInfo(
          text: '加我QQ吧',
          countryCode: 'CN',
          language: 'zh',
        );
        expect(result.hasContactInfo, true);
      });

      test('日韩用户应检测Line关键词', () {
        final result = FilterService.detectContactInfo(
          text: 'line IDを教えて',
          countryCode: 'JP',
          language: 'ja',
        );
        expect(result.hasContactInfo, true);
      });

      test('日韩用户应检测Kakao关键词', () {
        final result = FilterService.detectContactInfo(
          text: '카카오 계정 알려줄게',
          countryCode: 'KR',
          language: 'ko',
        );
        expect(result.hasContactInfo, true);
      });

      test('欧美用户应检测phone number关键词', () {
        final result = FilterService.detectContactInfo(
          text: 'whats your phone number',
          countryCode: 'US',
          language: 'en',
        );
        expect(result.hasContactInfo, true);
      });

      test('东南亚用户应检测Line ID关键词', () {
        final result = FilterService.detectContactInfo(
          text: 'share line id with me',
          countryCode: 'TH',
          language: 'en',
        );
        expect(result.hasContactInfo, true);
      });
    });

    group('综合安全检测', () {
      test('正常文本应判定为安全', () {
        final result = FilterService.checkTextSafety(
          text: '你好，今天天气不错，我想练习日语',
          language: 'zh',
        );
        expect(result.isSafe, true);
        expect(result.sensitiveWords, isEmpty);
        expect(result.contactInfo.hasContactInfo, false);
      });

      test('包含敏感词应判定为不安全', () {
        final result = FilterService.checkTextSafety(
          text: '这里有色情内容',
          language: 'zh',
        );
        expect(result.isSafe, false);
        expect(result.sensitiveWords, isNotEmpty);
      });

      test('包含联系方式应判定为不安全', () {
        final result = FilterService.checkTextSafety(
          text: '联系我：test@example.com',
          language: 'zh',
        );
        expect(result.isSafe, false);
        expect(result.contactInfo.hasContactInfo, true);
      });

      test('错误提示应根据语言返回不同文案', () {
        final zhResult = FilterService.checkTextSafety(
          text: 'test@example.com',
          language: 'zh',
        );
        expect(zhResult.errorMessage('zh'), contains('联系方式'));

        final enResult = FilterService.checkTextSafety(
          text: 'test@example.com',
          language: 'en',
        );
        expect(enResult.errorMessage('en'), contains('contact info'));
      });

      test('空文本应判定为安全', () {
        final result = FilterService.checkTextSafety(
          text: '',
          language: 'zh',
        );
        expect(result.isSafe, true);
      });
    });

    group('isTextSafeContact 方法测试', () {
      test('正常文本应返回true', () {
        expect(
          FilterService.isTextSafeContact(
            text: '今天天气很好',
            language: 'zh',
          ),
          true,
        );
      });

      test('包含邮箱应返回false', () {
        expect(
          FilterService.isTextSafeContact(
            text: 'test@example.com',
            language: 'zh',
          ),
          false,
        );
      });

      test('包含手机号应返回false', () {
        expect(
          FilterService.isTextSafeContact(
            text: '13812345678',
            language: 'zh',
          ),
          false,
        );
      });
    });
  });

  group('FilterService 敏感词过滤测试（保持原有功能）', () {
    test('正常文本应判定为安全', () {
      expect(FilterService.isTextSafe('你好，今天天气不错'), true);
      expect(FilterService.isTextSafe('我想练习日语，有人一起吗？'), true);
    });

    test('应能检测中文色情敏感词', () {
      final words = FilterService.detectSensitiveWords('这里有色情内容');
      expect(words.isNotEmpty, true);
      expect(words.contains('色情'), true);
      expect(FilterService.isTextSafe('这里有色情内容'), false);
    });

    test('应能检测英文敏感词', () {
      final words = FilterService.detectSensitiveWords('This is a fucking bad word');
      expect(words.isNotEmpty, true);
      expect(FilterService.isTextSafe('This is a fucking bad word'), false);
    });

    test('空文本应判定为安全', () {
      expect(FilterService.isTextSafe(''), true);
      expect(FilterService.isTextSafe('   '), true);
    });

    test('过滤功能应替换敏感词', () {
      final filtered = FilterService.filterText('这是色情内容');
      expect(filtered.contains('色情'), false);
      expect(filtered.contains('*'), true);
    });

    test('风险等级计算', () {
      expect(FilterService.getRiskLevel('正常文本'), 0);
      expect(FilterService.getRiskLevel('包含色情内容'), greaterThan(0));
    });
  });
}
