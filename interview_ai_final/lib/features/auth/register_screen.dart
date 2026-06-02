import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/typography.dart';
import '../../core/constants/constants.dart';
import '../../shared/widgets/custom_button.dart';
import '../../core/providers/api_providers.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        final success = await ref.read(authServiceProvider).register(
          _nameController.text.trim(),
          _emailController.text.trim(),
          _passwordController.text,
        );

        if (mounted) {
          if (success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Account created! Please log in.'),
                backgroundColor: AppColors.primary,
              ),
            );
            context.go('/login');
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Registration failed. Email might be in use.'),
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
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      margin: const EdgeInsets.only(bottom: AppConstants.stackSm),
                      decoration: const BoxDecoration(
                        color: AppColors.surfaceContainerLow,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.person_add_outlined,
                          color: AppColors.primary,
                          size: 24,
                        ),
                      ),
                    ),
                    Text(
                      'Create Account',
                      style: AppTypography.headlineLarge,
                    ),
                    const SizedBox(height: AppConstants.stackSm),
                    Text(
                      'Join Interview Pro and start your journey.',
                      style: AppTypography.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppConstants.stackLg),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Full Name', style: AppTypography.labelLarge),
                        const SizedBox(height: AppConstants.stackSm),
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.badge_outlined, color: AppColors.outline),
                            hintText: 'e.g. Jane Doe',
                            filled: true,
                            fillColor: AppColors.surfaceContainerLowest,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(color: AppColors.outlineVariant),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your full name';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: AppConstants.stackMd),

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
                            hintText: 'name@example.com',
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
                    const SizedBox(height: AppConstants.stackMd),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Password', style: AppTypography.labelLarge),
                        const SizedBox(height: AppConstants.stackSm),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.lock_outline, color: AppColors.outline),
                            hintText: 'Password',
                            filled: true,
                            fillColor: AppColors.surfaceContainerLowest,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(color: AppColors.outlineVariant),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.length < 6) {
                              return 'Password must be at least 6 characters long';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: AppConstants.stackMd),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Confirm Password', style: AppTypography.labelLarge),
                        const SizedBox(height: AppConstants.stackSm),
                        TextFormField(
                          controller: _confirmController,
                          obscureText: true,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.lock_reset_outlined, color: AppColors.outline),
                            hintText: 'Confirm Password',
                            filled: true,
                            fillColor: AppColors.surfaceContainerLowest,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(color: AppColors.outlineVariant),
                            ),
                          ),
                          validator: (value) {
                            if (value != _passwordController.text) {
                              return "Passwords do not match";
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: AppConstants.stackLg),

                    _isLoading
                      ? const CircularProgressIndicator()
                      : CustomButton(
                          text: 'Sign Up',
                          onPressed: _handleSignUp,
                          icon: Icons.arrow_forward,
                        ),
                    const SizedBox(height: AppConstants.stackLg),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Already have an account?", style: AppTypography.bodyMedium),
                        const SizedBox(width: 4.0),
                        GestureDetector(
                          onTap: () => context.go('/login'),
                          child: Text(
                            'Log in',
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
