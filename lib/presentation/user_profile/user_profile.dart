import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import './widgets/achievement_badge_widget.dart';
import './widgets/habit_analytics_widget.dart';
import './widgets/profile_header_widget.dart';
import './widgets/settings_list_widget.dart';
import './widgets/statistics_card_widget.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  bool isDarkMode = false;

  // Mock user data
  final Map<String, dynamic> userData = {
    "id": 1,
    "username": "Marie Dubois",
    "email": "marie.dubois@email.com",
    "avatar":
        "https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg?auto=compress&cs=tinysrgb&w=400",
    "joinDate": "2024-01-15",
    "bio": "Passionnée de développement personnel et de bien-être",
    "totalHabits": 12,
    "currentStreaks": 8,
    "completionRate": 78.5,
    "totalPoints": 2450,
    "level": 15,
    "achievements": [
      {
        "id": 1,
        "name": "Premier Pas",
        "description": "Créer votre première habitude",
        "icon": "star",
        "earned": true,
        "earnedDate": "2024-01-16"
      },
      {
        "id": 2,
        "name": "Série de 7",
        "description": "Maintenir une habitude pendant 7 jours",
        "icon": "local_fire_department",
        "earned": true,
        "earnedDate": "2024-01-23"
      },
      {
        "id": 3,
        "name": "Maître des Habitudes",
        "description": "Créer 10 habitudes différentes",
        "icon": "emoji_events",
        "earned": true,
        "earnedDate": "2024-02-10"
      },
      {
        "id": 4,
        "name": "Série de 30",
        "description": "Maintenir une habitude pendant 30 jours",
        "icon": "military_tech",
        "earned": false,
        "progress": 0.73
      }
    ],
    "habitStats": [
      {
        "name": "Méditation",
        "streak": 25,
        "completionRate": 92.0,
        "category": "Bien-être"
      },
      {
        "name": "Exercice",
        "streak": 18,
        "completionRate": 85.5,
        "category": "Santé"
      },
      {
        "name": "Lecture",
        "streak": 12,
        "completionRate": 78.0,
        "category": "Développement"
      }
    ],
    "weeklyProgress": [
      {"day": "Lun", "completion": 85.0},
      {"day": "Mar", "completion": 92.0},
      {"day": "Mer", "completion": 78.0},
      {"day": "Jeu", "completion": 88.0},
      {"day": "Ven", "completion": 95.0},
      {"day": "Sam", "completion": 72.0},
      {"day": "Dim", "completion": 80.0}
    ],
    "friends": 24,
    "sharedChallenges": 6,
    "communityContributions": 18
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              // Profile Header
              ProfileHeaderWidget(userData: userData),

              SizedBox(height: 2.h),

              // Statistics Dashboard
              _buildStatisticsSection(),

              SizedBox(height: 2.h),

              // Achievements Section
              _buildAchievementsSection(),

              SizedBox(height: 2.h),

              // Habit Analytics
              HabitAnalyticsWidget(
                habitStats: (userData["habitStats"] as List)
                    .cast<Map<String, dynamic>>(),
                weeklyProgress: (userData["weeklyProgress"] as List)
                    .cast<Map<String, dynamic>>(),
              ),

              SizedBox(height: 2.h),

              // Settings List
              SettingsListWidget(
                isDarkMode: isDarkMode,
                onDarkModeToggle: (value) {
                  setState(() {
                    isDarkMode = value;
                  });
                },
                onLogout: _handleLogout,
              ),

              SizedBox(height: 4.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatisticsSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Statistiques',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          SizedBox(height: 1.h),
          Row(
            children: [
              Expanded(
                child: StatisticsCardWidget(
                  title: 'Habitudes',
                  value: userData["totalHabits"].toString(),
                  icon: 'list_alt',
                  color: AppTheme.lightTheme.primaryColor,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: StatisticsCardWidget(
                  title: 'Séries',
                  value: userData["currentStreaks"].toString(),
                  icon: 'local_fire_department',
                  color: AppTheme.getSuccessColor(true),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.w),
          Row(
            children: [
              Expanded(
                child: StatisticsCardWidget(
                  title: 'Taux de réussite',
                  value: '${userData["completionRate"]}%',
                  icon: 'trending_up',
                  color: AppTheme.lightTheme.colorScheme.secondary,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: StatisticsCardWidget(
                  title: 'Points',
                  value: userData["totalPoints"].toString(),
                  icon: 'stars',
                  color: AppTheme.getAccentColor(true),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementsSection() {
    final achievements =
        (userData["achievements"] as List).cast<Map<String, dynamic>>();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Réalisations',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              Text(
                'Niveau ${userData["level"]}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          SizedBox(
            height: 12.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: achievements.length,
              separatorBuilder: (context, index) => SizedBox(width: 3.w),
              itemBuilder: (context, index) {
                final achievement = achievements[index];
                return AchievementBadgeWidget(
                  achievement: achievement,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Déconnexion',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          content: Text(
            'Êtes-vous sûr de vouloir vous déconnecter ?',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login-screen',
                  (route) => false,
                );
              },
              child: const Text('Déconnexion'),
            ),
          ],
        );
      },
    );
  }
}
