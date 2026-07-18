/// 内容过滤服务
/// 提供敏感词过滤、联系方式检测、文本安全检测功能
///
/// 对应需求文档第6章"内容安全策略"：
/// - 6.1 MVP阶段本地敏感词过滤
/// - 6.1 联系方式与导流信息过滤（邮箱/URL/IP/连续数字/社交平台关键词）
/// - 6.1 地区化规则（按用户语言/国家触发）
library;

/// 联系方式检测结果
class ContactInfoResult {
  /// 是否包含联系方式或导流信息
  final bool hasContactInfo;

  /// 命中的检测项描述（用于日志和调试，不直接展示给用户）
  final List<String> matchedPatterns;

  const ContactInfoResult({
    required this.hasContactInfo,
    required this.matchedPatterns,
  });

  /// 安全结果（无任何联系方式）
  factory ContactInfoResult.safe() => const ContactInfoResult(
        hasContactInfo: false,
        matchedPatterns: [],
      );
}

/// 文本综合安全检测结果
class TextSafetyResult {
  /// 是否安全（无敏感词且无联系方式）
  final bool isSafe;

  /// 命中的敏感词列表
  final List<String> sensitiveWords;

  /// 命中的联系方式检测结果
  final ContactInfoResult contactInfo;

  const TextSafetyResult({
    required this.isSafe,
    required this.sensitiveWords,
    required this.contactInfo,
  });

  /// 获取用户友好的错误提示
  /// 提示文案根据用户语言显示
  /// [language] 用户语言代码（如 'zh', 'en', 'ja'）
  String errorMessage(String language) {
    if (sensitiveWords.isNotEmpty) {
      return _localizedSensitiveMessage(language);
    }
    if (contactInfo.hasContactInfo) {
      return _localizedContactMessage(language);
    }
    return '';
  }

  /// 中文默认错误提示
  String get errorMessageZh => errorMessage('zh');

  String _localizedSensitiveMessage(String language) {
    switch (language.toLowerCase()) {
      case 'en':
        return 'Content contains sensitive words, please modify before sending.';
      case 'ja':
        return '内容に不適切な表現が含まれています。修正してから送信してください。';
      case 'ko':
        return '내용에 민감한 단어가 포함되어 있습니다. 수정 후 전송해 주세요.';
      default:
        return '内容包含敏感词，请修改后发送';
    }
  }

  String _localizedContactMessage(String language) {
    switch (language.toLowerCase()) {
      case 'en':
        return 'Message contains contact info, please keep the conversation in-app.';
      case 'ja':
        return '連絡先が含まれています。アプリ内で会話を続けてください。';
      case 'ko':
        return '연락처가 포함되어 있습니다. 앱 내에서 대화해 주세요.';
      default:
        return '消息包含联系方式，请留在应用内交流';
    }
  }
}

/// 内容过滤服务类
class FilterService {
  // ==================== 敏感词库 ====================

  // 中文敏感词库（色情类）
  static const List<String> _chineseSexualWords = [
    '色情', '裸体', '裸聊', '裸照', '裸视频', '约炮', '约吗', '一夜情',
    '找小姐', '上门服务', '按摩', '包夜', '出台', '陪睡', '陪聊',
    '性交', '做爱', '上床', '开房', '酒店', '房间号',
    '骚', '淫', '逼', '屌', '鸡巴', '逼逼', '色情网',
    '色图', '黄色', '黄图', '黄片', '毛片', 'AV', 'av女优',
    '三级片', '成人', '性服务', '性交易', '卖淫', '嫖娼',
    '口交', '肛交', '手淫', '自慰', '巨乳', '美乳',
    '丝袜', '内裤', '内衣', '情趣', '调情', '挑逗',
    '视频裸聊', '福利视频', '福利群', '福利号',
  ];

