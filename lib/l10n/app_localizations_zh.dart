// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appName => '漂流瓶';

  @override
  String get oceanTab => '海洋';

  @override
  String get chatTab => '对话';

  @override
  String get profileTab => '我的';

  @override
  String get throwBottle => '扔瓶子';

  @override
  String get catchBottle => '捞瓶子';

  @override
  String get writeBottleContent => '写下你想说的话，10-500字...';

  @override
  String get selectTag => '选择话题标签';

  @override
  String get throwOut => '扔出';

  @override
  String get cancel => '取消';

  @override
  String get save => '保存';

  @override
  String get confirm => '确定';

  @override
  String get delete => '删除';

  @override
  String get report => '举报';

  @override
  String get translate => '翻译';

  @override
  String get send => '发送';

  @override
  String get copy => '复制';

  @override
  String get close => '关闭';

  @override
  String get noConversations => '还没有对话';

  @override
  String get startChat => '开始对话吧';

  @override
  String get messageHint => '输入消息...';

  @override
  String get myBottles => '我的瓶子';

  @override
  String get floating => '漂流中';

  @override
  String get caught => '已被捞起';

  @override
  String get expired => '已过期';

  @override
  String get bottleStatus => '瓶子状态';

  @override
  String get settings => '设置';

  @override
  String get language => '语言';

  @override
  String get nickname => '昵称';

  @override
  String get country => '国家';

  @override
  String get privacyPolicy => '隐私政策';

  @override
  String get exportMyData => '导出我的数据';

  @override
  String get deleteAccount => '删除账号';

  @override
  String get logout => '退出登录';

  @override
  String get welcomeText =>
      '欢迎使用 DriftBottle！在这里，你可以把心情写进瓶子，扔进大海，也可以捞起来自世界各地的瓶子，与陌生人展开匿名对话。';

  @override
  String get ageVerificationTitle => '使用须知';

  @override
  String get ageVerificationConfirm => '我已年满13岁，同意并继续';

  @override
  String get emptyOcean => '海里暂时没有瓶子，来扔一个吧';

  @override
  String get bottleCaughtHint => '你捞到了一个瓶子';

  @override
  String get replyOrDiscard => '回复或丢回海里';

  @override
  String get deleteConversation => '删除对话';

  @override
  String get deleteConversationConfirm => '确定要删除这个对话吗？所有消息将被清空。';

  @override
  String get reportUser => '举报用户';

  @override
  String get reportConversation => '举报对话';

  @override
  String get reportReason => '举报原因';

  @override
  String get submit => '提交';

  @override
  String get operationSuccess => '操作成功';

  @override
  String get operationFailed => '操作失败，请重试';

  @override
  String get networkError => '网络错误，请检查网络后重试';

  @override
  String get loading => '加载中...';

  @override
  String remainingTranslateCount(Object count) {
    return '今日剩余翻译次数：$count';
  }

  @override
  String get translateThisMessage => '翻译这条消息';

  @override
  String get deleteMessage => '删除消息';

  @override
  String get deleteMessageConfirm => '确定要删除这条消息吗？';

  @override
  String get catchWithTags => '按标签捞瓶';

  @override
  String selectedTags(Object tags) {
    return '已选标签：$tags';
  }

  @override
  String get dataExportTitle => '导出个人数据';

  @override
  String get dataExportDescription => '数据副本已准备好，点击下方按钮可复制完整 JSON 数据。';

  @override
  String get copiedToClipboard => '已复制到剪贴板';

  @override
  String get deleteAccountConfirm => '删除账号后，所有数据将被永久清除，无法恢复。';

  @override
  String get deleteAccountTypeConfirm => '请在下方输入“删除账号”以确认操作。';

  @override
  String get deleteAccountKeyword => '删除账号';

  @override
  String get expiredConversationHint => '该对话已过期并自动清理。';

  @override
  String get quotaCatch => '可捞';

  @override
  String get quotaThrow => '可扔';

  @override
  String get quotaTranslate => '可翻译';

  @override
  String get quotaCatchNew => '可捞(新)';

  @override
  String get quotaThrowNew => '可扔(新)';

  @override
  String get tagFilterHint => '话题筛选（可选，最多3个）';

  @override
  String get clear => '清除';

  @override
  String get catchLimitReached => '今日捞瓶子次数已用完';

  @override
  String get throwLimitReached => '今日扔瓶子次数已用完';

  @override
  String get pleaseLogin => '请先完成登录';

  @override
  String get writeBottleTitle => '写漂流瓶';

  @override
  String contentMinLength(Object count) {
    return '内容至少需要$count个字';
  }

  @override
  String get bottleThrownSuccess => '瓶子已扔进大海';

  @override
  String get maxTagsHint => '最多选择3个话题标签';

  @override
  String get selectTopicTag => '选择话题（最多3个）';

  @override
  String get throwIntoOcean => '扔进大海';

  @override
  String throwQuotaHint(Object limit, Object remaining) {
    return '今日剩余可扔 $remaining/$limit 次';
  }

  @override
  String throwQuotaHintNew(Object dailyLimit, Object limit, Object remaining) {
    return '新用户24小时内可扔 $remaining/$limit 次，24小时后恢复 $dailyLimit 次';
  }

  @override
  String get anonymous => '匿名';

  @override
  String translateCost(Object count) {
    return '消耗 1 次翻译次数（今日剩余 $count 次）';
  }

  @override
  String get alreadyReported => '你已举报过该用户，请等待处理';

  @override
  String get translateLimitReached => '今日翻译次数已用完';

  @override
  String get translateFailed => '翻译失败，可能是次数已用完或网络问题';

  @override
  String get longPressToTranslate => '长按翻译';

  @override
  String get read => '已读';

  @override
  String get unread => '未读';

  @override
  String get goCatchBottle => '去捞一个瓶子吧';

  @override
  String get justNow => '刚刚';

  @override
  String minutesAgo(Object count) {
    return '$count分钟前';
  }

  @override
  String hoursAgo(Object count) {
    return '$count小时前';
  }

  @override
  String daysAgo(Object count) {
    return '$count天前';
  }

  @override
  String get reportSubmitted => '举报已提交，我们会尽快处理';

  @override
  String get noBottlesThrown => '还没有扔过瓶子';

  @override
  String get goThrowBottle => '去扔一个漂流瓶，等待远方的朋友捞起吧';

  @override
  String caughtAtTime(Object time) {
    return '于 $time 被捞起';
  }

  @override
  String replyMessage(Object message) {
    return '回复：$message';
  }

  @override
  String get caughtNoReply => '已捞起，但还未回复';

  @override
  String get slogan => '漂流瓶 · 连接世界';

  @override
  String get privacyAgreement => '继续即表示您同意我们的隐私政策和服务条款';

  @override
  String get disagreeExit => '不同意，退出应用';

  @override
  String get ageRule1 => '本应用面向 13 岁及以上用户。如果您未满 13 岁，请勿注册或使用本应用。';

  @override
  String get ageRule2 => '13-18 岁的用户请在监护人指导下使用，并避免与陌生人交换联系方式或线下见面。';

  @override
  String get ageRule3 => '请勿在瓶子内容或消息中包含色情、暴力、仇恨言论等违规内容。';

  @override
  String get ageRule4 => '请勿在内容中包含邮箱、电话、社交账号等联系方式，所有交流请留在应用内。';

  @override
  String get ageRule5 => '我们会在本地检测违规内容，并可能限制违规用户的使用。';

  @override
  String get editNickname => '编辑昵称';

  @override
  String get nicknameHint => '请输入昵称';

  @override
  String get saveSuccess => '保存成功';

  @override
  String get saveFailed => '保存失败，请重试';

  @override
  String get selectCountry => '选择国家';

  @override
  String get selectLanguage => '选择语言';

  @override
  String get saveProfile => '保存资料';

  @override
  String get todayQuota => '今日配额';

  @override
  String get myBottlesSubtitle => '查看你扔出的瓶子状态';

  @override
  String get exportMyDataSubtitle => '获取你的个人数据副本';

  @override
  String get deleteAccountSubtitle => '永久删除你的账号及全部数据';

  @override
  String get exportFailed => '导出失败，请检查网络后重试';

  @override
  String get copyFullData => '复制完整数据';

  @override
  String get deleteAccountDialogTitle => '删除账号';

  @override
  String get deleteAccountDialogContent => '即将永久删除你的账号及全部相关数据，此操作不可恢复：';

  @override
  String get deleteAccountDataList =>
      '· 你的所有漂流瓶将被删除\n· 你的所有对话和消息将被删除\n· 你提交的举报记录将被删除\n· 你的昵称、国家、语言等资料将被清除';

  @override
  String get deleteAccountRestartHint => '删除后，本设备将作为新用户重新开始。';

  @override
  String get continueDelete => '继续删除';

  @override
  String get finalConfirm => '最终确认';

  @override
  String get typeDeleteToConfirm => '请输入\"删除\"二字以最终确认操作：';

  @override
  String get typeDeleteHint => '删除';

  @override
  String get confirmDelete => '确认删除';

  @override
  String get accountDeleted => '账号已删除，正在重新初始化...';

  @override
  String get deleteAccountNetworkError => '删除失败，请检查网络后重试';

  @override
  String get reply => '回复';

  @override
  String get throwBack => '丢回海里';

  @override
  String reportTarget(Object target) {
    return '举报对象：$target';
  }

  @override
  String get selectReportReason => '选择举报原因';

  @override
  String get supplementDescription => '补充说明（可选）';

  @override
  String get describeViolation => '请描述违规行为...';

  @override
  String get submitReport => '提交举报';

  @override
  String get unknownRegion => '未知地区';

  @override
  String get privacyPolicyTitle => 'DriftBottle 隐私政策';

  @override
  String get lastUpdated => '最后更新日期：2026年7月18日';

  @override
  String get privacySection1Title => '1. 我们收集哪些信息';

  @override
  String get privacySection1Content =>
      '为了提供漂流瓶和跨语言聊天服务，我们会收集以下最少必要信息：\n\n• 设备标识符：用于匿名登录和识别账号，无需手机号。\n• 昵称、国家、母语：用于在瓶子中展示你的文化背景。\n• 你发送的瓶子内容和聊天消息：用于匹配其他用户并展示给对方。\n• IP 地址：用于估算你的国家/地区。';

  @override
  String get privacySection2Title => '2. 我们如何使用信息';

  @override
  String get privacySection2Content =>
      '• 将你的瓶子随机匹配给全球其他用户。\n• 调用 Google 翻译接口将内容翻译为接收者的母语。\n• 维护每日配额（扔瓶、捞瓶、翻译次数）和对话过期机制。\n• 通过本地敏感词过滤保护社区安全。';

  @override
  String get privacySection3Title => '3. 数据存储与安全';

  @override
  String get privacySection3Content =>
      '用户数据存储在 Supabase（PostgreSQL）中。我们采用 Row Level Security（RLS）限制数据访问：用户只能读取和自己相关的瓶子、对话和消息。所有网络通信均通过 HTTPS/WSS 加密传输。';

  @override
  String get privacySection4Title => '4. 你的权利';

  @override
  String get privacySection4Content =>
      '• 访问：你可以在「我的」页面查看和修改昵称、国家、语言。\n• 导出：你可以通过「我的」页面申请导出个人数据副本。\n• 删除：你可以通过「我的」页面的「删除账号」功能，永久删除账号及全部相关数据。\n• 撤回：停止使用应用即视为撤回授权，7 天后过期对话和消息将自动清理。';

  @override
  String get privacySection5Title => '5. 第三方服务';

  @override
  String get privacySection5Content =>
      '我们使用以下第三方服务来运行应用：\n\n• Supabase：数据库和实时通信。\n• Google 免费翻译 API：消息翻译。\n\n这些服务提供商有自己的隐私政策，我们建议你一并查阅。';

  @override
  String get privacySection6Title => '6. 儿童隐私';

  @override
  String get privacySection6Content =>
      'DriftBottle 不面向 13 岁以下儿童。如果我们发现收集了 13 岁以下儿童的个人信息，会立即删除。';

  @override
  String get privacySection7Title => '7. 政策更新';

  @override
  String get privacySection7Content =>
      '我们可能会不时更新本隐私政策。更新后的政策将在应用内发布，并更新最后更新日期。';

  @override
  String get privacySection8Title => '8. 联系我们';

  @override
  String get privacySection8Content =>
      '如有任何问题或数据请求，请发送邮件至：choas.bai84@gmail.com';
}
