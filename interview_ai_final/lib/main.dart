import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// Themes & Layout System
import 'core/theme/colors.dart';
import 'core/theme/typography.dart';
import 'core/models/category_model.dart';
import 'core/models/feedback_model.dart';

// Screens
import 'features/home/splash_screen.dart';
import 'features/home/onboarding_screens.dart';
import 'features/auth/login_screen.dart';
import 'features/auth/register_screen.dart';
import 'features/auth/forgot_password_screen.dart';
import 'features/dashboard/dashboard_screen.dart';
import 'features/dashboard/category_screen.dart';
import 'features/dashboard/practice_screen.dart';
import 'features/dashboard/history_screen.dart';
import 'features/dashboard/feedback_screen.dart';
import 'features/dashboard/session_details_screen.dart';
import 'features/profile/profile_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// GoRouter configuration containing exact pathways matching Material 3 flow
final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreens(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/forgot-password',
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const DashboardScreen(),
    ),
    GoRoute(
      path: '/category',
      builder: (context, state) => const CategoryScreen(),
    ),
    GoRoute(
      path: '/practice',
      builder: (context, state) {
        final category = state.extra as Category;
        return PracticeScreen(category: category);
      },
    ),
    GoRoute(
      path: '/history',
      builder: (context, state) => const HistoryScreen(),
    ),
    GoRoute(
      path: '/feedback',
      builder: (context, state) {
        final feedback = state.extra as InterviewFeedback;
        return FeedbackScreen(feedback: feedback);
      },
    ),
    GoRoute(
      path: '/session-details',
      builder: (context, state) {
        final sessionId = state.extra as String;
        return SessionDetailsScreen(sessionId: sessionId);
      },
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
  ],
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    // Non-blocking fallback for local test runs
    print("Dotenv load failed: $e");
  }
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const ProviderScope(
      child: InterviewApp(),
    ),
  );
}

class InterviewApp extends StatelessWidget {
  const InterviewApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'InterviewAI',
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: AppColors.primary,
          onPrimary: AppColors.onPrimary,
          secondary: AppColors.secondary,
          onSecondary: AppColors.onSecondary,
          error: AppColors.error,
          onError: AppColors.onError,
          surface: AppColors.surface,
          onSurface: AppColors.onSurface,
        ),
        textTheme: AppTypography.textTheme,
      ),
    );
  }
}
