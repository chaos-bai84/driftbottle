/// 对话列表页面
/// 显示当前用户的所有活跃对话
library;

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../models/conversation.dart';
import '../providers/user_provider.dart';
import '../services/chat_service.dart';
import '../widgets/nav_bar.dart';

/// 对话列表页面
class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  /// 聊天服务
  final ChatService _chatService = ChatService();

  /// 对话列表
  List<Conversation> _conversations = [];

  /// 是否正在加载
  bool _isLoading = true;

  /// 对话列表实时订阅
  StreamSubscription? _conversationSubscription;

  @override
  void initState() {
    super.initState();
    _loadConversations();
  }

  @override
  void dispose() {
    _conversationSubscription?.cancel();
    _chatService.dispose();
    super.dispose();
  }

  /// 加载对话列表
  Future<void> _loadConversations() async {
    final userProvider = context.read<UserProvider>();
    final currentUser = userProvider.currentUser;

    if (currentUser == null) {
      setState(() => _isLoading = false);
      return;
    }

    final conversations = await _chatService.getConversations(
      userId: currentUser.id,
    );

    if (mounted) {
      setState(() {
        _conversations = conversations;
        _isLoading = false;
      });
      // 启动实时订阅
      _startSubscription(currentUser.id);
    }
  }

  /// 启动对话列表实时订阅
  void _startSubscription(String userId) {
    if (_conversationSubscription != null) return;

    _conversationSubscription = _chatService.subscribeToConversations(
      userId: userId,
      onChanged: () {
        // 对话有变化时重新加载
        _loadConversations();
      },
    );
  }

  /// 下拉刷新
  Future<void> _onRefresh() async {
    await _loadConversations();
  }

  /// 格式化时间显示
  String _formatTime(DateTime? time) {
    if (time == null) return '';
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inMinutes < 1) return '刚刚';
    if (diff.inHours < 1) return '${diff.inMinutes}分钟前';
    if (diff.inDays < 1) return '${diff.inHours}小时前';
    if (diff.inDays < 7) return '${diff.inDays}天前';
    return '${time.month}/${time.day}';
  }

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
                      '对话',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ],
                ),
              ),
              // 对话列表
              Expanded(
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(color: secondaryColor),
                      )
                    : RefreshIndicator(
                        color: secondaryColor,
                        onRefresh: _onRefresh,
                        child: _conversations.isEmpty
                            ? _buildEmptyState()
                            : ListView.builder(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                itemCount: _conversations.length,
                                itemBuilder: (context, index) {
                                  return _buildConversationItem(
                                    _conversations[index],
                                  );
                                },
                              ),
                      ),
              ),
            ],
          ),
        ),
        // 底部导航栏
        bottomNavigationBar: const NavBar(currentIndex: 1),
      ),
    );
  }

  /// 构建空状态
  Widget _buildEmptyState() {
    // 用ListView包裹，使下拉刷新在空状态下仍可触发
    return ListView(
      children: [
        const SizedBox(height: 120),
        Center(
          child: Column(
            children: [
              Icon(
                Icons.inbox_outlined,
                size: 80,
                color: secondaryColor.withValues(alpha: 0.3),
              ),
              const SizedBox(height: 16),
              Text(
                '还没有对话',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                '去捞一个瓶子吧',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// 构建对话项
  Widget _buildConversationItem(Conversation conversation) {
    final currentUser = context.read<UserProvider>().currentUser;
    final userId = currentUser?.id ?? '';
    final partnerNickname = conversation.getPartnerNickname(userId);
    final partnerCountry = conversation.getPartnerCountryName(userId);
    final unreadCount = conversation.getMyUnreadCount(userId);
    final showUnread = unreadCount > 0;

    return GestureDetector(
      onLongPress: () => _showConversationOptions(conversation),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: getCardDecoration(),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          // 头像
          leading: CircleAvatar(
            backgroundColor: secondaryColor.withValues(alpha: 0.3),
            child: Text(
              partnerNickname.isNotEmpty
                  ? partnerNickname.substring(0, 1)
                  : '?',
              style: const TextStyle(color: textPrimary),
            ),
          ),
          // 昵称和国家
          title: Row(
            children: [
              Flexible(
                child: Text(
                  partnerNickname,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (partnerCountry != null) ...[
                const SizedBox(width: 6),
                Text(
                  partnerCountry,
                  style: const TextStyle(
                    color: textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ],
          ),
          // 最后消息
          subtitle: Text(
            conversation.lastMessage ?? '开始对话吧',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: textSecondary, fontSize: 13),
          ),
          // 时间和未读数
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _formatTime(conversation.lastMessageAt),
                style: const TextStyle(color: textHint, fontSize: 11),
              ),
              if (showUnread) ...[
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: secondaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '$unreadCount',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ],
          ),
          onTap: () async {
            // 点击进入聊天页面
            await Navigator.pushNamed(
              context,
              '/chat',
              arguments: {'conversation': conversation},
            );
            // 返回后刷新对话列表
            _loadConversations();
          },
        ),
      ),
    );
  }

  /// 显示对话操作菜单（长按）
  Future<void> _showConversationOptions(Conversation conversation) async {
    final result = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: textSecondary.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.redAccent),
                title: const Text(
                  '删除对话',
                  style: TextStyle(color: Colors.redAccent),
                ),
                onTap: () => Navigator.pop(context, 'delete'),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );

    if (result == 'delete') {
      await _deleteConversation(conversation);
    }
  }

  /// 删除对话
  Future<void> _deleteConversation(Conversation conversation) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: cardColor,
          title: const Text('删除对话', style: TextStyle(color: textPrimary)),
          content: const Text(
            '确定删除这个对话吗？对话中的所有消息都会被删除。',
            style: TextStyle(color: textSecondary),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text(
                '删除',
                style: TextStyle(color: Colors.redAccent),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    final chatService = ChatService();
    final success = await chatService.deleteConversation(
      conversationId: conversation.id,
    );

    if (success && mounted) {
      setState(() {
        _conversations.removeWhere((c) => c.id == conversation.id);
      });
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('删除失败，请重试')),
      );
    }
  }
}
