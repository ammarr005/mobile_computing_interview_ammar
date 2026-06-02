import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/typography.dart';
import '../../core/constants/constants.dart';
import '../../shared/widgets/custom_button.dart';
import '../../core/providers/api_providers.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleReset() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        await ref.read(authServiceProvider).sendPasswordResetEmail(
          _emailController.text.trim(),
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Instructions to reset your password have been sent to your email.'),
              backgroundColor: AppColors.primary,
            ),
          );
          context.go('/login');
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
          child: Container(
            constraints: const BoxConstraints(maxWidth: AppConstants.maxContentWidth-100),
            padding: const EdgeInsets.symmetric(horizontal: AppConstants.marginPage),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Container holding locked reset icon
                Container(
                  width: 64,
                  height: 64,
                  margin: const EdgeInsets.only(bottom: AppConstants.stackLg),
                  decoration: BoxDecoration(
                    color: AppColors.primaryContainer,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.lock_reset,
                      color: AppColors.onPrimary,
                      size: 32,
                    ),
                  ),
                ),
                Text(
                  'Forgot Password?',
                  style: AppTypography.headlineLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppConstants.stackSm),
                Text(
                  "Enter your email address and we'll send you instructions to reset your password.",
                  style: AppTypography.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppConstants.stackXl),

                Form(
                  key: _formKey,
                  child: Column(
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
                          fillColor: AppColors.surface,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: AppColors.outlineVariant),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email address';
                          }
                          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppConstants.stackLg),

                _isLoading
                    ? const CircularProgressIndicator()
                    : CustomButton(
                        text: 'Reset Password',
                        onPressed: _handleReset,
                      ),
                const SizedBox(height: AppConstants.stackXl),

                GestureDetector(
                  onTap: () => context.go('/login'),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.arrow_back, size: 18, color: AppColors.primary),
                      const SizedBox(width: 4),
                      Text(
                        'Back to Login',
                        style: AppTypography.labelLarge.copyWith(color: AppColors.primary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
