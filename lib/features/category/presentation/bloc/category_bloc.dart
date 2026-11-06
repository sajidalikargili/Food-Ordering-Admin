import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodie_admin/features/category/data/repository/category_repository.dart';
import 'package:foodie_admin/features/category/presentation/bloc/category_event.dart';
import 'package:foodie_admin/features/category/presentation/bloc/category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent,CategoryState> {
  final CategoryRepository categoryRepository;
    CategoryBloc({required this.categoryRepository}):super(InitialCategoryState()){
      on<LoadCategoryEvent>(_loadCategory);
    }
    Future<void> _loadCategory(LoadCategoryEvent event,Emitter<CategoryState> emit) async{
        final categories= await categoryRepository.categories();
           emit(LoadingCategoryState());
           try{
            emit(LoadedCategoryState(categories: categories));
           }catch(e){
            emit(ErrorCategoryState(errorMessage: e.toString()));
           }
    }
}