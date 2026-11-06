import 'package:equatable/equatable.dart';
abstract class AddCategoryState extends Equatable {
  const AddCategoryState();
  @override
  List<Object?> get props => [];
}
class InitialAddCategory extends AddCategoryState{
    const InitialAddCategory();
}
class LoadingAddCategory extends AddCategoryState{
  const LoadingAddCategory();
}
class SuccessFullAddCategory extends AddCategoryState{
  final String message;
  const SuccessFullAddCategory({required this.message});
}
class  ErrorAddCategory extends AddCategoryState{
  final String errorMessage;
 const ErrorAddCategory({required this.errorMessage});
}