  // 中文敏感词库（暴力/违法类）
  static const List<String> _chineseViolenceWords = [
    '杀人', '放火', '抢劫', '强奸', '绑架', '贩毒', '吸毒', '毒品',
    '冰毒', '海洛因', '大麻', '可卡因', '摇头丸', 'k粉',
    '枪支', '手枪', '步枪', '炸药', '炸弹', '军火',
    '自杀', '自残', '跳楼', '割腕', '上吊',
    '诈骗', '传销', '非法集资', '洗钱', '走私',
    '赌博', '赌球', '六合彩', '彩票代理',
    '邪教', '反动', '颠覆国家',
    '出售', '买卖', '代孕', '捐卵', '卖肾',
  ];

  // 英文敏感词库（色情类）
  static const List<String> _englishSexualWords = [
    'porn', 'pornography', 'nude', 'naked', 'sex', 'sexy',
    'fuck', 'fucking', 'pussy', 'dick', 'cock', 'ass',
    'boobs', 'tits', 'asshole', 'bitch', 'whore', 'slut',
    'masturbate', 'masturbation', 'orgasm', 'cum', 'sperm',
    'blowjob', 'handjob', 'anal', 'vagina', 'penis',
    'hooker', 'escort', 'prostitute', 'stripper',
    'xxx', 'x-rated', 'nsfw', 'onlyfans',
    'cam girl', 'cam show', 'live sex',
    'erotic', 'fetish', 'bdsm', 'bondage',
    'lingerie', 'underwear', 'nude photo',
    'one night stand', 'ons', 'hook up', 'casual sex',
  ];

  // 英文敏感词库（暴力/违法类）
  static const List<String> _englishViolenceWords = [
    'kill', 'murder', 'death', 'die', 'suicide',
    'gun', 'pistol', 'rifle', 'bomb', 'explosive',
    'drug', 'cocaine', 'heroin', 'marijuana', 'weed',
    'meth', 'crystal meth', 'lsd', 'ecstasy',
    'robbery', 'rob', 'steal', 'theft', 'fraud',
    'scam', 'scammer', 'hack', 'hacker',
    'rape', 'rapist', 'abuse', 'domestic violence',
    'terrorist', 'terrorism', 'isil', 'isis',
    'gambling', 'casino', 'betting', 'sports bet',
    'money laundering', 'smuggle', 'smuggling',
    'self harm', 'self-harm', 'cutting',
  ];

  // 日文敏感词库（色情类）
  static const List<String> _japaneseSexualWords = [
    'エロ', 'エッチ', 'Hな', '裸', '裸体', 'ヌード',
    'セックス', '性行為', '性交',
    '巨乳', '貧乳', 'パイパン', '毛深い',
    'オナニー', '手淫', 'マスターベーション',
    'フェラ', '口淫', 'アナル',
    'AV女優', 'AV男優', 'ポルノ', 'エロ動画',
    '風俗', 'ソープ', 'ヘルス', 'デリヘル',
    '出張ホスト', 'コンパニオン',
    'オナホ', 'ダッチワイフ', 'ラブドール',
    '変態', '痴漢', '露出', '覗き',
    'わいせつ', '淫行',
  ];

  // 日文敏感词库（暴力/违法类）
  static const List<String> _japaneseViolenceWords = [
    '殺す', '殺人', '死亡', '自殺', '首吊り',
    '銃', '拳銃', 'ライフル', '爆弾', '爆発物',
    '麻薬', '覚醒剤', 'コカイン', 'ヘロイン', '大麻',
    'MDMA', 'LSD', 'シャブ',
    '強盗', '窃盗', '詐欺', '振り込め詐欺',
    'レイプ', '強姦',
    'テロ', 'テロリスト',
    '賭博', 'ギャンブル', 'パチンコ', '競馬',
    '暴力団', 'やくざ', 'マフィア',
    '傷害', '暴行', '恐喝', '脅迫',
  ];

  // 所有敏感词（合并）
  static final List<String> _allSensitiveWords = [
    ..._chineseSexualWords,
    ..._chineseViolenceWords,
    ..._englishSexualWords,
    ..._englishViolenceWords,
    ..._japaneseSexualWords,
    ..._japaneseViolenceWords,
  ];

