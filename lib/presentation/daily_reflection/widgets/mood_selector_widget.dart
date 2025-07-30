import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class MoodSelectorWidget extends StatelessWidget {
  final String selectedMood;
  final Function(String) onMoodSelected;

  const MoodSelectorWidget({
    Key? key,
    required this.selectedMood,
    required this.onMoodSelected,
  }) : super(key: key);

  final List<Map<String, String>> _moods = const [
    {'emoji': '😊', 'label': 'Heureux'},
    {'emoji': '😌', 'label': 'Calme'},
    {'emoji': '😔', 'label': 'Triste'},
    {'emoji': '😤', 'label': 'Frustré'},
    {'emoji': '😴', 'label': 'Fatigué'},
    {'emoji': '🤔', 'label': 'Pensif'},
    {'emoji': '😍', 'label': 'Motivé'},
    {'emoji': '😰', 'label': 'Stressé'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Comment vous sentez-vous aujourd\'hui?',
            style: AppTheme.lightTheme.textTheme.titleMedium,
          ),
          SizedBox(height: 2.h),
          Wrap(
            spacing: 3.w,
            runSpacing: 1.h,
            children: _moods.map((mood) {
              final isSelected = selectedMood == mood['emoji'];
              return GestureDetector(
                onTap: () => onMoodSelected(mood['emoji']!),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 3.w,
                    vertical: 1.h,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppTheme.lightTheme.colorScheme.primaryContainer
                        : AppTheme.lightTheme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? AppTheme.lightTheme.colorScheme.primary
                          : AppTheme.lightTheme.colorScheme.outline
                              .withValues(alpha: 0.3),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        mood['emoji']!,
                        style: TextStyle(fontSize: 20.sp),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        mood['label']!,
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: isSelected
                              ? AppTheme.lightTheme.colorScheme.primary
                              : AppTheme.lightTheme.colorScheme.onSurface,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
