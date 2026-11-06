import 'package:equatable/equatable.dart';
import 'package:foodie_admin/features/review/data/model/review_model.dart';
class ReviewState extends Equatable{
 const ReviewState();
  @override
  List<Object?> get props => [];
}
class InitialReviewState extends ReviewState{
  const InitialReviewState();
}
class  LoadingReviewState extends ReviewState{
  const LoadingReviewState();
}
class LoadedReviewState extends ReviewState {
   final List<ReviewModel> reviewList;
   LoadedReviewState({required this.reviewList});
   @override
  List<Object?> get props => [reviewList];
}
class  ErrorReviewState extends ReviewState{
    final String errorMessage;
    ErrorReviewState({required this.errorMessage});
}