  // ==================== 联系方式正则 ====================

  /// 邮箱地址正则
  static final RegExp _emailRegex = RegExp(
    r'[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}',
  );

  /// URL 正则（http:// https://）
  static final RegExp _urlRegex = RegExp(
    r'https?://[^\s<>"{}|\\^`\[\]]+',
    caseSensitive: false,
  );

  /// IPv4 地址正则
  static final RegExp _ipRegex = RegExp(
    r'(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}'
    r'(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)',
  );

  /// 连续10位以上数字（用于拦截手机号、社交ID等）
  static final RegExp _longNumberRegex = RegExp(
    r'\d{10,}',
  );

  /// 裸域名正则（如 example.com）
  /// 用于检测不带 http(s):// 的域名
  static final RegExp _domainRegex = RegExp(
    r'(?:[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?\.)'
    r'+[a-zA-Z]{2,6}\b',
  );

  // ==================== 社交平台通用关键词 ====================

  /// 通用社交平台关键词（所有用户都检测）
  /// 包含主要国际社交平台及缩写
  static const List<String> _socialPlatformKeywords = [
    // 国际主流平台
    'whatsapp', 'telegram', 'instagram', 'facebook',
    'twitter', 'snapchat', 'discord', 'tiktok',
    'skype', 'signal', 'viber', 'kik', 'imessage',
    'kakao', 'kakaotalk', 'wechat', 'weixin',
    'line id', 'lineid', 'messenger',
    // 中文平台
    '微信', '微博', '小红书', '抖音', '快手', '知乎',
    '哔哩哔哩', 'b站',
    // 日韩平台
    'カカオ', '카카오', 'ライン', 'ライン',
    // 常见缩写
    'wa:', 'tg:', 'ig:', 'fb:', 'tw:',
  ];

  // ==================== 地区化关键词 ====================

  /// 中国用户重点检测关键词
  static const List<String> _chinaKeywords = [
    '微信', 'v信', 'vx', 'wx', '薇信', '威信',
    'qq', 'qq号', '扣扣', '企鹅号',
    '手机号', '电话', '手机', '电话号码', '联系电话',
    '加我', '扫码', '二维码', '扫一扫',
    '微博', '小红书', '抖音', '快手', '知乎',
    '私聊', '私信', '关注我', '加好友',
  ];

  /// 东南亚用户重点检测关键词
  static const List<String> _seaKeywords = [
    'line id', 'lineid', 'line:', 'line ',
    'whatsapp', 'wa:', 'wa number', 'wa ',
    'telegram', 'tg:', 'tg id', 'tg ',
    'wechat', 'weixin',
    'contact me', 'add me',
  ];

  /// 日韩用户重点检测关键词
  static const List<String> _jpKrKeywords = [
    'line', 'ライン', 'ライン', 'line id', 'lineid',
    'kakao', '카카오', 'カカオ', 'kakaotalk', 'kakao id',
    'instagram', 'インスタ', '인스타',
    'twitter', 'ツイッター', '트위터',
    'dm', 'pm', '連絡先', '연락처',
  ];

  /// 欧美用户重点检测关键词
  static const List<String> _westernKeywords = [
    'whatsapp', 'telegram', 'snapchat', 'discord', 'instagram',
    'facebook', 'messenger', 'twitter', 'tiktok', 'signal',
    'phone number', 'cell', 'mobile', 'call me', 'text me',
    'my number', 'reach me', 'dm me', 'pm me',
    'add me on', 'follow me', 'hit me up',
  ];

  // ==================== 敏感词检测方法 ====================

  /// 检测文本是否包含敏感词
  /// [text] 待检测的文本
  /// 返回敏感词列表，如果不包含敏感词则返回空列表
  static List<String> detectSensitiveWords(String text) {
    if (text.trim().isEmpty) return [];

    final lowerText = text.toLowerCase();
    final found = <String>[];

    for (final word in _allSensitiveWords) {
      if (lowerText.contains(word.toLowerCase())) {
        found.add(word);
      }
    }

    return found;
  }

