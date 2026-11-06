import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodie_admin/features/review/data/service/review_service.dart';
import 'package:foodie_admin/features/review/presentation/bloc/review_event.dart';
import 'package:foodie_admin/features/review/presentation/bloc/review_state.dart';

class ReviewBloc extends Bloc<ReviewEvent,ReviewState> {
  ReviewService reviewService;
  ReviewBloc({required this.reviewService}):super(InitialReviewState()){
    on<LoadReviewEvent>(_loadedReview);
    on<DeleteReviewEvent>(_deleteReviewEvent);
    on<HiddenReviewEvent>(_hiddenReviewEvent);
  }
  Future<void> _loadedReview(LoadReviewEvent event,Emitter<ReviewState> emit) async{
     final reviewList= await reviewService.getReviews();
     emit(LoadingReviewState());
     try{
      emit(LoadedReviewState(reviewList: reviewList));
     }catch(e){
      emit(ErrorReviewState(errorMessage: e.toString()));
     }
  }
  Future<void> _hiddenReviewEvent(HiddenReviewEvent event,Emitter<ReviewState> emit) async{
       await  reviewService.hiddenReviews(event.isHidden, event.reviewId);
       final reviews = await reviewService.getReviews();
       emit(LoadedReviewState(reviewList: reviews));
  }
  Future<void> _deleteReviewEvent(DeleteReviewEvent event,Emitter<ReviewState> emit) async{
        await reviewService.deleteReviews(event.reviewId);
        final reviews = await reviewService.getReviews();
        emit(LoadedReviewState(reviewList: reviews));
  }

}