import 'package:equatable/equatable.dart';
import 'package:foodie_admin/features/category/data/model/add_category_model.dart';
abstract  class AddCategoryEvent extends Equatable{
  const AddCategoryEvent();
  @override
  List<Object?> get props => [];
}
class AddCategory extends AddCategoryEvent{
  final AddCategoryModel addCategoryModel;
  const AddCategory({required this.addCategoryModel});
}