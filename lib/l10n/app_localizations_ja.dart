// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appName => '漂流瓶';

  @override
  String get oceanTab => '海';

  @override
  String get chatTab => 'トーク';

  @override
  String get profileTab => 'マイページ';

  @override
  String get throwBottle => '瓶を流す';

  @override
  String get catchBottle => '瓶を拾う';

  @override
  String get writeBottleContent => '伝えたいことを10〜500文字で書いてください...';

  @override
  String get selectTag => 'タグを選ぶ';

  @override
  String get throwOut => '流す';

  @override
  String get cancel => 'キャンセル';

  @override
  String get save => '保存';

  @override
  String get confirm => '確認';

  @override
  String get delete => '削除';

  @override
  String get report => '通報';

  @override
  String get translate => '翻訳';

  @override
  String get send => '送信';

  @override
  String get copy => 'コピー';

  @override
  String get close => '閉じる';

  @override
  String get noConversations => 'まだトークがありません';

  @override
  String get startChat => 'トークを始めましょう';

  @override
  String get messageHint => 'メッセージを入力...';

  @override
  String get myBottles => '流した瓶';

  @override
  String get floating => '漂流中';

  @override
  String get caught => '拾われました';

  @override
  String get expired => '期限切れ';

  @override
  String get bottleStatus => '瓶の状態';

  @override
  String get settings => '設定';

  @override
  String get language => '言語';

  @override
  String get nickname => 'ニックネーム';

  @override
  String get country => '国';

  @override
  String get privacyPolicy => 'プライバシーポリシー';

  @override
  String get exportMyData => 'データをエクスポート';

  @override
  String get deleteAccount => 'アカウントを削除';

  @override
  String get logout => 'ログアウト';

  @override
  String get welcomeText =>
      'DriftBottleへようこそ！気持ちを瓶に書いて海に流し、世界中の瓶を拾って見知らぬ人と匿名でおしゃべりしましょう。';

  @override
  String get ageVerificationTitle => '利用規約';

  @override
  String get ageVerificationConfirm => '13歳以上であり、続行することに同意します';

  @override
  String get emptyOcean => '海にはまだ瓶がありません。瓶を流しましょう';

  @override
  String get bottleCaughtHint => '瓶を拾いました';

  @override
  String get replyOrDiscard => '返信するか、海に戻す';

  @override
  String get deleteConversation => 'トークを削除';

  @override
  String get deleteConversationConfirm => 'このトークを削除しますか？すべてのメッセージが消去されます。';

  @override
  String get reportUser => 'ユーザーを通報';

  @override
  String get reportConversation => 'トークを通報';

  @override
  String get reportReason => '通報理由';

  @override
  String get submit => '送信';

  @override
  String get operationSuccess => '成功しました';

  @override
  String get operationFailed => '失敗しました。もう一度お試しください';

  @override
  String get networkError => 'ネットワークエラーです。接続を確認してください';

  @override
  String get loading => '読み込み中...';

  @override
  String remainingTranslateCount(Object count) {
    return '今日の残り翻訳回数：$count回';
  }

  @override
  String get translateThisMessage => 'このメッセージを翻訳';

  @override
  String get deleteMessage => 'メッセージを削除';

  @override
  String get deleteMessageConfirm => 'このメッセージを削除しますか？';

  @override
  String get catchWithTags => 'タグで拾う';

  @override
  String selectedTags(Object tags) {
    return '選択中のタグ：$tags';
  }

  @override
  String get dataExportTitle => '個人データのエクスポート';

  @override
  String get dataExportDescription => 'データのコピーの準備ができました。下のボタンで完全なJSONをコピーできます。';

  @override
  String get copiedToClipboard => 'クリップボードにコピーしました';

  @override
  String get deleteAccountConfirm => 'アカウントを削除すると、すべてのデータが永久に消去されます。元に戻せません。';

  @override
  String get deleteAccountTypeConfirm => '確認のため「アカウントを削除」と入力してください。';

  @override
  String get deleteAccountKeyword => 'アカウントを削除';

  @override
  String get expiredConversationHint => 'このトークは期限切れとなり、自動的に削除されました。';

  @override
  String get quotaCatch => '拾う';

  @override
  String get quotaThrow => '流す';

  @override
  String get quotaTranslate => '翻訳';

  @override
  String get quotaCatchNew => '拾う(新)';

  @override
  String get quotaThrowNew => '流す(新)';

  @override
  String get tagFilterHint => 'トピック絞り込み（任意、最大3つ）';

  @override
  String get clear => 'クリア';

  @override
  String get catchLimitReached => '今日の拾う回数が上限に達しました';

  @override
  String get throwLimitReached => '今日の流す回数が上限に達しました';

  @override
  String get pleaseLogin => 'ログインしてください';

  @override
  String get writeBottleTitle => '瓶を書く';

  @override
  String contentMinLength(Object count) {
    return '内容は$count文字以上必要です';
  }

  @override
  String get bottleThrownSuccess => '瓶を海に流しました';

  @override
  String get maxTagsHint => 'トピックタグは最大3つまで';

  @override
  String get selectTopicTag => 'トピックを選ぶ（最大3つ）';

  @override
  String get throwIntoOcean => '海に流す';

  @override
  String throwQuotaHint(Object limit, Object remaining) {
    return '今日の残り流せる回数：$remaining/$limit';
  }

  @override
  String throwQuotaHintNew(Object dailyLimit, Object limit, Object remaining) {
    return '新規ユーザーは24時間以内に$remaining/$limit回流せ、24時間後は1日$dailyLimit回に戻ります。';
  }

  @override
  String get anonymous => '匿名';

  @override
  String translateCost(Object count) {
    return '翻訳を1回消費（今日残り$count回）';
  }

  @override
  String get alreadyReported => 'このユーザーを既に通報しました。';

  @override
  String get translateLimitReached => '今日の翻訳回数が上限に達しました';

  @override
  String get translateFailed => '翻訳に失敗しました。回数制限またはネットワークの問題かもしれません。';

  @override
  String get longPressToTranslate => '長押しで翻訳';

  @override
  String get read => '既読';

  @override
  String get unread => '未読';

  @override
  String get goCatchBottle => '瓶を拾いに行きましょう';

  @override
  String get justNow => 'たった今';

  @override
  String minutesAgo(Object count) {
    return '$count分前';
  }

  @override
  String hoursAgo(Object count) {
    return '$count時間前';
  }

  @override
  String daysAgo(Object count) {
    return '$count日前';
  }

  @override
  String get reportSubmitted => '通報を受け付けました。順次確認いたします。';

  @override
  String get noBottlesThrown => 'まだ瓶を流していません';

  @override
  String get goThrowBottle => '瓶を流して、遠くの友達が拾うのを待ちましょう。';

  @override
  String caughtAtTime(Object time) {
    return '$timeに拾われました';
  }

  @override
  String replyMessage(Object message) {
    return '返信：$message';
  }

  @override
  String get caughtNoReply => '拾われましたが、まだ返信がありません';

  @override
  String get slogan => '漂流瓶 · 世界とつながる';

  @override
  String get privacyAgreement => '続行すると、プライバシーポリシーと利用規約に同意したものとみなされます。';

  @override
  String get disagreeExit => '同意しない、アプリを終了';

  @override
  String get ageRule1 => '本アプリは13歳以上を対象としています。13歳未満の方はご利用にならないでください。';

  @override
  String get ageRule2 =>
      '13〜18歳のユーザーは保護者の指導のもとで使用し、見知らぬ人と連絡先を交換したり、直接会うことを避けてください。';

  @override
  String get ageRule3 => '性的、暴力的、差別的な内容など、禁止された内容を含めないでください。';

  @override
  String get ageRule4 => 'メール、電話番号、SNSアカウントなどの連絡先を含めないでください。やり取りはアプリ内で行ってください。';

  @override
  String get ageRule5 => '違反内容をローカルで検出し、違反ユーザーは利用を制限する場合があります。';

  @override
  String get editNickname => 'ニックネームを編集';

  @override
  String get nicknameHint => 'ニックネームを入力';

  @override
  String get saveSuccess => '保存しました';

  @override
  String get saveFailed => '保存に失敗しました。もう一度お試しください';

  @override
  String get selectCountry => '国を選択';

  @override
  String get selectLanguage => '言語を選択';

  @override
  String get saveProfile => 'プロフィールを保存';

  @override
  String get todayQuota => '今日の残り';

  @override
  String get myBottlesSubtitle => '流した瓶の状態を確認';

  @override
  String get exportMyDataSubtitle => '個人データのコピーを取得';

  @override
  String get deleteAccountSubtitle => 'アカウントとすべてのデータを永久に削除';

  @override
  String get exportFailed => 'エクスポートに失敗しました。接続を確認してください';

  @override
  String get copyFullData => '完全なデータをコピー';

  @override
  String get deleteAccountDialogTitle => 'アカウントを削除';

  @override
  String get deleteAccountDialogContent => 'アカウントとすべての関連データが永久に削除されます。元に戻せません：';

  @override
  String get deleteAccountDataList =>
      '· すべての瓶が削除されます\n· すべてのトークとメッセージが削除されます\n· 通報記録が削除されます\n· ニックネーム、国、言語設定がクリアされます';

  @override
  String get deleteAccountRestartHint => '削除後、このデバイスは新規ユーザーとして始まります。';

  @override
  String get continueDelete => '削除を続ける';

  @override
  String get finalConfirm => '最終確認';

  @override
  String get typeDeleteToConfirm => '確認のため「削除」と入力してください：';

  @override
  String get typeDeleteHint => '削除';

  @override
  String get confirmDelete => '削除を確定';

  @override
  String get accountDeleted => 'アカウントを削除しました。初期化中...';

  @override
  String get deleteAccountNetworkError => '削除に失敗しました。接続を確認してください';

  @override
  String get reply => '返信';

  @override
  String get throwBack => '海に戻す';

  @override
  String reportTarget(Object target) {
    return '通報対象：$target';
  }

  @override
  String get selectReportReason => '通報理由を選択';

  @override
  String get supplementDescription => '補足説明（任意）';

  @override
  String get describeViolation => '違反内容を説明...';

  @override
  String get submitReport => '通報を送信';

  @override
  String get unknownRegion => '不明な地域';

  @override
  String get privacyPolicyTitle => 'DriftBottle プライバシーポリシー';

  @override
  String get lastUpdated => '最終更新日：2026年7月18日';

  @override
  String get privacySection1Title => '1. 収集する情報';

  @override
  String get privacySection1Content =>
      '漂流瓶と多言語チャットサービスを提供するため、最小限の必要情報を収集します：\n\n• デバイス識別子：電話番号なしで匿名ログインとアカウント識別に使用します。\n• ニックネーム、国、母語：瓶の中で文化背景を示すために使用します。\n• 送信した瓶の内容とチャットメッセージ：他のユーザーにマッチングして表示するために使用します。\n• IPアドレス：国・地域を推定するために使用します。';

  @override
  String get privacySection2Title => '2. 情報の利用目的';

  @override
  String get privacySection2Content =>
      '• 世界中の他のユーザーにランダムで瓶をマッチングします。\n• Google翻訳APIを使用して、受信者の言語に内容を翻訳します。\n• 1日の回数制限（流す、拾う、翻訳）とトークの期限切れを管理します。\n• ローカルのNGワードフィルタリングでコミュニティの安全を保護します。';

  @override
  String get privacySection3Title => '3. データの保存とセキュリティ';

  @override
  String get privacySection3Content =>
      'ユーザーデータはSupabase（PostgreSQL）に保存されます。Row Level Security（RLS）を使用してアクセスを制限しています：ユーザーは自分に関連する瓶、トーク、メッセージのみ読み取れます。すべての通信はHTTPS/WSSで暗号化されています。';

  @override
  String get privacySection4Title => '4. あなたの権利';

  @override
  String get privacySection4Content =>
      '• アクセス：マイページでニックネーム、国、言語を確認・編集できます。\n• エクスポート：マイページから個人データのコピーを請求できます。\n• 削除：マイページの「アカウントを削除」機能で、アカウントと関連データを永久に削除できます。\n• 撤回：アプリの使用停止は同意の撤回とみなされ、7日後に期限切れのトークとメッセージは自動的に削除されます。';

  @override
  String get privacySection5Title => '5. サードパーティサービス';

  @override
  String get privacySection5Content =>
      'アプリの運営のため、以下のサードパーティサービスを使用しています：\n\n• Supabase：データベースとリアルタイム通信。\n• Google 無料翻訳API：メッセージ翻訳。\n\nこれらのプロバイダーには独自のプライバシーポリシーがあります。併せてご確認ください。';

  @override
  String get privacySection6Title => '6. 子どものプライバシー';

  @override
  String get privacySection6Content =>
      'DriftBottleは13歳未満の子どもを対象としていません。13歳未満の子どもの個人情報を収集していることが判明した場合、直ちに削除します。';

  @override
  String get privacySection7Title => '7. ポリシーの更新';

  @override
  String get privacySection7Content =>
      '本プライバシーポリシーは随時更新される場合があります。更新後のポリシーはアプリ内に掲載され、最終更新日が更新されます。';

  @override
  String get privacySection8Title => '8. お問い合わせ';

  @override
  String get privacySection8Content =>
      'ご質問やデータの請求がある場合は、choas.bai84@gmail.com までご連絡ください。';
}
