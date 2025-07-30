import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SocialLoginButtonWidget extends StatelessWidget {
  final VoidCallback onGoogleSignIn;

  const SocialLoginButtonWidget({
    super.key,
    required this.onGoogleSignIn,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Google Sign In Button
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: onGoogleSignIn,
            icon: CustomIconWidget(
              iconName: 'google',
              size: 24,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
            label: Text(
              'Continuer avec Google',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 2.h),
              side: BorderSide(
                color: AppTheme.lightTheme.colorScheme.outline,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),

        SizedBox(height: 2.h),

        // Future: Apple Sign In Button (placeholder)
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {
              // TODO: Implement Apple Sign In
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Apple Sign In - Bientôt disponible'),
                  backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
                ),
              );
            },
            icon: CustomIconWidget(
              iconName: 'apple',
              size: 24,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
            label: Text(
              'Continuer avec Apple',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 2.h),
              side: BorderSide(
                color: AppTheme.lightTheme.colorScheme.outline,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
