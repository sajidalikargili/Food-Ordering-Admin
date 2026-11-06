import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodie_admin/features/dashboard/bloc/dashboard_bloc/dashboard_event.dart';
import 'package:foodie_admin/features/dashboard/bloc/dashboard_bloc/dashboard_state.dart';
import 'package:foodie_admin/features/dashboard/data/service/dashboard_service.dart';
class DashboardBloc extends Bloc<DashboardEvent,DashboardState> {
   DashboardBloc():super(InitialDashboardState()){
     on<LoadDashboardEvent>(_loadEvent);
   }
   Future<void> _loadEvent(LoadDashboardEvent event,Emitter<DashboardState> emit) async{
        final dashboardData=  await DashboardService().getDashboardData();
         emit(LoadingDashboardState());
        try{
          emit(LoadedDashboardState(dashboardData: dashboardData));
        }catch(e){
          emit(ErrorDashboardState(Error: e.toString()));
        }
   }
}