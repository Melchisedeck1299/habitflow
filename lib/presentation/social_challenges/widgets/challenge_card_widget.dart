import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ChallengeCardWidget extends StatelessWidget {
  final Map<String, dynamic> challenge;
  final VoidCallback onTap;
  final VoidCallback onJoin;

  const ChallengeCardWidget({
    Key? key,
    required this.challenge,
    required this.onTap,
    required this.onJoin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.shadowColor,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                // Challenge image
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CustomImageWidget(
                    imageUrl: challenge['image'],
                    width: 20.w,
                    height: 20.w,
                    fit: BoxFit.cover,
                  ),
                ),

                SizedBox(width: 4.w),

                // Challenge info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        challenge['title'],
                        style: AppTheme.lightTheme.textTheme.titleMedium,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      SizedBox(height: 1.h),

                      Text(
                        challenge['description'],
                        style: AppTheme.lightTheme.textTheme.bodySmall,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      SizedBox(height: 1.h),

                      // Challenge stats
                      Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'group',
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 16,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            '${challenge['participants']}',
                            style: AppTheme.lightTheme.textTheme.bodySmall,
                          ),
                          SizedBox(width: 4.w),
                          CustomIconWidget(
                            iconName: 'schedule',
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 16,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            challenge['duration'],
                            style: AppTheme.lightTheme.textTheme.bodySmall,
                          ),
                        ],
                      ),

                      SizedBox(height: 1.h),

                      // Progress bar
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
                        '${(challenge['progress'] * 100).toInt()}% complété',
                        style: AppTheme.lightTheme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),

                SizedBox(width: 2.w),

                // Join button
                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 2.w, vertical: 0.5.h),
                      decoration: BoxDecoration(
                        color: _getCategoryColor(challenge['category'])
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        challenge['category'],
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: _getCategoryColor(challenge['category']),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(height: 1.h),
                    challenge['isJoined']
                        ? Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 3.w, vertical: 1.h),
                            decoration: BoxDecoration(
                              color: AppTheme.getSuccessColor(true)
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: AppTheme.getSuccessColor(true),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CustomIconWidget(
                                  iconName: 'check',
                                  color: AppTheme.getSuccessColor(true),
                                  size: 16,
                                ),
                                SizedBox(width: 1.w),
                                Text(
                                  'Rejoint',
                                  style: AppTheme.lightTheme.textTheme.bodySmall
                                      ?.copyWith(
                                    color: AppTheme.getSuccessColor(true),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ElevatedButton(
                            onPressed: onJoin,
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 3.w, vertical: 1.h),
                              minimumSize: Size(0, 4.h),
                            ),
                            child: Text(
                              'Rejoindre',
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Bien-être':
        return AppTheme.getAccentColor(true);
      case 'Fitness':
        return AppTheme.lightTheme.colorScheme.primary;
      case 'Nutrition':
        return AppTheme.getSuccessColor(true);
      case 'Productivité':
        return AppTheme.lightTheme.colorScheme.secondary;
      case 'Éducation':
        return AppTheme.getWarningColor(true);
      case 'Santé':
        return const Color(0xFF2ECC71);
      default:
        return AppTheme.lightTheme.colorScheme.primary;
    }
  }
}
