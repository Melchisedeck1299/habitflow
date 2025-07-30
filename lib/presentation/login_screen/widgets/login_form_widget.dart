import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class LoginFormWidget extends StatefulWidget {
  final Function({required String email, required String password}) onSignIn;
  final Function(
      {required String email,
      required String password,
      required String fullName}) onSignUp;
  final Function(String email) onPasswordReset;

  const LoginFormWidget({
    super.key,
    required this.onSignIn,
    required this.onSignUp,
    required this.onPasswordReset,
  });

  @override
  State<LoginFormWidget> createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends State<LoginFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _fullNameController = TextEditingController();

  bool _isSignUpMode = false;
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _fullNameController.dispose();
    super.dispose();
  }

  void _toggleMode() {
    setState(() {
      _isSignUpMode = !_isSignUpMode;
    });
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez entrer votre email';
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return 'Veuillez entrer un email valide';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez entrer votre mot de passe';
    }
    if (value.length < 6) {
      return 'Le mot de passe doit contenir au moins 6 caractères';
    }
    return null;
  }

  String? _validateFullName(String? value) {
    if (_isSignUpMode && (value == null || value.isEmpty)) {
      return 'Veuillez entrer votre nom complet';
    }
    return null;
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      if (_isSignUpMode) {
        await widget.onSignUp(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          fullName: _fullNameController.text.trim(),
        );
      } else {
        await widget.onSignIn(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showPasswordResetDialog() {
    showDialog(
      context: context,
      builder: (context) {
        final resetEmailController = TextEditingController();
        return AlertDialog(
          title: Text('Réinitialiser le mot de passe'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                  'Entrez votre adresse email pour recevoir un lien de réinitialisation.'),
              SizedBox(height: 2.h),
              TextFormField(
                controller: resetEmailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'votre@email.com',
                  border: OutlineInputBorder(),
                ),
                validator: _validateEmail,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                widget.onPasswordReset(resetEmailController.text.trim());
              },
              child: Text('Envoyer'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Full Name Field (only for sign up)
          if (_isSignUpMode) ...[
            TextFormField(
              controller: _fullNameController,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                labelText: 'Nom complet',
                hintText: 'Votre nom complet',
                prefixIcon: CustomIconWidget(
                  iconName: 'person',
                  size: 24,
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: _validateFullName,
            ),
            SizedBox(height: 3.h),
          ],

          // Email Field
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'Email',
              hintText: 'votre@email.com',
              prefixIcon: CustomIconWidget(
                iconName: 'email',
                size: 24,
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            validator: _validateEmail,
          ),

          SizedBox(height: 3.h),

          // Password Field
          TextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            decoration: InputDecoration(
              labelText: 'Mot de passe',
              hintText: 'Votre mot de passe',
              prefixIcon: CustomIconWidget(
                iconName: 'lock',
                size: 24,
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
              suffixIcon: IconButton(
                icon: CustomIconWidget(
                  iconName: _obscurePassword ? 'visibility' : 'visibility_off',
                  size: 24,
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
                onPressed: _togglePasswordVisibility,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            validator: _validatePassword,
          ),

          SizedBox(height: 2.h),

          // Forgot Password (only for sign in)
          if (!_isSignUpMode)
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _showPasswordResetDialog,
                child: Text('Mot de passe oublié?'),
              ),
            ),

          SizedBox(height: 4.h),

          // Submit Button
          ElevatedButton(
            onPressed: _isLoading ? null : _handleSubmit,
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 2.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: _isLoading
                ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(
                    _isSignUpMode ? 'Créer un compte' : 'Se connecter',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
          ),

          SizedBox(height: 3.h),

          // Toggle Mode Button
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _isSignUpMode
                    ? 'Vous avez déjà un compte? '
                    : 'Vous n\'avez pas de compte? ',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              TextButton(
                onPressed: _toggleMode,
                child: Text(
                  _isSignUpMode ? 'Se connecter' : 'S\'inscrire',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
