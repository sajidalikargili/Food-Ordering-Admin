import 'package:equatable/equatable.dart';
class AddProductState extends Equatable {
  const AddProductState();
  @override
  List<Object?> get props => [];
}
class InitialProductState extends AddProductState{
   const InitialProductState();
   @override
  List<Object?> get props => [];
}
class LoadingProductState extends AddProductState{
  const LoadingProductState();
  @override
  List<Object?> get props => [];
}
class SubmitProductState extends AddProductState{
  final String message;
  const  SubmitProductState({required this.message});
  @override
  List<Object?> get props => [this.message];
}
class  ErrorProductState extends AddProductState{
  final String error;
  const ErrorProductState({required this.error});
  @override
  List<Object?> get props => [this.error];
}