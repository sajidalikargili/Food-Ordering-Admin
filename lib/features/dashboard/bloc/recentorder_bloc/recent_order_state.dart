 import 'package:equatable/equatable.dart';
import 'package:foodie_admin/features/dashboard/data/model/recent_order_model.dart';
abstract class RecentOrderState  extends Equatable{
  const RecentOrderState();
 }
 class InitialRecentOrderState extends RecentOrderState{
  const InitialRecentOrderState();
  @override
  List<Object?> get props => [];

 }
 class LoadingRecentOrderState extends RecentOrderState{
  const LoadingRecentOrderState();
  @override
  List<Object?> get props => [];

 }
 class  LoadedRecentOrderState extends RecentOrderState{
  List<RecentOrderModel> recentOrders;
  LoadedRecentOrderState({required this.recentOrders});
  @override
  List<Object?> get props => [recentOrders];
 }
 class ErrorRecentOrderState extends RecentOrderState{
  final String Error;
  ErrorRecentOrderState({required this.Error});
  @override
  List<Object?> get props => [Error];
 }