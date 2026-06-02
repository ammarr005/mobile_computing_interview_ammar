import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/typography.dart';
import '../../core/constants/constants.dart';
import '../../shared/widgets/custom_card.dart';
import '../../core/models/category_model.dart';
import '../../core/models/feedback_model.dart';
import '../../core/models/question_model.dart';
import '../../core/providers/api_providers.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class PracticeScreen extends ConsumerStatefulWidget {
  final Category category;

  const PracticeScreen({
    Key? key,
    required this.category,
  }) : super(key: key);

  @override
  ConsumerState<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends ConsumerState<PracticeScreen> {
  final _answerController = TextEditingController();
  int _charCount = 0;
  bool _isSubmitting = false;

  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _preSpeechText = '';
  int _preSpeechSelectionStart = -1;
  int _preSpeechSelectionEnd = -1;

  @override
  void initState() {
    super.initState();
    _answerController.addListener(_updateCharCount);
    _speech = stt.SpeechToText();
  }

  @override
  void dispose() {
    _answerController.removeListener(_updateCharCount);
    _answerController.dispose();
    if (_isListening) {
      _speech.stop();
    }
    super.dispose();
  }

  void _updateCharCount() {
    setState(() {
      _charCount = _answerController.text.length;
    });
  }

  Future<void> _startListening() async {
    try {
      bool available = await _speech.initialize(
        onStatus: (status) {
          if (status == 'notListening' || status == 'done') {
            if (mounted) {
              setState(() {
                _isListening = false;
              });
            }
          }
        },
        onError: (errorNotification) {
          if (mounted) {
            setState(() {
              _isListening = false;
            });
            String message = 'Speech recognition failed: ${errorNotification.errorMsg}';
            if (errorNotification.errorMsg.contains('permission') || 
                errorNotification.errorMsg.toLowerCase().contains('denied')) {
              message = 'Permission denied: Microphone access is required.';
            } else if (errorNotification.errorMsg.contains('service') || 
                       errorNotification.errorMsg.contains('unavailable')) {
              message = 'Speech unavailable: Recognition service is not available.';
            }
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(message),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
      );

      if (available) {
        _preSpeechText = _answerController.text;
        _preSpeechSelectionStart = _answerController.selection.start;
        _preSpeechSelectionEnd = _answerController.selection.end;

        if (mounted) {
          setState(() {
            _isListening = true;
          });
        }

        await _speech.listen(
          onResult: (result) {
            final recognizedWords = result.recognizedWords;
            String prefix = '';
            String suffix = '';

            if (_preSpeechSelectionStart >= 0 && _preSpeechSelectionEnd >= 0) {
              prefix = _preSpeechText.substring(0, _preSpeechSelectionStart);
              suffix = _preSpeechText.substring(_preSpeechSelectionEnd);
            } else {
              prefix = _preSpeechText;
              suffix = '';
            }

            final spacing = (prefix.isNotEmpty && !prefix.endsWith(' ')) ? ' ' : '';
            final newText = '$prefix$spacing$recognizedWords$suffix';

            if (mounted) {
              setState(() {
                _answerController.text = newText;
                final newCursorPosition = prefix.length + spacing.length + recognizedWords.length;
                _answerController.selection = TextSelection.collapsed(
                  offset: newCursorPosition,
                );
              });
            }
          },
        );
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Speech unavailable: Microphone permission denied or recognition not supported on this device.'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to initialize speech: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _stopListening() async {
    await _speech.stop();
    if (mounted) {
      setState(() {
        _isListening = false;
      });
    }
  }

  void _toggleListening() {
    if (_isListening) {
      _stopListening();
    } else {
      _startListening();
    }
  }

  Future<void> _submitAnswer(String questionText) async {
    final answerText = _answerController.text.trim();
    if (answerText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter an answer before submitting.')),
      );
      return;
    }

    if (_isSubmitting) return;

    setState(() => _isSubmitting = true);
    try {
      final userId = ref.read(authServiceProvider).getCurrentUserId();
      if (userId == null) {
        throw Exception('User is not logged in.');
      }

      final evaluationResult = await ref.read(geminiServiceProvider).evaluateAnswer(
        question: questionText,
        answer: answerText,
      );

      final feedback = InterviewFeedback.fromJson(evaluationResult);

      // Persist the completed session to Firestore and update user stats
      await ref.read(historyServiceProvider).saveSession(
        userId: userId,
        category: widget.category.title,
        question: questionText,
        answer: answerText,
        score: feedback.score,
        strengths: feedback.strengths,
        weaknesses: feedback.weaknesses,
        modelAnswer: feedback.modelAnswer,
      );

      // Invalidate cached statistics and history to trigger automatic UI refresh
      ref.invalidate(profileProvider);
      ref.invalidate(historyProvider);

      if (mounted) {
        context.push('/feedback', extra: feedback);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to submit answer: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Read category title and watch the live question generation provider
    final categoryTitle = widget.category.title;
    final questionAsync = ref.watch(geminiQuestionProvider(categoryTitle));

    return questionAsync.when(
      data: (questionText) {
        // Instantiate a Question model with the dynamic text for layout compatibility
        final currentQuestion = Question(
          id: 1,
          text: questionText,
          hint: 'Structure your response clearly and support it with examples.',
        );

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
              style: AppTypography.headlineMedium.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                constraints: const BoxConstraints(maxWidth: AppConstants.maxContentWidth),
                padding: const EdgeInsets.symmetric(horizontal: AppConstants.marginPage),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: AppConstants.stackMd),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(99),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.groups, size: 18, color: AppColors.primary),
                                const SizedBox(width: 8),
                                Text(
                                  categoryTitle,
                                  style: AppTypography.labelLarge.copyWith(color: AppColors.primary),
                                ),
                              ],
                            ),
                          ),
                          Text('Question 1 of 1', style: AppTypography.bodySmall),
                        ],
                      ),
                      const SizedBox(height: AppConstants.stackLg),

                      CustomCard(
                        borderLeftColor: AppColors.primary,
                        padding: 24.0,
                        borderRadius: 16.0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              currentQuestion.text,
                              style: AppTypography.headlineMedium,
                            ),
                            const SizedBox(height: AppConstants.stackSm),
                            if (currentQuestion.hint != null)
                              Text(
                                currentQuestion.hint!,
                                style: AppTypography.bodyMedium,
                              ),
                            const SizedBox(height: 16.0),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: TextButton.icon(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Hint: ${currentQuestion.hint}'),
                                      backgroundColor: AppColors.primary,
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.lightbulb_outline, size: 18, color: AppColors.primary),
                                label: Text(
                                  'Hint',
                                  style: AppTypography.buttonText.copyWith(color: AppColors.primary),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppConstants.stackLg),

                      Text('Your Response', style: AppTypography.labelLarge),
                      const SizedBox(height: AppConstants.stackSm),
                      SizedBox(
                        height: 240,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Container(
                              decoration: const BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0x0A0F172A),
                                    blurRadius: 15.0,
                                    spreadRadius: 0.0,
                                  ),
                                ],
                              ),
                              child: TextField(
                                controller: _answerController,
                                maxLines: null,
                                expands: true,
                                keyboardType: TextInputType.multiline,
                                textAlignVertical: TextAlignVertical.top,
                                style: AppTypography.bodyMedium.copyWith(
                                  color: AppColors.onSurface,
                                ),
                                cursorColor: AppColors.primary,
                                decoration: InputDecoration(
                                  hintText: 'Type your answer here or use the voice input...',
                                  hintStyle: TextStyle(color: AppColors.onSurfaceVariant.withOpacity(0.5)),
                                  filled: true,
                                  fillColor: AppColors.surfaceContainerLowest,
                                  contentPadding: const EdgeInsets.fromLTRB(16.0, 16.0, 80.0, 80.0), // Padding to prevent text overlap with overlay mic button/status
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16.0),
                                    borderSide: BorderSide(color: AppColors.outlineVariant.withOpacity(0.3)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16.0),
                                    borderSide: const BorderSide(color: AppColors.primary, width: 2.0),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 16,
                              right: 16,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (_isListening)
                                    Container(
                                      margin: const EdgeInsets.only(right: 12),
                                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: AppColors.primary.withOpacity(0.95),
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppColors.primary.withOpacity(0.3),
                                            blurRadius: 8,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const SizedBox(
                                                width: 8,
                                                height: 8,
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 1.5,
                                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                'Listening...',
                                                style: AppTypography.labelMedium.copyWith(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            'Tap to Stop',
                                            style: AppTypography.bodySmall.copyWith(
                                              color: Colors.white70,
                                              fontSize: 10,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    FloatingActionButton(
                                      onPressed: _toggleListening,
                                      backgroundColor: _isListening ? AppColors.error : AppColors.surfaceContainerLowest,
                                      elevation: 4.0,
                                      shape: const CircleBorder(),
                                      child: Icon(
                                        _isListening ? Icons.stop : Icons.mic,
                                        color: _isListening ? Colors.white : AppColors.primary,
                                        size: 24,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: AppConstants.stackSm),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('$_charCount / 1000 characters', style: AppTypography.labelMedium),
                          Text('Minimum 50 words recommended', style: AppTypography.labelMedium),
                        ],
                      ),
                      const SizedBox(height: 100.0), // Padding to allow scrolling past bottom sheet
                    ],
                  ),
                ),
              ),
            ),
          ),
          bottomSheet: Container(
            constraints: const BoxConstraints(maxWidth: AppConstants.maxContentWidth),
            padding: const EdgeInsets.symmetric(horizontal: AppConstants.marginPage, vertical: 16.0),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLowest.withOpacity(0.85),
              border: const Border(top: BorderSide(color: AppColors.outlineVariant, width: 0.5)),
            ),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: _isSubmitting
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      onPressed: () => _submitAnswer(questionText),
                      icon: const Icon(Icons.send, color: AppColors.onPrimary, size: 18),
                      label: Text('Submit Answer', style: AppTypography.buttonText),
                    ),
            ),
          ),
        );
      },
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (err, stack) => Scaffold(
        body: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: AppConstants.maxContentWidth - 100),
            padding: const EdgeInsets.symmetric(horizontal: AppConstants.marginPage),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: AppColors.error, size: 48),
                const SizedBox(height: 16),
                Text(
                  'Failed to generate question',
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
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      ref.invalidate(geminiQuestionProvider(categoryTitle));
                    },
                    child: const Text('Retry'),
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
