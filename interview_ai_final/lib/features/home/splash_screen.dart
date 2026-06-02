import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/typography.dart';
import '../../core/constants/constants.dart';
import '../../core/providers/api_providers.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    // Artificial delay to show logo
    await Future.delayed(const Duration(milliseconds: 2000));
    
    if (!mounted) return;

    final authService = ref.read(authServiceProvider);
    final isLoggedIn = await authService.isLoggedIn();

    if (mounted) {
      if (isLoggedIn) {
        context.go('/dashboard');
      } else {
        context.go('/onboarding');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceContainerLowest,
      body: SafeArea(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: AppConstants.maxContentWidth),
            padding: const EdgeInsets.symmetric(horizontal: AppConstants.marginPage),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Spacer(),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.primaryContainer, AppColors.secondaryContainer],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(24.0),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.2),
                            blurRadius: 15.0,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.chat_bubble_outline_rounded,
                          color: Colors.white,
                          size: 48,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppConstants.stackLg),
                    Text(
                      'InterviewAI',
                      style: AppTypography.headlineLarge.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                const Padding(
                  padding: EdgeInsets.only(bottom: AppConstants.stackXl),
                  child: SizedBox(
                    width: 32,
                    height: 32,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                      strokeWidth: 3.5,
                    ),
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
