import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ChallengeFilterWidget extends StatelessWidget {
  final String selectedFilter;
  final List<String> filterOptions;
  final Function(String) onFilterChanged;

  const ChallengeFilterWidget({
    Key? key,
    required this.selectedFilter,
    required this.filterOptions,
    required this.onFilterChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: EdgeInsets.all(4.w),
        constraints: BoxConstraints(
          maxHeight: 60.h,
          maxWidth: 80.w,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'filter_list',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 24,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Filtrer les défis',
                  style: AppTheme.lightTheme.textTheme.titleLarge,
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: CustomIconWidget(
                    iconName: 'close',
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    size: 24,
                  ),
                ),
              ],
            ),

            SizedBox(height: 2.h),

            Text(
              'Catégories',
              style: AppTheme.lightTheme.textTheme.titleMedium,
            ),

            SizedBox(height: 1.h),

            // Filter options
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: filterOptions.length,
                itemBuilder: (context, index) {
                  final option = filterOptions[index];
                  final isSelected = option == selectedFilter;

                  return Container(
                    margin: EdgeInsets.only(bottom: 1.h),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          onFilterChanged(option);
                          Navigator.pop(context);
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 4.w,
                            vertical: 1.5.h,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppTheme.lightTheme.colorScheme.primary
                                    .withValues(alpha: 0.1)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? AppTheme.lightTheme.colorScheme.primary
                                  : AppTheme.lightTheme.colorScheme.outline,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              CustomIconWidget(
                                iconName: _getCategoryIcon(option),
                                color: isSelected
                                    ? AppTheme.lightTheme.colorScheme.primary
                                    : AppTheme.lightTheme.colorScheme.onSurface,
                                size: 20,
                              ),
                              SizedBox(width: 3.w),
                              Expanded(
                                child: Text(
                                  option,
                                  style: AppTheme
                                      .lightTheme.textTheme.bodyMedium
                                      ?.copyWith(
                                    color: isSelected
                                        ? AppTheme
                                            .lightTheme.colorScheme.primary
                                        : AppTheme
                                            .lightTheme.colorScheme.onSurface,
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                  ),
                                ),
                              ),
                              if (isSelected)
                                CustomIconWidget(
                                  iconName: 'check',
                                  color:
                                      AppTheme.lightTheme.colorScheme.primary,
                                  size: 20,
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: 2.h),

            // Reset button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  onFilterChanged('Tous');
                  Navigator.pop(context);
                },
                child: const Text('Réinitialiser les filtres'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getCategoryIcon(String category) {
    switch (category) {
      case 'Tous':
        return 'apps';
      case 'Bien-être':
        return 'spa';
      case 'Fitness':
        return 'fitness_center';
      case 'Nutrition':
        return 'restaurant';
      case 'Productivité':
        return 'trending_up';
      case 'Éducation':
        return 'school';
      case 'Santé':
        return 'favorite';
      default:
        return 'category';
    }
  }
}