  /// 检测文本是否安全（不包含敏感词）
  /// [text] 待检测的文本
  /// 返回 true 表示文本安全，false 表示包含敏感词
  static bool isTextSafe(String text) {
    return detectSensitiveWords(text).isEmpty;
  }

  /// 过滤文本中的敏感词（用 * 替换）
  /// [text] 待过滤的文本
  /// 返回过滤后的文本
  static String filterText(String text) {
    if (text.trim().isEmpty) return text;

    String result = text;
    final lowerText = text.toLowerCase();

    for (final word in _allSensitiveWords) {
      final lowerWord = word.toLowerCase();
      if (lowerText.contains(lowerWord)) {
        // 用相同长度的 * 替换
        final replacement = '*' * word.length;
        // 不区分大小写替换
        result = result.replaceAll(
          RegExp(RegExp.escape(word), caseSensitive: false),
          replacement,
        );
      }
    }

    return result;
  }

  /// 计算文本的风险等级
  /// [text] 待检测的文本
  /// 返回 0-3 级：0=安全，1=低风险，2=中风险，3=高风险
  static int getRiskLevel(String text) {
    final words = detectSensitiveWords(text);
    if (words.isEmpty) return 0;

    int sexualCount = 0;
    int violenceCount = 0;

    for (final word in words) {
      if (_chineseSexualWords.contains(word) ||
          _englishSexualWords.contains(word) ||
          _japaneseSexualWords.contains(word)) {
        sexualCount++;
      } else {
        violenceCount++;
      }
    }

    if (violenceCount >= 2 || sexualCount >= 5) return 3;
    if (violenceCount >= 1 || sexualCount >= 2) return 2;
    return 1;
  }

  // ==================== 联系方式检测方法 ====================

  /// 检测文本中是否包含联系方式或导流信息
  ///
  /// 实现需求文档 6.1 节"联系方式与导流信息过滤"：
  /// - 邮箱地址（如 xxx@xxx.com）
  /// - URL 链接（含 http://、https://、裸域名）
  /// - IP 地址
  /// - 过长连续数字（10位以上，用于拦截手机号、社交ID等）
  /// - 常见社交平台关键词及缩写
  /// - 地区化规则（按用户语言/国家触发）
  ///
  /// [text] 待检测文本
  /// [countryCode] 用户国家代码（用于地区化规则，如 'CN', 'JP'）
  /// [language] 用户语言（用于地区化规则，如 'zh', 'ja'）
  static ContactInfoResult detectContactInfo({
    required String text,
    String? countryCode,
    String? language,
  }) {
    if (text.trim().isEmpty) return ContactInfoResult.safe();

    final lowerText = text.toLowerCase();
    final matched = <String>[];

    // 1. 邮箱检测
    if (_emailRegex.hasMatch(text)) {
      matched.add('邮箱地址');
    }

    // 2. URL 检测（http:// https://）
    if (_urlRegex.hasMatch(text)) {
      matched.add('链接');
    }

    // 3. IP 地址检测
    if (_ipRegex.hasMatch(text)) {
      matched.add('IP地址');
    }

    // 4. 连续10位以上数字（手机号、QQ号等）
    if (_longNumberRegex.hasMatch(text)) {
      matched.add('连续数字');
    }

    // 5. 裸域名检测（仅当未匹配到URL时，避免重复）
    if (!_urlRegex.hasMatch(text)) {
      final domainMatches = _domainRegex.allMatches(text);
      for (final match in domainMatches) {
        final domain = match.group(0)!.toLowerCase();
        // 排除纯数字.数字情况（如版本号 1.0.0 或小数）
        if (!RegExp(r'^\d+\.\d+').hasMatch(domain)) {
          // 排除常见无害后缀
          if (!_isHarmlessDomain(domain)) {
            matched.add('域名');
            break;
          }
        }
      }
    }

    // 6. 通用社交平台关键词
    for (final keyword in _socialPlatformKeywords) {
      if (lowerText.contains(keyword.toLowerCase())) {
        matched.add('社交平台:$keyword');
        break; // 一个就足够
      }
    }

    // 7. 地区化关键词检测
    final regionKeywords = _getRegionKeywords(countryCode, language);
    for (final keyword in regionKeywords) {
      if (lowerText.contains(keyword.toLowerCase())) {
        // 避免与通用关键词重复
        final desc = '导流信息:$keyword';
        if (!matched.any((m) => m.contains(keyword))) {
          matched.add(desc);
        }
        break;
      }
    }

    return ContactInfoResult(
      hasContactInfo: matched.isNotEmpty,
      matchedPatterns: matched,
    );
  }

