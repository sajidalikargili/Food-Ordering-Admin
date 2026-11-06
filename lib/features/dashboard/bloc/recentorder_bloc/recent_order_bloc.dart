import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodie_admin/features/dashboard/bloc/recentorder_bloc/recent_order_event.dart';
import 'package:foodie_admin/features/dashboard/bloc/recentorder_bloc/recent_order_state.dart';
import 'package:foodie_admin/features/dashboard/data/service/recent_order_service.dart';

class RecentOrderBloc extends Bloc<RecentOrderEvent,RecentOrderState>{
 final RecentOrderService recentOrderService;
  RecentOrderBloc({required this.recentOrderService}):super(InitialRecentOrderState()){
    on<RecentOrderEvent>(_loadRecentOrder);
  }
  Future<void> _loadRecentOrder(RecentOrderEvent event,Emitter<RecentOrderState> emit) async{
    final recentOrders= await  recentOrderService.getRecentOrder();
     emit(LoadingRecentOrderState());
     try{
      emit(LoadedRecentOrderState(recentOrders: recentOrders));
     }catch(e){
      emit(ErrorRecentOrderState(Error: e.toString()));
     }
  }
}