import 'package:equatable/equatable.dart';
import 'package:foodie_admin/features/product/data/product_model.dart';
class AddProductEvent extends Equatable {
  const AddProductEvent();
  @override
  List<Object?> get props => [];
}
class AddProductSubmitted extends AddProductEvent{
  final AddProductModel addProductModel;
  const  AddProductSubmitted({required this.addProductModel});
  @override
  List<Object?> get props => [];
}