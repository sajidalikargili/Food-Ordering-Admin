import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodie_admin/features/auth/screen/login_screen.dart';
import 'package:foodie_admin/features/category/category_screen.dart';
import 'package:foodie_admin/features/order/order_screen.dart';
import 'package:foodie_admin/features/product/presentation/product_screen.dart';
import 'package:foodie_admin/features/review/review_screen.dart';
import 'package:foodie_admin/features/setting/presentation/screen/setting_screen.dart';
import 'package:foodie_admin/features/splash/splash_screen.dart';
import 'package:foodie_admin/features/users/users_screen.dart';
import '../constant/routes/app_routes.dart';
import '../features/dashboard/presentation/screen/dashboard_screen.dart';
class AppPage {
static Route<dynamic> generateRouter(RouteSettings setting){
  switch(setting.name){
    case AppRoutes.splash:
      return MaterialPageRoute(builder: (_)=>SplashScreen());
    case AppRoutes.dashboard:
      return MaterialPageRoute(builder: (_)=> DashboardScreen());
    case AppRoutes.login:
      return MaterialPageRoute(builder: (_)=>LoginScreen());
    case AppRoutes.product:
      return MaterialPageRoute(builder: (_)=>ProductScreen());
    case AppRoutes.category:
      return MaterialPageRoute(builder: (_)=>CategoryScreen());
    case AppRoutes.review:
      return MaterialPageRoute(builder: (_)=>ReviewScreen());
    case AppRoutes.setting:
      return MaterialPageRoute(builder: (_)=>SettingScreen());
    case AppRoutes.users:
      return MaterialPageRoute(builder: (_)=>UsersScreen());
    case AppRoutes.order:
      return MaterialPageRoute(builder: (_)=>OrderScreen());
    default:
      return MaterialPageRoute(builder:(_)=>Center(
        child: Text("Route not Found"),
      ) );
  }
}

}