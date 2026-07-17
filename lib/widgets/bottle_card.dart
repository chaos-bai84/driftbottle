/// 瓶子卡片组件
/// 在海洋页面展示捞到的漂流瓶内容，提供回复与丢弃操作
library;

import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../models/bottle.dart';

/// 瓶子卡片组件
/// 在深蓝海洋背景上呈现半透明发光卡片，展示瓶子内容
class BottleCard extends StatelessWidget {
  /// 瓶子数据
  final Bottle bottle;

  /// 回复按钮回调
  final VoidCallback onReply;

  /// 丢回海里按钮回调
  final VoidCallback onDiscard;

  const BottleCard({
    super.key,
    required this.bottle,
    required this.onReply,
    required this.onDiscard,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: getCardDecoration(),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 顶部小瓶子图标
          Center(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: secondaryColor.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.local_drink,
                color: accentColor,
                size: 32,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 发送者国家信息
          if (bottle.senderCountryName != null ||
              bottle.senderCountryCode != null)
            Row(
              children: [
                const Icon(
                  Icons.public,
                  size: 16,
                  color: textSecondary,
                ),
                const SizedBox(width: 6),
                Text(
                  _getCountryDisplay(),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),

          // 话题标签
          if (bottle.tag != null && bottle.tag!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: secondaryColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                bottle.tag!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: accentColor,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          ],

          // 瓶子内容
          const SizedBox(height: 16),
          Text(
            bottle.content,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  height: 1.6,
                ),
          ),

          // 底部操作按钮
          const SizedBox(height: 20),
          Row(
            children: [
              // 回复按钮 - 主色背景
              Expanded(
                child: ElevatedButton(
                  onPressed: onReply,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('回复'),
                ),
              ),
              const SizedBox(width: 12),
              // 丢回海里按钮 - 透明背景加边框
              Expanded(
                child: OutlinedButton(
                  onPressed: onDiscard,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: textPrimary,
                    backgroundColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    side: const BorderSide(color: cardBorderColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('丢回海里'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 获取国家显示文本
  /// 优先展示国旗emoji + 国家名，无国家名时仅展示国旗
  String _getCountryDisplay() {
    final code = bottle.senderCountryCode;
    final name = bottle.senderCountryName;

    // 将两位国家代码转换为国旗emoji（区域指示符）
    String flag = '';
    if (code != null && code.length == 2) {
      flag = String.fromCharCodes(
        code.toUpperCase().codeUnits.map((c) => 0x1F1E6 + c - 0x41),
      );
    }

    if (name != null && name.isNotEmpty) {
      return flag.isEmpty ? name : '$flag $name';
    }
    return flag.isEmpty ? (code ?? '未知地区') : flag;
  }
}
