import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodie_admin/constant/routes/app_routes.dart';
import 'package:foodie_admin/constant/theme/app_theme.dart';
import 'package:foodie_admin/features/auth/bloc/auth_bloc.dart';
import 'package:foodie_admin/features/auth/service/auth_service.dart';
import 'package:foodie_admin/features/category/data/repository/category_repository.dart';
import 'package:foodie_admin/features/category/presentation/bloc/add_category/add_category_bloc.dart';
import 'package:foodie_admin/features/category/presentation/bloc/category_bloc.dart';
import 'package:foodie_admin/features/category/presentation/bloc/category_event.dart';
import 'package:foodie_admin/features/dashboard/bloc/dashboard_bloc/dashboard_bloc.dart';
import 'package:foodie_admin/features/dashboard/bloc/dashboard_bloc/dashboard_event.dart';
import 'package:foodie_admin/features/dashboard/bloc/recentorder_bloc/recent_order_bloc.dart';
import 'package:foodie_admin/features/dashboard/bloc/recentorder_bloc/recent_order_event.dart';
import 'package:foodie_admin/features/dashboard/bloc/recentuser_bloc/recent_user_bloc.dart';
import 'package:foodie_admin/features/dashboard/bloc/recentuser_bloc/recent_user_event.dart';
import 'package:foodie_admin/features/dashboard/data/service/recent_order_service.dart';
import 'package:foodie_admin/features/dashboard/data/service/recent_user_service.dart';
import 'package:foodie_admin/features/product/data/add_product_repository.dart';
import 'package:foodie_admin/features/product/presentation/bloc/add_product_bloc.dart';
import 'package:foodie_admin/features/review/data/service/review_service.dart';
import 'package:foodie_admin/features/review/presentation/bloc/review_bloc.dart';
import 'package:foodie_admin/features/review/presentation/bloc/review_event.dart';
import 'package:foodie_admin/features/setting/data/admin_service.dart';
import 'package:foodie_admin/features/setting/presentation/bloc/admin_bloc.dart';
import 'package:foodie_admin/firebase_options.dart';
import 'package:foodie_admin/routes/app_page.dart';
import 'package:foodie_admin/features/splash/splash_screen.dart';
import 'package:foodie_admin/theme/bloc/theme_bloc.dart';
import 'package:foodie_admin/theme/bloc/theme_event.dart';
import 'package:foodie_admin/theme/bloc/theme_state.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  final AuthService authService= AuthService();
  final RecentOrderService recentOrderService=RecentOrderService();
  final RecentUserService recentUserService=RecentUserService();
  final CategoryRepository categoryRepository=CategoryRepository();
  final AddProductRepository addProductRepository=AddProductRepository();
  final ReviewService reviewService=ReviewService();
  final AdminService adminService=AdminService();
  runApp(
      MultiBlocProvider(providers: [
BlocProvider(create: (_)=>ThemeBloc()..add(LoadTheme())),
BlocProvider(create: (_)=>AuthBloc(authService: authService)),
BlocProvider(create: (_)=>DashboardBloc()..add(LoadDashboardEvent())),
BlocProvider(create: (_)=>RecentOrderBloc(recentOrderService: recentOrderService)..add(LoadRecentOrderEvent())),
BlocProvider(create: (_)=>RecentUserBloc(recentUserService: recentUserService)..add(LoadRecentUserEvent())) ,
BlocProvider(create: (_)=>CategoryBloc(categoryRepository: categoryRepository)..add(LoadCategoryEvent())),
BlocProvider(create: (_)=>AddProductBloc(addProductRepository: addProductRepository)),
BlocProvider(create: (_)=>AddCategoryBloc(categoryRepository: categoryRepository)),
BlocProvider(create: (_)=>ReviewBloc(reviewService: reviewService)..add(LoadReviewEvent())),
BlocProvider(create: (_)=>AdminBloc(adminService: adminService))
    ], child: MyApp())
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
  return BlocBuilder<ThemeBloc,ThemeState>(builder: (context,state){
      return MaterialApp(
        debugShowCheckedModeBanner: false,
       title: 'Flutter Demo',

       theme: AppTheme.lightTheme,
       darkTheme: AppTheme.darkTheme,
       themeMode: state.themeMode,
       initialRoute: AppRoutes.splash,
       onGenerateRoute: AppPage.generateRouter,
     );
  });
  }
}



