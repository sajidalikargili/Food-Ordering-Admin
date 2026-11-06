import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodie_admin/features/review/data/model/review_model.dart';

class ReviewService {
  final FirebaseFirestore _firebaseFirestore;
  ReviewService({FirebaseFirestore? firebaseFirtore}):_firebaseFirestore=firebaseFirtore ?? FirebaseFirestore.instance;
Future<List<ReviewModel>> getReviews()async{
  final snapshot= await _firebaseFirestore.collection('reviews').get();
  return snapshot.docs.map((review){
    return ReviewModel.fromMap(review.id, review.data());
  }).toList();
}
Future<void> hiddenReviews(final bool isHidden,final String reviewId) async{
     await _firebaseFirestore.collection('reviews').doc(reviewId).update({'isHidden':isHidden});
}
Future<void> deleteReviews(final String reviewId) async{
    await _firebaseFirestore.collection('reviews').doc(reviewId).delete();
}
}