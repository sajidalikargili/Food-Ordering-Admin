import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodie_admin/constant/routes/app_routes.dart';
import 'package:foodie_admin/features/dashboard/data/model/quick_action_model.dart';
import 'package:foodie_admin/features/dashboard/data/model/side_bar_item_model.dart';
class HelperMethod {
  static    List<SideBarItemModel> sideBarList=[
    SideBarItemModel(icon: Icons.dashboard, title: 'Dashboard'),
    SideBarItemModel(icon: Icons.inventory_2_outlined, title: 'Product'),
    SideBarItemModel(icon: Icons.category, title: 'Category'),
    SideBarItemModel(icon: Icons.shopping_cart, title: 'Orders'),
    SideBarItemModel(icon: Icons.people, title: 'Users'),
    SideBarItemModel(icon: Icons.star, title: 'Reviews'),
    SideBarItemModel(icon: Icons.settings, title: 'Setting'),
    SideBarItemModel(icon: Icons.logout, title: 'Logout')
  ];
  static List<QuickActionModel> quickActionList=[
    QuickActionModel(title: "Add New Product", icon: Icons.add_circle_outlined, color: Colors.deepOrange,route:AppRoutes.product),
    QuickActionModel(title: "Manages Categories", icon: Icons.category_sharp, color: Colors.blue,route: AppRoutes.category),
    QuickActionModel(title: "View Orders", icon: Icons.shopping_cart, color: Colors.green,route: AppRoutes.order),
    QuickActionModel(title: "Manage Users", icon: CupertinoIcons.person_alt_circle_fill, color: Colors.deepPurple,route: AppRoutes.users)
  ];
 static Timer moveNext(BuildContext context){
   return Timer(Duration(seconds: 3),(){
     if(!context.mounted) return;
     final currentUser=FirebaseAuth.instance.currentUser;

     if (currentUser==null){
       Navigator.pushReplacementNamed(context, AppRoutes.login);
     } else{
       Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
     }
   });
   }
  static void showToast(String message, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }
  static Future<String?> uploadImage(Uint8List imageBytes) async {
    const cloudName = 'dha3fmoqm';
    const uploadPreset = 'product_image';

    final uri = Uri.parse(
      'https://api.cloudinary.com/v1_1/$cloudName/image/upload',
    );

    final request = http.MultipartRequest('POST', uri)
      ..fields['upload_preset'] = uploadPreset
      ..files.add(
        http.MultipartFile.fromBytes(
          'file',
          imageBytes,
          filename: 'product.jpg',
        ),
      );

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      final data = jsonDecode(responseBody) as Map<String, dynamic>;
      return data['secure_url'] as String?;
    }

    throw Exception('Image upload failed: $responseBody');
  }
}