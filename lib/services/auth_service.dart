import 'package:supabase_flutter/supabase_flutter.dart';

import './supabase_service.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  late final SupabaseClient _client;
  bool _isInitialized = false;

  factory AuthService() {
    return _instance;
  }

  AuthService._internal() {
    _initializeService();
  }

  Future<void> _initializeService() async {
    if (!_isInitialized) {
      _client = await SupabaseService().client;
      _isInitialized = true;
    }
  }

  // Ensure client is initialized
  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await _initializeService();
    }
  }

  /// Sign up a new user with email and password
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    String? fullName,
  }) async {
    await _ensureInitialized();

    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
        data: {
          'full_name': fullName ?? email.split('@')[0],
        },
      );

      return response;
    } catch (error) {
      throw Exception('Sign-up failed: $error');
    }
  }

  /// Sign in with email and password
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    await _ensureInitialized();

    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      return response;
    } catch (error) {
      throw Exception('Sign-in failed: $error');
    }
  }

  /// Sign out current user
  Future<void> signOut() async {
    await _ensureInitialized();

    try {
      await _client.auth.signOut();
    } catch (error) {
      throw Exception('Sign-out failed: $error');
    }
  }

  /// Get current user
  User? getCurrentUser() {
    if (!_isInitialized) return null;
    return _client.auth.currentUser;
  }

  /// Check if user is signed in
  bool isSignedIn() {
    return getCurrentUser() != null;
  }

  /// Get current user profile
  Future<Map<String, dynamic>?> getCurrentUserProfile() async {
    await _ensureInitialized();

    final user = getCurrentUser();
    if (user == null) return null;

    try {
      final response = await _client
          .from('user_profiles')
          .select()
          .eq('id', user.id)
          .single();

      return response;
    } catch (error) {
      throw Exception('Failed to fetch user profile: $error');
    }
  }

  /// Update user profile
  Future<void> updateUserProfile({
    required String userId,
    String? fullName,
    String? avatarUrl,
  }) async {
    await _ensureInitialized();

    try {
      final updates = <String, dynamic>{};

      if (fullName != null) updates['full_name'] = fullName;
      if (avatarUrl != null) updates['avatar_url'] = avatarUrl;

      if (updates.isNotEmpty) {
        await _client.from('user_profiles').update(updates).eq('id', userId);
      }
    } catch (error) {
      throw Exception('Failed to update profile: $error');
    }
  }

  /// Listen to auth state changes
  Stream<AuthState> get authStateStream {
    if (!_isInitialized) {
      return Stream.error('Auth service not initialized');
    }
    return _client.auth.onAuthStateChange;
  }

  /// Sign in with Google OAuth
  Future<bool> signInWithGoogle() async {
    await _ensureInitialized();

    try {
      return await _client.auth.signInWithOAuth(OAuthProvider.google);
    } catch (error) {
      throw Exception('Google sign-in failed: $error');
    }
  }

  /// Reset password
  Future<void> resetPassword({required String email}) async {
    await _ensureInitialized();

    try {
      await _client.auth.resetPasswordForEmail(email);
    } catch (error) {
      throw Exception('Password reset failed: $error');
    }
  }

  /// Delete current user account
  Future<void> deleteAccount() async {
    await _ensureInitialized();

    final user = getCurrentUser();
    if (user == null) throw Exception('No user logged in');

    try {
      // Delete user profile first
      await _client.from('user_profiles').delete().eq('id', user.id);

      // Then delete auth user
      await _client.auth.admin.deleteUser(user.id);
    } catch (error) {
      throw Exception('Account deletion failed: $error');
    }
  }
}
