/// 隐私政策页面
/// 展示 DriftBottle 的数据收集、使用和用户权利说明
library;

import 'package:flutter/material.dart';
import '../config/theme.dart';

/// 隐私政策页面
class PrivacyPolicyScreen extends StatelessWidget {
  /// 构造方法
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: getOceanBackground(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: textPrimary),
          title: const Text(
            '隐私政策',
            style: TextStyle(color: textPrimary),
          ),
        ),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            children: [
              Text(
                'DriftBottle 隐私政策',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              const Text(
                '最后更新日期：2026年7月18日',
                style: TextStyle(color: textHint, fontSize: 12),
              ),
              const SizedBox(height: 24),
              _buildSection(
                title: '1. 我们收集哪些信息',
                content:
                    '为了提供漂流瓶和跨语言聊天服务，我们会收集以下最少必要信息：\n\n'
                    '• 设备标识符：用于匿名登录和识别账号，无需手机号。\n'
                    '• 昵称、国家、母语：用于在瓶子中展示你的文化背景。\n'
                    '• 你发送的瓶子内容和聊天消息：用于匹配其他用户并展示给对方。\n'
                    '• IP 地址：用于估算你的国家/地区。',
              ),
              _buildSection(
                title: '2. 我们如何使用信息',
                content:
                    '• 将你的瓶子随机匹配给全球其他用户。\n'
                    '• 调用 Google 翻译接口将内容翻译为接收者的母语。\n'
                    '• 维护每日配额（扔瓶、捞瓶、翻译次数）和对话过期机制。\n'
                    '• 通过本地敏感词过滤保护社区安全。',
              ),
              _buildSection(
                title: '3. 数据存储与安全',
                content:
                    '用户数据存储在 Supabase（PostgreSQL）中。我们采用 Row Level Security（RLS）限制数据访问：用户只能读取和自己相关的瓶子、对话和消息。所有网络通信均通过 HTTPS/WSS 加密传输。',
              ),
              _buildSection(
                title: '4. 你的权利',
                content:
                    '• 访问：你可以在「我的」页面查看和修改昵称、国家、语言。\n'
                    '• 删除：你可以通过应用内反馈或邮件联系我们删除所有个人数据。\n'
                    '• 撤回：停止使用应用即视为撤回授权，7 天后过期对话和消息将自动清理。',
              ),
              _buildSection(
                title: '5. 第三方服务',
                content:
                    '我们使用以下第三方服务来运行应用：\n\n'
                    '• Supabase：数据库和实时通信。\n'
                    '• Google 免费翻译 API：消息翻译。\n\n'
                    '这些服务提供商有自己的隐私政策，我们建议你一并查阅。',
              ),
              _buildSection(
                title: '6. 儿童隐私',
                content:
                    'DriftBottle 不面向 13 岁以下儿童。如果我们发现收集了 13 岁以下儿童的个人信息，会立即删除。',
              ),
              _buildSection(
                title: '7. 政策更新',
                content:
                    '我们可能会不时更新本隐私政策。更新后的政策将在应用内发布，并更新最后更新日期。',
              ),
              _buildSection(
                title: '8. 联系我们',
                content:
                    '如有任何问题或数据删除请求，请发送邮件至：support@driftbottle.app',
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
