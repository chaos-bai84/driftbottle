/// 我的瓶子页面
/// 展示用户扔出的所有瓶子及其当前状态（漂流中/已被捞起/已过期）
/// 当瓶子被捞起并产生对话时，展示最后一条消息及跳转到聊天页面的入口
///
/// 对应需求文档 7.3 瓶子状态反馈：
/// - "我的瓶子"页面展示每个瓶子的被捞次数、被回复状态
library;

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../l10n/app_localizations.dart';
import '../models/bottle.dart';
import '../models/conversation.dart';
import '../providers/user_provider.dart';
import '../services/bottle_service.dart';
import '../services/chat_service.dart';

/// 我的瓶子页面
class MyBottlesScreen extends StatefulWidget {
  const MyBottlesScreen({super.key});

  @override
  State<MyBottlesScreen> createState() => _MyBottlesScreenState();
}

class _MyBottlesScreenState extends State<MyBottlesScreen> {
  /// 瓶子服务
  final BottleService _bottleService = BottleService();

  /// 聊天服务（用于查询瓶子对应的对话）
  final ChatService _chatService = ChatService();

  /// 我的瓶子列表
  List<Bottle> _bottles = [];

  /// 每个瓶子对应的对话（bottleId -> Conversation）
  Map<String, Conversation> _conversationMap = {};

  /// 是否正在加载
  bool _isLoading = true;

  /// 实时订阅
  StreamSubscription? _bottleSubscription;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _bottleSubscription?.cancel();
    _chatService.dispose();
    super.dispose();
  }

  /// 加载我的瓶子和关联的对话
  Future<void> _loadData() async {
    final currentUser = context.read<UserProvider>().currentUser;
    if (currentUser == null) {
      if (mounted) setState(() => _isLoading = false);
      return;
    }

    final bottles = await _bottleService.getMyBottles(senderId: currentUser.id);

    // 查询用户的所有对话，建立 bottleId -> Conversation 的映射
    final conversations =
        await _chatService.getConversations(userId: currentUser.id);
    final Map<String, Conversation> convMap = {};
    for (final c in conversations) {
      convMap[c.bottleId] = c;
    }

    if (mounted) {
      setState(() {
        _bottles = bottles;
        _conversationMap = convMap;
        _isLoading = false;
      });
      // 启动实时订阅
      _startSubscription(currentUser.id);
    }
  }

  /// 启动瓶子状态订阅
  void _startSubscription(String userId) {
    if (_bottleSubscription != null) return;
    _bottleSubscription = _bottleService.subscribeToMyBottles(
      senderId: userId,
      onChanged: () => _loadData(),
    );
  }

  /// 下拉刷新
  Future<void> _onRefresh() async {
    await _loadData();
  }

  /// 格式化时间
  String _formatTime(DateTime? time, AppLocalizations l10n) {
    if (time == null) return '';
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inMinutes < 1) return l10n.justNow;
    if (diff.inHours < 1) return l10n.minutesAgo(diff.inMinutes);
    if (diff.inDays < 1) return l10n.hoursAgo(diff.inHours);
    if (diff.inDays < 7) return l10n.daysAgo(diff.inDays);
    return '${time.month}/${time.day}';
  }

  /// 获取瓶子状态文字与颜色
  ({String label, Color color, IconData icon}) _getStatusInfo(
    Bottle bottle,
    AppLocalizations l10n,
  ) {
    // 已过期
    if (bottle.status == 'expired' ||
        (bottle.expiresAt != null && bottle.expiresAt!.isBefore(DateTime.now()))) {
      return (
        label: l10n.expired,
        color: textHint,
        icon: Icons.schedule_outlined,
      );
    }
    // 已被捞起
    if (bottle.status == 'caught' || bottle.catcherId != null) {
      return (
        label: l10n.caught,
        color: accentColor,
        icon: Icons.sailing,
      );
    }
    // 漂流中
    return (
      label: l10n.floating,
      color: secondaryColor,
      icon: Icons.waves,
    );
  }

  /// 进入聊天页面
  Future<void> _openConversation(Conversation conversation) async {
    await Navigator.pushNamed(
      context,
      '/chat',
      arguments: {'conversation': conversation},
    );
    // 返回后刷新数据
    if (mounted) _loadData();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      decoration: getOceanBackground(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(l10n.myBottles),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SafeArea(
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: secondaryColor),
                )
              : RefreshIndicator(
                  color: secondaryColor,
                  onRefresh: _onRefresh,
                  child: _bottles.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          itemCount: _bottles.length,
                          itemBuilder: (context, index) {
                            final bottle = _bottles[index];
                            final conversation = _conversationMap[bottle.id];
                            return _buildBottleItem(bottle, conversation);
                          },
                        ),
                ),
        ),
      ),
    );
  }

  /// 空状态
  Widget _buildEmptyState() {
    final l10n = AppLocalizations.of(context)!;
    return ListView(
      children: [
        const SizedBox(height: 120),
        Center(
          child: Column(
            children: [
              Icon(
                Icons.sailing_outlined,
                size: 80,
                color: secondaryColor.withValues(alpha: 0.3),
              ),
              const SizedBox(height: 16),
              Text(
                l10n.noBottlesThrown,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                l10n.goThrowBottle,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// 构建瓶子项
  Widget _buildBottleItem(Bottle bottle, Conversation? conversation) {
    final l10n = AppLocalizations.of(context)!;
    final status = _getStatusInfo(bottle, l10n);
    final hasConversation = conversation != null;
    final hasReply = hasConversation &&
        conversation.lastMessage != null &&
        conversation.lastMessage!.isNotEmpty;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: getCardDecoration(),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: hasConversation ? () => _openConversation(conversation) : null,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 状态标签行
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: status.color.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: status.color.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(status.icon, size: 12, color: status.color),
                        const SizedBox(width: 4),
                        Text(
                          status.label,
                          style: TextStyle(
                            color: status.color,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Text(
                    _formatTime(bottle.createdAt, l10n),
                    style: const TextStyle(color: textHint, fontSize: 11),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // 瓶子内容摘要
              Text(
                bottle.content,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: textPrimary,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
              // 话题标签
              if (bottle.tag != null && bottle.tag!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: bottle.tag!.split(' ').map((t) {
                    final tag = t.trim();
                    if (tag.isEmpty) return const SizedBox.shrink();
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: secondaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        tag,
                        style: const TextStyle(
                          color: secondaryColor,
                          fontSize: 11,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
              // 被捞起信息
              if (bottle.caughtAt != null) ...[
                const SizedBox(height: 12),
                const Divider(color: cardBorderColor, height: 1),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.person_pin_outlined,
                      size: 14,
                      color: accentColor,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        l10n.caughtAtTime(_formatTime(bottle.caughtAt, l10n)),
                        style: const TextStyle(
                          color: accentColor,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
              // 对话/回复状态
              if (hasConversation) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: darkColor.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        hasReply
                            ? Icons.chat_bubble_outline
                            : Icons.chat_bubble_outline_outlined,
                        size: 14,
                        color: hasReply ? secondaryColor : textHint,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          hasReply
                              ? l10n.replyMessage(conversation.lastMessage!)
                              : l10n.caughtNoReply,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: hasReply ? textPrimary : textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.chevron_right,
                        size: 16,
                        color: textHint,
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
