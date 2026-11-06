import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodie_admin/features/category/data/model/add_category_model.dart';
import 'package:foodie_admin/features/category/data/model/category_model.dart';

class CategoryRepository {
  FirebaseFirestore _firebaseFirestore;
  CategoryRepository({FirebaseFirestore? firebaseFirestore}):_firebaseFirestore=firebaseFirestore ?? FirebaseFirestore.instance;
 Future<List<CategoryModel>> categories() async{
    final snapshot= await _firebaseFirestore.collection('categories').get();
    return snapshot.docs.map((doc){
      return CategoryModel.fromMap(doc.id, doc.data());
    }).toList();
 }
 Future<void> addCategory(AddCategoryModel category) async{
  await _firebaseFirestore.collection('categories').add(category.toMap());
 }
}