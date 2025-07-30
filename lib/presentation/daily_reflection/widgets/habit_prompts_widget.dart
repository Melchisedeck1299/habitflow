import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class HabitPromptsWidget extends StatelessWidget {
  final List<Map<String, dynamic>> habitPrompts;
  final Function(String) onPromptTap;

  const HabitPromptsWidget({
    Key? key,
    required this.habitPrompts,
    required this.onPromptTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (habitPrompts.isEmpty) {
      return SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'lightbulb_outline',
                color: AppTheme.getWarningColor(true),
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                'Suggestions de réflexion',
                style: AppTheme.lightTheme.textTheme.titleMedium,
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            'Basées sur vos habitudes d\'aujourd\'hui',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 2.h),
          ...habitPrompts.map((habit) => _buildHabitPromptCard(habit)).toList(),
        ],
      ),
    );
  }

  Widget _buildHabitPromptCard(Map<String, dynamic> habit) {
    final isCompleted = habit['completed'] as bool;

    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: isCompleted
            ? AppTheme.getSuccessColor(true).withValues(alpha: 0.1)
            : AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isCompleted
              ? AppTheme.getSuccessColor(true).withValues(alpha: 0.3)
              : AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(1.5.w),
                decoration: BoxDecoration(
                  color: isCompleted
                      ? AppTheme.getSuccessColor(true)
                      : AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                ),
                child: CustomIconWidget(
                  iconName: isCompleted ? 'check' : 'schedule',
                  color: isCompleted
                      ? Colors.white
                      : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 16,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      habit['habitName'] as String,
                      style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                        color: isCompleted
                            ? AppTheme.getSuccessColor(true)
                            : AppTheme.lightTheme.colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      isCompleted ? 'Terminé' : 'En attente',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: isCompleted
                            ? AppTheme.getSuccessColor(true)
                            : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            habit['prompt'] as String,
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
          SizedBox(height: 2.h),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () => onPromptTap(habit['prompt'] as String),
              icon: CustomIconWidget(
                iconName: 'add',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 16,
              ),
              label: Text('Ajouter'),
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
