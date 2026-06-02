class SessionSummary {
  final String id;
  final DateTime date;
  final String title;
  final int score;
  final bool isCompleted;

  SessionSummary({
    required this.id,
    required this.date,
    required this.title,
    required this.score,
    required this.isCompleted,
  });

  factory SessionSummary.fromJson(Map<String, dynamic> json) {
    return SessionSummary(
      id: json['id'],
      date: DateTime.parse(json['date']),
      title: json['title'],
      score: json['score'],
      isCompleted: json['is_completed'],
    );
  }
}

class SessionDetail {
  final String id;
  final int overallScore;
  final String categoryTitle;
  final DateTime createdAt;
  final List<AnswerDetail> answers;

  SessionDetail({
    required this.id,
    required this.overallScore,
    required this.categoryTitle,
    required this.createdAt,
    required this.answers,
  });

  factory SessionDetail.fromJson(Map<String, dynamic> json) {
    return SessionDetail(
      id: json['id'],
      overallScore: json['overall_score'],
      categoryTitle: json['category_title'],
      createdAt: DateTime.parse(json['created_at']),
      answers: (json['answers'] as List)
          .map((i) => AnswerDetail.fromJson(i))
          .toList(),
    );
  }
}

class AnswerDetail {
  final String questionText;
  final String userAnswer;
  final int score;
  final List<String> strengths;
  final List<String> weaknesses;
  final String modelAnswer;

  AnswerDetail({
    required this.questionText,
    required this.userAnswer,
    required this.score,
    required this.strengths,
    required this.weaknesses,
    required this.modelAnswer,
  });

  factory AnswerDetail.fromJson(Map<String, dynamic> json) {
    return AnswerDetail(
      questionText: json['question_text'],
      userAnswer: json['user_answer'],
      score: json['score'],
      strengths: List<String>.from(json['strengths']),
      weaknesses: List<String>.from(json['weaknesses']),
      modelAnswer: json['model_answer'],
    );
  }
}
