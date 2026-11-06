import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeRespository {
  static const String sp_key="theme";
static Future<void> saveTheme(ThemeMode themeMode) async {
   print('pref_save_theme:${themeMode}');
    final sharePref= await SharedPreferences.getInstance();
       sharePref.setBool(sp_key, themeMode==ThemeMode.dark);
  }
 static Future<ThemeMode> getTheme() async{
    final sharePref= await SharedPreferences.getInstance();
   final isDark= sharePref.getBool(sp_key) ??  false;
   print('pref_load_theme:${isDark}');
  return isDark ? ThemeMode.dark : ThemeMode.light;
  }
}