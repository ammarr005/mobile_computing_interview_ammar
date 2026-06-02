import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<Map<String, dynamic>> getProfile() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      throw Exception('User is not logged in');
    }
    final doc = await _firestore.collection('users').doc(uid).get();
    if (!doc.exists) {
      throw Exception('Profile document not found');
    }
    
    final data = doc.data();
    if (data == null) {
      throw Exception('Profile data is empty');
    }

    // Return the data directly. We map 'avg_score', 'total_sessions', 'streak' to stats sub-map for Dashboard backward compatibility.
    return {
      'full_name': data['full_name'],
      'email': data['email'],
      'photo_url': data['photo_url'] ?? data['avatar_url'] ?? '',
      'avg_score': data['avg_score'] ?? 0,
      'total_sessions': data['total_sessions'] ?? 0,
      'streak': data['streak'] ?? 0,
      'stats': {
        'avg_score': data['avg_score'] ?? 0,
        'total_sessions': data['total_sessions'] ?? 0,
      }
    };
  }

  Future<bool> updateProfile(String fullName, String? photoUrl) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return false;
    try {
      await _firestore.collection('users').doc(uid).update({
        'full_name': fullName,
        'photo_url': photoUrl,
        'avatar_url': photoUrl, // Maintain backward compatibility
      });
      return true;
    } catch (e) {
      return false;
    }
  }
}
