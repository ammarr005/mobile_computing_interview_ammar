import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/typography.dart';
import '../../core/constants/constants.dart';
import '../../shared/widgets/custom_card.dart';
import '../../core/providers/api_providers.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  Color _getCategoryColor(String title) {
    if (title.contains('Software')) return AppColors.primary;
    if (title.contains('Behavioral')) return AppColors.secondary;
    if (title.contains('System')) return AppColors.tertiary;
    return AppColors.primary;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(historyProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Interview Pro',
          style: AppTypography.headlineMedium.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: Container(
            constraints: const BoxConstraints(maxWidth: AppConstants.maxContentWidth),
            padding: const EdgeInsets.symmetric(horizontal: AppConstants.marginPage),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppConstants.stackMd),
                Text('History', style: AppTypography.headlineLarge),
                const SizedBox(height: AppConstants.stackSm),
                Text('Review your past sessions and track your progress.', style: AppTypography.bodyMedium),
                const SizedBox(height: AppConstants.stackLg),

                Expanded(
                  child: historyAsync.when(
                    data: (sessions) {
                      if (sessions.isEmpty) {
                        return const Center(child: Text('No history found yet. Start practicing!'));
                      }
                      return ListView.builder(
                        itemCount: sessions.length,
                        itemBuilder: (context, index) {
                          final session = sessions[index];
                          final categoryColor = _getCategoryColor(session.title);
                          return Padding(
                            padding: const EdgeInsets.only(bottom: AppConstants.stackMd),
                            child: CustomCard(
                              borderLeftColor: categoryColor,
                              borderRadius: 24.0,
                              backgroundColor: AppColors.surfaceContainerLowest,
                              padding: 16,
                              onTap: () {
                                context.push('/session-details', extra: session.id);
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        DateFormat('MMM dd, yyyy • hh:mm a').format(session.date),
                                        style: AppTypography.labelMedium,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(session.title, style: AppTypography.headlineSmall),
                                      const SizedBox(height: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: categoryColor.withOpacity(0.12),
                                          borderRadius: BorderRadius.circular(99),
                                        ),
                                        child: Text(
                                          'Score: ${session.score}/100',
                                          style: AppTypography.labelMedium.copyWith(color: categoryColor, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: const BoxDecoration(
                                      color: AppColors.surfaceContainer,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(Icons.chevron_right, color: categoryColor),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (err, stack) {
                      debugPrint(err.toString());
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Failed to load history'),
                            TextButton(
                              onPressed: () => ref.invalidate(historyProvider),
                              child: const Text('Retry'),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
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
          currentIndex: 1,
          onTap: (index) {
            if (index == 0) context.push('/dashboard');
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
}
