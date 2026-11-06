import 'package:equatable/equatable.dart';
import 'package:foodie_admin/features/category/data/model/category_model.dart';
abstract class CategoryState extends Equatable {
  const CategoryState();
  @override
  List<Object?> get props => [];
}
class InitialCategoryState  extends CategoryState{
   const InitialCategoryState();
}
class LoadingCategoryState extends CategoryState{
 const LoadingCategoryState();
}
class LoadedCategoryState extends CategoryState{
  List<CategoryModel> categories;
  LoadedCategoryState({required this.categories});
  @override
  List<Object?> get props => [this.categories];
}
class  ErrorCategoryState extends CategoryState{
  final String  errorMessage;
  ErrorCategoryState({required this.errorMessage});
  @override
  List<Object?> get props => [this.errorMessage];
}