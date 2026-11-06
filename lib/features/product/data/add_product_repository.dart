import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodie_admin/features/product/data/product_model.dart';

class AddProductRepository {
  FirebaseFirestore _firebaseFirestore;
  AddProductRepository({FirebaseFirestore? firebaseFirestore}):_firebaseFirestore=firebaseFirestore?? FirebaseFirestore.instance;
  Future<void> addProduct(AddProductModel product) async{
    await _firebaseFirestore.collection('products').add(
     product.toMap()
    );
  }
}