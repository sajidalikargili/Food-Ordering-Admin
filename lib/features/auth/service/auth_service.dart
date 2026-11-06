import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:foodie_admin/constant/routes/app_routes.dart';
class AuthService {
 final FirebaseAuth firebaseAuth;
 AuthService({FirebaseAuth? firebaseAuth}):firebaseAuth =firebaseAuth ?? FirebaseAuth.instance;
 Future<UserCredential> login({required String email,required String password }) async{
     return await  firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
 }
 Future<void> logout() async{
   try{
      await firebaseAuth.signOut();
   }catch(e){
     debugPrint('Logout error: $e');
   }
 }

}