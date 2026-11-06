import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodie_admin/features/setting/data/model/admin_model.dart';

class AdminService {
  final FirebaseFirestore _firebaseFirestore;
  AdminService({FirebaseFirestore? firebaseFirestore})
    : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  Future<AdminModel> getAdminDetail() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) {
      throw Exception('Admin is not logged in');
    }

    final doc = await _firebaseFirestore.collection('users').doc(uid).get();

    final data = doc.data();

    if (data == null) {
      throw Exception('Admin details not found');
    }

    return AdminModel.fromMap(data);
  }
}
