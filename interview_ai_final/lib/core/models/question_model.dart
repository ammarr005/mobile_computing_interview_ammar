class Question {
  final int id;
  final String text;
  final String? hint;

  Question({
    required this.id,
    required this.text,
    this.hint,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      text: json['text'],
      hint: json['hint'],
    );
  }
}
