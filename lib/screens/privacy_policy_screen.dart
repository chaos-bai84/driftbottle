/// 隐私政策页面
/// 展示 DriftBottle 的数据收集、使用和用户权利说明
library;

import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../l10n/app_localizations.dart';

/// 隐私政策页面
class PrivacyPolicyScreen extends StatelessWidget {
  /// 构造方法
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      decoration: getOceanBackground(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: textPrimary),
          title: Text(
            l10n.privacyPolicy,
            style: const TextStyle(color: textPrimary),
          ),
        ),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            children: [
              Text(
                l10n.privacyPolicyTitle,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                l10n.lastUpdated,
                style: const TextStyle(color: textHint, fontSize: 12),
              ),
              const SizedBox(height: 24),
              _buildSection(
                title: l10n.privacySection1Title,
                content: l10n.privacySection1Content,
              ),
              _buildSection(
                title: l10n.privacySection2Title,
                content: l10n.privacySection2Content,
              ),
              _buildSection(
                title: l10n.privacySection3Title,
                content: l10n.privacySection3Content,
              ),
              _buildSection(
                title: l10n.privacySection4Title,
                content: l10n.privacySection4Content,
              ),
              _buildSection(
                title: l10n.privacySection5Title,
                content: l10n.privacySection5Content,
              ),
              _buildSection(
                title: l10n.privacySection6Title,
                content: l10n.privacySection6Content,
              ),
              _buildSection(
                title: l10n.privacySection7Title,
                content: l10n.privacySection7Content,
              ),
              _buildSection(
                title: l10n.privacySection8Title,
                content: l10n.privacySection8Content,
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建政策章节
  Widget _buildSection({required String title, required String content}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              color: textSecondary,
              fontSize: 14,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
