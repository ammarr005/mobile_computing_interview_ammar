import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/auth_service.dart';
import '../services/history_service.dart';
import '../services/profile_service.dart';
import '../services/gemini_service.dart';
import '../models/category_model.dart';
import '../models/session_model.dart';

final authServiceProvider = Provider((ref) {
  return AuthService();
});

final geminiServiceProvider = Provider((ref) {
  return GeminiService();
});

final historyServiceProvider = Provider((ref) {
  return HistoryService();
});

final profileServiceProvider = Provider((ref) {
  return ProfileService();
});

final categoriesProvider = FutureProvider<List<Category>>((ref) async {
  try {
    final snapshot = await FirebaseFirestore.instance.collection('categories').get();
    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Category(
          id: (data['id'] ?? int.tryParse(doc.id) ?? 0) as int,
          title: data['title'] ?? '',
          subtitle: data['subtitle'] ?? '',
          iconKey: data['icon_key'] ?? '',
        );
      }).toList();
    }
  } catch (e) {
    // Suppress error and fallback to static list
  }

  // Fallback static list
  return [
    Category(
      id: 1,
      title: "Software Engineering",
      subtitle: "Coding, Algorithms & Data Structures",
      iconKey: "code",
    ),
    Category(
      id: 2,
      title: "Behavioral",
      subtitle: "Leadership, STAR Method & Core Values",
      iconKey: "psychology",
    ),
    Category(
      id: 3,
      title: "System Design",
      subtitle: "Scalability, Databases & Architecture",
      iconKey: "storage",
    ),
    Category(
      id: 4,
      title: "Product Management",
      subtitle: "Product Strategy, Estimation & Metrics",
      iconKey: "view_kanban",
    ),
  ];
});

final historyProvider = FutureProvider<List<SessionSummary>>((ref) async {
  final userId = ref.read(authServiceProvider).getCurrentUserId();
  if (userId == null) {
    return [];
  }
  return ref.watch(historyServiceProvider).getHistory(userId);
});

final sessionDetailProvider = FutureProvider.family<SessionDetail, String>((ref, sessionId) async {
  return ref.watch(historyServiceProvider).getSessionDetail(sessionId);
});

final profileProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  return ref.watch(profileServiceProvider).getProfile();
});

final geminiQuestionProvider = FutureProvider.family<String, String>((ref, category) async {
  return ref.watch(geminiServiceProvider).generateInterviewQuestion(category: category);
});
