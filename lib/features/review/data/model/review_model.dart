import 'package:cloud_firestore/cloud_firestore.dart';
class ReviewModel {
  final String id;
  final String userName;
  final  String productName;
  final  double rating;
  final String  comment;
  final DateTime  date;
  final bool isHidden;
  ReviewModel({required this.id,required this.userName,required this.productName,required this.rating,required this.comment,required this.date,this.isHidden=false});
  factory ReviewModel.fromMap(
  final String id,
  Map<String,dynamic> data,
      ){
    return ReviewModel(id: id,userName: data['userName'] as String? ?? "UnKnow User",
        productName: data['productName'] as String? ?? "",
        rating: (data['rating'] as num)?.toDouble() ?? 0.0,
        comment: data['comment'] as String? ?? '',
        date:data['createdAt'] is Timestamp ? (data['createdAt'] as Timestamp).toDate() : data['createdAt'] is DateTime ? data['createdAt'] as DateTime :DateTime.now(),
        isHidden:data['isHidden'] as bool? ?? false);
  }
}