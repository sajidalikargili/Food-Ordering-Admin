import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:foodie_admin/features/dashboard/data/model/recent_user_model.dart';
abstract class RecentUserState extends Equatable {
  const RecentUserState();
  @override
  List<Object?> get props => [];
}
class InitialRecentUserState extends RecentUserState{
  const InitialRecentUserState();
}
class LoadingRecentUserState extends RecentUserState{
  const LoadingRecentUserState();
}
class LoadedRecentUserState extends RecentUserState{
  final List<RecentUserModel> recentUsers;
 const LoadedRecentUserState({required this.recentUsers});
   @override
  List<Object?> get props => [recentUsers];
}
class ErrorRecentUserState extends RecentUserState{
   final String Error;
 const ErrorRecentUserState({required this.Error});
   @override
  List<Object?> get props => [Error];
}