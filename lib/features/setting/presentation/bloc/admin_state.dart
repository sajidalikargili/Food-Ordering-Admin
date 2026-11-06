import 'package:equatable/equatable.dart';
import 'package:foodie_admin/features/setting/data/model/admin_model.dart';

abstract class AdminState extends Equatable {
 const AdminState();
 @override
  List<Object?> get props => [];
}
class InitialAdminState extends AdminState{
  const InitialAdminState();
}
class LoadingAdminState extends AdminState{
  const LoadingAdminState();
  @override
  List<Object?> get props => [];
}
class LoadedAdminState extends AdminState{
  final AdminModel adminModel;
  const LoadedAdminState({required this.adminModel});
  @override
  List<Object?> get props => [this.adminModel];
}
class ErrorAdminState extends AdminState{
  final String messageError;
  ErrorAdminState({required this.messageError});
  @override
  List<Object?> get props => [this.messageError];
}