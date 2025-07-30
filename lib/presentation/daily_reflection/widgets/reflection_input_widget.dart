import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ReflectionInputWidget extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final int characterCount;
  final int maxCharacters;

  const ReflectionInputWidget({
    Key? key,
    required this.controller,
    required this.focusNode,
    required this.characterCount,
    required this.maxCharacters,
  }) : super(key: key);

  @override
  State<ReflectionInputWidget> createState() => _ReflectionInputWidgetState();
}

class _ReflectionInputWidgetState extends State<ReflectionInputWidget> {
  bool _isBold = false;
  bool _isItalic = false;
  bool _isBulletList = false;

  final List<String> _reflectionPrompts = [
    'Comment s\'est passée votre journée?',
    'Quels défis avez-vous rencontrés?',
    'Qu\'avez-vous appris aujourd\'hui?',
    'De quoi êtes-vous reconnaissant?',
    'Comment pouvez-vous améliorer demain?',
  ];

  void _insertBulletPoint() {
    final text = widget.controller.text;
    final selection = widget.controller.selection;
    final newText = text.replaceRange(
      selection.start,
      selection.end,
      '• ',
    );
    widget.controller.text = newText;
    widget.controller.selection = TextSelection.collapsed(
      offset: selection.start + 2,
    );
  }

  void _insertPrompt(String prompt) {
    final text = widget.controller.text;
    final selection = widget.controller.selection;
    final newText = text.replaceRange(
      selection.start,
      selection.end,
      '$prompt\n\n',
    );
    widget.controller.text = newText;
    widget.controller.selection = TextSelection.collapsed(
      offset: selection.start + prompt.length + 2,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isNearLimit = widget.characterCount > (widget.maxCharacters * 0.8);
    final isOverLimit = widget.characterCount > widget.maxCharacters;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: widget.focusNode.hasFocus
              ? AppTheme.lightTheme.colorScheme.primary
              : AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
          width: widget.focusNode.hasFocus ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Formatting toolbar
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface
                  .withValues(alpha: 0.5),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              border: Border(
                bottom: BorderSide(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.2),
                ),
              ),
            ),
            child: Row(
              children: [
                _buildFormatButton(
                  icon: 'format_bold',
                  isActive: _isBold,
                  onTap: () => setState(() => _isBold = !_isBold),
                ),
                SizedBox(width: 2.w),
                _buildFormatButton(
                  icon: 'format_italic',
                  isActive: _isItalic,
                  onTap: () => setState(() => _isItalic = !_isItalic),
                ),
                SizedBox(width: 2.w),
                _buildFormatButton(
                  icon: 'format_list_bulleted',
                  isActive: _isBulletList,
                  onTap: _insertBulletPoint,
                ),
                Spacer(),
                PopupMenuButton<String>(
                  icon: CustomIconWidget(
                    iconName: 'help_outline',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 20,
                  ),
                  onSelected: _insertPrompt,
                  itemBuilder: (context) => _reflectionPrompts
                      .map((prompt) => PopupMenuItem<String>(
                            value: prompt,
                            child: Text(
                              prompt,
                              style: AppTheme.lightTheme.textTheme.bodyMedium,
                            ),
                          ))
                      .toList(),
                ),
              ],
            ),
          ),

          // Text input area
          Padding(
            padding: EdgeInsets.all(4.w),
            child: TextField(
              controller: widget.controller,
              focusNode: widget.focusNode,
              maxLines: null,
              minLines: 8,
              maxLength: widget.maxCharacters,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: _isBold ? FontWeight.bold : FontWeight.normal,
                fontStyle: _isItalic ? FontStyle.italic : FontStyle.normal,
              ),
              decoration: InputDecoration(
                hintText: 'Commencez à écrire votre réflexion...',
                hintStyle: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                      .withValues(alpha: 0.6),
                ),
                border: InputBorder.none,
                counterText: '',
              ),
            ),
          ),

          // Character counter
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tapez pour commencer votre réflexion',
                  style: AppTheme.lightTheme.textTheme.bodySmall,
                ),
                Text(
                  '${widget.characterCount}/${widget.maxCharacters}',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: isOverLimit
                        ? AppTheme.lightTheme.colorScheme.error
                        : isNearLimit
                            ? AppTheme.getWarningColor(true)
                            : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    fontWeight:
                        isNearLimit ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormatButton({
    required String icon,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(2.w),
        decoration: BoxDecoration(
          color: isActive
              ? AppTheme.lightTheme.colorScheme.primaryContainer
              : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: CustomIconWidget(
          iconName: icon,
          color: isActive
              ? AppTheme.lightTheme.colorScheme.primary
              : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          size: 20,
        ),
      ),
    );
  }
}
