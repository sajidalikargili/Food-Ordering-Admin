import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodie_admin/features/auth/bloc/auth_event.dart';
import 'package:foodie_admin/features/auth/bloc/auth_state.dart';
import 'package:foodie_admin/features/auth/service/auth_service.dart';
class AuthBloc extends Bloc<AuthEvent,AuthState>{
 final AuthService authService;
   AuthBloc({required this.authService}):super(const InitialState()){
     on<LoginEvent>(_login);
     on<LogoutEvent>(_logout);
   }
   Future<void> _login(LoginEvent event,Emitter<AuthState> emit) async{
       emit( const LoadingState());
     try{
       await authService.login(email: event.email, password: event.password);
       emit( const SuccessState());
     }catch(e){
       emit(ErrorState(error: e.toString()));
     }
   }
 Future<void> _logout(LogoutEvent event,Emitter<AuthState> emit)async{
     emit(const LoadingState());
     try{
       await authService.logout();
       emit(const SuccessState());
     }catch(e){
       emit(ErrorState(error: e.toString()));
     }
  }
}