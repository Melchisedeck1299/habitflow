import 'package:flutter/material.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/habit_dashboard/habit_dashboard.dart';
import '../presentation/daily_reflection/daily_reflection.dart';
import '../presentation/social_challenges/social_challenges.dart';
import '../presentation/user_profile/user_profile.dart';
import '../presentation/habit_creation/habit_creation.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String loginScreen = '/login-screen';
  static const String habitDashboard = '/habit-dashboard';
  static const String dailyReflection = '/daily-reflection';
  static const String socialChallenges = '/social-challenges';
  static const String userProfile = '/user-profile';
  static const String habitCreation = '/habit-creation';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const LoginScreen(),
    loginScreen: (context) => const LoginScreen(),
    habitDashboard: (context) => const HabitDashboard(),
    dailyReflection: (context) => const DailyReflection(),
    socialChallenges: (context) => const SocialChallenges(),
    userProfile: (context) => const UserProfile(),
    habitCreation: (context) => const HabitCreation(),
    // TODO: Add your other routes here
  };
}
