/// 个人资料页面
/// 显示和编辑用户信息、查看每日配额
library;

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../config/constants.dart';
import '../l10n/app_localizations.dart';
import '../providers/user_provider.dart';
import '../widgets/nav_bar.dart';
import 'privacy_policy_screen.dart';

/// 个人资料页面
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  /// 可选国家列表
  static const List<Map<String, String>> _countryOptions = [
    {'code': 'CN', 'name': '中国'},
    {'code': 'US', 'name': '美国'},
    {'code': 'JP', 'name': '日本'},
    {'code': 'KR', 'name': '韩国'},
    {'code': 'GB', 'name': '英国'},
    {'code': 'FR', 'name': '法国'},
    {'code': 'DE', 'name': '德国'},
    {'code': 'BR', 'name': '巴西'},
    {'code': 'IN', 'name': '印度'},
    {'code': '', 'name': '其他'},
  ];

  /// 可选语言列表
  static const List<Map<String, String>> _languageOptions = [
    {'code': 'zh', 'name': '中文'},
    {'code': 'en', 'name': '英语'},
    {'code': 'ja', 'name': '日语'},
    {'code': 'ko', 'name': '韩语'},
    {'code': 'fr', 'name': '法语'},
    {'code': 'de', 'name': '德语'},
    {'code': 'es', 'name': '西班牙语'},
    {'code': 'pt', 'name': '葡萄牙语'},
    {'code': 'ru', 'name': '俄语'},
  ];

  /// 昵称输入控制器
  late TextEditingController _nicknameController;

  /// 选中的国家代码
  String? _selectedCountryCode;

  /// 选中的国家名称
  String? _selectedCountryName;

  /// 选中的语言代码
  String? _selectedLanguage;

  /// 是否正在保存
  bool _isSaving = false;

  /// 是否正在导出数据
  bool _isExporting = false;

  @override
  void initState() {
    super.initState();
    final user = context.read<UserProvider>().currentUser;
    _nicknameController = TextEditingController(text: user?.nickname ?? '');
    _selectedCountryCode = user?.countryCode;
    _selectedCountryName = user?.countryName;
    _selectedLanguage = user?.language ?? 'zh';
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }

  /// 获取语言中文名称
  String _getLanguageName(String? code) {
    if (code == null) return '中文';
    for (final lang in _languageOptions) {
      if (lang['code'] == code) return lang['name']!;
    }
    return '中文';
  }

  /// 获取国家中文名称
  String _getCountryName(String? code) {
    if (code == null || code.isEmpty) return '其他';
    for (final country in _countryOptions) {
      if (country['code'] == code) return country['name']!;
    }
    return '其他';
  }

  /// 编辑昵称（弹出对话框）
  Future<void> _editNickname() async {
    final controller = TextEditingController(text: _nicknameController.text);
    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: darkColor,
          title: const Text(
            '编辑昵称',
            style: TextStyle(color: textPrimary),
          ),
          content: TextField(
            controller: controller,
            maxLength: 20,
            style: const TextStyle(color: textPrimary),
            decoration: const InputDecoration(
              hintText: '请输入昵称',
              hintStyle: TextStyle(color: textHint),
            ),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, controller.text.trim()),
              child: const Text('确定'),
            ),
          ],
        );
      },
    );

    if (result != null && result.isNotEmpty) {
      setState(() {
        _nicknameController.text = result;
      });
    }
    controller.dispose();
  }

  /// 选择国家（底部弹窗）
  Future<void> _selectCountry() async {
    final result = await showModalBottomSheet<Map<String, String>>(
      context: context,
      backgroundColor: darkColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  '选择国家',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              const Divider(color: cardBorderColor),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _countryOptions.length,
                  itemBuilder: (context, index) {
                    final country = _countryOptions[index];
                    final isSelected = country['code'] == _selectedCountryCode;
                    return ListTile(
                      title: Text(
                        country['name']!,
                        style: TextStyle(
                          color: isSelected ? secondaryColor : textPrimary,
                        ),
                      ),
                      trailing: isSelected
                          ? const Icon(Icons.check, color: secondaryColor)
                          : null,
                      onTap: () => Navigator.pop(context, country),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );

    if (result != null) {
      setState(() {
        _selectedCountryCode = result['code'];
        _selectedCountryName = result['name'];
      });
    }
  }

  /// 选择语言（底部弹窗）
  Future<void> _selectLanguage() async {
    final result = await showModalBottomSheet<Map<String, String>>(
      context: context,
      backgroundColor: darkColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  '选择语言',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              const Divider(color: cardBorderColor),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _languageOptions.length,
                  itemBuilder: (context, index) {
                    final lang = _languageOptions[index];
                    final isSelected = lang['code'] == _selectedLanguage;
                    return ListTile(
                      title: Text(
                        lang['name']!,
                        style: TextStyle(
                          color: isSelected ? secondaryColor : textPrimary,
                        ),
                      ),
                      trailing: isSelected
                          ? const Icon(Icons.check, color: secondaryColor)
                          : null,
                      onTap: () => Navigator.pop(context, lang),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );

    if (result != null) {
      setState(() {
        _selectedLanguage = result['code'];
      });
    }
  }

  /// 保存资料
  Future<void> _saveProfile() async {
    final userProvider = context.read<UserProvider>();
    final nickname = _nicknameController.text.trim();

    if (nickname.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('昵称不能为空')),
      );
      return;
    }

    setState(() => _isSaving = true);

    final success = await userProvider.updateProfile(
      nickname: nickname,
      countryCode: _selectedCountryCode,
      countryName: _selectedCountryName,
      language: _selectedLanguage,
    );

    if (mounted) {
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success ? '保存成功' : '保存失败，请重试'),
        ),
      );
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
          child: Consumer<UserProvider>(
            builder: (context, userProvider, child) {
              final user = userProvider.currentUser;

              if (user == null) {
                // 加载中显示转圈，失败显示错误和重试按钮
                return Center(
                  child: userProvider.isLoading
                      ? const CircularProgressIndicator(color: secondaryColor)
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              userProvider.error ?? l10n.operationFailed,
                              style: const TextStyle(color: textSecondary),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () => userProvider.init(),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                              ),
                              child: Text(l10n.operationFailed),
                            ),
                          ],
                        ),
                );
              }

              return Column(
                children: [
                  // 顶部标题
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                    child: Row(
                      children: [
                        Text(
                          l10n.profileTab,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                      ],
                    ),
                  ),
                  // 内容区域
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      children: [
                        const SizedBox(height: 16),
                        // 头像和昵称
                        Center(
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 48,
                                backgroundColor:
                                    secondaryColor.withValues(alpha: 0.3),
                                child: Text(
                                  _nicknameController.text.isNotEmpty
                                      ? _nicknameController.text.substring(0, 1)
                                      : '?',
                                  style: const TextStyle(
                                    fontSize: 36,
                                    color: textPrimary,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                _nicknameController.text,
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        // 资料编辑卡片
                        Container(
                          decoration: getCardDecoration(),
                          padding:
                              const EdgeInsets.symmetric(vertical: 8),
                          child: Column(
                            children: [
                              // 昵称
                              _buildEditItem(
                                icon: Icons.person_outline,
                                label: '昵称',
                                value: _nicknameController.text,
                                onTap: _editNickname,
                              ),
                              const Divider(
                                color: cardBorderColor,
                                height: 1,
                                indent: 16,
                                endIndent: 16,
                              ),
                              // 国家
                              _buildEditItem(
                                icon: Icons.public,
                                label: '国家',
                                value: _getCountryName(_selectedCountryCode),
                                onTap: _selectCountry,
                              ),
                              const Divider(
                                color: cardBorderColor,
                                height: 1,
                                indent: 16,
                                endIndent: 16,
                              ),
                              // 语言
                              _buildEditItem(
                                icon: Icons.translate,
                                label: '语言',
                                value: _getLanguageName(_selectedLanguage),
                                onTap: _selectLanguage,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        // 保存按钮
                        ElevatedButton(
                          onPressed: _isSaving ? null : _saveProfile,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            padding:
                                const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: _isSaving
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text('保存资料'),
                        ),
                        const SizedBox(height: 24),
                        // 配额信息标题
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '今日配额',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // 配额信息卡片
                        Container(
                          decoration: getCardDecoration(),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildQuotaItem(
                                label: '可扔',
                                count: userProvider.remainingThrowCount,
                                total: dailyThrowLimit,
                              ),
                              _buildQuotaItem(
                                label: '可捞',
                                count: userProvider.remainingCatchCount,
                                total: dailyCatchLimit,
                              ),
                              _buildQuotaItem(
                                label: '可翻译',
                                count: userProvider.remainingTranslateCount,
                                total: dailyTranslateLimit,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        // 我的瓶子入口
                        Container(
                          decoration: getCardDecoration(),
                          child: ListTile(
                            leading: const Icon(
                              Icons.sailing_outlined,
                              color: secondaryColor,
                            ),
                            title: const Text(
                              '我的瓶子',
                              style: TextStyle(color: textPrimary),
                            ),
                            subtitle: const Text(
                              '查看你扔出的瓶子状态',
                              style: TextStyle(color: textSecondary, fontSize: 12),
                            ),
                            trailing: const Icon(
                              Icons.chevron_right,
                              color: textHint,
                            ),
                            onTap: () {
                              Navigator.pushNamed(context, '/my-bottles');
                            },
                          ),
                        ),
                        const SizedBox(height: 12),
                        // 导出数据入口
                        Container(
                          decoration: getCardDecoration(),
                          child: ListTile(
                            leading: const Icon(
                              Icons.download_outlined,
                              color: secondaryColor,
                            ),
                            title: const Text(
                              '导出我的数据',
                              style: TextStyle(color: textPrimary),
                            ),
                            subtitle: const Text(
                              '获取你的个人数据副本',
                              style: TextStyle(color: textSecondary, fontSize: 12),
                            ),
                            trailing: _isExporting
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      color: secondaryColor,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Icon(
                                    Icons.chevron_right,
                                    color: textHint,
                                  ),
                            onTap: _isExporting ? null : _exportUserData,
                          ),
                        ),
                        const SizedBox(height: 12),
                        // 隐私政策入口
                        Container(
                          decoration: getCardDecoration(),
                          child: ListTile(
                            leading: const Icon(
                              Icons.privacy_tip_outlined,
                              color: secondaryColor,
                            ),
                            title: const Text(
                              '隐私政策',
                              style: TextStyle(color: textPrimary),
                            ),
                            trailing: const Icon(
                              Icons.chevron_right,
                              color: textHint,
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const PrivacyPolicyScreen(),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 24),
                        // 删除账号入口
                        Container(
                          decoration: getCardDecoration(),
                          child: ListTile(
                            leading: const Icon(
                              Icons.delete_forever_outlined,
                              color: Colors.redAccent,
                            ),
                            title: const Text(
                              '删除账号',
                              style: TextStyle(color: Colors.redAccent),
                            ),
                            subtitle: const Text(
                              '永久删除你的账号及全部数据',
                              style: TextStyle(color: textSecondary, fontSize: 12),
                            ),
                            trailing: const Icon(
                              Icons.chevron_right,
                              color: textHint,
                            ),
                            onTap: _confirmDeleteAccount,
                          ),
                        ),
                        const SizedBox(height: 24),
                        // 版本号
                        Center(
                          child: Text(
                            'DriftBottle v1.0.0',
                            style: TextStyle(
                              color: textHint,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        // 底部导航栏
        bottomNavigationBar: const NavBar(currentIndex: 2),
      ),
    );
  }

  /// 导出用户数据副本
  Future<void> _exportUserData() async {
    final userProvider = context.read<UserProvider>();

    setState(() => _isExporting = true);
    final data = await userProvider.exportUserData();
    if (mounted) {
      setState(() => _isExporting = false);
    }

    if (data == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('导出失败，请检查网络后重试')),
        );
      }
      return;
    }

    final bottles = data['bottles'] as List? ?? [];
    final conversations = data['conversations'] as List? ?? [];
    final messages = data['messages'] as List? ?? [];
    final reports = data['reports'] as List? ?? [];

    if (mounted) {
      await showDialog<void>(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: cardColor,
            title: const Text(
              '导出个人数据',
              style: TextStyle(color: textPrimary),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '数据副本已准备好，点击下方按钮可复制完整 JSON 数据。',
                  style: TextStyle(color: textSecondary, fontSize: 14),
                ),
                const SizedBox(height: 16),
                _buildExportStat('漂流瓶', bottles.length),
                _buildExportStat('对话', conversations.length),
                _buildExportStat('消息', messages.length),
                _buildExportStat('举报', reports.length),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('关闭'),
              ),
              TextButton(
                onPressed: () async {
                  final jsonString = const JsonEncoder.withIndent('  ')
                      .convert(data);
                  await Clipboard.setData(ClipboardData(text: jsonString));
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('已复制到剪贴板')),
                    );
                    Navigator.pop(context);
                  }
                },
                child: const Text('复制完整数据'),
              ),
            ],
          );
        },
      );
    }
  }

  /// 构建导出数据摘要项
  Widget _buildExportStat(String label, int count) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(color: textSecondary, fontSize: 14),
          ),
          const Spacer(),
          Text(
            '$count',
            style: const TextStyle(
              color: textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  /// 确认删除账号对话框（第一层确认）
  Future<void> _confirmDeleteAccount() async {
    final userProvider = context.read<UserProvider>();
    final currentUser = userProvider.currentUser;
    if (currentUser == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: cardColor,
          title: const Text(
            '删除账号',
            style: TextStyle(color: Colors.redAccent),
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '即将永久删除你的账号及全部相关数据，此操作不可恢复：',
                style: TextStyle(color: textPrimary, fontSize: 14),
              ),
              SizedBox(height: 12),
              Text(
                '· 你的所有漂流瓶将被删除\n'
                '· 你的所有对话和消息将被删除\n'
                '· 你提交的举报记录将被删除\n'
                '· 你的昵称、国家、语言等资料将被清除',
                style: TextStyle(color: textSecondary, fontSize: 13, height: 1.6),
              ),
              SizedBox(height: 12),
              Text(
                '删除后，本设备将作为新用户重新开始。',
                style: TextStyle(color: textSecondary, fontSize: 12),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
              child: const Text('继续删除'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    // 第二层确认：输入"删除"二字才能继续
    final doubleConfirmed = await _confirmByTypingDelete();
    if (doubleConfirmed != true) return;

    // 执行删除
    final success = await userProvider.deleteAccount();

    if (!mounted) return;

    if (success) {
      // 删除成功，跳转到启动页重新初始化
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('账号已删除，正在重新初始化...')),
      );
      // 跳转到根路由（SplashScreen 会重新初始化用户）
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/',
        (Route<dynamic> route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('删除失败，请检查网络后重试')),
      );
    }
  }

  /// 第二层确认：要求用户输入"删除"二字
  Future<bool> _confirmByTypingDelete() async {
    final controller = TextEditingController();
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: cardColor,
          title: const Text(
            '最终确认',
            style: TextStyle(color: Colors.redAccent),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '请输入"删除"二字以最终确认操作：',
                style: TextStyle(color: textPrimary, fontSize: 14),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: controller,
                autofocus: true,
                style: const TextStyle(color: textPrimary),
                decoration: const InputDecoration(
                  hintText: '删除',
                  hintStyle: TextStyle(color: textHint),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: cardBorderColor),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.redAccent),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () {
                final text = controller.text.trim();
                Navigator.pop(context, text == '删除');
              },
              style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
              child: const Text('确认删除'),
            ),
          ],
        );
      },
    );
    controller.dispose();
    return result ?? false;
  }

  /// 构建编辑项
  Widget _buildEditItem({
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: secondaryColor, size: 22),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(color: textSecondary, fontSize: 15),
            ),
            const Spacer(),
            Flexible(
              child: Text(
                value,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: textPrimary, fontSize: 15),
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right, color: textHint, size: 20),
          ],
        ),
      ),
    );
  }

  /// 构建配额项
  Widget _buildQuotaItem({
    required String label,
    required int count,
    required int total,
  }) {
    return Column(
      children: [
        Text(
          '$count/$total',
          style: TextStyle(
            color: count > 0 ? secondaryColor : textHint,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: textSecondary, fontSize: 12),
        ),
      ],
    );
  }
}
