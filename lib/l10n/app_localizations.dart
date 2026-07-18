import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('zh'),
    Locale('en'),
    Locale('ja'),
    Locale('ko'),
  ];

  /// No description provided for @appName.
  ///
  /// In zh, this message translates to:
  /// **'漂流瓶'**
  String get appName;

  /// No description provided for @oceanTab.
  ///
  /// In zh, this message translates to:
  /// **'海洋'**
  String get oceanTab;

  /// No description provided for @chatTab.
  ///
  /// In zh, this message translates to:
  /// **'对话'**
  String get chatTab;

  /// No description provided for @profileTab.
  ///
  /// In zh, this message translates to:
  /// **'我的'**
  String get profileTab;

  /// No description provided for @throwBottle.
  ///
  /// In zh, this message translates to:
  /// **'扔瓶子'**
  String get throwBottle;

  /// No description provided for @catchBottle.
  ///
  /// In zh, this message translates to:
  /// **'捞瓶子'**
  String get catchBottle;

  /// No description provided for @writeBottleContent.
  ///
  /// In zh, this message translates to:
  /// **'写下你想说的话，10-500字...'**
  String get writeBottleContent;

  /// No description provided for @selectTag.
  ///
  /// In zh, this message translates to:
  /// **'选择话题标签'**
  String get selectTag;

  /// No description provided for @throwOut.
  ///
  /// In zh, this message translates to:
  /// **'扔出'**
  String get throwOut;

  /// No description provided for @cancel.
  ///
  /// In zh, this message translates to:
  /// **'取消'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In zh, this message translates to:
  /// **'保存'**
  String get save;

  /// No description provided for @confirm.
  ///
  /// In zh, this message translates to:
  /// **'确定'**
  String get confirm;

  /// No description provided for @delete.
  ///
  /// In zh, this message translates to:
  /// **'删除'**
  String get delete;

  /// No description provided for @report.
  ///
  /// In zh, this message translates to:
  /// **'举报'**
  String get report;

  /// No description provided for @translate.
  ///
  /// In zh, this message translates to:
  /// **'翻译'**
  String get translate;

  /// No description provided for @send.
  ///
  /// In zh, this message translates to:
  /// **'发送'**
  String get send;

  /// No description provided for @copy.
  ///
  /// In zh, this message translates to:
  /// **'复制'**
  String get copy;

  /// No description provided for @close.
  ///
  /// In zh, this message translates to:
  /// **'关闭'**
  String get close;

  /// No description provided for @noConversations.
  ///
  /// In zh, this message translates to:
  /// **'还没有对话'**
  String get noConversations;

  /// No description provided for @startChat.
  ///
  /// In zh, this message translates to:
  /// **'开始对话吧'**
  String get startChat;

  /// No description provided for @messageHint.
  ///
  /// In zh, this message translates to:
  /// **'输入消息...'**
  String get messageHint;

  /// No description provided for @myBottles.
  ///
  /// In zh, this message translates to:
  /// **'我的瓶子'**
  String get myBottles;

  /// No description provided for @floating.
  ///
  /// In zh, this message translates to:
  /// **'漂流中'**
  String get floating;

  /// No description provided for @caught.
  ///
  /// In zh, this message translates to:
  /// **'已被捞起'**
  String get caught;

  /// No description provided for @expired.
  ///
  /// In zh, this message translates to:
  /// **'已过期'**
  String get expired;

  /// No description provided for @bottleStatus.
  ///
  /// In zh, this message translates to:
  /// **'瓶子状态'**
  String get bottleStatus;

  /// No description provided for @settings.
  ///
  /// In zh, this message translates to:
  /// **'设置'**
  String get settings;

  /// No description provided for @language.
  ///
  /// In zh, this message translates to:
  /// **'语言'**
  String get language;

  /// No description provided for @nickname.
  ///
  /// In zh, this message translates to:
  /// **'昵称'**
  String get nickname;

  /// No description provided for @country.
  ///
  /// In zh, this message translates to:
  /// **'国家'**
  String get country;

  /// No description provided for @privacyPolicy.
  ///
  /// In zh, this message translates to:
  /// **'隐私政策'**
  String get privacyPolicy;

  /// No description provided for @exportMyData.
  ///
  /// In zh, this message translates to:
  /// **'导出我的数据'**
  String get exportMyData;

  /// No description provided for @deleteAccount.
  ///
  /// In zh, this message translates to:
  /// **'删除账号'**
  String get deleteAccount;

  /// No description provided for @logout.
  ///
  /// In zh, this message translates to:
  /// **'退出登录'**
  String get logout;

  /// No description provided for @welcomeText.
  ///
  /// In zh, this message translates to:
  /// **'欢迎使用 DriftBottle！在这里，你可以把心情写进瓶子，扔进大海，也可以捞起来自世界各地的瓶子，与陌生人展开匿名对话。'**
  String get welcomeText;

  /// No description provided for @ageVerificationTitle.
  ///
  /// In zh, this message translates to:
  /// **'使用须知'**
  String get ageVerificationTitle;

  /// No description provided for @ageVerificationConfirm.
  ///
  /// In zh, this message translates to:
  /// **'我已年满13岁，同意并继续'**
  String get ageVerificationConfirm;

  /// No description provided for @emptyOcean.
  ///
  /// In zh, this message translates to:
  /// **'海里暂时没有瓶子，来扔一个吧'**
  String get emptyOcean;

  /// No description provided for @bottleCaughtHint.
  ///
  /// In zh, this message translates to:
  /// **'你捞到了一个瓶子'**
  String get bottleCaughtHint;

  /// No description provided for @replyOrDiscard.
  ///
  /// In zh, this message translates to:
  /// **'回复或丢回海里'**
  String get replyOrDiscard;

  /// No description provided for @deleteConversation.
  ///
  /// In zh, this message translates to:
  /// **'删除对话'**
  String get deleteConversation;

  /// No description provided for @deleteConversationConfirm.
  ///
  /// In zh, this message translates to:
  /// **'确定要删除这个对话吗？所有消息将被清空。'**
  String get deleteConversationConfirm;

  /// No description provided for @reportUser.
  ///
  /// In zh, this message translates to:
  /// **'举报用户'**
  String get reportUser;

  /// No description provided for @reportConversation.
  ///
  /// In zh, this message translates to:
  /// **'举报对话'**
  String get reportConversation;

  /// No description provided for @reportReason.
  ///
  /// In zh, this message translates to:
  /// **'举报原因'**
  String get reportReason;

  /// No description provided for @submit.
  ///
  /// In zh, this message translates to:
  /// **'提交'**
  String get submit;

  /// No description provided for @operationSuccess.
  ///
  /// In zh, this message translates to:
  /// **'操作成功'**
  String get operationSuccess;

  /// No description provided for @operationFailed.
  ///
  /// In zh, this message translates to:
  /// **'操作失败，请重试'**
  String get operationFailed;

  /// No description provided for @networkError.
  ///
  /// In zh, this message translates to:
  /// **'网络错误，请检查网络后重试'**
  String get networkError;

  /// No description provided for @loading.
  ///
  /// In zh, this message translates to:
  /// **'加载中...'**
  String get loading;

  /// No description provided for @remainingTranslateCount.
  ///
  /// In zh, this message translates to:
  /// **'今日剩余翻译次数：{count}'**
  String remainingTranslateCount(Object count);

  /// No description provided for @translateThisMessage.
  ///
  /// In zh, this message translates to:
  /// **'翻译这条消息'**
  String get translateThisMessage;

  /// No description provided for @deleteMessage.
  ///
  /// In zh, this message translates to:
  /// **'删除消息'**
  String get deleteMessage;

  /// No description provided for @deleteMessageConfirm.
  ///
  /// In zh, this message translates to:
  /// **'确定要删除这条消息吗？'**
  String get deleteMessageConfirm;

  /// No description provided for @catchWithTags.
  ///
  /// In zh, this message translates to:
  /// **'按标签捞瓶'**
  String get catchWithTags;

  /// No description provided for @selectedTags.
  ///
  /// In zh, this message translates to:
  /// **'已选标签：{tags}'**
  String selectedTags(Object tags);

  /// No description provided for @dataExportTitle.
  ///
  /// In zh, this message translates to:
  /// **'导出个人数据'**
  String get dataExportTitle;

  /// No description provided for @dataExportDescription.
  ///
  /// In zh, this message translates to:
  /// **'数据副本已准备好，点击下方按钮可复制完整 JSON 数据。'**
  String get dataExportDescription;

  /// No description provided for @copiedToClipboard.
  ///
  /// In zh, this message translates to:
  /// **'已复制到剪贴板'**
  String get copiedToClipboard;

  /// No description provided for @deleteAccountConfirm.
  ///
  /// In zh, this message translates to:
  /// **'删除账号后，所有数据将被永久清除，无法恢复。'**
  String get deleteAccountConfirm;

  /// No description provided for @deleteAccountTypeConfirm.
  ///
  /// In zh, this message translates to:
  /// **'请在下方输入“删除账号”以确认操作。'**
  String get deleteAccountTypeConfirm;

  /// No description provided for @deleteAccountKeyword.
  ///
  /// In zh, this message translates to:
  /// **'删除账号'**
  String get deleteAccountKeyword;

  /// No description provided for @expiredConversationHint.
  ///
  /// In zh, this message translates to:
  /// **'该对话已过期并自动清理。'**
  String get expiredConversationHint;

  /// No description provided for @quotaCatch.
  ///
  /// In zh, this message translates to:
  /// **'可捞'**
  String get quotaCatch;

  /// No description provided for @quotaThrow.
  ///
  /// In zh, this message translates to:
  /// **'可扔'**
  String get quotaThrow;

  /// No description provided for @quotaTranslate.
  ///
  /// In zh, this message translates to:
  /// **'可翻译'**
  String get quotaTranslate;

  /// No description provided for @quotaCatchNew.
  ///
  /// In zh, this message translates to:
  /// **'可捞(新)'**
  String get quotaCatchNew;

  /// No description provided for @quotaThrowNew.
  ///
  /// In zh, this message translates to:
  /// **'可扔(新)'**
  String get quotaThrowNew;

  /// No description provided for @tagFilterHint.
  ///
  /// In zh, this message translates to:
  /// **'话题筛选（可选，最多3个）'**
  String get tagFilterHint;

  /// No description provided for @clear.
  ///
  /// In zh, this message translates to:
  /// **'清除'**
  String get clear;

  /// No description provided for @catchLimitReached.
  ///
  /// In zh, this message translates to:
  /// **'今日捞瓶子次数已用完'**
  String get catchLimitReached;

  /// No description provided for @throwLimitReached.
  ///
  /// In zh, this message translates to:
  /// **'今日扔瓶子次数已用完'**
  String get throwLimitReached;

  /// No description provided for @pleaseLogin.
  ///
  /// In zh, this message translates to:
  /// **'请先完成登录'**
  String get pleaseLogin;

  /// No description provided for @writeBottleTitle.
  ///
  /// In zh, this message translates to:
  /// **'写漂流瓶'**
  String get writeBottleTitle;

  /// No description provided for @contentMinLength.
  ///
  /// In zh, this message translates to:
  /// **'内容至少需要{count}个字'**
  String contentMinLength(Object count);

  /// No description provided for @bottleThrownSuccess.
  ///
  /// In zh, this message translates to:
  /// **'瓶子已扔进大海'**
  String get bottleThrownSuccess;

  /// No description provided for @maxTagsHint.
  ///
  /// In zh, this message translates to:
  /// **'最多选择3个话题标签'**
  String get maxTagsHint;

  /// No description provided for @selectTopicTag.
  ///
  /// In zh, this message translates to:
  /// **'选择话题（最多3个）'**
  String get selectTopicTag;

  /// No description provided for @throwIntoOcean.
  ///
  /// In zh, this message translates to:
  /// **'扔进大海'**
  String get throwIntoOcean;

  /// No description provided for @throwQuotaHint.
  ///
  /// In zh, this message translates to:
  /// **'今日剩余可扔 {remaining}/{limit} 次'**
  String throwQuotaHint(Object limit, Object remaining);

  /// No description provided for @throwQuotaHintNew.
  ///
  /// In zh, this message translates to:
  /// **'新用户24小时内可扔 {remaining}/{limit} 次，24小时后恢复 {dailyLimit} 次'**
  String throwQuotaHintNew(Object dailyLimit, Object limit, Object remaining);

  /// No description provided for @anonymous.
  ///
  /// In zh, this message translates to:
  /// **'匿名'**
  String get anonymous;

  /// No description provided for @translateCost.
  ///
  /// In zh, this message translates to:
  /// **'消耗 1 次翻译次数（今日剩余 {count} 次）'**
  String translateCost(Object count);

  /// No description provided for @alreadyReported.
  ///
  /// In zh, this message translates to:
  /// **'你已举报过该用户，请等待处理'**
  String get alreadyReported;

  /// No description provided for @translateLimitReached.
  ///
  /// In zh, this message translates to:
  /// **'今日翻译次数已用完'**
  String get translateLimitReached;

  /// No description provided for @translateFailed.
  ///
  /// In zh, this message translates to:
  /// **'翻译失败，可能是次数已用完或网络问题'**
  String get translateFailed;

  /// No description provided for @longPressToTranslate.
  ///
  /// In zh, this message translates to:
  /// **'长按翻译'**
  String get longPressToTranslate;

  /// No description provided for @read.
  ///
  /// In zh, this message translates to:
  /// **'已读'**
  String get read;

  /// No description provided for @unread.
  ///
  /// In zh, this message translates to:
  /// **'未读'**
  String get unread;

  /// No description provided for @goCatchBottle.
  ///
  /// In zh, this message translates to:
  /// **'去捞一个瓶子吧'**
  String get goCatchBottle;

  /// No description provided for @justNow.
  ///
  /// In zh, this message translates to:
  /// **'刚刚'**
  String get justNow;

  /// No description provided for @minutesAgo.
  ///
  /// In zh, this message translates to:
  /// **'{count}分钟前'**
  String minutesAgo(Object count);

  /// No description provided for @hoursAgo.
  ///
  /// In zh, this message translates to:
  /// **'{count}小时前'**
  String hoursAgo(Object count);

  /// No description provided for @daysAgo.
  ///
  /// In zh, this message translates to:
  /// **'{count}天前'**
  String daysAgo(Object count);

  /// No description provided for @reportSubmitted.
  ///
  /// In zh, this message translates to:
  /// **'举报已提交，我们会尽快处理'**
  String get reportSubmitted;

  /// No description provided for @noBottlesThrown.
  ///
  /// In zh, this message translates to:
  /// **'还没有扔过瓶子'**
  String get noBottlesThrown;

  /// No description provided for @goThrowBottle.
  ///
  /// In zh, this message translates to:
  /// **'去扔一个漂流瓶，等待远方的朋友捞起吧'**
  String get goThrowBottle;

  /// No description provided for @caughtAtTime.
  ///
  /// In zh, this message translates to:
  /// **'于 {time} 被捞起'**
  String caughtAtTime(Object time);

  /// No description provided for @replyMessage.
  ///
  /// In zh, this message translates to:
  /// **'回复：{message}'**
  String replyMessage(Object message);

  /// No description provided for @caughtNoReply.
  ///
  /// In zh, this message translates to:
  /// **'已捞起，但还未回复'**
  String get caughtNoReply;

  /// No description provided for @slogan.
  ///
  /// In zh, this message translates to:
  /// **'漂流瓶 · 连接世界'**
  String get slogan;

  /// No description provided for @privacyAgreement.
  ///
  /// In zh, this message translates to:
  /// **'继续即表示您同意我们的隐私政策和服务条款'**
  String get privacyAgreement;

  /// No description provided for @disagreeExit.
  ///
  /// In zh, this message translates to:
  /// **'不同意，退出应用'**
  String get disagreeExit;

  /// No description provided for @ageRule1.
  ///
  /// In zh, this message translates to:
  /// **'本应用面向 13 岁及以上用户。如果您未满 13 岁，请勿注册或使用本应用。'**
  String get ageRule1;

  /// No description provided for @ageRule2.
  ///
  /// In zh, this message translates to:
  /// **'13-18 岁的用户请在监护人指导下使用，并避免与陌生人交换联系方式或线下见面。'**
  String get ageRule2;

  /// No description provided for @ageRule3.
  ///
  /// In zh, this message translates to:
  /// **'请勿在瓶子内容或消息中包含色情、暴力、仇恨言论等违规内容。'**
  String get ageRule3;

  /// No description provided for @ageRule4.
  ///
  /// In zh, this message translates to:
  /// **'请勿在内容中包含邮箱、电话、社交账号等联系方式，所有交流请留在应用内。'**
  String get ageRule4;

  /// No description provided for @ageRule5.
  ///
  /// In zh, this message translates to:
  /// **'我们会在本地检测违规内容，并可能限制违规用户的使用。'**
  String get ageRule5;

  /// No description provided for @editNickname.
  ///
  /// In zh, this message translates to:
  /// **'编辑昵称'**
  String get editNickname;

  /// No description provided for @nicknameHint.
  ///
  /// In zh, this message translates to:
  /// **'请输入昵称'**
  String get nicknameHint;

  /// No description provided for @saveSuccess.
  ///
  /// In zh, this message translates to:
  /// **'保存成功'**
  String get saveSuccess;

  /// No description provided for @saveFailed.
  ///
  /// In zh, this message translates to:
  /// **'保存失败，请重试'**
  String get saveFailed;

  /// No description provided for @selectCountry.
  ///
  /// In zh, this message translates to:
  /// **'选择国家'**
  String get selectCountry;

  /// No description provided for @selectLanguage.
  ///
  /// In zh, this message translates to:
  /// **'选择语言'**
  String get selectLanguage;

  /// No description provided for @saveProfile.
  ///
  /// In zh, this message translates to:
  /// **'保存资料'**
  String get saveProfile;

  /// No description provided for @todayQuota.
  ///
  /// In zh, this message translates to:
  /// **'今日配额'**
  String get todayQuota;

  /// No description provided for @myBottlesSubtitle.
  ///
  /// In zh, this message translates to:
  /// **'查看你扔出的瓶子状态'**
  String get myBottlesSubtitle;

  /// No description provided for @exportMyDataSubtitle.
  ///
  /// In zh, this message translates to:
  /// **'获取你的个人数据副本'**
  String get exportMyDataSubtitle;

  /// No description provided for @deleteAccountSubtitle.
  ///
  /// In zh, this message translates to:
  /// **'永久删除你的账号及全部数据'**
  String get deleteAccountSubtitle;

  /// No description provided for @exportFailed.
  ///
  /// In zh, this message translates to:
  /// **'导出失败，请检查网络后重试'**
  String get exportFailed;

  /// No description provided for @copyFullData.
  ///
  /// In zh, this message translates to:
  /// **'复制完整数据'**
  String get copyFullData;

  /// No description provided for @deleteAccountDialogTitle.
  ///
  /// In zh, this message translates to:
  /// **'删除账号'**
  String get deleteAccountDialogTitle;

  /// No description provided for @deleteAccountDialogContent.
  ///
  /// In zh, this message translates to:
  /// **'即将永久删除你的账号及全部相关数据，此操作不可恢复：'**
  String get deleteAccountDialogContent;

  /// No description provided for @deleteAccountDataList.
  ///
  /// In zh, this message translates to:
  /// **'· 你的所有漂流瓶将被删除\n· 你的所有对话和消息将被删除\n· 你提交的举报记录将被删除\n· 你的昵称、国家、语言等资料将被清除'**
  String get deleteAccountDataList;

  /// No description provided for @deleteAccountRestartHint.
  ///
  /// In zh, this message translates to:
  /// **'删除后，本设备将作为新用户重新开始。'**
  String get deleteAccountRestartHint;

  /// No description provided for @continueDelete.
  ///
  /// In zh, this message translates to:
  /// **'继续删除'**
  String get continueDelete;

  /// No description provided for @finalConfirm.
  ///
  /// In zh, this message translates to:
  /// **'最终确认'**
  String get finalConfirm;

  /// No description provided for @typeDeleteToConfirm.
  ///
  /// In zh, this message translates to:
  /// **'请输入\"删除\"二字以最终确认操作：'**
  String get typeDeleteToConfirm;

  /// No description provided for @typeDeleteHint.
  ///
  /// In zh, this message translates to:
  /// **'删除'**
  String get typeDeleteHint;

  /// No description provided for @confirmDelete.
  ///
  /// In zh, this message translates to:
  /// **'确认删除'**
  String get confirmDelete;

  /// No description provided for @accountDeleted.
  ///
  /// In zh, this message translates to:
  /// **'账号已删除，正在重新初始化...'**
  String get accountDeleted;

  /// No description provided for @deleteAccountNetworkError.
  ///
  /// In zh, this message translates to:
  /// **'删除失败，请检查网络后重试'**
  String get deleteAccountNetworkError;

  /// No description provided for @reply.
  ///
  /// In zh, this message translates to:
  /// **'回复'**
  String get reply;

  /// No description provided for @throwBack.
  ///
  /// In zh, this message translates to:
  /// **'丢回海里'**
  String get throwBack;

  /// No description provided for @reportTarget.
  ///
  /// In zh, this message translates to:
  /// **'举报对象：{target}'**
  String reportTarget(Object target);

  /// No description provided for @selectReportReason.
  ///
  /// In zh, this message translates to:
  /// **'选择举报原因'**
  String get selectReportReason;

  /// No description provided for @supplementDescription.
  ///
  /// In zh, this message translates to:
  /// **'补充说明（可选）'**
  String get supplementDescription;

  /// No description provided for @describeViolation.
  ///
  /// In zh, this message translates to:
  /// **'请描述违规行为...'**
  String get describeViolation;

  /// No description provided for @submitReport.
  ///
  /// In zh, this message translates to:
  /// **'提交举报'**
  String get submitReport;

  /// No description provided for @unknownRegion.
  ///
  /// In zh, this message translates to:
  /// **'未知地区'**
  String get unknownRegion;

  /// No description provided for @privacyPolicyTitle.
  ///
  /// In zh, this message translates to:
  /// **'DriftBottle 隐私政策'**
  String get privacyPolicyTitle;

  /// No description provided for @lastUpdated.
  ///
  /// In zh, this message translates to:
  /// **'最后更新日期：2026年7月18日'**
  String get lastUpdated;

  /// No description provided for @privacySection1Title.
  ///
  /// In zh, this message translates to:
  /// **'1. 我们收集哪些信息'**
  String get privacySection1Title;

  /// No description provided for @privacySection1Content.
  ///
  /// In zh, this message translates to:
  /// **'为了提供漂流瓶和跨语言聊天服务，我们会收集以下最少必要信息：\n\n• 设备标识符：用于匿名登录和识别账号，无需手机号。\n• 昵称、国家、母语：用于在瓶子中展示你的文化背景。\n• 你发送的瓶子内容和聊天消息：用于匹配其他用户并展示给对方。\n• IP 地址：用于估算你的国家/地区。'**
  String get privacySection1Content;

  /// No description provided for @privacySection2Title.
  ///
  /// In zh, this message translates to:
  /// **'2. 我们如何使用信息'**
  String get privacySection2Title;

  /// No description provided for @privacySection2Content.
  ///
  /// In zh, this message translates to:
  /// **'• 将你的瓶子随机匹配给全球其他用户。\n• 调用 Google 翻译接口将内容翻译为接收者的母语。\n• 维护每日配额（扔瓶、捞瓶、翻译次数）和对话过期机制。\n• 通过本地敏感词过滤保护社区安全。'**
  String get privacySection2Content;

  /// No description provided for @privacySection3Title.
  ///
  /// In zh, this message translates to:
  /// **'3. 数据存储与安全'**
  String get privacySection3Title;

  /// No description provided for @privacySection3Content.
  ///
  /// In zh, this message translates to:
  /// **'用户数据存储在 Supabase（PostgreSQL）中。我们采用 Row Level Security（RLS）限制数据访问：用户只能读取和自己相关的瓶子、对话和消息。所有网络通信均通过 HTTPS/WSS 加密传输。'**
  String get privacySection3Content;

  /// No description provided for @privacySection4Title.
  ///
  /// In zh, this message translates to:
  /// **'4. 你的权利'**
  String get privacySection4Title;

  /// No description provided for @privacySection4Content.
  ///
  /// In zh, this message translates to:
  /// **'• 访问：你可以在「我的」页面查看和修改昵称、国家、语言。\n• 导出：你可以通过「我的」页面申请导出个人数据副本。\n• 删除：你可以通过「我的」页面的「删除账号」功能，永久删除账号及全部相关数据。\n• 撤回：停止使用应用即视为撤回授权，7 天后过期对话和消息将自动清理。'**
  String get privacySection4Content;

  /// No description provided for @privacySection5Title.
  ///
  /// In zh, this message translates to:
  /// **'5. 第三方服务'**
  String get privacySection5Title;

  /// No description provided for @privacySection5Content.
  ///
  /// In zh, this message translates to:
  /// **'我们使用以下第三方服务来运行应用：\n\n• Supabase：数据库和实时通信。\n• Google 免费翻译 API：消息翻译。\n\n这些服务提供商有自己的隐私政策，我们建议你一并查阅。'**
  String get privacySection5Content;

  /// No description provided for @privacySection6Title.
  ///
  /// In zh, this message translates to:
  /// **'6. 儿童隐私'**
  String get privacySection6Title;

  /// No description provided for @privacySection6Content.
  ///
  /// In zh, this message translates to:
  /// **'DriftBottle 不面向 13 岁以下儿童。如果我们发现收集了 13 岁以下儿童的个人信息，会立即删除。'**
  String get privacySection6Content;

  /// No description provided for @privacySection7Title.
  ///
  /// In zh, this message translates to:
  /// **'7. 政策更新'**
  String get privacySection7Title;

  /// No description provided for @privacySection7Content.
  ///
  /// In zh, this message translates to:
  /// **'我们可能会不时更新本隐私政策。更新后的政策将在应用内发布，并更新最后更新日期。'**
  String get privacySection7Content;

  /// No description provided for @privacySection8Title.
  ///
  /// In zh, this message translates to:
  /// **'8. 联系我们'**
  String get privacySection8Title;

  /// No description provided for @privacySection8Content.
  ///
  /// In zh, this message translates to:
  /// **'如有任何问题或数据请求，请发送邮件至：choas.bai84@gmail.com'**
  String get privacySection8Content;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ja', 'ko', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
