import 'package:cloud_firestore/cloud_firestore.dart';

class CloudService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> getDiseaseInfo(String diseaseName) async {
    try {
      final doc = await _firestore.collection('diseases').doc(diseaseName).get();
      if (doc.exists) {
        return doc.data();
      } else {
        print("❌ Disease not found in Firestore: $diseaseName");
        return null;
      }
    } catch (e) {
      print("🔥 Firestore error: $e");
      return null;
    }
  }
}
