import 'package:equatable/equatable.dart';
import 'package:foodie_admin/features/auth/bloc/auth_state.dart';
import 'package:foodie_admin/features/dashboard/data/model/dashboard_model.dart';
class DashboardState extends Equatable {
 const DashboardState();
  @override
  List<Object?> get props => [];
}
class InitialDashboardState extends DashboardState{
  const InitialDashboardState();
}
class LoadingDashboardState extends DashboardState{
  const LoadingDashboardState();
}
class LoadedDashboardState extends DashboardState{
  final DashboardModel dashboardData;
  LoadedDashboardState({required this.dashboardData});
  @override
  List<Object?> get props => [dashboardData];
}
class ErrorDashboardState extends DashboardState{
  final String Error;
  ErrorDashboardState({required this.Error});
  @override
  List<Object?> get props => [Error];
}