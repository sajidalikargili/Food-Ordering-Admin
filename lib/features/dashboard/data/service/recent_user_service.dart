import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodie_admin/features/dashboard/data/model/recent_user_model.dart';

class RecentUserService {
  FirebaseFirestore _firebaseFirestore;
  RecentUserService({FirebaseFirestore? firebaseFirestore}):_firebaseFirestore=firebaseFirestore?? FirebaseFirestore.instance;
  Future<List<RecentUserModel>> getRecentUsers() async{
      final snapshot=await _firebaseFirestore.collection('users').limit(5).get();
       return snapshot.docs.map((doc){
          final data=doc.data();
          final name=(data['name'] ?? 'Unknown  User').toString();
          final email=(data['email'] ?? '').toString();
          final rawRole = (data['role'] ?? 'user').toString();
          final role = rawRole.toLowerCase() == 'foodie admin'
              ? 'admin'
              : rawRole;

          return RecentUserModel(id: doc.id, name: name,email: email ,role: role);
               }).toList();

  }
}