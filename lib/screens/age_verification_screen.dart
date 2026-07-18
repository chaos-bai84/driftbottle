/// 未成年人使用提示页面
/// 首次启动时显示，要求用户确认已年满13岁
///
/// 对应需求文档 6.3 节"全球法规合规"的MVP落地要求：
/// - 未成年人使用提示，建议13/16岁以下用户勿注册（V1.0）
/// - 美国 COPPA：13岁以下禁止注册
/// - 日本青少年网络环境整备法：18岁以下用户需限制
library;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/theme.dart';
import '../l10n/app_localizations.dart';

/// 未成年人使用提示页面
class AgeVerificationScreen extends StatefulWidget {
  /// 用户同意后跳转的路由
  final VoidCallback onAgreed;

  const AgeVerificationScreen({
    super.key,
    required this.onAgreed,
  });

  @override
  State<AgeVerificationScreen> createState() => _AgeVerificationScreenState();

  /// SharedPreferences键名 - 是否已通过年龄验证
  static const String keyAgeVerified = 'age_verified';

  /// 检查用户是否已通过年龄验证
  static Future<bool> isAgeVerified() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(keyAgeVerified) ?? false;
  }

  /// 标记用户已通过年龄验证
  static Future<void> markAgeVerified() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(keyAgeVerified, true);
  }
}

class _AgeVerificationScreenState extends State<AgeVerificationScreen> {
  /// 是否正在处理同意操作
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      decoration: getOceanBackground(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 32,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 顶部图标
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: secondaryColor.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.local_drink,
                      size: 64,
                      color: accentColor,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // 应用名称
                Center(
                  child: Text(
                    'DriftBottle',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          letterSpacing: 2,
                        ),
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    l10n.slogan,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                const SizedBox(height: 32),

                // 年龄限制说明卡片
                Container(
                  decoration: getCardDecoration(),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.shield_outlined,
                            color: secondaryColor,
                            size: 22,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            l10n.ageVerificationTitle,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l10n.welcomeText,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 12),
                      _buildBulletPoint(context, l10n.ageRule1),
                      _buildBulletPoint(context, l10n.ageRule2),
                      _buildBulletPoint(context, l10n.ageRule3),
                      _buildBulletPoint(context, l10n.ageRule4),
                      _buildBulletPoint(context, l10n.ageRule5),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // 隐私政策提示
                Container(
                  decoration: getCardDecoration(),
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.privacy_tip_outlined,
                        color: secondaryColor,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                          child: Text(
                            l10n.privacyAgreement,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // 同意并继续按钮
                ElevatedButton(
                  onPressed: _isProcessing ? null : _onAgree,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isProcessing
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          l10n.ageVerificationConfirm,
                          style: const TextStyle(fontSize: 16),
                        ),
                ),
                const SizedBox(height: 12),

                // 退出按钮
                OutlinedButton(
                  onPressed: _isProcessing ? null : _onExit,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: textSecondary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(color: cardBorderColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(l10n.disagreeExit),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 构建要点项
  Widget _buildBulletPoint(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '• ',
            style: TextStyle(
              color: secondaryColor,
              fontSize: 14,
              height: 1.5,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    height: 1.5,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  /// 用户同意
  Future<void> _onAgree() async {
    final l10n = AppLocalizations.of(context)!;
    setState(() => _isProcessing = true);

    try {
      await AgeVerificationScreen.markAgeVerified();
      if (mounted) {
        widget.onAgreed();
      }
    } catch (_) {
      if (mounted) {
        setState(() => _isProcessing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.operationFailed)),
        );
      }
    }
  }

  /// 用户不同意，退出应用
  void _onExit() {
    // 关闭应用
    // ignore: avoid_print
    print('用户不同意年龄限制，退出应用');
    // 使用 SystemNavigator.pop 退出应用（仅在移动端有效）
    Navigator.of(context).maybePop();
  }
}
