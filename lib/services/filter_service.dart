/// 内容过滤服务
/// 提供敏感词过滤、文本安全检测功能
library;

/// 内容过滤服务类
class FilterService {
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
}
