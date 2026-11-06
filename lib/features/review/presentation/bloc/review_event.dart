import 'package:equatable/equatable.dart';
import 'package:foodie_admin/features/review/data/model/review_model.dart';
abstract class ReviewEvent extends Equatable {
   const ReviewEvent();
  @override
  List<Object?> get props => [];
}
class  LoadReviewEvent extends ReviewEvent{
 const LoadReviewEvent();
}
class HiddenReviewEvent extends ReviewEvent{
  final bool isHidden;
  final String reviewId;
 const  HiddenReviewEvent({required this.reviewId,required this.isHidden});
}
class DeleteReviewEvent extends ReviewEvent{
  final String reviewId;
  const DeleteReviewEvent({required this.reviewId});
}