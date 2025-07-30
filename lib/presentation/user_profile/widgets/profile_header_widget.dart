import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProfileHeaderWidget extends StatelessWidget {
  final Map<String, dynamic> userData;

  const ProfileHeaderWidget({
    super.key,
    required this.userData,
  });

  @override
  Widget build(BuildContext context) {
    final joinDate = DateTime.parse(userData["joinDate"] as String);
    final formattedDate = "${joinDate.day}/${joinDate.month}/${joinDate.year}";

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
            AppTheme.lightTheme.colorScheme.secondary.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(6.w),
          bottomRight: Radius.circular(6.w),
        ),
      ),
      child: Column(
        children: [
          // Avatar and Edit Button
          Stack(
            children: [
              Container(
                width: 25.w,
                height: 25.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppTheme.lightTheme.primaryColor,
                    width: 3,
                  ),
                ),
                child: ClipOval(
                  child: CustomImageWidget(
                    imageUrl: userData["avatar"] as String,
                    width: 25.w,
                    height: 25.w,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () => _showEditProfileDialog(context),
                  child: Container(
                    width: 8.w,
                    height: 8.w,
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.primaryColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: CustomIconWidget(
                      iconName: 'edit',
                      color: Colors.white,
                      size: 4.w,
                    ),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Username
          Text(
            userData["username"] as String,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
          ),

          SizedBox(height: 0.5.h),

          // Bio
          if (userData["bio"] != null)
            Text(
              userData["bio"] as String,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
            ),

          SizedBox(height: 1.h),

          // Join Date
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconWidget(
                iconName: 'calendar_today',
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                size: 4.w,
              ),
              SizedBox(width: 2.w),
              Text(
                'Membre depuis le $formattedDate',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Social Stats
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildSocialStat(
                context,
                'Amis',
                userData["friends"].toString(),
                'people',
              ),
              Container(
                width: 1,
                height: 4.h,
                color: Theme.of(context).dividerColor,
              ),
              _buildSocialStat(
                context,
                'Défis',
                userData["sharedChallenges"].toString(),
                'emoji_events',
              ),
              Container(
                width: 1,
                height: 4.h,
                color: Theme.of(context).dividerColor,
              ),
              _buildSocialStat(
                context,
                'Contributions',
                userData["communityContributions"].toString(),
                'favorite',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSocialStat(
      BuildContext context, String label, String value, String iconName) {
    return Column(
      children: [
        CustomIconWidget(
          iconName: iconName,
          color: AppTheme.lightTheme.primaryColor,
          size: 5.w,
        ),
        SizedBox(height: 0.5.h),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.onSurface,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      ],
    );
  }

  void _showEditProfileDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 60.h,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(6.w),
            topRight: Radius.circular(6.w),
          ),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              width: 12.w,
              height: 0.5.h,
              margin: EdgeInsets.only(top: 2.h),
              decoration: BoxDecoration(
                color: Theme.of(context).dividerColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            SizedBox(height: 2.h),

            // Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Annuler'),
                  ),
                  Text(
                    'Modifier le profil',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      // Handle save
                    },
                    child: const Text('Sauvegarder'),
                  ),
                ],
              ),
            ),

            Divider(height: 1, color: Theme.of(context).dividerColor),

            SizedBox(height: 2.h),

            // Edit form content
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Column(
                  children: [
                    // Photo selection
                    GestureDetector(
                      onTap: () {
                        // Handle photo selection
                      },
                      child: Stack(
                        children: [
                          Container(
                            width: 20.w,
                            height: 20.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppTheme.lightTheme.primaryColor,
                                width: 2,
                              ),
                            ),
                            child: ClipOval(
                              child: CustomImageWidget(
                                imageUrl: userData["avatar"] as String,
                                width: 20.w,
                                height: 20.w,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 6.w,
                              height: 6.w,
                              decoration: BoxDecoration(
                                color: AppTheme.lightTheme.primaryColor,
                                shape: BoxShape.circle,
                              ),
                              child: CustomIconWidget(
                                iconName: 'camera_alt',
                                color: Colors.white,
                                size: 3.w,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 3.h),

                    // Name field
                    TextFormField(
                      initialValue: userData["username"] as String,
                      decoration: const InputDecoration(
                        labelText: 'Nom d\'utilisateur',
                        prefixIcon: Icon(Icons.person),
                      ),
                    ),

                    SizedBox(height: 2.h),

                    // Bio field
                    TextFormField(
                      initialValue: userData["bio"] as String,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Bio',
                        prefixIcon: Icon(Icons.info),
                        alignLabelWithHint: true,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
