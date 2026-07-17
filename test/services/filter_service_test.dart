import 'package:flutter_test/flutter_test.dart';
import 'package:driftbottle/services/filter_service.dart';

void main() {
  group('FilterService 敏感词过滤测试', () {
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
