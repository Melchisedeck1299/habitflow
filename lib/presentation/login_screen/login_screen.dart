import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/app_export.dart';
import '../../services/auth_service.dart';
import './widgets/app_logo_widget.dart';
import './widgets/login_form_widget.dart';
import './widgets/social_login_button_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();
  late final Stream<AuthState> _authStateStream;

  @override
  void initState() {
    super.initState();
    _initAuthStateListener();
    _checkInitialAuthState();
  }

  void _initAuthStateListener() {
    _authStateStream = _authService.authStateStream;
    _authStateStream.listen((data) {
      final AuthChangeEvent event = data.event;
      if (event == AuthChangeEvent.signedIn) {
        _navigateToHome();
      }
    });
  }

  void _checkInitialAuthState() {
    // Check if user is already signed in
    if (_authService.isSignedIn()) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _navigateToHome();
      });
    }
  }

  void _navigateToHome() {
    Navigator.pushReplacementNamed(context, AppRoutes.habitDashboard);
  }

  Future<void> _handleSignIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _authService.signIn(
        email: email,
        password: password,
      );

      if (response.user != null) {
        _navigateToHome();
      }
    } catch (error) {
      _showErrorSnackBar('Erreur de connexion: ${error.toString()}');
    }
  }

  Future<void> _handleSignUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      final response = await _authService.signUp(
        email: email,
        password: password,
        fullName: fullName,
      );

      if (response.user != null) {
        _showSuccessSnackBar('Compte créé avec succès!');
        _navigateToHome();
      }
    } catch (error) {
      _showErrorSnackBar(
          'Erreur lors de la création du compte: ${error.toString()}');
    }
  }

  Future<void> _handleGoogleSignIn() async {
    try {
      final success = await _authService.signInWithGoogle();
      if (success) {
        // Navigation will be handled by auth state listener
      }
    } catch (error) {
      _showErrorSnackBar('Erreur de connexion Google: ${error.toString()}');
    }
  }

  Future<void> _handlePasswordReset(String email) async {
    if (email.isEmpty) {
      _showErrorSnackBar('Veuillez entrer votre adresse email');
      return;
    }

    try {
      await _authService.resetPassword(email: email);
      _showSuccessSnackBar('Email de réinitialisation envoyé!');
    } catch (error) {
      _showErrorSnackBar('Erreur: ${error.toString()}');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.lightTheme.colorScheme.error,
        duration: Duration(seconds: 4),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(6.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 8.h),

              // App Logo
              AppLogoWidget(),

              SizedBox(height: 6.h),

              // Welcome Text
              Text(
                'Bienvenue sur HabitFlow',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                    ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 2.h),

              Text(
                'Créez et suivez vos habitudes quotidiennes',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 6.h),

              // Login Form
              LoginFormWidget(
                onSignIn: _handleSignIn,
                onSignUp: _handleSignUp,
                onPasswordReset: _handlePasswordReset,
              ),

              SizedBox(height: 4.h),

              // Divider
              Row(
                children: [
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: Text(
                      'ou',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ),
                  Expanded(child: Divider()),
                ],
              ),

              SizedBox(height: 4.h),

              // Social Login Buttons
              SocialLoginButtonWidget(
                onGoogleSignIn: _handleGoogleSignIn,
              ),

              SizedBox(height: 6.h),

              // Demo Account Info
              Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Compte de démonstration',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      'Email: demo@habitflow.com',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Text(
                      'Mot de passe: password123',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
