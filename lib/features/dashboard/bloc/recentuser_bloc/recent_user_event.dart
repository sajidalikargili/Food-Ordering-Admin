import 'package:equatable/equatable.dart';
abstract class RecentUserEvent extends Equatable {
   const RecentUserEvent();
}
class  LoadRecentUserEvent extends RecentUserEvent{
  const LoadRecentUserEvent();
  @override
  List<Object?> get props => [];
}