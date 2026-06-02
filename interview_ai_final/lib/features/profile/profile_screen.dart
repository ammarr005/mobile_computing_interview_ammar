import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/typography.dart';
import '../../core/constants/constants.dart';
import '../../shared/widgets/custom_card.dart';
import '../../core/providers/api_providers.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  void _showEditProfileDialog(
    BuildContext context,
    WidgetRef ref,
    String currentName,
    String currentPhotoUrl,
  ) {
    final nameController = TextEditingController(text: currentName);
    final photoUrlController = TextEditingController(text: currentPhotoUrl);
    final formKey = GlobalKey<FormState>();
    bool isSaving = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (statefulContext, setState) {
            return AlertDialog(
              backgroundColor: AppColors.surfaceBright,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.0),
              ),
              title: Text(
                'Edit Profile',
                style: AppTypography.headlineSmall.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: nameController,
                        style: AppTypography.bodyMedium.copyWith(color: AppColors.onSurface),
                        cursorColor: AppColors.primary,
                        decoration: InputDecoration(
                          labelText: 'Full Name',
                          labelStyle: TextStyle(color: AppColors.onSurfaceVariant.withOpacity(0.8)),
                          hintText: 'Enter your full name',
                          filled: true,
                          fillColor: AppColors.surfaceContainerLowest,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide(color: AppColors.outlineVariant.withOpacity(0.3)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: const BorderSide(color: AppColors.primary, width: 2.0),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Full name cannot be empty';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: photoUrlController,
                        style: AppTypography.bodyMedium.copyWith(color: AppColors.onSurface),
                        cursorColor: AppColors.primary,
                        decoration: InputDecoration(
                          labelText: 'Profile Image URL (optional)',
                          labelStyle: TextStyle(color: AppColors.onSurfaceVariant.withOpacity(0.8)),
                          hintText: 'https://example.com/avatar.png',
                          filled: true,
                          fillColor: AppColors.surfaceContainerLowest,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide(color: AppColors.outlineVariant.withOpacity(0.3)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: const BorderSide(color: AppColors.primary, width: 2.0),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
              actionsPadding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              actions: [
                TextButton(
                  onPressed: isSaving ? null : () => Navigator.of(dialogContext).pop(),
                  child: Text(
                    'Cancel',
                    style: AppTypography.buttonText.copyWith(color: AppColors.onSurfaceVariant),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                  ),
                  onPressed: isSaving
                      ? null
                      : () async {
                          if (formKey.currentState?.validate() ?? false) {
                            setState(() {
                              isSaving = true;
                            });

                            final name = nameController.text.trim();
                            final photoUrl = photoUrlController.text.trim();

                            final success = await ref
                                .read(profileServiceProvider)
                                .updateProfile(name, photoUrl.isNotEmpty ? photoUrl : null);

                            if (success) {
                              ref.invalidate(profileProvider);
                              if (dialogContext.mounted) {
                                Navigator.of(dialogContext).pop();
                              }
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Profile updated successfully'),
                                    backgroundColor: AppColors.success,
                                  ),
                                );
                              }
                            } else {
                              setState(() {
                                isSaving = false;
                              });
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Failed to update profile. Please try again.'),
                                    backgroundColor: AppColors.error,
                                  ),
                                );
                              }
                            }
                          }
                        },
                  child: isSaving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text(
                          'Save',
                          style: AppTypography.buttonText.copyWith(color: Colors.white),
                        ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileProvider);
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
          'Profile',
          style: AppTypography.headlineMedium.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: profileAsync.when(
            data: (profile) {
              final fullName = profile['full_name'] ?? 'No Name';
              final email = profile['email'] ?? 'No Email';
              final photoUrl = profile['photo_url'] as String? ?? '';
              final avgScore = profile['avg_score'] ?? 0;
              final totalSessions = profile['total_sessions'] ?? 0;
              final streak = profile['streak'] ?? 0;

              return SingleChildScrollView(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: AppConstants.maxContentWidth),
                  padding: const EdgeInsets.symmetric(horizontal: AppConstants.marginPage, vertical: AppConstants.stackMd),
                  child: Column(
                    children: [
                      // User Photo Profile section with edit FAB
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: AppColors.surfaceContainerLowest, width: 4.0),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      photoUrl.isNotEmpty
                                          ? photoUrl
                                          : 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&q=80&w=200',
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color(0x0A0F172A),
                                      blurRadius: 15.0,
                                    )
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () => _showEditProfileDialog(context, ref, fullName, photoUrl),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: const BoxDecoration(
                                    color: AppColors.primary,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.edit, color: Colors.white, size: 16),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppConstants.stackMd),
                          Text(fullName, style: AppTypography.headlineMedium),
                          const SizedBox(height: 4),
                          Text(email, style: AppTypography.bodySmall),
                        ],
                      ),
                      const SizedBox(height: AppConstants.stackXl),

                      // Bento summary numbers cards
                      Row(
                        children: [
                          Expanded(
                            child: CustomCard(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Icon(Icons.military_tech, color: AppColors.secondary, size: 30),
                                  const SizedBox(height: 8),
                                  Text('$avgScore%', style: AppTypography.headlineMedium),
                                  const SizedBox(height: 2),
                                  Text('AVG SCORE', style: AppTypography.labelMedium.copyWith(letterSpacing: 1.0)),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: AppConstants.gutterGrid),
                          Expanded(
                            child: CustomCard(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Icon(Icons.headset_mic, color: AppColors.primary, size: 30),
                                  const SizedBox(height: 8),
                                  Text('$totalSessions', style: AppTypography.headlineMedium),
                                  const SizedBox(height: 2),
                                  Text('TOTAL SESSIONS', style: AppTypography.labelMedium.copyWith(letterSpacing: 1.0)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppConstants.gutterGrid),

                      // Streak Tracker Card
                      CustomCard(
                        borderLeftColor: AppColors.primary,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: const BoxDecoration(
                                    color: AppColors.surfaceVariant,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.trending_up, color: AppColors.primary),
                                ),
                                const SizedBox(width: 16),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Current Streak', style: AppTypography.headlineSmall.copyWith(fontSize: 16)),
                                    Text('Keep up the momentum!', style: AppTypography.bodySmall),
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Text('$streak', style: AppTypography.headlineLarge.copyWith(color: AppColors.primary)),
                                const SizedBox(width: 4),
                                Text('days', style: AppTypography.bodySmall),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppConstants.stackXl),

                      // Settings Panel
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
                          child: Text('Account Settings', style: AppTypography.labelLarge.copyWith(color: AppColors.onSurfaceVariant)),
                        ),
                      ),

                      _buildSettingsRow(icon: Icons.person, label: 'Personal Information'),
                      _buildSettingsRow(icon: Icons.notifications, label: 'Notifications'),
                      _buildSettingsRow(icon: Icons.lock, label: 'Privacy & Security'),
                      const SizedBox(height: AppConstants.stackXl),

                      // Logout option button
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            backgroundColor: AppColors.errorContainer.withOpacity(0.4),
                            side: const BorderSide(color: AppColors.error, width: 1.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () async {
                            await ref.read(authServiceProvider).logout();
                            if (context.mounted) {
                              context.go('/login');
                            }
                          },
                          icon: const Icon(Icons.logout, color: AppColors.error),
                          label: Text(
                            'Logout',
                            style: AppTypography.buttonText.copyWith(color: AppColors.error),
                          ),
                        ),
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
                  const Icon(Icons.error_outline, color: AppColors.error, size: 48),
                  const SizedBox(height: 16),
                  Text('Failed to load profile data', style: AppTypography.headlineSmall),
                  const SizedBox(height: 8),
                  Text(err.toString(), style: AppTypography.bodySmall, textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => ref.invalidate(profileProvider),
                    child: const Text('Retry'),
                  ),
                ],
              ),
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
          currentIndex: 2,
          onTap: (index) {
            if (index == 0) context.push('/dashboard');
            if (index == 1) context.push('/history');
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

  Widget _buildSettingsRow({required IconData icon, required String label}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: CustomCard(
        padding: 16.0,
        borderRadius: 8.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, color: AppColors.onSurfaceVariant),
                const SizedBox(width: 12),
                Text(label, style: AppTypography.bodyMedium.copyWith(color: AppColors.onSurface)),
              ],
            ),
            const Icon(Icons.chevron_right, color: AppColors.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}
