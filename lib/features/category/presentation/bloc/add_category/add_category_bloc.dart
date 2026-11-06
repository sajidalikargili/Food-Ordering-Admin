import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodie_admin/features/category/data/repository/category_repository.dart';
import 'package:foodie_admin/features/category/presentation/bloc/add_category/add_category_event.dart';
import 'package:foodie_admin/features/category/presentation/bloc/add_category/add_category_state.dart';
class AddCategoryBloc extends Bloc<AddCategory,AddCategoryState>{
   final CategoryRepository categoryRepository;
   AddCategoryBloc({required this.categoryRepository}):super(InitialAddCategory()){
     on<AddCategory>(_addCategory);
   }
   Future<void> _addCategory(AddCategory event,Emitter<AddCategoryState> emit) async{
        emit(LoadingAddCategory());
      try{
        await categoryRepository.addCategory(event.addCategoryModel);
        emit(SuccessFullAddCategory(message: "Category added successfully"));
      }catch(e){
        emit(ErrorAddCategory(errorMessage: e.toString()));
      }
   }
}