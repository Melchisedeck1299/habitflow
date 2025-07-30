import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class HabitPreviewWidget extends StatelessWidget {
  final String habitName;
  final String category;
  final TimeOfDay time;
  final bool isStreakBased;
  final int targetQuantity;
  final String quantityUnit;
  final Color selectedColor;
  final List<Map<String, dynamic>> categories;

  const HabitPreviewWidget({
    Key? key,
    required this.habitName,
    required this.category,
    required this.time,
    required this.isStreakBased,
    required this.targetQuantity,
    required this.quantityUnit,
    required this.selectedColor,
    required this.categories,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final categoryData = categories.firstWhere(
      (cat) => cat['name'] == category,
      orElse: () => {'name': category, 'icon': 'star', 'color': selectedColor},
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Aperçu',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        SizedBox(height: 1.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selectedColor.withValues(alpha: 0.3),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: selectedColor.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with category and time
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: selectedColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: CustomIconWidget(
                      iconName: categoryData['icon'],
                      color: selectedColor,
                      size: 20,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          category,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: selectedColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                        Text(
                          _formatTime(time),
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withValues(alpha: 0.7),
                                  ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Theme.of(context)
                            .colorScheme
                            .outline
                            .withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomIconWidget(
                          iconName: isStreakBased
                              ? 'local_fire_department'
                              : 'trending_up',
                          color: selectedColor,
                          size: 16,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          isStreakBased ? '0' : '$targetQuantity',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: selectedColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 2.h),

              // Habit name
              Text(
                habitName,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),

              SizedBox(height: 1.h),

              // Goal description
              Text(
                isStreakBased
                    ? 'Objectif: Maintenir une série quotidienne'
                    : 'Objectif: $targetQuantity $quantityUnit par jour',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.7),
                    ),
              ),

              SizedBox(height: 2.h),

              // Action button preview
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 1.5.h),
                decoration: BoxDecoration(
                  color: selectedColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconWidget(
                      iconName: 'check_circle',
                      color: Colors.white,
                      size: 20,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Marquer comme terminé',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
