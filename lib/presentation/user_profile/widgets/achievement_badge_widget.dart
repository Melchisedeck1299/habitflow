import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AchievementBadgeWidget extends StatelessWidget {
  final Map<String, dynamic> achievement;

  const AchievementBadgeWidget({
    super.key,
    required this.achievement,
  });

  @override
  Widget build(BuildContext context) {
    final bool isEarned = achievement["earned"] as bool;
    final double? progress = achievement["progress"] as double?;

    return GestureDetector(
      onTap: () => _showAchievementDetails(context),
      child: Container(
        width: 20.w,
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(4.w),
          border: Border.all(
            color: isEarned
                ? AppTheme.getSuccessColor(true)
                : Theme.of(context).dividerColor,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Badge Icon
            Stack(
              alignment: Alignment.center,
              children: [
                if (!isEarned && progress != null)
                  SizedBox(
                    width: 12.w,
                    height: 12.w,
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 2,
                      backgroundColor: Theme.of(context).dividerColor,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppTheme.lightTheme.primaryColor,
                      ),
                    ),
                  ),
                Container(
                  width: 10.w,
                  height: 10.w,
                  decoration: BoxDecoration(
                    color: isEarned
                        ? AppTheme.getSuccessColor(true).withValues(alpha: 0.1)
                        : Theme.of(context).colorScheme.surface,
                    shape: BoxShape.circle,
                  ),
                  child: CustomIconWidget(
                    iconName: achievement["icon"] as String,
                    color: isEarned
                        ? AppTheme.getSuccessColor(true)
                        : Theme.of(context).colorScheme.onSurfaceVariant,
                    size: 5.w,
                  ),
                ),
              ],
            ),

            SizedBox(height: 1.h),

            // Badge Name
            Text(
              achievement["name"] as String,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isEarned
                        ? Theme.of(context).colorScheme.onSurface
                        : Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            // Progress indicator for unearned badges
            if (!isEarned && progress != null) ...[
              SizedBox(height: 0.5.h),
              Text(
                '${(progress * 100).toInt()}%',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showAchievementDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final bool isEarned = achievement["earned"] as bool;
        final double? progress = achievement["progress"] as double?;

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.w),
          ),
          title: Row(
            children: [
              Container(
                width: 12.w,
                height: 12.w,
                decoration: BoxDecoration(
                  color: isEarned
                      ? AppTheme.getSuccessColor(true).withValues(alpha: 0.1)
                      : Theme.of(context).colorScheme.surface,
                  shape: BoxShape.circle,
                ),
                child: CustomIconWidget(
                  iconName: achievement["icon"] as String,
                  color: isEarned
                      ? AppTheme.getSuccessColor(true)
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                  size: 6.w,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Text(
                  achievement["name"] as String,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                achievement["description"] as String,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(height: 2.h),
              if (isEarned) ...[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color:
                        AppTheme.getSuccessColor(true).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(2.w),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomIconWidget(
                        iconName: 'check_circle',
                        color: AppTheme.getSuccessColor(true),
                        size: 4.w,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'Obtenu le ${_formatDate(achievement["earnedDate"] as String)}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.getSuccessColor(true),
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ],
                  ),
                ),
              ] else if (progress != null) ...[
                Text(
                  'Progression',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
                SizedBox(height: 1.h),
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Theme.of(context).dividerColor,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppTheme.lightTheme.primaryColor,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  '${(progress * 100).toInt()}% complété',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.primaryColor,
                      ),
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Fermer'),
            ),
          ],
        );
      },
    );
  }

  String _formatDate(String dateString) {
    final date = DateTime.parse(dateString);
    return "${date.day}/${date.month}/${date.year}";
  }
}
