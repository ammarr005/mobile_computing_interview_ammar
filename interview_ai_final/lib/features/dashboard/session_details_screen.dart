import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/typography.dart';
import '../../core/constants/constants.dart';
import '../../shared/widgets/custom_card.dart';
import '../../core/providers/api_providers.dart';
import '../../core/models/session_model.dart';

class SessionDetailsScreen extends ConsumerWidget {
  final String sessionId;

  const SessionDetailsScreen({
    Key? key,
    required this.sessionId,
  }) : super(key: key);

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(
            child: Text(
              text,
              style: AppTypography.bodySmall,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(sessionDetailProvider(sessionId));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Session Details',
          style: AppTypography.headlineMedium.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: detailAsync.when(
            data: (detail) {
              final answer = detail.answers.isNotEmpty
                  ? detail.answers[0]
                  : AnswerDetail(
                      questionText: '',
                      userAnswer: '',
                      score: 0,
                      strengths: [],
                      weaknesses: [],
                      modelAnswer: '',
                    );

              return SingleChildScrollView(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: AppConstants.maxContentWidth),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.marginPage,
                    vertical: AppConstants.stackMd,
                  ),
                  child: Column(
                    children: [
                      // Overall Score Bento panel
                      CustomCard(
                        borderLeftColor: AppColors.primary,
                        borderRadius: 24.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Overall Score',
                                  style: AppTypography.headlineSmall,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${detail.categoryTitle} - ${DateFormat('MMM dd, yyyy').format(detail.createdAt)}',
                                  style: AppTypography.bodySmall,
                                ),
                              ],
                            ),
                            // Circular Chart Score
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                SizedBox(
                                  width: 64,
                                  height: 64,
                                  child: CircularProgressIndicator(
                                    value: detail.overallScore / 100.0,
                                    strokeWidth: 4.0,
                                    backgroundColor: AppColors.surfaceVariant,
                                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.secondary),
                                  ),
                                ),
                                Text(
                                  '${detail.overallScore}',
                                  style: AppTypography.headlineSmall.copyWith(color: AppColors.secondaryContainer, fontSize: 16),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: AppConstants.stackLg),

                      // The Question Card section
                      CustomCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.help, color: AppColors.primary, size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  'THE QUESTION',
                                  style: AppTypography.labelLarge.copyWith(color: AppColors.primary, letterSpacing: 1.5),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppConstants.stackSm),
                            Text(
                              answer.questionText,
                              style: AppTypography.bodyMedium.copyWith(color: AppColors.onSurface),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppConstants.stackLg),

                      // User Response Card
                      CustomCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.record_voice_over, color: AppColors.tertiaryContainer, size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  'YOUR RESPONSE',
                                  style: AppTypography.labelLarge.copyWith(color: AppColors.tertiaryContainer, letterSpacing: 1.5),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppConstants.stackSm),
                            Text(
                              answer.userAnswer,
                              style: AppTypography.bodyMedium.copyWith(height: 1.6),
                            ),
                            const SizedBox(height: 16),
                            // Custom Audio feedback bar
                            Row(
                              children: [
                                OutlinedButton.icon(
                                  style: OutlinedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(99.0),
                                    ),
                                  ),
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Audio recording playback is not implemented in persist mode.'),
                                        backgroundColor: AppColors.primary,
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.play_arrow),
                                  label: const Text('Listen Audio'),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  '--:--',
                                  style: AppTypography.bodySmall,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppConstants.stackLg),

                      // Expert AI Feedback Panel
                      CustomCard(
                        child: Stack(
                          children: [
                            // Ambient glow indicator
                            Positioned(
                              top: -10,
                              right: -10,
                              child: Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.insights, color: AppColors.secondary, size: 20),
                                    const SizedBox(width: 8),
                                    Text(
                                      'EXPERT AI FEEDBACK',
                                      style: AppTypography.labelLarge.copyWith(color: AppColors.secondary, letterSpacing: 1.5),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: AppConstants.stackLg),
                                // Strengths Block
                                Row(
                                  children: [
                                    const Icon(Icons.check_circle_outlined, color: AppColors.success, size: 18),
                                    const SizedBox(width: 8),
                                    Text('Strengths', style: AppTypography.labelLarge),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                ...answer.strengths.map((s) => _buildBulletPoint(s)).toList(),
                                const SizedBox(height: 16),
                                // Areas for progress Block
                                Row(
                                  children: [
                                    const Icon(Icons.lightbulb_outline, color: Colors.orange, size: 18),
                                    const SizedBox(width: 8),
                                    Text('Areas for Improvement', style: AppTypography.labelLarge),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                ...answer.weaknesses.map((w) => _buildBulletPoint(w)).toList(),
                                const SizedBox(height: 16),
                                // suggested rephrasal
                                Container(
                                  padding: const EdgeInsets.all(16.0),
                                  decoration: BoxDecoration(
                                    color: AppColors.inverseOnSurface,
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'SUGGESTED REPHRASING',
                                        style: AppTypography.labelMedium.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold, letterSpacing: 1.0),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        answer.modelAnswer,
                                        style: AppTypography.bodySmall.copyWith(fontStyle: FontStyle.italic),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
            error: (err, stack) => Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, color: AppColors.error, size: 48),
                    const SizedBox(height: 16),
                    Text(
                      'Failed to load session details',
                      style: AppTypography.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      err.toString(),
                      style: AppTypography.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                      ),
                      onPressed: () => ref.invalidate(sessionDetailProvider(sessionId)),
                      child: const Text('Retry'),
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
