import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ActiveChallengeWidget extends StatelessWidget {
  final Map<String, dynamic> challenge;
  final VoidCallback onCheckIn;

  const ActiveChallengeWidget({
    Key? key,
    required this.challenge,
    required this.onCheckIn,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.shadowColor,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with title and rank
          Row(
            children: [
              Expanded(
                child: Text(
                  challenge['title'],
                  style: AppTheme.lightTheme.textTheme.titleMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomIconWidget(
                      iconName: 'emoji_events',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 16,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      '#${challenge['rank']}',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Progress section
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Progression',
                      style: AppTheme.lightTheme.textTheme.bodySmall,
                    ),
                    SizedBox(height: 0.5.h),
                    LinearProgressIndicator(
                      value: challenge['progress'],
                      backgroundColor: AppTheme.lightTheme.colorScheme.primary
                          .withValues(alpha: 0.2),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppTheme.lightTheme.colorScheme.primary,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      '${challenge['currentStreak']}/${challenge['totalDays']} jours',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(width: 4.w),

              // Streak indicator
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: AppTheme.getSuccessColor(true).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    CustomIconWidget(
                      iconName: 'local_fire_department',
                      color: AppTheme.getSuccessColor(true),
                      size: 24,
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      '${challenge['currentStreak']}',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        color: AppTheme.getSuccessColor(true),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'jours',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.getSuccessColor(true),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Stats row
          Row(
            children: [
              _buildStatItem(
                'Rang',
                '${challenge['rank']}/${challenge['totalParticipants']}',
                'leaderboard',
              ),
              SizedBox(width: 4.w),
              _buildStatItem(
                'Prochain check-in',
                challenge['nextCheckIn'],
                'schedule',
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Check-in button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: challenge['canCheckIn'] ? onCheckIn : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: challenge['canCheckIn']
                    ? AppTheme.getSuccessColor(true)
                    : AppTheme.lightTheme.colorScheme.outline,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 1.5.h),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName:
                        challenge['canCheckIn'] ? 'check_circle' : 'schedule',
                    color: Colors.white,
                    size: 20,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    challenge['canCheckIn']
                        ? 'Faire le check-in'
                        : 'Check-in effectué',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, String iconName) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CustomIconWidget(
                  iconName: iconName,
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 16,
                ),
                SizedBox(width: 2.w),
                Text(
                  label,
                  style: AppTheme.lightTheme.textTheme.bodySmall,
                ),
              ],
            ),
            SizedBox(height: 0.5.h),
            Text(
              value,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
