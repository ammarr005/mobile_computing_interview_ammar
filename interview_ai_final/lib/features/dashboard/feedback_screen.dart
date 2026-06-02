import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/typography.dart';
import '../../core/constants/constants.dart';
import '../../shared/widgets/custom_button.dart';
import '../../shared/widgets/custom_card.dart';
import '../../core/models/feedback_model.dart';

class FeedbackScreen extends StatelessWidget {
  final InterviewFeedback feedback;

  const FeedbackScreen({
    Key? key,
    required this.feedback,
  }) : super(key: key);

  String _getScoreLabel(int score) {
    if (score >= 90) return 'Outstanding';
    if (score >= 80) return 'Excellent';
    if (score >= 70) return 'Good';
    if (score >= 60) return 'Average';
    return 'Needs Improvement';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => context.go('/dashboard'),
        ),
        title: Text(
          'Interview Pro',
          style: AppTypography.headlineMedium.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            child: Container(
              constraints: const BoxConstraints(maxWidth: AppConstants.maxContentWidth),
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.marginPage,
                vertical: AppConstants.stackMd,
              ),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 160,
                        height: 160,
                        child: CircularProgressIndicator(
                          value: feedback.score / 100,
                          strokeWidth: 8.0,
                          backgroundColor: AppColors.secondaryFixedDim.withOpacity(0.3),
                          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.secondaryContainer),
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: '${feedback.score}',
                                  style: AppTypography.headlineLarge.copyWith(color: AppColors.primary, fontSize: 36),
                                ),
                                TextSpan(
                                  text: '/100',
                                  style: AppTypography.headlineSmall.copyWith(color: AppColors.onSurfaceVariant),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _getScoreLabel(feedback.score),
                            style: AppTypography.labelLarge.copyWith(color: AppColors.secondaryContainer, fontSize: 16),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: AppConstants.stackLg),

                  Text(feedback.score >= 70 ? 'Great Job!' : 'Keep Practicing!', style: AppTypography.headlineMedium),
                  const SizedBox(height: 8),
                  Text(
                    feedback.score >= 70 
                      ? 'Your response was strong and highly structured. A few minor tweaks could make it perfect.'
                      : 'You have a good start. Focus on the areas for improvement to elevate your response.',
                    style: AppTypography.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppConstants.stackXl),

                  CustomCard(
                    borderLeftColor: AppColors.primary,
                    borderRadius: 24.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.analytics, color: AppColors.primary, size: 24),
                            const SizedBox(width: 8),
                            Text('Detailed Feedback', style: AppTypography.headlineSmall),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.check_circle_outlined, size: 18, color: AppColors.primary),
                                      const SizedBox(width: 8),
                                      Text('Strengths', style: AppTypography.labelLarge.copyWith(color: AppColors.primary)),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  ...feedback.strengths.map((s) => _buildBulletPoint(s)).toList(),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.trending_up, size: 18, color: AppColors.error),
                                      const SizedBox(width: 8),
                                      Text('Improvements', style: AppTypography.labelLarge.copyWith(color: AppColors.error)),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  ...feedback.weaknesses.map((w) => _buildBulletPoint(w)).toList(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppConstants.stackLg),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24.0),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerHigh,
                      borderRadius: BorderRadius.circular(24.0),
                      boxShadow: const [
                        BoxShadow(color: Color(0x0A0F172A), blurRadius: 15),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.auto_awesome, color: AppColors.secondary, size: 24),
                            const SizedBox(width: 8),
                            Text('Model Response', style: AppTypography.headlineSmall),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainerLowest,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            feedback.modelAnswer,
                            style: AppTypography.bodySmall.copyWith(fontStyle: FontStyle.italic, height: 1.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppConstants.stackXl),

                  CustomButton(
                    text: 'Finish Session',
                    onPressed: () {
                      context.go('/dashboard');
                    },
                    icon: Icons.check_circle_outline,
                  ),
                  const SizedBox(height: AppConstants.stackMd),
                  CustomButton(
                    text: 'Practice Again',
                    type: ButtonType.secondary,
                    onPressed: () {
                      context.pop();
                    },
                    icon: Icons.refresh,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

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
}
