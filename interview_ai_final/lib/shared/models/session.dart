class InterviewSession {
  final String id;
  final String categoryName;
  final String dateString;
  final int score;
  final String question;
  final String userResponse;
  final String strengths;
  final String areasOfImprovement;
  final String suggestedRephrasing;

  InterviewSession({
    required this.id,
    required this.categoryName,
    required this.dateString,
    required this.score,
    required this.question,
    required this.userResponse,
    required this.strengths,
    required this.areasOfImprovement,
    required this.suggestedRephrasing,
  });

  factory InterviewSession.fromJson(Map<String, dynamic> json) {
    return InterviewSession(
      id: json['id'] as String,
      categoryName: json['categoryName'] as String,
      dateString: json['dateString'] as String,
      score: json['score'] as int,
      question: json['question'] as String,
      userResponse: json['userResponse'] as String,
      strengths: json['strengths'] as String,
      areasOfImprovement: json['areasOfImprovement'] as String,
      suggestedRephrasing: json['suggestedRephrasing'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'categoryName': categoryName,
      'dateString': dateString,
      'score': score,
      'question': question,
      'userResponse': userResponse,
      'strengths': strengths,
      'areasOfImprovement': areasOfImprovement,
      'suggestedRephrasing': suggestedRephrasing,
    };
  }
}
