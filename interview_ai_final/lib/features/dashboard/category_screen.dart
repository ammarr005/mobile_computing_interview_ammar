import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/typography.dart';
import '../../core/constants/constants.dart';
import '../../core/providers/api_providers.dart';
import '../../core/models/category_model.dart';

class CategoryScreen extends ConsumerWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  IconData _getIconData(String iconKey) {
    switch (iconKey) {
      case 'groups':
        return Icons.groups;
      case 'code':
        return Icons.code;
      case 'psychology':
        return Icons.psychology;
      case 'storage':
        return Icons.storage;
      case 'view_kanban':
        return Icons.view_kanban;
      case 'chat_bubble':
        return Icons.chat_bubble;
      default:
        return Icons.help_outline;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
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
                Text(
                  'Choose a Category',
                  style: AppTypography.headlineLarge,
                ),
                const SizedBox(height: AppConstants.stackSm),
                Text(
                  'Select a domain to begin your tailored interview practice session.',
                  style: AppTypography.bodyMedium,
                ),
                const SizedBox(height: AppConstants.stackXl),
                Expanded(
                  child: categoriesAsync.when(
                    data: (categories) => GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: AppConstants.gutterGrid,
                        mainAxisSpacing: AppConstants.gutterGrid,
                        childAspectRatio: 1.1,
                      ),
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final item = categories[index];
                        return _buildCategoryCard(context, item);
                      },
                    ),
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (err, stack) => Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline, color: AppColors.error, size: 48),
                          const SizedBox(height: 16),
                          Text('Failed to load categories', style: AppTypography.headlineSmall),
                          TextButton(
                            onPressed: () => ref.invalidate(categoriesProvider),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
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

  Widget _buildCategoryCard(BuildContext context, Category item) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12.0),
        border: const Border(
          top: BorderSide(color: AppColors.primary, width: 2.0),
        ),
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
          onTap: () {
            // Push to active practice screen for selected category
            context.push('/practice', extra: item);
          },
          borderRadius: BorderRadius.circular(12.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    color: AppColors.surfaceContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(_getIconData(item.iconKey), color: AppColors.primary, size: 24),
                ),
                const SizedBox(height: AppConstants.stackMd),
                Text(
                  item.title,
                  style: AppTypography.buttonText.copyWith(color: AppColors.onSurface),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4.0),
                Text(
                  item.subtitle,
                  style: AppTypography.labelMedium,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
