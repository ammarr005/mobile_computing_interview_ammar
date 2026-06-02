import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/session_model.dart';

class HistoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveSession({
    required String userId,
    required String category,
    required String question,
    required String answer,
    required int score,
    required List<String> strengths,
    required List<String> weaknesses,
    required String modelAnswer,
  }) async {
    final sessionRef = _firestore.collection('sessions').doc();
    final userRef = _firestore.collection('users').doc(userId);

    await _firestore.runTransaction((transaction) async {
      // 1. Read user document stats first (All reads must execute before all writes)
      final userSnapshot = await transaction.get(userRef);

      // 2. Write the completed interview session doc
      transaction.set(sessionRef, {
        'user_id': userId,
        'category': category,
        'question': question,
        'answer': answer,
        'score': score,
        'strengths': strengths,
        'weaknesses': weaknesses,
        'model_answer': modelAnswer,
        'created_at': FieldValue.serverTimestamp(),
      });

      // 3. Atomically update user document statistics if the user document exists
      if (userSnapshot.exists) {
        final data = userSnapshot.data();
        if (data != null) {
          final currentTotal = (data['total_sessions'] ?? 0) as int;
          final currentAvg = (data['avg_score'] ?? 0) as int;
          
          final newTotal = currentTotal + 1;
          final newAvg = ((currentAvg * currentTotal) + score) ~/ newTotal;

          transaction.update(userRef, {
            'total_sessions': newTotal,
            'avg_score': newAvg,
            'last_practice_date': FieldValue.serverTimestamp(),
          });
        }
      }
    });
  }

  Future<List<SessionSummary>> getHistory(String userId) async {
    final querySnapshot = await _firestore
        .collection('sessions')
        .where('user_id', isEqualTo: userId)
        .get();

    final sessions = querySnapshot.docs.map((doc) {
      final data = doc.data();
      final createdAt = data['created_at'] as Timestamp?;
      return SessionSummary(
        id: doc.id,
        date: createdAt?.toDate() ?? DateTime.now(),
        title: data['category'] ?? 'Session',
        score: data['score'] ?? 0,
        isCompleted: true,
      );
    }).toList();

    // Sort client-side by date descending to bypass Firestore composite index requirement
    sessions.sort((a, b) => b.date.compareTo(a.date));
    return sessions;
  }

  Future<SessionDetail> getSessionDetail(String sessionId) async {
    final docSnapshot = await _firestore.collection('sessions').doc(sessionId).get();
    if (!docSnapshot.exists) {
      throw Exception('Session details not found');
    }
    final data = docSnapshot.data()!;
    final createdAt = data['created_at'] as Timestamp?;

    return SessionDetail(
      id: docSnapshot.id,
      overallScore: data['score'] ?? 0,
      categoryTitle: data['category'] ?? 'Session',
      createdAt: createdAt?.toDate() ?? DateTime.now(),
      answers: [
        AnswerDetail(
          questionText: data['question'] ?? '',
          userAnswer: data['answer'] ?? '',
          score: data['score'] ?? 0,
          strengths: List<String>.from(data['strengths'] ?? []),
          weaknesses: List<String>.from(data['weaknesses'] ?? []),
          modelAnswer: data['model_answer'] ?? '',
        )
      ],
    );
  }
}
