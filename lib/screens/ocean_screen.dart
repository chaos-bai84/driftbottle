/// 海洋页面 - 捞瓶子
/// 应用的主页，用户可以在此捞取漂流瓶
/// V1.0 新增：捞瓶方话题标签筛选（原为付费版功能，V1.0免费开放）
library;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../config/constants.dart';
import '../l10n/app_localizations.dart';
import '../providers/user_provider.dart';
import '../providers/bottle_provider.dart';
import '../widgets/bottle_card.dart';
import '../widgets/nav_bar.dart';

/// 海洋页面
class OceanScreen extends StatefulWidget {
  const OceanScreen({super.key});

  @override
  State<OceanScreen> createState() => _OceanScreenState();
}

class _OceanScreenState extends State<OceanScreen> {
  /// 捞瓶时选中的话题标签（最多3个）
  final List<String> _selectedCatchTags = [];

  /// 切换话题标签选中状态
  void _toggleCatchTag(String tag) {
    final l10n = AppLocalizations.of(context)!;
    setState(() {
      if (_selectedCatchTags.contains(tag)) {
        _selectedCatchTags.remove(tag);
      } else if (_selectedCatchTags.length < 3) {
        _selectedCatchTags.add(tag);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.tagFilterHint)),
        );
      }
    });
  }

  /// 捞瓶子操作
  Future<void> _onCatchBottle(BuildContext context) async {
    final userProvider = context.read<UserProvider>();
    final bottleProvider = context.read<BottleProvider>();
    final l10n = AppLocalizations.of(context)!;

    if (userProvider.remainingCatchCount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.catchLimitReached)),
      );
      return;
    }

    if (userProvider.currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.pleaseLogin)),
      );
      return;
    }

    bottleProvider.clearMessage();
    final bottle = await bottleProvider.catchBottleWithTags(
      catcherId: userProvider.currentUser!.id,
      tags: _selectedCatchTags.isEmpty ? null : _selectedCatchTags,
    );

    // 捞瓶子完成后刷新配额（无论成功与否都刷新）
    if (bottle != null || bottleProvider.message != null) {
      await userProvider.refreshQuotas();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
                      l10n.appName,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const Spacer(),
                    // 跳转到扔瓶子页面
                    IconButton(
                      icon: const Icon(Icons.edit_note, color: textPrimary),
                      onPressed: () {
                        Navigator.pushNamed(context, '/throw');
                      },
                      tooltip: l10n.throwBottle,
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
                              l10n.loading,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                        ),
                      );
                    }

                    // 默认状态 - 显示捞瓶子按钮和标签筛选
                    return SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // 标签筛选区
                          _buildTagFilter(),
                          const SizedBox(height: 24),
                          // 中央捞瓶子按钮
                          Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // 海浪图标
                                Icon(
                                  Icons.waves,
                                  size: 80,
                                  color: secondaryColor.withValues(alpha: 0.3),
                                ),
                                const SizedBox(height: 24),
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
                                    l10n.catchBottle,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(color: Colors.white),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                // 操作提示
                                Text(
                                  _selectedCatchTags.isEmpty
                                      ? l10n.emptyOcean
                                      : l10n.selectedTags(
                                          _selectedCatchTags.join(' ')),
                                  style: Theme.of(context).textTheme.bodySmall,
                                  textAlign: TextAlign.center,
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
                                          color: bottleProvider.messageType ==
                                                  'error'
                                              ? Colors.redAccent
                                              : accentColor,
                                        ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ],
                            ),
                          ),
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
                          label: isNew ? l10n.quotaCatchNew : l10n.quotaCatch,
                          count: userProvider.remainingCatchCount,
                          total: isNew ? newUserCatchLimit : dailyCatchLimit,
                        ),
                        _QuotaItem(
                          label: isNew ? l10n.quotaThrowNew : l10n.quotaThrow,
                          count: userProvider.remainingThrowCount,
                          total: isNew ? newUserThrowLimit : dailyThrowLimit,
                        ),
                        _QuotaItem(
                          label: l10n.quotaTranslate,
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

  /// 构建话题标签筛选区
  Widget _buildTagFilter() {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: getCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.filter_list, size: 16, color: accentColor),
              const SizedBox(width: 6),
              Text(
                l10n.tagFilterHint,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const Spacer(),
              if (_selectedCatchTags.isNotEmpty)
                GestureDetector(
                  onTap: () {
                    setState(() => _selectedCatchTags.clear());
                  },
                  child: Text(
                    l10n.clear,
                    style: const TextStyle(color: secondaryColor, fontSize: 12),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: tags.map((tag) {
              final selected = _selectedCatchTags.contains(tag);
              return ChoiceChip(
                label: Text(tag),
                selected: selected,
                selectedColor: secondaryColor,
                backgroundColor: darkColor.withValues(alpha: 0.5),
                labelStyle: TextStyle(
                  color: selected ? Colors.white : textSecondary,
                  fontSize: 12,
                ),
                side: BorderSide(
                  color: selected ? secondaryColor : cardBorderColor,
                ),
                onSelected: (_) => _toggleCatchTag(tag),
              );
            }).toList(),
          ),
        ],
      ),
    );
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
