import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodie_admin/features/dashboard/bloc/recentuser_bloc/recent_user_event.dart';
import 'package:foodie_admin/features/dashboard/bloc/recentuser_bloc/recent_user_state.dart';
import 'package:foodie_admin/features/dashboard/data/service/recent_user_service.dart';
class RecentUserBloc extends Bloc<RecentUserEvent, RecentUserState> {
  final RecentUserService recentUserService;

  RecentUserBloc({
    required this.recentUserService,
  }) : super(const InitialRecentUserState()) {
    on<LoadRecentUserEvent>(_loadRecentUser);
  }

  Future<void> _loadRecentUser(
      LoadRecentUserEvent event,
      Emitter<RecentUserState> emit,
      ) async {
    final recentUsers = await recentUserService.getRecentUsers();
    emit(LoadingRecentUserState());

    try {
      emit(LoadedRecentUserState(
        recentUsers: recentUsers,
      ));
    } catch (e) {
      emit(ErrorRecentUserState(
        Error: e.toString(),
      ));
    }
  }
}
