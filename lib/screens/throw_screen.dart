/// 扔瓶子页面
/// 用户在此编写漂流瓶内容并扔进大海
library;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../config/constants.dart';
import '../l10n/app_localizations.dart';
import '../providers/user_provider.dart';
import '../providers/bottle_provider.dart';

/// 扔漂流瓶页面
class ThrowScreen extends StatefulWidget {
  const ThrowScreen({super.key});

  @override
  State<ThrowScreen> createState() => _ThrowScreenState();
}

class _ThrowScreenState extends State<ThrowScreen> {
  /// 文本输入控制器
  final TextEditingController _contentController = TextEditingController();

  /// 当前选中的话题标签（最多3个）
  final List<String> _selectedTags = [];

  /// 最大字数限制
  static const int _maxChars = 500;

  /// 最小字数要求
  static const int _minChars = 10;

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  /// 扔瓶子操作
  Future<void> _onThrowBottle() async {
    final l10n = AppLocalizations.of(context)!;
    final content = _contentController.text.trim();

    // 校验内容长度
    if (content.length < _minChars) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.contentMinLength(_minChars))),
      );
      return;
    }

    final userProvider = context.read<UserProvider>();
    final bottleProvider = context.read<BottleProvider>();

    // 校验剩余次数
    if (userProvider.remainingThrowCount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.throwLimitReached)),
      );
      return;
    }

    final currentUser = userProvider.currentUser;
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.pleaseLogin)),
      );
      return;
    }

    // 调用Provider扔瓶子
    final success = await bottleProvider.throwBottle(
      senderId: currentUser.id,
      content: content,
      tag: _selectedTags.isEmpty ? null : _selectedTags.join(' '),
      senderNickname: currentUser.nickname,
      senderCountryCode: currentUser.countryCode,
      senderCountryName: currentUser.countryName,
      senderLanguage: currentUser.language,
    );

    if (!mounted) return;

    if (success) {
      // 成功提示
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.bottleThrownSuccess)),
      );
      // 刷新配额
      userProvider.refreshQuotas();
      // 清除输入
      _contentController.clear();
      // 返回海洋页
      Navigator.pop(context);
    } else {
      // 失败提示
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(bottleProvider.message ?? l10n.operationFailed),
        ),
      );
    }
  }

  /// 切换话题标签选中状态
  void _toggleTag(String tag) {
    final l10n = AppLocalizations.of(context)!;
    setState(() {
      if (_selectedTags.contains(tag)) {
        _selectedTags.remove(tag);
      } else if (_selectedTags.length < 3) {
        _selectedTags.add(tag);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.maxTagsHint)),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      decoration: getOceanBackground(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text(l10n.writeBottleTitle),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SafeArea(
          child: Consumer2<UserProvider, BottleProvider>(
            builder: (context, userProvider, bottleProvider, child) {
              final isThrowing = bottleProvider.isThrowing;
              final remaining = userProvider.remainingThrowCount;
              final isNew = userProvider.isNewUser;
              final limit = isNew ? newUserThrowLimit : dailyThrowLimit;
              final quotaHint = isNew
                  ? l10n.throwQuotaHintNew(remaining, limit, dailyThrowLimit)
                  : l10n.throwQuotaHint(remaining, limit);

              return SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 配额提示
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: getCardDecoration(),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.sailing,
                            size: 18,
                            color: accentColor,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              quotaHint,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 内容输入框（固定高度，避免键盘弹出时被推走）
                    Container(
                      height: 220,
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: cardBorderColor),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: TextField(
                        controller: _contentController,
                        maxLength: _maxChars,
                        maxLines: null,
                        minLines: 6,
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.newline,
                        style: const TextStyle(color: textPrimary),
                        scrollPadding: const EdgeInsets.only(bottom: 120),
                        decoration: InputDecoration(
                          hintText: l10n.writeBottleContent,
                          border: InputBorder.none,
                          counterStyle: const TextStyle(color: textSecondary),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 话题标签标题
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '选择话题（最多3个）',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // 话题标签选择区
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: tags.map((tag) {
                        final selected = _selectedTags.contains(tag);
                        return ChoiceChip(
                          label: Text(tag),
                          selected: selected,
                          selectedColor: secondaryColor,
                          backgroundColor: cardColor,
                          labelStyle: TextStyle(
                            color: selected ? Colors.white : textSecondary,
                          ),
                          side: BorderSide(color: cardBorderColor),
                          onSelected: (_) => _toggleTag(tag),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),

                    // 扔进大海按钮
                    ElevatedButton(
                      onPressed: isThrowing ? null : _onThrowBottle,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: isThrowing
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(l10n.throwIntoOcean),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
