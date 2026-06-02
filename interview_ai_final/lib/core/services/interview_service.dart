import '../api/api_client.dart';
import '../models/category_model.dart';
import '../models/question_model.dart';
import '../models/feedback_model.dart';

class InterviewService {
  final ApiClient _apiClient;

  InterviewService(this._apiClient);

  Future<List<Category>> getCategories() async {
    final response = await _apiClient.get('/categories');
    return (response.data as List).map((i) => Category.fromJson(i)).toList();
  }

  Future<Map<String, dynamic>> startInterview(int categoryId) async {
    final response = await _apiClient.post('/interview/start', data: {
      'category_id': categoryId,
    });
    return {
      'session_id': response.data['session_id'],
      'questions': (response.data['questions'] as List)
          .map((i) => Question.fromJson(i))
          .toList(),
    };
  }

  Future<InterviewFeedback> evaluateAnswer(
    String sessionId,
    int questionId,
    String userAnswer,
  ) async {
    final response = await _apiClient.post('/interview/evaluate', data: {
      'session_id': sessionId,
      'question_id': questionId,
      'user_answer': userAnswer,
    });
    return InterviewFeedback.fromJson(response.data);
  }

  Future<int> finishInterview(String sessionId) async {
    final response = await _apiClient.post('/interview/finish', data: {
      'session_id': sessionId,
    });
    return response.data['overall_score'];
  }
}
