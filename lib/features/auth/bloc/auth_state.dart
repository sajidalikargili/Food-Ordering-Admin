import 'package:equatable/equatable.dart';
abstract class AuthState extends Equatable{
  const AuthState();
  @override
  List<Object?> get props => [];
}
class InitialState extends AuthState{
   const  InitialState();
}
class LoadingState extends AuthState{
     const LoadingState();
}
class SuccessState extends AuthState{
      const SuccessState();
}
class ErrorState extends AuthState{
  final String error;
  ErrorState({required this.error});
  @override
  List<Object?> get props => [this.error];
}