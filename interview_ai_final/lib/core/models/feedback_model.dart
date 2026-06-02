class InterviewFeedback {
  final int score;
  final List<String> strengths;
  final List<String> weaknesses;
  final String modelAnswer;

  InterviewFeedback({
    required this.score,
    required this.strengths,
    required this.weaknesses,
    required this.modelAnswer,
  });

  factory InterviewFeedback.fromJson(Map<String, dynamic> json) {
    return InterviewFeedback(
      score: json['score'],
      strengths: List<String>.from(json['strengths']),
      weaknesses: List<String>.from(json['weaknesses']),
      modelAnswer: json['model_answer'],
    );
  }
}
