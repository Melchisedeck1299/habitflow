import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DailyProgressWidget extends StatelessWidget {
  final int completedHabits;
  final int totalHabits;
  final List<Map<String, dynamic>> todayHabits;

  const DailyProgressWidget({
    super.key,
    required this.completedHabits,
    required this.totalHabits,
    required this.todayHabits,
  });

  double get progressPercentage {
    if (totalHabits == 0) return 0.0;
    return completedHabits / totalHabits;
  }

  int get totalStreak {
    return (todayHabits as List)
        .fold(0, (sum, habit) => sum + (habit['streak'] as int));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(4.w),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'today',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Text(
                'Progrès du jour',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
          SizedBox(height: 3.h),

          // Progress Circle and Stats
          Row(
            children: [
              // Circular Progress
              Expanded(
                flex: 2,
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 25.w,
                        height: 25.w,
                        child: CircularProgressIndicator(
                          value: progressPercentage,
                          strokeWidth: 8,
                          backgroundColor: AppTheme
                              .lightTheme.colorScheme.primary
                              .withValues(alpha: 0.2),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppTheme.lightTheme.colorScheme.primary,
                          ),
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '$completedHabits',
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color:
                                      AppTheme.lightTheme.colorScheme.primary,
                                ),
                          ),
                          Text(
                            'sur $totalHabits',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppTheme.lightTheme.colorScheme
                                          .onSurfaceVariant,
                                    ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Stats
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    _buildStatItem(
                      context,
                      'local_fire_department',
                      'Séries totales',
                      '$totalStreak',
                      AppTheme.getSuccessColor(true),
                    ),
                    SizedBox(height: 2.h),
                    _buildStatItem(
                      context,
                      'percent',
                      'Taux de réussite',
                      '${(progressPercentage * 100).toInt()}%',
                      AppTheme.lightTheme.colorScheme.secondary,
                    ),
                    SizedBox(height: 2.h),
                    _buildStatItem(
                      context,
                      'trending_up',
                      'Habitudes actives',
                      '$totalHabits',
                      AppTheme.getAccentColor(true),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Progress Bar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Progression quotidienne',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  Text(
                    '${(progressPercentage * 100).toInt()}%',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppTheme.lightTheme.colorScheme.primary,
                        ),
                  ),
                ],
              ),
              SizedBox(height: 1.h),
              LinearProgressIndicator(
                value: progressPercentage,
                backgroundColor: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.2),
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppTheme.lightTheme.colorScheme.primary,
                ),
                minHeight: 8,
              ),
            ],
          ),

          if (completedHabits == totalHabits && totalHabits > 0) ...[
            SizedBox(height: 2.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.getSuccessColor(true).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.getSuccessColor(true).withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'celebration',
                    color: AppTheme.getSuccessColor(true),
                    size: 20,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Text(
                      'Félicitations ! Toutes vos habitudes sont terminées !',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.getSuccessColor(true),
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String iconName,
    String label,
    String value,
    Color color,
  ) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(2.w),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: CustomIconWidget(
            iconName: iconName,
            color: color,
            size: 16,
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
              ),
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
