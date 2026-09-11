import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_icons.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_input_field.dart';
import '../../core/widgets/max_width_container.dart';
import '../../core/widgets/primary_button.dart';
import '../../routing/route_paths.dart';

/// Ports `SignInScreen`.
///
/// NOT IMPLEMENTED (documented in the report): this screen is built as
/// polished, navigable UI only — there is no real authentication, email
/// format validation, or password check behind "Sign In". Tapping it
/// simply proceeds to Home, since the assignment brief scopes this
/// assessment to the front end with no backend/auth service in place.
class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailController =
      TextEditingController(text: 'alex.morgan@university.edu');
  final _passwordController = TextEditingController(text: '••••••••');

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: MaxWidthContainer(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 48, 24, 34),
              decoration: const BoxDecoration(
                gradient: AppColors.heroGradient,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(28),
                  bottomRight: Radius.circular(28),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome back 👋',
                    style: AppTextStyles.display(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Sign in to your account',
                    style: AppTextStyles.body(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.72),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppInputField(
                      label: 'Email Address',
                      controller: _emailController,
                      placeholder: 'you@university.edu',
                      keyboardType: TextInputType.emailAddress,
                      icon: const Icon(LucideIcons.mail,
                          size: 16, color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 20),
                    AppInputField(
                      label: 'Password',
                      controller: _passwordController,
                      placeholder: 'Enter your password',
                      obscureText: true,
                      icon: const Icon(LucideIcons.lock,
                          size: 16, color: AppColors.textSecondary),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          'Forgot Password?',
                          style: AppTextStyles.body(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    PrimaryButton(
                      label: 'Sign In',
                      onPressed: () => context.go(RoutePaths.home),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: AppTextStyles.body(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Text(
                            'Create Account',
                            style: AppTextStyles.body(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
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
