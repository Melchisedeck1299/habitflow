import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FeaturedChallengeWidget extends StatelessWidget {
  final Map<String, dynamic> challenge;
  final VoidCallback onTap;
  final VoidCallback onJoin;

  const FeaturedChallengeWidget({
    Key? key,
    required this.challenge,
    required this.onTap,
    required this.onJoin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70.w,
      margin: EdgeInsets.only(right: 4.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.shadowColor,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              // Background image
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: CustomImageWidget(
                  imageUrl: challenge['image'],
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

              // Gradient overlay
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.7),
                    ],
                  ),
                ),
              ),

              // Content
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Padding(
                  padding: EdgeInsets.all(4.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Category badge
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.w, vertical: 0.5.h),
                        decoration: BoxDecoration(
                          color: _getCategoryColor(challenge['category']),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          challenge['category'],
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      SizedBox(height: 1.h),

                      // Title
                      Text(
                        challenge['title'],
                        style:
                            AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      SizedBox(height: 0.5.h),

                      // Description
                      Text(
                        challenge['description'],
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      SizedBox(height: 1.h),

                      // Stats row
                      Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'group',
                            color: Colors.white,
                            size: 16,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            '${challenge['participants']}',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: Colors.white,
                            ),
                          ),

                          SizedBox(width: 4.w),

                          CustomIconWidget(
                            iconName: 'schedule',
                            color: Colors.white,
                            size: 16,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            challenge['duration'],
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: Colors.white,
                            ),
                          ),

                          const Spacer(),

                          // Join button
                          challenge['isJoined']
                              ? Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 3.w, vertical: 1.h),
                                  decoration: BoxDecoration(
                                    color: AppTheme.getSuccessColor(true),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CustomIconWidget(
                                        iconName: 'check',
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                      SizedBox(width: 1.w),
                                      Text(
                                        'Rejoint',
                                        style: AppTheme
                                            .lightTheme.textTheme.bodySmall
                                            ?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : GestureDetector(
                                  onTap: onJoin,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 4.w, vertical: 1.h),
                                    decoration: BoxDecoration(
                                      color: AppTheme
                                          .lightTheme.colorScheme.primary,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      'Rejoindre',
                                      style: AppTheme
                                          .lightTheme.textTheme.bodySmall
                                          ?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Difficulty indicator
              Positioned(
                top: 4.w,
                right: 4.w,
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomIconWidget(
                        iconName: 'trending_up',
                        color: _getDifficultyColor(challenge['difficulty']),
                        size: 14,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        challenge['difficulty'],
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
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

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty) {
      case 'Facile':
        return AppTheme.getSuccessColor(true);
      case 'Débutant':
        return AppTheme.getSuccessColor(true);
      case 'Intermédiaire':
        return AppTheme.getWarningColor(true);
      case 'Difficile':
        return AppTheme.lightTheme.colorScheme.error;
      default:
        return AppTheme.lightTheme.colorScheme.primary;
    }
  }
}
