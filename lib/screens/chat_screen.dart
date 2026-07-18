/// 聊天页面
/// 用户与漂流瓶对方的实时聊天界面
library;

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../l10n/app_localizations.dart';
import '../models/bottle.dart';
import '../models/conversation.dart';
import '../models/message.dart';
import '../providers/user_provider.dart';
import '../services/chat_service.dart';
import '../services/report_service.dart';
import '../services/supabase_service.dart';
import '../widgets/report_dialog.dart';

/// 聊天页面
class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  /// 聊天服务
  final ChatService _chatService = ChatService();

  /// 消息输入控制器
  final TextEditingController _messageController = TextEditingController();

  /// 滚动控制器
  final ScrollController _scrollController = ScrollController();

  /// 消息列表
  final List<Message> _messages = [];

  /// 当前对话
  Conversation? _conversation;

  /// 对方昵称
  String _partnerNickname = '';

  /// 对方国家名称
  String? _partnerCountry;

  /// 是否正在加载
  bool _isLoading = true;

  /// 是否正在创建对话
  bool _isCreatingConversation = false;

  /// 是否正在发送消息
  bool _isSending = false;

  /// 实时消息订阅
  StreamSubscription? _messageSubscription;

  /// 是否已初始化（避免 didChangeDependencies 重复执行）
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      _initChat();
    }
  }

  @override
  void dispose() {
    _messageSubscription?.cancel();
    _chatService.dispose();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  /// 初始化聊天
  Future<void> _initChat() async {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (args == null) {
      setState(() => _isLoading = false);
      return;
    }

    // 如果传入的是已有对话
    if (args.containsKey('conversation')) {
      final conversation = args['conversation'] as Conversation;
      _conversation = conversation;
      final currentUser = context.read<UserProvider>().currentUser;
      if (currentUser != null) {
        _partnerNickname = conversation.getPartnerNickname(currentUser.id);
        _partnerCountry = conversation.getPartnerCountryName(currentUser.id);
      } else {
        _partnerNickname = conversation.user1Nickname;
        _partnerCountry = conversation.user1CountryName;
      }
      await _loadMessages();
      _subscribeMessages();
      // 标记为已读
      await _markAsRead();
      if (mounted) {
        setState(() => _isLoading = false);
      }
      return;
    }

    // 如果传入的是瓶子，需要创建对话
    if (args.containsKey('bottle')) {
      final bottle = args['bottle'] as Bottle;
      _partnerNickname = bottle.senderNickname;
      _partnerCountry = bottle.senderCountryName;
      setState(() => _isCreatingConversation = true);

      final conversation = await _getOrCreateConversation(bottle);
      if (conversation != null) {
        _conversation = conversation;
        await _loadMessages();
        _subscribeMessages();
      }

      if (mounted) {
        setState(() {
          _isCreatingConversation = false;
          _isLoading = false;
        });
      }
    }
  }

  /// 创建或获取对话（从瓶子进入时）
  /// 直接操作Supabase的bottles和conversations表
  Future<Conversation?> _getOrCreateConversation(Bottle bottle) async {
    final currentUser = context.read<UserProvider>().currentUser;
    if (currentUser == null) return null;

    final client = SupabaseService.instance.client;

    try {
      // 先查询是否已存在该瓶子的对话
      final existing = await client
          .from('conversations')
          .select()
          .eq('bottle_id', bottle.id)
          .maybeSingle();

      if (existing != null) {
        // maybeSingle 返回 Map<String, dynamic>，无需转换
        return Conversation.fromJson(existing);
      }

      // 创建新对话记录
      final response = await client.from('conversations').insert({
        'bottle_id': bottle.id,
        'user1_id': bottle.senderId,
        'user2_id': currentUser.id,
        'user1_nickname': bottle.senderNickname,
        'user1_country_code': bottle.senderCountryCode,
        'user1_country_name': bottle.senderCountryName,
        'user1_language': bottle.senderLanguage,
        'user2_nickname': currentUser.nickname,
        'user2_country_code': currentUser.countryCode,
        'user2_country_name': currentUser.countryName,
        'user2_language': currentUser.language,
        'partner_nickname': bottle.senderNickname,
        'partner_country_code': bottle.senderCountryCode,
        'partner_country_name': bottle.senderCountryName,
        'partner_language': bottle.senderLanguage,
        'last_message': null,
        'last_message_at': DateTime.now().toIso8601String(),
        'last_sender_id': null,
        'unread_count': 0,
        'status': 'active',
        'expires_at': DateTime.now()
            .add(const Duration(days: 7))
            .toIso8601String(),
      }).select().single();

      return Conversation.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  /// 加载历史消息
  Future<void> _loadMessages() async {
    if (_conversation == null) return;

    final messages = await _chatService.getMessages(
      conversationId: _conversation!.id,
    );

    if (mounted) {
      setState(() {
        _messages.clear();
        _messages.addAll(messages);
      });
      _scrollToBottom();
    }
  }

  /// 订阅实时消息（通过Supabase Realtime）
  void _subscribeMessages() {
    if (_conversation == null) return;

    _messageSubscription = _chatService.subscribeToMessages(
      conversationId: _conversation!.id,
      onNewMessage: (message) {
        if (!mounted) return;
        // 已存在该消息：更新字段（如 is_read 状态变化）
        final index = _messages.indexWhere((m) => m.id == message.id);
        if (index != -1) {
          setState(() {
            _messages[index] = message;
          });
          return;
        }
        // 新消息：添加到列表
        setState(() {
          _messages.add(message);
        });
        _scrollToBottom();
        // 如果是对方发的消息，标记为已读
        final currentUser =
            context.read<UserProvider>().currentUser;
        if (currentUser != null &&
            message.senderId != currentUser.id) {
          _markAsRead();
        }
      },
    );
  }

  /// 滚动到底部
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  /// 标记消息为已读
  Future<void> _markAsRead() async {
    final currentUser = context.read<UserProvider>().currentUser;
    if (_conversation == null || currentUser == null) return;

    await _chatService.markMessagesAsRead(
      conversationId: _conversation!.id,
      userId: currentUser.id,
    );
  }

  /// 发送消息
  Future<void> _sendMessage() async {
    final l10n = AppLocalizations.of(context)!;
    final content = _messageController.text.trim();
    if (content.isEmpty) return;

    final currentUser = context.read<UserProvider>().currentUser;
    if (currentUser == null || _conversation == null) return;

    setState(() => _isSending = true);

    final result = await _chatService.sendMessage(
      conversationId: _conversation!.id,
      senderId: currentUser.id,
      content: content,
      senderNickname: currentUser.nickname,
      sourceLanguage: currentUser.language,
      senderCountryCode: currentUser.countryCode,
    );

    if (result.success && result.message != null) {
      final message = result.message!;
      // 避免重复添加（实时订阅可能已经添加）
      if (!_messages.any((m) => m.id == message.id)) {
        setState(() {
          _messages.add(message);
        });
      }
      _messageController.clear();
      _scrollToBottom();
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result.errorMessage ?? l10n.operationFailed),
          ),
        );
      }
    }

    if (mounted) {
      setState(() => _isSending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      decoration: getOceanBackground(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _partnerNickname.isEmpty ? l10n.anonymous : _partnerNickname,
                style: const TextStyle(fontSize: 16),
                overflow: TextOverflow.ellipsis,
              ),
              if (_partnerCountry != null)
                Text(
                  _partnerCountry!,
                  style: const TextStyle(
                    fontSize: 12,
                    color: textSecondary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              // 消息列表
              Expanded(
                child: _isLoading || _isCreatingConversation
                    ? const Center(
                        child: CircularProgressIndicator(color: secondaryColor),
                      )
                    : _messages.isEmpty
                        ? _buildEmptyState()
                        : ListView.builder(
                            controller: _scrollController,
                            padding: const EdgeInsets.all(16),
                            itemCount: _messages.length,
                            itemBuilder: (context, index) {
                              return _buildMessageItem(_messages[index]);
                            },
                          ),
              ),
              // 底部输入栏
              _buildInputBar(),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建空状态
  Widget _buildEmptyState() {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 64,
            color: secondaryColor.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.startChat,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }

  /// 显示消息操作菜单（长按）
  Future<void> _showMessageOptions(Message message) async {
    final l10n = AppLocalizations.of(context)!;
    final currentUser = context.read<UserProvider>().currentUser;
    if (currentUser == null) return;

    final isMe = message.senderId == currentUser.id;
    final canTranslate = message.sourceLanguage.toLowerCase() !=
        currentUser.language.toLowerCase();

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
              if (canTranslate)
                ListTile(
                  leading: const Icon(Icons.translate, color: textPrimary),
                  title: Text(
                    l10n.translateThisMessage,
                    style: const TextStyle(color: textPrimary),
                  ),
                  subtitle: Text(
                    l10n.translateCost(context.read<UserProvider>().remainingTranslateCount),
                    style: const TextStyle(color: textSecondary, fontSize: 12),
                  ),
                  onTap: () => Navigator.pop(context, 'translate'),
                ),
              if (isMe)
                ListTile(
                  leading: const Icon(Icons.delete, color: Colors.redAccent),
                  title: Text(
                    l10n.deleteMessage,
                    style: const TextStyle(color: Colors.redAccent),
                  ),
                  onTap: () => Navigator.pop(context, 'delete'),
                ),
              if (!isMe)
                ListTile(
                  leading: const Icon(Icons.flag_outlined, color: Colors.redAccent),
                  title: Text(
                    l10n.reportUser,
                    style: const TextStyle(color: Colors.redAccent),
                  ),
                  onTap: () => Navigator.pop(context, 'report'),
                ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );

    if (result == 'translate') {
      await _translateMessage(message);
    } else if (result == 'delete') {
      await _deleteMessage(message);
    } else if (result == 'report') {
      await _reportUserFromMessage(message);
    }
  }

  /// 从消息发起举报
  Future<void> _reportUserFromMessage(Message message) async {
    final l10n = AppLocalizations.of(context)!;
    final currentUser = context.read<UserProvider>().currentUser;
    if (currentUser == null || _conversation == null) return;

    // 对方ID = 对话中非当前用户的那一方
    final partnerId = _conversation!.user1Id == currentUser.id
        ? _conversation!.user2Id
        : _conversation!.user1Id;

    if (partnerId.isEmpty) return;

    // 先检查是否已举报过该用户
    final reportService = ReportService();
    final alreadyReported = await reportService.hasReported(
      reporterId: currentUser.id,
      targetType: ReportTargetType.user,
      targetId: partnerId,
    );

    if (!mounted) return;

    if (alreadyReported) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.alreadyReported)),
      );
      return;
    }

    // 消息摘要用于描述
    final messageSummary = message.content.length > 30
        ? '${message.content.substring(0, 30)}...'
        : message.content;
    final description = '$_partnerNickname（消息：$messageSummary）';

    final success = await showReportDialogAndSubmit(
      context: context,
      reporterId: currentUser.id,
      reportedId: partnerId,
      targetType: ReportTargetType.user,
      targetId: partnerId,
      targetDescription: description,
    );

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success ? l10n.reportSubmitted : l10n.operationFailed),
      ),
    );
  }

  /// 翻译单条消息
  Future<void> _translateMessage(Message message) async {
    final l10n = AppLocalizations.of(context)!;
    final userProvider = context.read<UserProvider>();
    final currentUser = userProvider.currentUser;
    if (currentUser == null) return;

    if (userProvider.remainingTranslateCount <= 0) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.translateLimitReached)),
        );
      }
      return;
    }

    setState(() => _isSending = true);

    final translated = await _chatService.translateMessage(
      messageId: message.id,
      userId: currentUser.id,
      content: message.content,
      sourceLanguage: message.sourceLanguage,
      targetLanguage: currentUser.language,
    );

    if (mounted) {
      setState(() => _isSending = false);

      if (translated != null) {
        // 更新本地消息列表中的翻译结果
        final index = _messages.indexWhere((m) => m.id == message.id);
        if (index != -1) {
          setState(() {
            _messages[index] = message.copyWith(
              translatedContent: translated,
              targetLanguage: currentUser.language,
            );
          });
        }
        userProvider.refreshQuotas();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.translateFailed)),
        );
      }
    }
  }

  /// 删除单条消息
  Future<void> _deleteMessage(Message message) async {
    final l10n = AppLocalizations.of(context)!;
    final success = await _chatService.deleteMessage(messageId: message.id);
    if (success && mounted) {
      setState(() {
        _messages.removeWhere((m) => m.id == message.id);
      });
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.operationFailed)),
      );
    }
  }

  /// 构建单条消息
  Widget _buildMessageItem(Message message) {
    final l10n = AppLocalizations.of(context)!;
    final currentUser = context.read<UserProvider>().currentUser;
    final isMe = currentUser != null && message.senderId == currentUser.id;

    return GestureDetector(
      onLongPress: () => _showMessageOptions(message),
      child: Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          decoration: BoxDecoration(
            color: isMe ? secondaryColor : cardColor,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(16),
              topRight: const Radius.circular(16),
              bottomLeft: isMe ? const Radius.circular(16) : Radius.zero,
              bottomRight: isMe ? Radius.zero : const Radius.circular(16),
            ),
            border: isMe ? null : Border.all(color: cardBorderColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // 原文内容
              Text(
                message.content,
                style: TextStyle(
                  color: isMe ? Colors.white : textPrimary,
                  fontSize: 15,
                ),
              ),
              // 译文（如果有）
              if (message.translatedContent != null &&
                  message.translatedContent!.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  message.translatedContent!,
                  style: TextStyle(
                    color: isMe ? Colors.white70 : textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
              // 可翻译提示（仅对方消息显示）
              if (!isMe &&
                  (message.translatedContent == null ||
                      message.translatedContent!.isEmpty)) ...[
                const SizedBox(height: 4),
                Text(
                  l10n.longPressToTranslate,
                  style: TextStyle(
                    color: textSecondary.withValues(alpha: 0.5),
                    fontSize: 11,
                  ),
                ),
              ],
              // 已读状态（仅自己发的消息显示）
              if (isMe) ...[
                const SizedBox(height: 4),
                Text(
                  message.isRead ? l10n.read : l10n.unread,
                  style: TextStyle(
                    color: message.isRead
                        ? Colors.white60
                        : Colors.white.withValues(alpha: 0.4),
                    fontSize: 11,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// 构建底部输入栏
  Widget _buildInputBar() {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
      decoration: BoxDecoration(
        color: darkColor.withValues(alpha: 0.5),
        border: Border(top: BorderSide(color: cardBorderColor)),
      ),
      child: Row(
        children: [
          // 输入框
          Expanded(
            child: TextField(
              controller: _messageController,
              minLines: 1,
              maxLines: 4,
              style: const TextStyle(color: textPrimary),
              decoration: InputDecoration(
                hintText: l10n.messageHint,
                hintStyle: const TextStyle(color: textHint),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(color: cardBorderColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(color: cardBorderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: const BorderSide(color: secondaryColor),
                ),
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          const SizedBox(width: 8),
          // 发送按钮
          IconButton(
            onPressed: _isSending ? null : _sendMessage,
            icon: _isSending
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: secondaryColor,
                      strokeWidth: 2,
                    ),
                  )
                : const Icon(Icons.send, color: secondaryColor),
          ),
        ],
      ),
    );
  }
}
