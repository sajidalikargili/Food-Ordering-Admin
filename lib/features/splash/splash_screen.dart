import 'dart:async';
import 'package:flutter/material.dart';
import 'package:foodie_admin/constant/helper_method.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}
class _SplashScreenState extends State<SplashScreen> {
  Timer? timer;
  @override
  void initState() {
    super.initState();
   timer= HelperMethod.moveNext(context);
  }
  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme=Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Icon(
                Icons.restaurant,
                size: 55,
                color: colorScheme.primary,
              ),
            ),

            const SizedBox(height: 24),

            // App name
            Text(
              'Foodie Admin',
              style: TextStyle(
                color: colorScheme.onPrimary,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Manage your food business',
              style: TextStyle(
                color: colorScheme.onPrimary.withValues(alpha: 0.8),
                fontSize: 15,
              ),
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: 25,
              height: 25,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: colorScheme.onPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
