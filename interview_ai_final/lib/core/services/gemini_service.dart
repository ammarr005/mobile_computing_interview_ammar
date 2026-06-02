import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  late final GenerativeModel _model;

  GeminiService() {
    final apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
    _model = GenerativeModel(
      model: 'gemini-2.5-flash-lite',
      apiKey: apiKey,
    );
  }

  Future<String> generateInterviewQuestion({
    required String category,
  }) async {
    try {
      final response = await _model.generateContent([
        Content.text(
          'You are an expert interviewer. Generate exactly one challenging interview question for the category: "$category". '
          'Return only the plain text of the question, without any introductory or concluding remarks, explanations, or numberings.',
        )
      ]);
      return response.text?.trim() ?? 'No question generated';
    } catch (e) {
      return 'Error generating question: $e';
    }
  }

  Future<Map<String, dynamic>> evaluateAnswer({
    required String question,
    required String answer,
  }) async {
    try {
      final response = await _model.generateContent(
        [
          Content.text(
            'You are an expert interviewer. Evaluate the candidate\'s response to the following interview question.\n\n'
            'Question: "$question"\n'
            'Candidate\'s Answer: "$answer"\n\n'
            'Provide feedback strictly in JSON format with the following keys:\n'
            '- "score": an integer between 0 and 100\n'
            '- "strengths": a list of strings (2-3 items)\n'
            '- "weaknesses": a list of strings (2-3 items of areas for improvement)\n'
            '- "model_answer": a concise (3-4 sentences) exemplary answer that demonstrates how to answer this question perfectly.\n\n'
            'Your output must contain only valid JSON. Do not write any markdown code blocks or explanations outside of the JSON structure.'
          )
        ],
        generationConfig: GenerationConfig(responseMimeType: 'application/json'),
      );

      final text = response.text?.trim() ?? '{}';
      return jsonDecode(text) as Map<String, dynamic>;
    } catch (e) {
      return {
        'score': 0,
        'strengths': ['Could not evaluate response due to an error'],
        'weaknesses': ['Error details: $e'],
        'model_answer': 'N/A'
      };
    }
  }
}
