import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/typography.dart';
import '../../core/constants/constants.dart';
import '../../shared/widgets/custom_button.dart';
import '../../shared/widgets/custom_card.dart';

class OnboardingScreens extends StatefulWidget {
  const OnboardingScreens({Key? key}) : super(key: key);

  @override
  State<OnboardingScreens> createState() => _OnboardingScreensState();
}

class _OnboardingScreensState extends State<OnboardingScreens> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.animateToPage(
        _currentPage + 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else {
      context.go('/register');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          if (_currentPage < 2)
            TextButton(
              onPressed: () {
                context.go('/register');
              },
              child: Text(
                'Skip',
                style: AppTypography.buttonText.copyWith(color: AppColors.primary),
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: AppConstants.maxContentWidth),
            padding: const EdgeInsets.symmetric(horizontal: AppConstants.marginPage),
            child: Column(
              children: [
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (page) {
                      setState(() {
                        _currentPage = page;
                      });
                    },
                    children: [
                      _buildPage1(),
                      _buildPage2(),
                      _buildPage3(),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: AppConstants.stackLg),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Styled Page Indicator Dots
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(3, (index) {
                          bool isActive = index == _currentPage;
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            margin: const EdgeInsets.symmetric(horizontal: 4.0),
                            height: 10,
                            width: isActive ? 24 : 10,
                            decoration: BoxDecoration(
                              color: isActive ? AppColors.primary : AppColors.outlineVariant,
                              borderRadius: BorderRadius.circular(5),
                              boxShadow: isActive
                                  ? [
                                      BoxShadow(
                                        color: AppColors.primary.withOpacity(0.3),
                                        blurRadius: 10,
                                      )
                                    ]
                                  : null,
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: AppConstants.stackLg),
                      CustomButton(
                        text: _currentPage == 2 ? 'Get Started' : 'Next',
                        onPressed: _nextPage,
                        icon: _currentPage == 0 ? Icons.arrow_forward : null,
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

  Widget _buildPage1() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // 3D Illustration Mock Container
        Container(
          width: double.infinity,
          height: 300,
          margin: const EdgeInsets.only(bottom: AppConstants.stackXl),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLow,
            borderRadius: BorderRadius.circular(32.0),
            border: Border.all(color: AppColors.surfaceContainerHigh),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Clean graphical background representation of mock setup
              Positioned(
                bottom: 20,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 50,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.person, color: AppColors.outline),
                    ),
                    const SizedBox(width: 40),
                    Container(
                      width: 70,
                      height: 70,
                      decoration: const BoxDecoration(
                        color: AppColors.primaryContainer,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.psychology, color: Colors.white, size: 36),
                    ),
                  ],
                ),
              ),
              const Positioned(
                top: 40,
                child: Text(
                  'Interview Practice',
                  style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        ),
        Text(
          'Master Your Interviews',
          style: AppTypography.headlineLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppConstants.stackMd),
        Text(
          'Practice realistic mock interviews tailored to your industry and get instant feedback.',
          style: AppTypography.bodyLarge,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildPage2() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Phone mockup container with score ring and feedback points
        Container(
          width: 250,
          height: 320,
          margin: const EdgeInsets.only(bottom: AppConstants.stackXl),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(32.0),
            border: Border.all(color: AppColors.surfaceContainerHigh, width: 4.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 30.0,
                offset: const Offset(0, 15),
              ),
            ],
          ),
          child: Column(
            children: [
              // App Bar inner mockup
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Live Analysis', style: AppTypography.labelLarge.copyWith(fontSize: 12)),
                    const Icon(Icons.graphic_eq, color: AppColors.primary, size: 16),
                  ],
                ),
              ),
              const Divider(height: 1, color: AppColors.outlineVariant),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      // Ring
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 80,
                            height: 80,
                            child: CircularProgressIndicator(
                              value: 0.85,
                              strokeWidth: 6.0,
                              backgroundColor: AppColors.outlineVariant.withOpacity(0.3),
                              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.secondary),
                            ),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('85', style: AppTypography.headlineSmall.copyWith(fontSize: 18)),
                              Text('Strong', style: AppTypography.labelMedium.copyWith(color: AppColors.secondary, fontSize: 8)),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 12.0),
                      // Mock feedback items
                      Expanded(
                        child: ListView(
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            CustomCard(
                              padding: 6,
                              borderRadius: 8,
                              borderLeftColor: AppColors.primary,
                              backgroundColor: AppColors.background,
                              child: Row(
                                children: [
                                  const Icon(Icons.format_list_bulleted, size: 14, color: AppColors.primary),
                                  const SizedBox(width: 8),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Structure', style: AppTypography.labelMedium.copyWith(fontSize: 8, fontWeight: FontWeight.bold)),
                                      Text('Clear STAR method detected.', style: AppTypography.labelMedium.copyWith(fontSize: 7)),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(height: 6),
                            CustomCard(
                              padding: 6,
                              borderRadius: 8,
                              borderLeftColor: AppColors.secondary,
                              backgroundColor: AppColors.background,
                              child: Row(
                                children: [
                                  const Icon(Icons.record_voice_over, size: 14, color: AppColors.secondary),
                                  const SizedBox(width: 8),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Tone', style: AppTypography.labelMedium.copyWith(fontSize: 8, fontWeight: FontWeight.bold)),
                                      Text('Confident pacing, good clarity.', style: AppTypography.labelMedium.copyWith(fontSize: 7)),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Text(
          'Real-time AI Feedback',
          style: AppTypography.headlineLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppConstants.stackMd),
        Text(
          'Our AI analyzes your responses for structure, tone, and content to provide actionable insights.',
          style: AppTypography.bodyLarge,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildPage3() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Trophy illustration mockup representation
        Container(
          width: double.infinity,
          height: 300,
          margin: const EdgeInsets.only(bottom: AppConstants.stackXl),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLow,
            borderRadius: BorderRadius.circular(32.0),
            border: Border.all(color: AppColors.surfaceContainerHigh),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Golden Trophy Concept vector mock
              Positioned(
                top: 40,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.emoji_events, size: 50, color: Colors.orange),
                ),
              ),
              // Upward arrow
              Positioned(
                bottom: 40,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 10,
                      )
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.trending_up, color: AppColors.primary),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Interview Score', style: AppTypography.labelMedium),
                          Text('+24%', style: AppTypography.headlineSmall.copyWith(color: AppColors.primary)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Text(
          'Track Your Growth',
          style: AppTypography.headlineLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppConstants.stackMd),
        Text(
          'Save your sessions, review history, and watch your interview skills improve over time.',
          style: AppTypography.bodyLarge,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
