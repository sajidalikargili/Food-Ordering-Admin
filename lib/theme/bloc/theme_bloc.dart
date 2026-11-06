import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodie_admin/theme/bloc/theme_event.dart';
import 'package:foodie_admin/theme/bloc/theme_state.dart';
import '../theme_repository/theme_respository.dart';
class ThemeBloc  extends Bloc <ThemeEvent,ThemeState>{
ThemeBloc():super(ThemeState(ThemeMode.light)){
  on<ThemeToggleEvent>((event,emit) async{
   ThemeMode theme= state.themeMode==ThemeMode.light ? ThemeMode.dark :ThemeMode.light;
   await ThemeRespository.saveTheme(theme);
      emit(ThemeState(theme));
 });
  on<LoadTheme>((event,emit) async{
     final theme=await ThemeRespository.getTheme();
     print('load_b_theme:${theme}');
     emit(ThemeState(theme));
  });
}

}