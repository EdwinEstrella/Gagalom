import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../home/screens/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    hintText: 'Email Address',
                  ),
                ),
                const SizedBox(height: 16),

                // Continue Button
                SizedBox(
                  width: 344,
                  height: 49,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomeScreen(),
                        ),
                        (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                    child: const Text('Continue'),
                  ),
                ),
                const SizedBox(height: 16),

                // Create Account Link
                Center(
                  child: GestureDetector(
                    onTap: () {
                      // Navigate to create account
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
