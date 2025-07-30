import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class HabitCardWidget extends StatefulWidget {
  final Map<String, dynamic> habit;
  final VoidCallback onToggleCompletion;
  final VoidCallback onLongPress;

  const HabitCardWidget({
    super.key,
    required this.habit,
    required this.onToggleCompletion,
    required this.onLongPress,
  });

  @override
  State<HabitCardWidget> createState() => _HabitCardWidgetState();
}

class _HabitCardWidgetState extends State<HabitCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    setState(() {
      _isPressed = true;
    });
    _animationController.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() {
      _isPressed = false;
    });
    _animationController.reverse();
  }

  void _handleTapCancel() {
    setState(() {
      _isPressed = false;
    });
    _animationController.reverse();
  }

  String _getTimeRemaining() {
    final targetTime = widget.habit['targetTime'] as String;
    if (targetTime == 'Toute la journée') return targetTime;

    try {
      final parts = targetTime.split(':');
      final targetHour = int.parse(parts[0]);
      final targetMinute = int.parse(parts[1]);

      final now = DateTime.now();
      final target =
          DateTime(now.year, now.month, now.day, targetHour, targetMinute);

      if (target.isBefore(now)) {
        return 'Temps écoulé';
      }

      final difference = target.difference(now);
      final hours = difference.inHours;
      final minutes = difference.inMinutes % 60;

      if (hours > 0) {
        return 'Dans ${hours}h ${minutes}min';
      } else {
        return 'Dans ${minutes}min';
      }
    } catch (e) {
      return targetTime;
    }
  }

  Color _getProgressColor() {
    final progress = widget.habit['progress'] as double;
    if (progress >= 1.0) {
      return AppTheme.getSuccessColor(true);
    } else if (progress >= 0.5) {
      return AppTheme.getWarningColor(true);
    } else {
      return AppTheme.lightTheme.colorScheme.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final habit = widget.habit;
    final isCompleted = habit['isCompleted'] as bool;
    final streak = habit['streak'] as int;
    final progress = habit['progress'] as double;
    final name = habit['name'] as String;
    final description = habit['description'] as String;
    final category = habit['category'] as String;
    final iconName = habit['icon'] as String;

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: _handleTapDown,
            onTapUp: _handleTapUp,
            onTapCancel: _handleTapCancel,
            onLongPress: () {
              HapticFeedback.mediumImpact();
              widget.onLongPress();
            },
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: isCompleted
                    ? AppTheme.getSuccessColor(true).withValues(alpha: 0.05)
                    : AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isCompleted
                      ? AppTheme.getSuccessColor(true).withValues(alpha: 0.3)
                      : AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.2),
                  width: isCompleted ? 2 : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: _isPressed
                        ? AppTheme.lightTheme.colorScheme.shadow
                            .withValues(alpha: 0.2)
                        : AppTheme.lightTheme.colorScheme.shadow,
                    blurRadius: _isPressed ? 8 : 12,
                    offset: Offset(0, _isPressed ? 2 : 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Row
                  Row(
                    children: [
                      // Icon and Category
                      Container(
                        padding: EdgeInsets.all(2.5.w),
                        decoration: BoxDecoration(
                          color: _getProgressColor().withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: CustomIconWidget(
                          iconName: iconName,
                          color: _getProgressColor(),
                          size: 24,
                        ),
                      ),
                      SizedBox(width: 3.w),

                      // Habit Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    decoration: isCompleted
                                        ? TextDecoration.lineThrough
                                        : null,
                                    color: isCompleted
                                        ? AppTheme.lightTheme.colorScheme
                                            .onSurfaceVariant
                                        : AppTheme
                                            .lightTheme.colorScheme.onSurface,
                                  ),
                            ),
                            SizedBox(height: 0.5.h),
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 2.w, vertical: 0.5.h),
                                  decoration: BoxDecoration(
                                    color: AppTheme
                                        .lightTheme.colorScheme.secondary
                                        .withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    category,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                          color: AppTheme
                                              .lightTheme.colorScheme.secondary,
                                          fontWeight: FontWeight.w500,
                                        ),
                                  ),
                                ),
                                SizedBox(width: 2.w),
                                CustomIconWidget(
                                  iconName: 'access_time',
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                                  size: 12,
                                ),
                                SizedBox(width: 1.w),
                                Text(
                                  _getTimeRemaining(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: AppTheme.lightTheme.colorScheme
                                            .onSurfaceVariant,
                                      ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Streak Counter
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 3.w, vertical: 1.h),
                        decoration: BoxDecoration(
                          color: AppTheme.getSuccessColor(true)
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomIconWidget(
                              iconName: 'local_fire_department',
                              color: AppTheme.getSuccessColor(true),
                              size: 16,
                            ),
                            SizedBox(width: 1.w),
                            Text(
                              '$streak',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.getSuccessColor(true),
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 2.h),

                  // Description
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  SizedBox(height: 3.h),

                  // Progress and Check Button Row
                  Row(
                    children: [
                      // Progress Circle
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Progrès',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                                Text(
                                  '${(progress * 100).toInt()}%',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: _getProgressColor(),
                                      ),
                                ),
                              ],
                            ),
                            SizedBox(height: 1.h),
                            LinearProgressIndicator(
                              value: progress,
                              backgroundColor:
                                  _getProgressColor().withValues(alpha: 0.2),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  _getProgressColor()),
                              minHeight: 6,
                            ),
                          ],
                        ),
                      ),

                      SizedBox(width: 4.w),

                      // Check Button
                      GestureDetector(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          widget.onToggleCompletion();
                        },
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 200),
                          width: 15.w,
                          height: 15.w,
                          decoration: BoxDecoration(
                            color: isCompleted
                                ? AppTheme.getSuccessColor(true)
                                : AppTheme.lightTheme.colorScheme.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isCompleted
                                  ? AppTheme.getSuccessColor(true)
                                  : AppTheme.lightTheme.colorScheme.outline,
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: isCompleted
                                    ? AppTheme.getSuccessColor(true)
                                        .withValues(alpha: 0.3)
                                    : AppTheme.lightTheme.colorScheme.shadow,
                                blurRadius: 8,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Center(
                            child: AnimatedSwitcher(
                              duration: Duration(milliseconds: 200),
                              child: isCompleted
                                  ? CustomIconWidget(
                                      key: ValueKey('completed'),
                                      iconName: 'check',
                                      color: Colors.white,
                                      size: 24,
                                    )
                                  : CustomIconWidget(
                                      key: ValueKey('incomplete'),
                                      iconName: 'radio_button_unchecked',
                                      color: AppTheme.lightTheme.colorScheme
                                          .onSurfaceVariant,
                                      size: 24,
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  if (isCompleted && habit['completedAt'] != null) ...[
                    SizedBox(height: 2.h),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        color: AppTheme.getSuccessColor(true)
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'check_circle',
                            color: AppTheme.getSuccessColor(true),
                            size: 16,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            'Terminé à ${_formatCompletionTime(habit['completedAt'] as DateTime)}',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppTheme.getSuccessColor(true),
                                      fontWeight: FontWeight.w500,
                                    ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _formatCompletionTime(DateTime completedAt) {
    final now = DateTime.now();
    final difference = now.difference(completedAt);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}min';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h${difference.inMinutes % 60}min';
    } else {
      return '${completedAt.hour.toString().padLeft(2, '0')}:${completedAt.minute.toString().padLeft(2, '0')}';
    }
  }
}
