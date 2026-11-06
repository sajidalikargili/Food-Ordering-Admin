import 'package:equatable/equatable.dart';

abstract class RecentOrderEvent extends Equatable {
const RecentOrderEvent();
}
class LoadRecentOrderEvent extends RecentOrderEvent{
  const LoadRecentOrderEvent();
  @override
  List<Object?> get props => [];
}