import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/typography.dart';
import '../../core/constants/constants.dart';
import '../../shared/widgets/custom_card.dart';
import '../../core/providers/api_providers.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Interview Pro',
          style: AppTypography.headlineMedium.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: profileAsync.when(
            data: (profile) {
              final stats = profile['stats'];
              return SingleChildScrollView(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: AppConstants.maxContentWidth),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.marginPage,
                    vertical: AppConstants.stackLg,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Greeting
                      Text('Hi, ${profile['full_name']}', style: AppTypography.headlineLarge),
                      const SizedBox(height: AppConstants.stackSm),
                      Text('Ready to ace your next interview?', style: AppTypography.bodyMedium),
                      const SizedBox(height: AppConstants.stackXl),

                      // Stats Bento Grid
                      Row(
                        children: [
                          Expanded(
                            child: CustomCard(
                              onTap: () {},
                              padding: 16.0,
                              borderRadius: 16.0,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.data_usage_rounded, color: AppColors.secondary, size: 18),
                                      const SizedBox(width: 8.0),
                                      Text('Total Sessions', style: AppTypography.labelLarge.copyWith(color: AppColors.onSurfaceVariant)),
                                    ],
                                  ),
                                  const SizedBox(height: 16.0),
                                  Text('${stats['total_sessions']}', style: AppTypography.headlineLarge),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: AppConstants.gutterGrid),
                          Expanded(
                            child: CustomCard(
                              onTap: () {},
                              padding: 16.0,
                              borderRadius: 16.0,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.trending_up, color: AppColors.primary, size: 18),
                                      const SizedBox(width: 8.0),
                                      Text('Avg Score', style: AppTypography.labelLarge.copyWith(color: AppColors.onSurfaceVariant)),
                                    ],
                                  ),
                                  const SizedBox(height: 16.0),
                                  Text('${stats['avg_score']}%', style: AppTypography.headlineLarge.copyWith(color: AppColors.primary)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppConstants.stackXl),

                      // Practice Action Card
                      _buildActionCard(
                        title: 'Start New Practice',
                        subtitle: 'Begin an AI mock interview session',
                        icon: Icons.play_arrow,
                        gradient: const LinearGradient(
                          colors: [AppColors.primary, AppColors.secondary],
                        ),
                        onTap: () => context.push('/category'),
                      ),
                      const SizedBox(height: AppConstants.stackMd),

                      // History Action Card
                      _buildActionCard(
                        title: 'View History',
                        subtitle: 'Review past sessions and feedback',
                        icon: Icons.history,
                        onTap: () => context.push('/history'),
                      ),
                      const SizedBox(height: AppConstants.stackMd),

                      // Profile Action Card
                      _buildActionCard(
                        title: 'Profile',
                        subtitle: 'Manage settings and preferences',
                        icon: Icons.person,
                        onTap: () => context.push('/profile'),
                      ),
                    ],
                  ),
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Failed to load dashboard data'),
                  ElevatedButton(
                    onPressed: () => ref.invalidate(profileProvider),
                    child: const Text('Retry'),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      // Consistent Bottom Navigation Bar
      bottomNavigationBar: Container(
        constraints: const BoxConstraints(maxWidth: AppConstants.maxContentWidth),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          border: const Border(top: BorderSide(color: AppColors.outlineVariant, width: 1.0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, -2),
            )
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: AppColors.surfaceContainerLowest,
          selectedItemColor: AppColors.secondary,
          unselectedItemColor: AppColors.onSurfaceVariant.withOpacity(0.7),
          currentIndex: 0,
          onTap: (index) {
            if (index == 1) context.push('/history');
            if (index == 2) context.push('/profile');
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_filled),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: 'History',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    Gradient? gradient,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: gradient,
        color: gradient == null ? AppColors.surfaceContainerLowest : null,
        borderRadius: BorderRadius.circular(24.0),
        border: gradient == null ? Border.all(color: AppColors.outlineVariant.withOpacity(0.3)) : null,
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A0F172A),
            blurRadius: 15.0,
            spreadRadius: 0.0,
          )
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24.0),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: gradient == null ? AppColors.surfaceVariant : Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        icon,
                        color: gradient == null ? AppColors.onSurfaceVariant : Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: AppTypography.headlineSmall.copyWith(
                            color: gradient == null ? AppColors.onSurface : Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: AppTypography.bodySmall.copyWith(
                            color: gradient == null ? AppColors.onSurfaceVariant : Colors.white.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Icon(
                  Icons.arrow_forward,
                  color: gradient == null ? AppColors.onSurfaceVariant : Colors.white,
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
