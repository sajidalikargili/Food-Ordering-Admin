import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodie_admin/features/setting/data/admin_service.dart';
import 'package:foodie_admin/features/setting/presentation/bloc/admin_event.dart';
import 'package:foodie_admin/features/setting/presentation/bloc/admin_state.dart';

class AdminBloc extends Bloc<AdminEvent,AdminState> {
  final AdminService adminService;
  AdminBloc({required this.adminService}):super(InitialAdminState()){
    on<LoadedAdminEvent>(_loadedEvent);
  }
  Future<void> _loadedEvent(LoadedAdminEvent event ,Emitter<AdminState> emit)async{
     final adminData= await adminService.getAdminDetail();
      emit(LoadingAdminState());
      try{
        emit(LoadedAdminState(adminModel: adminData));
      }catch(e){
        emit(ErrorAdminState(messageError: e.toString()));
      }
  }
}