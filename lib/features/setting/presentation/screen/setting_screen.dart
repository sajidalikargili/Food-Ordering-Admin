import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodie_admin/constant/helper_method.dart';
import 'package:foodie_admin/constant/routes/app_routes.dart';
import 'package:foodie_admin/features/auth/bloc/auth_bloc.dart';
import 'package:foodie_admin/features/auth/bloc/auth_event.dart';
import 'package:foodie_admin/features/auth/bloc/auth_state.dart';
import 'package:foodie_admin/features/setting/presentation/bloc/admin_bloc.dart';
import 'package:foodie_admin/features/setting/presentation/bloc/admin_event.dart';
import 'package:foodie_admin/features/setting/presentation/bloc/admin_state.dart';
import 'package:foodie_admin/theme/bloc/theme_bloc.dart';
import 'package:foodie_admin/theme/bloc/theme_event.dart';
import 'package:foodie_admin/theme/bloc/theme_state.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Reviews', style: theme.textTheme.headlineMedium),
        backgroundColor: theme.colorScheme.surface,
        surfaceTintColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Reviews',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'View and manage customer review for your product',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ThemeContainer(theme: theme),
            BlocBuilder<AdminBloc,AdminState>(builder: (context,state){
              // if(state is InitialAdminState || state is LoadingAdminState){
              //   return Center(
              //     child: CircularProgressIndicator(strokeWidth:2),
              //   );
              // }
              if(state is LoadedAdminState){
                final data=state.adminModel;
                return AdminProfile(theme: theme,name: data.name,email: data.email);
              }
              if(state is ErrorAdminState){
                return Column(
                  children: [
                    Text('Admin data load failed'),
                    SizedBox(height: 10),
                    Text('Error:${state.messageError}'),
                    SizedBox(height: 10),
                    ElevatedButton(onPressed: (){
                      context.read<AdminBloc>().add(LoadedAdminEvent());
                    }, child: Text('Reload'))
                  ],
                );
              }
              return SizedBox.shrink();
            }),
            AppInformation(theme: theme,title:"App Information" ,subTitle: "Foodie Admin-Version 1.0.0",icon:Icons.info_outline_rounded ,onClick: (){
              HelperMethod.showToast("App Information", context);
            }),
            BlocConsumer<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is SuccessState) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.login,
                        (route) => false,
                  );
                }
              },
              builder: (context, state) {
                // if (state is LoadingState || state is InitialState) {
                //   return Center(
                //     child: const CircularProgressIndicator(
                //       strokeWidth: 2,
                //     ),
                //   );
                // }

                if (state is ErrorState) {
                  return Text('Error: ${state.error}');
                }

                return AppInformation(
                  theme: theme,
                  title: "Logout",
                  subTitle: "Sign out from your account",
                  icon: Icons.logout,
                  onClick: () {
                    context.read<AuthBloc>().add(LogoutEvent());
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ThemeContainer extends StatelessWidget {
  const ThemeContainer({super.key, required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 120,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(12),
            side: BorderSide(color: Colors.grey.withOpacity(0.1), width: 1),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Icon(Icons.brightness_2, color: Colors.white),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Reviews',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Switch between light and dark mode',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      'Light',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.brightness == Brightness.light
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(width: 5),

                    Switch(
                      value: theme.brightness == Brightness.dark,
                      onChanged: (value) {
                        context.read<ThemeBloc>().add(ThemeToggleEvent());
                      },
                    ),

                    const SizedBox(width: 5),

                    Text(
                      'Dark',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.brightness == Brightness.dark
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AdminProfile extends StatelessWidget {
  const AdminProfile({super.key, required this.theme,required this.name,required this.email});
  final ThemeData theme;
  final String name;
  final String email;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 240,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(12),
            side: BorderSide(color: Colors.grey.withOpacity(0.1), width: 1),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Reviews',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'View your account information',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
          
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Icon(Icons.arrow_forward_ios_rounded),
                  ),
                ],
              ),
             SizedBox(height: 5),
             Row(
               children: [
                 SizedBox(width: 65,),
                 Expanded(
                   child: Column(
                     mainAxisAlignment: MainAxisAlignment.start,
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Padding(
                         padding: const EdgeInsets.only(right:20),
                         child: Divider(color: theme.dividerColor.withOpacity(0.2), thickness: 1, height: 1),
                       ),
                       SizedBox(height: 20),
                       Text('Name',style: theme.textTheme.bodySmall),
                       Text(name,style: theme.textTheme.titleMedium?.copyWith(
                         fontSize: 15
                       )),
                       SizedBox(height: 20),
                       Text('Email',style: theme.textTheme.bodySmall),
                       Text(email,style: theme.textTheme.titleMedium?.copyWith(
                           fontSize: 15
                       )),
                     ],
                   ),
                 )
               ],
             )
            ],
          ),
        ),
      ),
    );
  }
}
class AppInformation extends StatelessWidget {
  final String title;
  final String subTitle;
  final IconData icon;
  final VoidCallback onClick;
  const AppInformation({super.key, required this.theme,required this.title,required this.subTitle,required this.icon,required this.onClick});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        onClick();
      },
      child: SizedBox(
        width: double.infinity,
        height: 100,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusGeometry.circular(12),
              side: BorderSide(color: Colors.grey.withOpacity(0.1), width: 1),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Icon(icon, color: Colors.white),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            title,
                            style: theme.textTheme.titleMedium?.copyWith(
                      fontSize: 15
                      ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            subTitle,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                              fontSize: 13
                            ),
                          ),

                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: Icon(Icons.arrow_forward_ios_rounded),
                    ),
                  ],
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
