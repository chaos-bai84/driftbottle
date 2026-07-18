// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Drift Bottle';

  @override
  String get oceanTab => 'Ocean';

  @override
  String get chatTab => 'Chats';

  @override
  String get profileTab => 'Me';

  @override
  String get throwBottle => 'Throw Bottle';

  @override
  String get catchBottle => 'Catch Bottle';

  @override
  String get writeBottleContent => 'Write something, 10-500 characters...';

  @override
  String get selectTag => 'Select a tag';

  @override
  String get throwOut => 'Throw';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get confirm => 'Confirm';

  @override
  String get delete => 'Delete';

  @override
  String get report => 'Report';

  @override
  String get translate => 'Translate';

  @override
  String get send => 'Send';

  @override
  String get copy => 'Copy';

  @override
  String get close => 'Close';

  @override
  String get noConversations => 'No conversations yet';

  @override
  String get startChat => 'Start a conversation';

  @override
  String get messageHint => 'Type a message...';

  @override
  String get myBottles => 'My Bottles';

  @override
  String get floating => 'Floating';

  @override
  String get caught => 'Caught';

  @override
  String get expired => 'Expired';

  @override
  String get bottleStatus => 'Bottle Status';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get nickname => 'Nickname';

  @override
  String get country => 'Country';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get exportMyData => 'Export My Data';

  @override
  String get deleteAccount => 'Delete Account';

  @override
  String get logout => 'Log Out';

  @override
  String get welcomeText =>
      'Welcome to DriftBottle! Write your thoughts into a bottle, throw it into the ocean, or catch bottles from around the world and chat anonymously with strangers.';

  @override
  String get ageVerificationTitle => 'Terms of Use';

  @override
  String get ageVerificationConfirm =>
      'I am at least 13 years old and agree to continue';

  @override
  String get emptyOcean => 'The ocean is empty. Throw a bottle!';

  @override
  String get bottleCaughtHint => 'You caught a bottle';

  @override
  String get replyOrDiscard => 'Reply or throw it back';

  @override
  String get deleteConversation => 'Delete Conversation';

  @override
  String get deleteConversationConfirm =>
      'Delete this conversation? All messages will be removed.';

  @override
  String get reportUser => 'Report User';

  @override
  String get reportConversation => 'Report Conversation';

  @override
  String get reportReason => 'Reason';

  @override
  String get submit => 'Submit';

  @override
  String get operationSuccess => 'Success';

  @override
  String get operationFailed => 'Failed, please try again';

  @override
  String get networkError => 'Network error, please check your connection';

  @override
  String get loading => 'Loading...';

  @override
  String remainingTranslateCount(Object count) {
    return 'Translations left today: $count';
  }

  @override
  String get translateThisMessage => 'Translate this message';

  @override
  String get deleteMessage => 'Delete Message';

  @override
  String get deleteMessageConfirm => 'Delete this message?';

  @override
  String get catchWithTags => 'Catch by Tags';

  @override
  String selectedTags(Object tags) {
    return 'Selected tags: $tags';
  }

  @override
  String get dataExportTitle => 'Export Personal Data';

  @override
  String get dataExportDescription =>
      'Your data copy is ready. Tap below to copy the full JSON.';

  @override
  String get copiedToClipboard => 'Copied to clipboard';

  @override
  String get deleteAccountConfirm =>
      'Deleting your account will permanently erase all data. This cannot be undone.';

  @override
  String get deleteAccountTypeConfirm =>
      'Please type “Delete Account” below to confirm.';

  @override
  String get deleteAccountKeyword => 'Delete Account';

  @override
  String get expiredConversationHint =>
      'This conversation has expired and been cleaned up.';

  @override
  String get quotaCatch => 'Catch';

  @override
  String get quotaThrow => 'Throw';

  @override
  String get quotaTranslate => 'Translate';

  @override
  String get quotaCatchNew => 'Catch(New)';

  @override
  String get quotaThrowNew => 'Throw(New)';

  @override
  String get tagFilterHint => 'Topic filter (optional, max 3)';

  @override
  String get clear => 'Clear';

  @override
  String get catchLimitReached => 'Daily catch limit reached';

  @override
  String get throwLimitReached => 'Daily throw limit reached';

  @override
  String get pleaseLogin => 'Please log in first';

  @override
  String get writeBottleTitle => 'Write Bottle';

  @override
  String contentMinLength(Object count) {
    return 'Content must be at least $count characters';
  }

  @override
  String get bottleThrownSuccess => 'Bottle thrown into the ocean';

  @override
  String get maxTagsHint => 'Select up to 3 topic tags';

  @override
  String get selectTopicTag => 'Select topics (up to 3)';

  @override
  String get throwIntoOcean => 'Throw into Ocean';

  @override
  String throwQuotaHint(Object limit, Object remaining) {
    return 'Throws left today: $remaining/$limit';
  }

  @override
  String throwQuotaHintNew(Object dailyLimit, Object limit, Object remaining) {
    return 'New users can throw $remaining/$limit times within 24 hours, then $dailyLimit daily.';
  }

  @override
  String get anonymous => 'Anonymous';

  @override
  String translateCost(Object count) {
    return 'Use 1 translation ($count left today)';
  }

  @override
  String get alreadyReported => 'You have already reported this user.';

  @override
  String get translateLimitReached => 'Daily translation limit reached';

  @override
  String get translateFailed =>
      'Translation failed. It may be due to limit exhaustion or network issues.';

  @override
  String get longPressToTranslate => 'Long press to translate';

  @override
  String get read => 'Read';

  @override
  String get unread => 'Unread';

  @override
  String get goCatchBottle => 'Go catch a bottle';

  @override
  String get justNow => 'Just now';

  @override
  String minutesAgo(Object count) {
    return '${count}m ago';
  }

  @override
  String hoursAgo(Object count) {
    return '${count}h ago';
  }

  @override
  String daysAgo(Object count) {
    return '${count}d ago';
  }

  @override
  String get reportSubmitted => 'Report submitted. We\'ll review it soon.';

  @override
  String get noBottlesThrown => 'No bottles thrown yet';

  @override
  String get goThrowBottle =>
      'Throw a bottle and wait for someone to catch it.';

  @override
  String caughtAtTime(Object time) {
    return 'Caught at $time';
  }

  @override
  String replyMessage(Object message) {
    return 'Reply: $message';
  }

  @override
  String get caughtNoReply => 'Caught, but no reply yet';

  @override
  String get slogan => 'Drift Bottle · Connect the World';

  @override
  String get privacyAgreement =>
      'Continuing means you agree to our Privacy Policy and Terms of Service.';

  @override
  String get disagreeExit => 'Disagree and exit';

  @override
  String get ageRule1 =>
      'This app is for users aged 13 and above. If you are under 13, please do not use this app.';

  @override
  String get ageRule2 =>
      'Users aged 13-18 should use this app under parental guidance and avoid sharing contact info or meeting strangers offline.';

  @override
  String get ageRule3 =>
      'Do not include pornography, violence, hate speech, or other prohibited content.';

  @override
  String get ageRule4 =>
      'Do not include email, phone, or social media contacts. Keep all communication in the app.';

  @override
  String get ageRule5 =>
      'We detect violations locally and may restrict offending users.';

  @override
  String get editNickname => 'Edit Nickname';

  @override
  String get nicknameHint => 'Enter nickname';

  @override
  String get saveSuccess => 'Saved successfully';

  @override
  String get saveFailed => 'Save failed, please try again';

  @override
  String get selectCountry => 'Select Country';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get saveProfile => 'Save Profile';

  @override
  String get todayQuota => 'Today\'s Quota';

  @override
  String get myBottlesSubtitle => 'Check the status of bottles you threw';

  @override
  String get exportMyDataSubtitle => 'Get a copy of your personal data';

  @override
  String get deleteAccountSubtitle =>
      'Permanently delete your account and all data';

  @override
  String get exportFailed => 'Export failed, please check your connection';

  @override
  String get copyFullData => 'Copy Full Data';

  @override
  String get deleteAccountDialogTitle => 'Delete Account';

  @override
  String get deleteAccountDialogContent =>
      'Your account and all related data will be permanently deleted. This cannot be undone:';

  @override
  String get deleteAccountDataList =>
      '· All your bottles will be deleted\n· All your conversations and messages will be deleted\n· Your reports will be deleted\n· Your nickname, country, and language settings will be cleared';

  @override
  String get deleteAccountRestartHint =>
      'After deletion, this device will start as a new user.';

  @override
  String get continueDelete => 'Continue Delete';

  @override
  String get finalConfirm => 'Final Confirmation';

  @override
  String get typeDeleteToConfirm => 'Please type \"Delete\" to confirm:';

  @override
  String get typeDeleteHint => 'Delete';

  @override
  String get confirmDelete => 'Confirm Delete';

  @override
  String get accountDeleted => 'Account deleted. Reinitializing...';

  @override
  String get deleteAccountNetworkError =>
      'Delete failed, please check your connection';

  @override
  String get reply => 'Reply';

  @override
  String get throwBack => 'Throw Back';

  @override
  String reportTarget(Object target) {
    return 'Report target: $target';
  }

  @override
  String get selectReportReason => 'Select a reason';

  @override
  String get supplementDescription => 'Additional details (optional)';

  @override
  String get describeViolation => 'Describe the violation...';

  @override
  String get submitReport => 'Submit Report';

  @override
  String get unknownRegion => 'Unknown region';

  @override
  String get privacyPolicyTitle => 'DriftBottle Privacy Policy';

  @override
  String get lastUpdated => 'Last updated: July 18, 2026';

  @override
  String get privacySection1Title => '1. Information We Collect';

  @override
  String get privacySection1Content =>
      'To provide drift bottle and cross-language chat services, we collect the minimum necessary information:\n\n• Device identifier: used for anonymous login and account recognition without phone number.\n• Nickname, country, native language: used to show your cultural background in bottles.\n• Bottle content and chat messages: used to match and display to other users.\n• IP address: used to estimate your country/region.';

  @override
  String get privacySection2Title => '2. How We Use Information';

  @override
  String get privacySection2Content =>
      '• Randomly match your bottles to other users worldwide.\n• Use Google Translate API to translate content into the recipient\'s language.\n• Maintain daily quotas (throw, catch, translate) and conversation expiration.\n• Protect community safety through local sensitive word filtering.';

  @override
  String get privacySection3Title => '3. Data Storage and Security';

  @override
  String get privacySection3Content =>
      'User data is stored in Supabase (PostgreSQL). We use Row Level Security (RLS) to restrict access: users can only read bottles, conversations, and messages related to them. All network communication is encrypted via HTTPS/WSS.';

  @override
  String get privacySection4Title => '4. Your Rights';

  @override
  String get privacySection4Content =>
      '• Access: You can view and edit nickname, country, and language on the Profile page.\n• Export: You can request a copy of your personal data on the Profile page.\n• Delete: You can permanently delete your account and all related data via the Delete Account feature.\n• Withdraw: Stopping use of the app is considered withdrawal of consent; expired conversations and messages are automatically cleaned up after 7 days.';

  @override
  String get privacySection5Title => '5. Third-Party Services';

  @override
  String get privacySection5Content =>
      'We use the following third-party services to run the app:\n\n• Supabase: database and real-time communication.\n• Google Free Translate API: message translation.\n\nThese providers have their own privacy policies, which we recommend you review.';

  @override
  String get privacySection6Title => '6. Children\'s Privacy';

  @override
  String get privacySection6Content =>
      'DriftBottle is not directed to children under 13. If we discover that we have collected personal information from a child under 13, we will delete it immediately.';

  @override
  String get privacySection7Title => '7. Policy Updates';

  @override
  String get privacySection7Content =>
      'We may update this privacy policy from time to time. The updated policy will be posted in the app with the latest update date.';

  @override
  String get privacySection8Title => '8. Contact Us';

  @override
  String get privacySection8Content =>
      'If you have any questions or data requests, please email: choas.bai84@gmail.com';
}
