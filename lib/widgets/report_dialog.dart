/// 举报对话框组件
/// 提供举报类型选择和详细描述填写
///
/// 对应需求文档 4. V1.2 举报系统
library;

import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../services/report_service.dart';

/// 举报选择结果
class _ReportSelection {
  final String type;
  final String reason;

  const _ReportSelection({required this.type, required this.reason});
}

/// 显示举报对话框并提交举报
///
/// [context] BuildContext
/// [reporterId] 举报人用户ID
/// [reportedId] 被举报人用户ID（可为空）
/// [targetType] 举报对象类型（参考 ReportTargetType 常量）
/// [targetId] 举报对象ID
/// [targetDescription] 举报对象描述（如对方昵称或消息摘要）
///
/// 返回是否举报成功（false 表示用户取消或提交失败）
Future<bool> showReportDialogAndSubmit({
  required BuildContext context,
  required String reporterId,
  required String? reportedId,
  required String targetType,
  required String? targetId,
  required String targetDescription,
}) async {
  // 先显示对话框，获取用户选择
  final result = await showDialog<_ReportSelection>(
    context: context,
    builder: (context) => _ReportDialog(
      targetDescription: targetDescription,
    ),
  );

  // 用户取消
  if (result == null) return false;

  // 提交举报
  final reportService = ReportService();
  final success = await reportService.createReport(
    reporterId: reporterId,
    reportedId: reportedId,
    reportType: result.type,
    targetType: targetType,
    targetId: targetId,
    reason: result.reason,
  );

  return success;
}

/// 举报对话框内部实现
class _ReportDialog extends StatefulWidget {
  final String targetDescription;

  const _ReportDialog({required this.targetDescription});

  @override
  State<_ReportDialog> createState() => _ReportDialogState();
}

class _ReportDialogState extends State<_ReportDialog> {
  String _selectedType = ReportType.harassment;
  final TextEditingController _reasonController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _isSubmitting = true);

    if (mounted) {
      Navigator.pop(
        context,
        _ReportSelection(
          type: _selectedType,
          reason: _reasonController.text.trim(),
        ),
      );
    }
  }

  Widget _buildTypeOption(String code, String label) {
    final isSelected = _selectedType == code;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () {
          setState(() => _selectedType = code);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? secondaryColor.withValues(alpha: 0.15)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? secondaryColor : cardBorderColor,
            ),
          ),
          child: Row(
            children: [
              Icon(
                isSelected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_off,
                color: isSelected ? secondaryColor : textHint,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: isSelected ? textPrimary : textSecondary,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Row(
        children: [
          const Icon(Icons.flag_outlined, color: Colors.redAccent, size: 24),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '举报',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 举报对象提示
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: darkColor.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '举报对象：${widget.targetDescription}',
                style: const TextStyle(
                  color: textSecondary,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 举报类型选择标题
            const Text(
              '选择举报原因',
              style: TextStyle(
                color: textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            // 类型选项列表
            ...ReportType.all.map(
              (type) => _buildTypeOption(type['code']!, type['label']!),
            ),

            const SizedBox(height: 16),
            // 详细描述输入框
            const Text(
              '补充说明（可选）',
              style: TextStyle(
                color: textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: darkColor.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: cardBorderColor),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: TextField(
                controller: _reasonController,
                maxLines: 4,
                maxLength: 200,
                style: const TextStyle(color: textPrimary, fontSize: 14),
                decoration: const InputDecoration(
                  hintText: '请描述违规行为...',
                  hintStyle: TextStyle(color: textHint, fontSize: 14),
                  border: InputBorder.none,
                  counterStyle: TextStyle(color: textHint, fontSize: 11),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSubmitting ? null : () => Navigator.pop(context),
          child: const Text('取消'),
        ),
        ElevatedButton(
          onPressed: _isSubmitting ? null : _submit,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent,
            foregroundColor: Colors.white,
          ),
          child: _isSubmitting
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : const Text('提交举报'),
        ),
      ],
    );
  }
}
