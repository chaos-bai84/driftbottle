/// 海洋页面 - 捞瓶子
/// 应用的主页，用户可以在此捞取漂流瓶
library;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../config/constants.dart';
import '../providers/user_provider.dart';
import '../providers/bottle_provider.dart';
import '../widgets/bottle_card.dart';
import '../widgets/nav_bar.dart';

/// 海洋页面
class OceanScreen extends StatelessWidget {
  const OceanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: getOceanBackground(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              // 顶部标题
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Row(
                  children: [
                    Text(
                      '漂流瓶',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const Spacer(),
                    // 跳转到扔瓶子页面
                    IconButton(
                      icon: const Icon(Icons.edit_note, color: textPrimary),
                      onPressed: () {
                        Navigator.pushNamed(context, '/throw');
                      },
                      tooltip: '写瓶子',
                    ),
                  ],
                ),
              ),

              // 中间区域 - 捞瓶子按钮或瓶子卡片
              Expanded(
                child: Consumer<BottleProvider>(
                  builder: (context, bottleProvider, child) {
                    // 显示捞到的瓶子
                    if (bottleProvider.currentBottle != null) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: BottleCard(
                            bottle: bottleProvider.currentBottle!,
                            onReply: () {
                              // 回复瓶子，跳转到聊天页面
                              Navigator.pushNamed(
                                context,
                                '/chat',
                                arguments: {
                                  'bottle': bottleProvider.currentBottle,
                                },
                              );
                            },
                            onDiscard: () {
                              bottleProvider.discardBottle(
                                bottleId: bottleProvider.currentBottle!.id,
                              );
                            },
                          ),
                        ),
                      );
                    }

                    // 捞瓶子加载中
                    if (bottleProvider.isCatching) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const CircularProgressIndicator(
                              color: secondaryColor,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              '正在打捞中...',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                        ),
                      );
                    }

                    // 默认状态 - 显示捞瓶子按钮
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // 海浪图标
                          Icon(
                            Icons.waves,
                            size: 80,
                            color: secondaryColor.withValues(alpha: 0.3),
                          ),
                          const SizedBox(height: 32),
                          // 捞瓶子按钮
                          ElevatedButton(
                            onPressed: () => _onCatchBottle(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 48,
                                vertical: 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: Text(
                              '捞瓶子',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(color: Colors.white),
                            ),
                          ),
                          const SizedBox(height: 16),
                          // 操作提示
                          Text(
                            '从大海中捞起一个漂流瓶',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          // 显示操作消息
                          if (bottleProvider.message != null) ...[
                            const SizedBox(height: 12),
                            Text(
                              bottleProvider.message!,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: bottleProvider.messageType == 'error'
                                        ? Colors.redAccent
                                        : accentColor,
                                  ),
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                ),
              ),

              // 底部配额信息
              Consumer<UserProvider>(
                builder: (context, userProvider, child) {
                  final isNew = userProvider.isNewUser;
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _QuotaItem(
                          label: isNew ? '可捞(新)' : '可捞',
                          count: userProvider.remainingCatchCount,
                          total: isNew ? newUserCatchLimit : dailyCatchLimit,
                        ),
                        _QuotaItem(
                          label: isNew ? '可扔(新)' : '可扔',
                          count: userProvider.remainingThrowCount,
                          total: isNew ? newUserThrowLimit : dailyThrowLimit,
                        ),
                        _QuotaItem(
                          label: '可翻译',
                          count: userProvider.remainingTranslateCount,
                          total: dailyTranslateLimit,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        // 底部导航栏
        bottomNavigationBar: const NavBar(currentIndex: 0),
      ),
    );
  }

  /// 捞瓶子操作
  Future<void> _onCatchBottle(BuildContext context) async {
    final userProvider = context.read<UserProvider>();
    final bottleProvider = context.read<BottleProvider>();

    if (userProvider.remainingCatchCount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('今日捞瓶子次数已用完')),
      );
      return;
    }

    if (userProvider.currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请先完成登录')),
      );
      return;
    }

    bottleProvider.clearMessage();
    final bottle =
        await bottleProvider.catchBottle(catcherId: userProvider.currentUser!.id);

    // 捞瓶子完成后刷新配额（无论成功与否都刷新）
    if (bottle != null || bottleProvider.message != null) {
      await userProvider.refreshQuotas();
    }
  }
}

/// 配额显示组件
class _QuotaItem extends StatelessWidget {
  final String label;
  final int count;
  final int total;

  const _QuotaItem({
    required this.label,
    required this.count,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '$count/$total',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: count > 0 ? secondaryColor : textHint,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}