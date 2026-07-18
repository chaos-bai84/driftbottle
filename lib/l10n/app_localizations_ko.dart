// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appName => '유리병';

  @override
  String get oceanTab => '바다';

  @override
  String get chatTab => '대화';

  @override
  String get profileTab => '내 정보';

  @override
  String get throwBottle => '유리병 던지기';

  @override
  String get catchBottle => '유리병 잡기';

  @override
  String get writeBottleContent => '하고 싶은 말을 10~500자로 작성하세요...';

  @override
  String get selectTag => '태그 선택';

  @override
  String get throwOut => '던지기';

  @override
  String get cancel => '취소';

  @override
  String get save => '저장';

  @override
  String get confirm => '확인';

  @override
  String get delete => '삭제';

  @override
  String get report => '신고';

  @override
  String get translate => '번역';

  @override
  String get send => '보내기';

  @override
  String get copy => '복사';

  @override
  String get close => '닫기';

  @override
  String get noConversations => '아직 대화가 없습니다';

  @override
  String get startChat => '대화를 시작하세요';

  @override
  String get messageHint => '메시지 입력...';

  @override
  String get myBottles => '내 유리병';

  @override
  String get floating => '떠다니는 중';

  @override
  String get caught => '잡힘';

  @override
  String get expired => '만료됨';

  @override
  String get bottleStatus => '유리병 상태';

  @override
  String get settings => '설정';

  @override
  String get language => '언어';

  @override
  String get nickname => '닉네임';

  @override
  String get country => '국가';

  @override
  String get privacyPolicy => '개인정보 처리방침';

  @override
  String get exportMyData => '내 데이터 내보내기';

  @override
  String get deleteAccount => '계정 삭제';

  @override
  String get logout => '로그아웃';

  @override
  String get welcomeText =>
      'DriftBottle에 오신 것을 환영합니다! 마음을 유리병에 담아 바다에 던지고, 전 세계의 유리병을 잡아 낯선 사람과 익명으로 대화해 보세요.';

  @override
  String get ageVerificationTitle => '이용 안내';

  @override
  String get ageVerificationConfirm => '저는 13세 이상이며 계속 진행에 동의합니다';

  @override
  String get emptyOcean => '바다에 유리병이 없습니다. 하나 던져보세요';

  @override
  String get bottleCaughtHint => '유리병을 잡았습니다';

  @override
  String get replyOrDiscard => '답장하거나 바다로 돌려보내기';

  @override
  String get deleteConversation => '대화 삭제';

  @override
  String get deleteConversationConfirm => '이 대화를 삭제할까요? 모든 메시지가 삭제됩니다.';

  @override
  String get reportUser => '사용자 신고';

  @override
  String get reportConversation => '대화 신고';

  @override
  String get reportReason => '신고 사유';

  @override
  String get submit => '제출';

  @override
  String get operationSuccess => '성공';

  @override
  String get operationFailed => '실패했습니다. 다시 시도해 주세요';

  @override
  String get networkError => '네트워크 오류입니다. 연결을 확인해 주세요';

  @override
  String get loading => '로딩 중...';

  @override
  String remainingTranslateCount(Object count) {
    return '오늘 남은 번역 횟수: $count회';
  }

  @override
  String get translateThisMessage => '이 메시지 번역';

  @override
  String get deleteMessage => '메시지 삭제';

  @override
  String get deleteMessageConfirm => '이 메시지를 삭제할까요?';

  @override
  String get catchWithTags => '태그로 잡기';

  @override
  String selectedTags(Object tags) {
    return '선택한 태그: $tags';
  }

  @override
  String get dataExportTitle => '개인 데이터 내보내기';

  @override
  String get dataExportDescription =>
      '데이터 사본이 준비되었습니다. 아래 버튼을 눌러 전체 JSON을 복사하세요.';

  @override
  String get copiedToClipboard => '클립보드에 복사되었습니다';

  @override
  String get deleteAccountConfirm =>
      '계정을 삭제하면 모든 데이터가 영구적으로 삭제됩니다. 복구할 수 없습니다.';

  @override
  String get deleteAccountTypeConfirm => '확인을 위해 “계정 삭제”를 입력하세요.';

  @override
  String get deleteAccountKeyword => '계정 삭제';

  @override
  String get expiredConversationHint => '이 대화는 만료되어 자동으로 정리되었습니다.';

  @override
  String get quotaCatch => '잡기';

  @override
  String get quotaThrow => '던지기';

  @override
  String get quotaTranslate => '번역';

  @override
  String get quotaCatchNew => '잡기(새)';

  @override
  String get quotaThrowNew => '던지기(새)';

  @override
  String get tagFilterHint => '토픽 조절(선택, 최대 3개)';

  @override
  String get clear => '초기화';

  @override
  String get catchLimitReached => '오늘 유리병 잡기 횟수를 모두 사용했습니다';

  @override
  String get throwLimitReached => '오늘 유리병 던지기 횟수를 모두 사용했습니다';

  @override
  String get pleaseLogin => '로그인해 주세요';

  @override
  String get writeBottleTitle => '유리병 작성';

  @override
  String contentMinLength(Object count) {
    return '내용은 최소 $count자 이상이어야 합니다';
  }

  @override
  String get bottleThrownSuccess => '유리병을 바다에 띄웠습니다';

  @override
  String get maxTagsHint => '토픽 태그는 최대 3개까지';

  @override
  String get selectTopicTag => '토픽 선택 (최대 3개)';

  @override
  String get throwIntoOcean => '바다에 던지기';

  @override
  String throwQuotaHint(Object limit, Object remaining) {
    return '오늘 남은 던지기 횟수: $remaining/$limit';
  }

  @override
  String throwQuotaHintNew(Object dailyLimit, Object limit, Object remaining) {
    return '신규 사용자는 24시간 이내에 $remaining/$limit번 던질 수 있으며, 24시간 후 하루 $dailyLimit번으로 복원됩니다.';
  }

  @override
  String get anonymous => '익명';

  @override
  String translateCost(Object count) {
    return '번역 1회 소모 (오늘 남은 $count회)';
  }

  @override
  String get alreadyReported => '이 사용자를 이미 신고했습니다.';

  @override
  String get translateLimitReached => '오늘 번역 횟수를 모두 사용했습니다';

  @override
  String get translateFailed => '번역 실패. 횟수 소진 또는 네트워크 문제일 수 있습니다.';

  @override
  String get longPressToTranslate => '길게 눌러 번역';

  @override
  String get read => '읽음';

  @override
  String get unread => '안 읽음';

  @override
  String get goCatchBottle => '유리병을 잡으러 가보세요';

  @override
  String get justNow => '방금';

  @override
  String minutesAgo(Object count) {
    return '$count분 전';
  }

  @override
  String hoursAgo(Object count) {
    return '$count시간 전';
  }

  @override
  String daysAgo(Object count) {
    return '$count일 전';
  }

  @override
  String get reportSubmitted => '신고가 접수되었으며, 검토하겠습니다.';

  @override
  String get noBottlesThrown => '아직 유리병을 던지지 않았습니다';

  @override
  String get goThrowBottle => '유리병을 던져서 멀리 있는 친구가 잡기를 기다려보세요.';

  @override
  String caughtAtTime(Object time) {
    return '$time에 잡혔습니다';
  }

  @override
  String replyMessage(Object message) {
    return '답장: $message';
  }

  @override
  String get caughtNoReply => '잡혔지만 아직 답장이 없습니다';

  @override
  String get slogan => '유리병 · 세상과 연결';

  @override
  String get privacyAgreement => '계속하면 개인정보 처리방침 및 서비스 이용약관에 동의하는 것입니다.';

  @override
  String get disagreeExit => '동의하지 않음, 앱 종료';

  @override
  String get ageRule1 => '본 앱은 13세 이상 사용자를 대상으로 합니다. 13세 미만은 가입하거나 사용하지 마세요.';

  @override
  String get ageRule2 =>
      '13~18세 사용자는 보호자의 지도 하에 사용하고, 모르는 사람과 연락처를 교환하거나 오프라인 만남을 피하세요.';

  @override
  String get ageRule3 => '병 내용이나 메시지에 성적, 폭력, 혐오 발언 등 위반 내용을 포함하지 마세요.';

  @override
  String get ageRule4 => '이메일, 전화번호, 소셜 계정 등 연락처를 포함하지 마세요. 모든 소통은 앱 내에서 해주세요.';

  @override
  String get ageRule5 => '위반 내용을 로컬에서 감지하며, 위반 사용자는 이용을 제한할 수 있습니다.';

  @override
  String get editNickname => '닉네임 수정';

  @override
  String get nicknameHint => '닉네임을 입력하세요';

  @override
  String get saveSuccess => '저장 완료';

  @override
  String get saveFailed => '저장 실패, 다시 시도해 주세요';

  @override
  String get selectCountry => '국가 선택';

  @override
  String get selectLanguage => '언어 선택';

  @override
  String get saveProfile => '프로필 저장';

  @override
  String get todayQuota => '오늘 할당량';

  @override
  String get myBottlesSubtitle => '내가 던진 유리병 상태 보기';

  @override
  String get exportMyDataSubtitle => '개인 데이터 사본 가져오기';

  @override
  String get deleteAccountSubtitle => '계정과 모든 데이터를 영구 삭제';

  @override
  String get exportFailed => '내보내기 실패, 연결을 확인해 주세요';

  @override
  String get copyFullData => '전체 데이터 복사';

  @override
  String get deleteAccountDialogTitle => '계정 삭제';

  @override
  String get deleteAccountDialogContent =>
      '계정과 모든 관련 데이터가 영구 삭제됩니다. 복구할 수 없습니다:';

  @override
  String get deleteAccountDataList =>
      '· 모든 유리병이 삭제됩니다\n· 모든 대화와 메시지가 삭제됩니다\n· 신고 기록이 삭제됩니다\n· 닉네임, 국가, 언어 설정이 삭제됩니다';

  @override
  String get deleteAccountRestartHint => '삭제 후 이 기기는 새 사용자로 다시 시작합니다.';

  @override
  String get continueDelete => '삭제 계속';

  @override
  String get finalConfirm => '최종 확인';

  @override
  String get typeDeleteToConfirm => '확인을 위해 “삭제”를 입력하세요:';

  @override
  String get typeDeleteHint => '삭제';

  @override
  String get confirmDelete => '삭제 확인';

  @override
  String get accountDeleted => '계정이 삭제되었습니다. 다시 초기화 중...';

  @override
  String get deleteAccountNetworkError => '삭제 실패, 연결을 확인해 주세요';

  @override
  String get reply => '답장';

  @override
  String get throwBack => '바다로 돌려보내기';

  @override
  String reportTarget(Object target) {
    return '신고 대상: $target';
  }

  @override
  String get selectReportReason => '신고 사유 선택';

  @override
  String get supplementDescription => '추가 설명 (선택)';

  @override
  String get describeViolation => '위반 내용을 설명해 주세요...';

  @override
  String get submitReport => '신고 제출';

  @override
  String get unknownRegion => '알 수 없는 지역';

  @override
  String get privacyPolicyTitle => 'DriftBottle 개인정보 처리방침';

  @override
  String get lastUpdated => '최종 업데이트: 2026년 7월 18일';

  @override
  String get privacySection1Title => '1. 수집하는 정보';

  @override
  String get privacySection1Content =>
      '유리병과 다국어 채팅 서비스를 제공하기 위해 최소한의 필요한 정보를 수집합니다:\n\n• 기기 식별자: 전화번호 없이 익명 로그인과 계정 식별에 사용됩니다.\n• 닉네임, 국가, 모국어: 병에서 문화적 배경을 표시하는 데 사용됩니다.\n• 병 내용과 채팅 메시지: 다른 사용자와 매칭하여 표시하는 데 사용됩니다.\n• IP 주소: 국가/지역을 추정하는 데 사용됩니다.';

  @override
  String get privacySection2Title => '2. 정보 사용 방법';

  @override
  String get privacySection2Content =>
      '• 전 세계 다른 사용자에게 유리병을 무작위로 매칭합니다.\n• Google 번역 API를 사용하여 내용을 수신자의 언어로 번역합니다.\n• 일일 할당량(던지기, 잡기, 번역)과 대화 만료를 관리합니다.\n• 로컬 민감 단어 필터링으로 커뮤니티 안전을 보호합니다.';

  @override
  String get privacySection3Title => '3. 데이터 저장 및 보안';

  @override
  String get privacySection3Content =>
      '사용자 데이터는 Supabase(PostgreSQL)에 저장됩니다. Row Level Security(RLS)를 사용하여 데이터 접근을 제한합니다: 사용자는 자신과 관련된 병, 대화, 메시지만 읽을 수 있습니다. 모든 네트워크 통신은 HTTPS/WSS로 암호화됩니다.';

  @override
  String get privacySection4Title => '4. 사용자 권리';

  @override
  String get privacySection4Content =>
      '• 접근: 프로필 페이지에서 닉네임, 국가, 언어를 확인하고 수정할 수 있습니다.\n• 내보내기: 프로필 페이지에서 개인 데이터 사본을 요청할 수 있습니다.\n• 삭제: 프로필 페이지의 “계정 삭제” 기능으로 계정과 관련 데이터를 영구 삭제할 수 있습니다.\n• 철회: 앱 사용 중단은 동의 철회로 간주되며, 7일 후 만료된 대화와 메시지는 자동으로 정리됩니다.';

  @override
  String get privacySection5Title => '5. 제3자 서비스';

  @override
  String get privacySection5Content =>
      '앱 운영을 위해 다음 제3자 서비스를 사용합니다:\n\n• Supabase: 데이터베이스 및 실시간 통신.\n• Google 무료 번역 API: 메시지 번역.\n\n이러한 제공업체는 자체 개인정보 처리방침을 가지고 있으므로 함께 확인하시기 바랍니다.';

  @override
  String get privacySection6Title => '6. 아동 개인정보';

  @override
  String get privacySection6Content =>
      'DriftBottle은 13세 미만 아동을 대상으로 하지 않습니다. 13세 미만 아동의 개인정보를 수집한 것을 발견하면 즉시 삭제합니다.';

  @override
  String get privacySection7Title => '7. 정책 업데이트';

  @override
  String get privacySection7Content =>
      '본 개인정보 처리방침은 수시로 업데이트될 수 있습니다. 업데이트된 정책은 앱 내에 게시되며 최종 업데이트 날짜가 갱신됩니다.';

  @override
  String get privacySection8Title => '8. 문의하기';

  @override
  String get privacySection8Content =>
      '질문이나 데이터 요청이 있으면 choas.bai84@gmail.com으로 이메일을 보내주세요.';
}
