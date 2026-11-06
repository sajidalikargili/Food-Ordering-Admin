import 'package:equatable/equatable.dart';
import 'package:foodie_admin/features/setting/data/model/admin_model.dart';
abstract class AdminEvent extends Equatable {
  const AdminEvent();
  @override
  List<Object?> get props => [];
}
class LoadedAdminEvent extends AdminEvent{
  const LoadedAdminEvent();

}