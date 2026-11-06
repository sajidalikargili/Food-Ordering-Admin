import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodie_admin/features/product/data/add_product_repository.dart';
import 'package:foodie_admin/features/product/presentation/bloc/add_product_event.dart';
import 'package:foodie_admin/features/product/presentation/bloc/add_product_state.dart';
class AddProductBloc extends Bloc<AddProductEvent,AddProductState> {
    final AddProductRepository addProductRepository;
   AddProductBloc({required this.addProductRepository}):super(InitialProductState()){
     on<AddProductSubmitted>(_addProduct);
   }
   Future<void> _addProduct(AddProductSubmitted event,Emitter<AddProductState> emit) async{
        emit(LoadingProductState());
        try{
          await addProductRepository.addProduct(event.addProductModel);
          emit(SubmitProductState(message: "Product Added Successfully"));
        }catch(e){
          emit(ErrorProductState(error: e.toString()));
        }

   }
}