  /// 检测文本是否不含联系方式（安全）
  /// [text] 待检测文本
  /// [countryCode] 用户国家代码（用于地区化规则）
  /// [language] 用户语言（用于地区化规则）
  static bool isTextSafeContact({
    required String text,
    String? countryCode,
    String? language,
  }) {
    return !detectContactInfo(
      text: text,
      countryCode: countryCode,
      language: language,
    ).hasContactInfo;
  }

  /// 根据用户国家/语言获取地区化关键词
  ///
  /// 实现需求文档 6.1 节"地区化规则"：
  /// - 中国用户：重点检测"微信"、"VX"、"WX"、"QQ"、"手机号" + 数字组合
  /// - 东南亚用户：重点检测 Line ID、WhatsApp、Telegram 缩写
  /// - 日韩用户：重点检测 Line、KakaoTalk（카카오、カカオ）
  /// - 欧美用户：重点检测 WhatsApp、Telegram、Snapchat、Discord、Instagram
  static List<String> _getRegionKeywords(String? countryCode, String? language) {
    final code = countryCode?.toUpperCase() ?? '';
    final lang = language?.toLowerCase() ?? '';

    // 中国用户
    if (code == 'CN' || lang == 'zh') {
      return _chinaKeywords;
    }
    // 日本用户
    if (code == 'JP' || lang == 'ja') {
      return _jpKrKeywords;
    }
    // 韩国用户
    if (code == 'KR' || lang == 'ko') {
      return _jpKrKeywords;
    }
    // 东南亚用户
    if (['TH', 'VN', 'ID', 'MY', 'PH', 'SG'].contains(code)) {
      return _seaKeywords;
    }
    // 欧美用户（默认）
    return _westernKeywords;
  }

  /// 判断是否为无害域名（避免误判）
  static bool _isHarmlessDomain(String domain) {
    // 排除一些常见误判后缀
    const harmlessSuffixes = [
      '.0.0', '.0', // 版本号
    ];
    for (final suffix in harmlessSuffixes) {
      if (domain.endsWith(suffix)) return true;
    }
    return false;
  }

  // ==================== 综合安全检测 ====================

  /// 综合检测：敏感词 + 联系方式
  ///
  /// 一次性检测文本中的敏感词和联系方式，返回综合结果。
  /// 用于扔瓶子和发送消息前的统一校验。
  ///
  /// [text] 待检测文本
  /// [countryCode] 用户国家代码（用于地区化规则）
  /// [language] 用户语言（用于地区化规则和提示文案）
  static TextSafetyResult checkTextSafety({
    required String text,
    String? countryCode,
    String? language,
  }) {
    final sensitiveWords = detectSensitiveWords(text);
    final contactInfo = detectContactInfo(
      text: text,
      countryCode: countryCode,
      language: language,
    );

    return TextSafetyResult(
      isSafe: sensitiveWords.isEmpty && !contactInfo.hasContactInfo,
      sensitiveWords: sensitiveWords,
      contactInfo: contactInfo,
    );
  }
}
