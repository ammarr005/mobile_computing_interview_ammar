import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/typography.dart';
import '../../core/constants/constants.dart';
import '../../shared/widgets/custom_button.dart';
import '../../core/providers/api_providers.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        final success = await ref.read(authServiceProvider).login(
          _emailController.text.trim(),
          _passwordController.text,
        );

        if (mounted) {
          if (success) {
            context.go('/dashboard');
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Invalid email or password'),
                backgroundColor: AppColors.error,
              ),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${e.toString()}'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              constraints: const BoxConstraints(maxWidth: AppConstants.maxContentWidth),
              padding: const EdgeInsets.symmetric(horizontal: AppConstants.marginPage),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      margin: const EdgeInsets.only(bottom: AppConstants.stackLg),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.primaryContainer, AppColors.secondaryContainer],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(24.0),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.chat_bubble_outline_rounded,
                          color: Colors.white,
                          size: 48,
                        ),
                      ),
                    ),
                    Text(
                      'Welcome Back',
                      style: AppTypography.headlineLarge,
                    ),
                    const SizedBox(height: AppConstants.stackSm),
                    Text(
                      'Sign in to continue your interview prep.',
                      style: AppTypography.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppConstants.stackXl),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Email Address', style: AppTypography.labelLarge),
                        const SizedBox(height: AppConstants.stackSm),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.mail_outline, color: AppColors.outline),
                            hintText: 'you@example.com',
                            filled: true,
                            fillColor: AppColors.surfaceContainerLowest,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(color: AppColors.outlineVariant),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: AppConstants.stackLg),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Password', style: AppTypography.labelLarge),
                            GestureDetector(
                              onTap: () => context.push('/forgot-password'),
                              child: Text(
                                'Forgot password?',
                                style: AppTypography.labelMedium.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: AppConstants.stackSm),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.lock_outline, color: AppColors.outline),
                            suffixIcon: IconButton(
                              icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, color: AppColors.outline),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                            hintText: 'Password',
                            filled: true,
                            fillColor: AppColors.surfaceContainerLowest,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(color: AppColors.outlineVariant),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: AppConstants.stackXl),

                    _isLoading 
                      ? const CircularProgressIndicator()
                      : CustomButton(
                          text: 'Login',
                          onPressed: _handleLogin,
                          icon: Icons.arrow_forward,
                        ),
                    const SizedBox(height: AppConstants.stackLg),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don't have an account?", style: AppTypography.bodyMedium),
                        const SizedBox(width: 4.0),
                        GestureDetector(
                          onTap: () => context.go('/register'),
                          child: Text(
                            'Create account',
                            style: AppTypography.labelLarge.copyWith(color: AppColors.primary),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
