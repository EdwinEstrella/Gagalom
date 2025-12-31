import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../home/screens/home_screen.dart';
import '../providers/auth_provider.dart';
import 'register_screen.dart';
import 'login_password_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 123),
                Text(
                  'Sign in',
                  style: theme.textTheme.displaySmall?.copyWith(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.408,
                  ),
                ),
                const SizedBox(height: 40),

                // Email Field
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.done,
                        decoration: const InputDecoration(
                          hintText: 'Email Address',
                        ),
                        onFieldSubmitted: (_) => _handleContinue(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Continue Button
                SizedBox(
                  width: 344,
                  height: 49,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleContinue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      disabledBackgroundColor: theme.colorScheme.primary.withOpacity(0.5),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text('Continue'),
                  ),
                ),
                const SizedBox(height: 16),

                // Error Message
                Consumer(
                  builder: (context, ref, _) {
                    final error = ref.watch(authErrorProvider);
                    if (error != null) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.red.shade200),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.error_outline, color: Colors.red.shade700, size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  error,
                                  style: TextStyle(color: Colors.red.shade700, fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),

                // Create Account Link
                Center(
                  child: GestureDetector(
                    onTap: () {
                      ref.read(authProvider.notifier).clearError();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterScreen(),
                        ),
                      );
                    },
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 12,
                          color: theme.colorScheme.onSurface,
                          letterSpacing: -0.408,
                        ),
                        children: [
                          const TextSpan(text: "Dont have an Account ? "),
                          TextSpan(
                            text: 'Create One',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 60),

                // Social Login
                const Text(
                  'Sign up Methods',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),

                // Apple Button
                _buildSocialButton(
                  context,
                  label: 'Continue With Apple',
                  icon: 'assets/icons/apple.svg',
                  onTap: () {},
                ),
                const SizedBox(height: 12),

                // Google Button
                _buildSocialButton(
                  context,
                  label: 'Continue With Google',
                  icon: 'assets/icons/google.svg',
                  onTap: () {},
                ),
                const SizedBox(height: 12),

                // Facebook Button
                _buildSocialButton(
                  context,
                  label: 'Continue With Facebook',
                  icon: 'assets/icons/facebook.svg',
                  onTap: () {},
                ),
                const SizedBox(height: 60),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleContinue() async {
    final email = _emailController.text.trim();

    // Validación básica de email
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor ingresa tu email')),
      );
      return;
    }

    if (!email.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor ingresa un email válido')),
      );
      return;
    }

    // Navegar a la pantalla de password
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPasswordScreen(email: email),
      ),
    );
  }

  Widget _buildSocialButton(
    BuildContext context, {
    required String label,
    required String icon,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 344,
        height: 49,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              icon,
              width: 24,
              height: 24,
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
                letterSpacing: -0.4958,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
