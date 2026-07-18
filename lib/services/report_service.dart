/// 举报服务
/// 负责创建举报记录到Supabase的reports表
///
/// 对应需求文档 4. V1.2 举报系统 和 6.3 全球法规合规的举报入口要求
library;

import 'supabase_service.dart';

/// 举报类型常量
class ReportType {
  /// 骚扰/辱骂
  static const String harassment = 'harassment';

  /// 色情低俗
  static const String sexual = 'sexual';

  /// 诈骗/导流
  static const String scam = 'scam';

  /// 暴力威胁
  static const String violence = 'violence';

  /// 其他
  static const String other = 'other';

  /// 所有举报类型列表（按顺序展示）
  static const List<Map<String, String>> all = [
    {'code': harassment, 'label': '骚扰 / 辱骂'},
    {'code': sexual, 'label': '色情低俗内容'},
    {'code': scam, 'label': '诈骗 / 导流信息'},
    {'code': violence, 'label': '暴力 / 威胁'},
    {'code': other, 'label': '其他'},
  ];

  /// 根据代码获取标签
  static String getLabel(String code) {
    for (final item in all) {
      if (item['code'] == code) return item['label']!;
    }
    return '未知';
  }
}

/// 举报对象类型常量
class ReportTargetType {
  /// 消息
  static const String message = 'message';

  /// 对话
  static const String conversation = 'conversation';

  /// 瓶子
  static const String bottle = 'bottle';

  /// 用户
  static const String user = 'user';
}

/// 举报服务类
class ReportService {
  /// 提交举报
  ///
  /// [reporterId] 举报人用户ID
  /// [reportedId] 被举报人用户ID（可为空）
  /// [reportType] 举报类型（参考 ReportType 常量）
  /// [targetType] 举报对象类型（参考 ReportTargetType 常量）
  /// [targetId] 举报对象ID（消息/对话/瓶子/用户ID）
  /// [reason] 详细描述（可选）
  ///
  /// 返回是否提交成功
  Future<bool> createReport({
    required String reporterId,
    String? reportedId,
    required String reportType,
    required String targetType,
    String? targetId,
    String? reason,
  }) async {
    final client = SupabaseService.instance.client;

    try {
      await client.from('reports').insert({
        'reporter_id': reporterId,
        'reported_id': reportedId,
        'report_type': reportType,
        'target_type': targetType,
        'target_id': targetId,
        'reason': reason?.trim().isNotEmpty == true ? reason!.trim() : null,
        'status': 'pending',
      });

      return true;
    } catch (e) {
      return false;
    }
  }

  /// 检查用户是否已对某个对象提交过举报
  /// 用于避免重复举报
  ///
  /// [reporterId] 举报人用户ID
  /// [targetType] 举报对象类型
  /// [targetId] 举报对象ID
  Future<bool> hasReported({
    required String reporterId,
    required String targetType,
    required String targetId,
  }) async {
    final client = SupabaseService.instance.client;

    try {
      final response = await client
          .from('reports')
          .select('id')
          .eq('reporter_id', reporterId)
          .eq('target_type', targetType)
          .eq('target_id', targetId)
          .limit(1);

      return (response as List).isNotEmpty;
    } catch (e) {
      return false;
    }
  }
}
