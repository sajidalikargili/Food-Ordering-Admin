import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodie_admin/constant/routes/app_routes.dart';
import 'package:foodie_admin/features/auth/bloc/auth_bloc.dart';
import 'package:foodie_admin/features/auth/bloc/auth_event.dart';
import 'package:foodie_admin/features/auth/bloc/auth_state.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}
class _LoginScreenState extends State<LoginScreen> {
  final _formKey=GlobalKey<FormState>();
  final email_controller=TextEditingController();
  final password_controller=TextEditingController();
  bool  obscurePassword=true;
  @override
  void dispose() {
    super.dispose();
    email_controller.dispose();
    password_controller.dispose();
  }
  void  login(){
    final email=email_controller.text.trim();
    final password=password_controller.text.trim();
    debugPrint('Email: $email');
    debugPrint('Password: $password');
  }
  @override
  Widget build(BuildContext context) {
    final theme=Theme.of(context);
    final colorScreme=theme.colorScheme;
    return Scaffold(
 backgroundColor: colorScreme.surface,
      body: SafeArea(child: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: ConstrainedBox(constraints: BoxConstraints(
            maxWidth: 450
          ),child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: colorScreme.primary,
                  borderRadius: BorderRadius.circular(24)
                ),
                child: Center(
                  child: Icon(
                    color: colorScreme.onPrimary,
                    Icons.ice_skating,
                    size: 45,
                  ),
                ),
              ),
               const SizedBox(height: 24),
                Text('Food Admin',style: theme.textTheme.headlineSmall!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScreme.onSurface
                ),),
                const SizedBox(height: 8),
                Text('Sign in  to manage you food bussiness ',
                textAlign:TextAlign.center,
                style: theme.textTheme.bodyMedium!.copyWith(
                  color: colorScreme.onSurfaceVariant
                ),),
                SizedBox(height: 40),
                Align(alignment: Alignment.centerLeft,
                  child: Text('Email',style: theme.textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.w500
                  ),),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller:email_controller,
                  keyboardType:TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'Enter your email',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)
                    ),
                  ),
                  validator: (value){
                    if(value==null || value.trim().isEmpty){
                      return 'Please enter your email';
                    }
                    final emailRegex = RegExp(
                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                    );
                    if(!emailRegex.hasMatch(value.trim())){
                       return 'Please  enter a valid email';
                    }
                    return null;
                  },


                ),
                const  SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                    child: Text('password',
                    style: theme.textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.w500
                    ),),
                ),
                TextFormField(
                  controller: password_controller,
                  obscureText: obscurePassword,
                  decoration: InputDecoration(
                    hintText: 'Enter the password',
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: IconButton(onPressed: (){
                       setState(() {
                         obscurePassword =!obscurePassword;
                       });
                    }, icon: Icon(obscurePassword ? Icons.visibility_outlined :Icons.visibility_off_outlined))

                  ),
                  validator: (value){
                    if(value==null || value.isEmpty){
                      return 'please enter your password';
                    }
                    if(value.length <6){
                      return "Password must be atleast 6 character";
                    }
                  },

                ),
                const  SizedBox(height: 30),
                BlocConsumer<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state is SuccessState) {
                      Navigator.pushReplacementNamed(
                        context,
                        AppRoutes.dashboard,
                      );
                    }

                    if (state is ErrorState) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.error),
                        ),
                      );
                    }
                  },

                  builder: (context, state) {
                    final isLoading=state is LoadingState;
                    return SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : () {
                          if(_formKey.currentState!.validate()){
                            context.read<AuthBloc>().add(
                              LoginEvent(
                                email: email_controller.text.trim(),
                                password: password_controller.text,
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorScreme.primary,
                          foregroundColor: colorScreme.onPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: isLoading ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        ) : Text('Login',style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600
                        ))
                      ),
                    );

                  },
                ),
                const SizedBox(height: 24),
                 Text('Admin access only',style: theme.textTheme.bodySmall?.copyWith(
                   color: colorScreme?.onSurfaceVariant
                 ),)

              ],
            ),
          ),),
        ),
      ))
    );
  }
}
