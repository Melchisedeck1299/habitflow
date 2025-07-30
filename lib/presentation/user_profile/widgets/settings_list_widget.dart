import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SettingsListWidget extends StatelessWidget {
  final bool isDarkMode;
  final Function(bool) onDarkModeToggle;
  final VoidCallback onLogout;

  const SettingsListWidget({
    super.key,
    required this.isDarkMode,
    required this.onDarkModeToggle,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(4.w),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Text(
              'Paramètres',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),

          // Account Settings Section
          _buildSectionHeader(context, 'Compte'),
          _buildSettingsItem(
            context,
            'Modifier le profil',
            'person',
            () => _showEditProfile(context),
          ),
          _buildSettingsItem(
            context,
            'Notifications',
            'notifications',
            () => _showNotificationSettings(context),
          ),
          _buildSettingsItem(
            context,
            'Confidentialité',
            'privacy_tip',
            () => _showPrivacySettings(context),
          ),
          _buildSettingsItem(
            context,
            'Langue',
            'language',
            () => _showLanguageSettings(context),
            trailing: Text(
              'Français',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ),

          Divider(height: 1, color: Theme.of(context).dividerColor),

          // App Settings Section
          _buildSectionHeader(context, 'Application'),
          _buildSettingsItem(
            context,
            'Mode sombre',
            'dark_mode',
            null,
            trailing: Switch(
              value: isDarkMode,
              onChanged: onDarkModeToggle,
            ),
          ),
          _buildSettingsItem(
            context,
            'Exporter les données',
            'download',
            () => _showDataExport(context),
          ),
          _buildSettingsItem(
            context,
            'Sauvegarde et restauration',
            'backup',
            () => _showBackupSettings(context),
          ),

          Divider(height: 1, color: Theme.of(context).dividerColor),

          // Support Section
          _buildSectionHeader(context, 'Support'),
          _buildSettingsItem(
            context,
            'FAQ',
            'help',
            () => _showFAQ(context),
          ),
          _buildSettingsItem(
            context,
            'Contacter le support',
            'support_agent',
            () => _showContactSupport(context),
          ),
          _buildSettingsItem(
            context,
            'À propos',
            'info',
            () => _showAbout(context),
            trailing: Text(
              'v1.0.0',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ),

          Divider(height: 1, color: Theme.of(context).dividerColor),

          // Logout
          _buildSettingsItem(
            context,
            'Déconnexion',
            'logout',
            onLogout,
            isDestructive: true,
          ),

          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.fromLTRB(4.w, 2.h, 4.w, 1.h),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.primaryColor,
            ),
      ),
    );
  }

  Widget _buildSettingsItem(
    BuildContext context,
    String title,
    String iconName,
    VoidCallback? onTap, {
    Widget? trailing,
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Container(
        width: 10.w,
        height: 10.w,
        decoration: BoxDecoration(
          color: isDestructive
              ? AppTheme.lightTheme.colorScheme.error.withValues(alpha: 0.1)
              : AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(2.w),
        ),
        child: CustomIconWidget(
          iconName: iconName,
          color: isDestructive
              ? AppTheme.lightTheme.colorScheme.error
              : AppTheme.lightTheme.primaryColor,
          size: 5.w,
        ),
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w500,
              color: isDestructive
                  ? AppTheme.lightTheme.colorScheme.error
                  : Theme.of(context).colorScheme.onSurface,
            ),
      ),
      trailing: trailing ??
          (onTap != null
              ? CustomIconWidget(
                  iconName: 'chevron_right',
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  size: 5.w,
                )
              : null),
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.5.h),
    );
  }

  void _showEditProfile(BuildContext context) {
    // Navigate to edit profile or show modal
  }

  void _showNotificationSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 70.h,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(6.w),
            topRight: Radius.circular(6.w),
          ),
        ),
        child: Column(
          children: [
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
            Text(
              'Notifications',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            SizedBox(height: 2.h),
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                children: [
                  _buildNotificationToggle(
                      context, 'Rappels d\'habitudes', true),
                  _buildNotificationToggle(context, 'Activités sociales', true),
                  _buildNotificationToggle(context, 'Réalisations', false),
                  _buildNotificationToggle(
                      context, 'Défis hebdomadaires', true),
                  _buildNotificationToggle(
                      context, 'Conseils quotidiens', false),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationToggle(
      BuildContext context, String title, bool value) {
    return SwitchListTile(
      title: Text(title),
      value: value,
      onChanged: (bool newValue) {
        // Handle toggle
      },
      contentPadding: EdgeInsets.symmetric(vertical: 0.5.h),
    );
  }

  void _showPrivacySettings(BuildContext context) {
    // Show privacy settings
  }

  void _showLanguageSettings(BuildContext context) {
    // Show language selection
  }

  void _showDataExport(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Exporter les données'),
          content: const Text(
              'Choisissez le format d\'exportation de vos données d\'habitudes.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Export as JSON
              },
              child: const Text('JSON'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Export as CSV
              },
              child: const Text('CSV'),
            ),
          ],
        );
      },
    );
  }

  void _showBackupSettings(BuildContext context) {
    // Show backup and restore options
  }

  void _showFAQ(BuildContext context) {
    // Show FAQ
  }

  void _showContactSupport(BuildContext context) {
    // Show contact support options
  }

  void _showAbout(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'HabitFlow',
      applicationVersion: '1.0.0',
      applicationIcon: Container(
        width: 15.w,
        height: 15.w,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.primaryColor,
          borderRadius: BorderRadius.circular(3.w),
        ),
        child: CustomIconWidget(
          iconName: 'local_fire_department',
          color: Colors.white,
          size: 8.w,
        ),
      ),
      children: [
        Text(
          'HabitFlow vous aide à construire et maintenir de bonnes habitudes grâce à un suivi intelligent et une motivation sociale.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}
