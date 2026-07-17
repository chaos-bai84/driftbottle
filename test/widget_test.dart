// DriftBottle 基础widget测试
//
// 验证应用能正常构建和显示启动页面

import 'package:flutter_test/flutter_test.dart';

import 'package:driftbottle/main.dart';

void main() {
  testWidgets('App launches and shows splash screen', (WidgetTester tester) async {
    // 构建应用并触发一帧
    await tester.pumpWidget(const DriftBottleApp());

    // 验证启动页显示了应用名称
    expect(find.text('DriftBottle'), findsOneWidget);
  });
}
