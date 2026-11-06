import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodie_admin/features/dashboard/data/model/dashboard_model.dart';
class DashboardService {
  FirebaseFirestore _firebaseFirestore;
  DashboardService({FirebaseFirestore? firebaseFirestore}):_firebaseFirestore=firebaseFirestore ?? FirebaseFirestore.instance;
  Future<DashboardModel> getDashboardData() async{
    final results= await Future.wait([
      _firebaseFirestore.collection('orders').get(),
      _firebaseFirestore.collection('users').get(),
      _firebaseFirestore.collection('products').get(),
    ]);
    final orders=results[0].docs;
    final users=results[1].docs;
    final products=results[2].docs;
    double revenue=0;
     for( final order in orders){
       final data=order.data();
       final status=(data['status'] ?? '').toString().toLowerCase().replaceAll('', '_');
       if(status=="delivery"){
          final total=data['total'];
          if(total is num){
              revenue+=total.toDouble();
          }else if (total is String){
            revenue+=double.tryParse(total) ?? 0;
          }
       }
     }
     return DashboardModel(totalOrders: orders.length, totalProducts: products.length, totalUsers: users.length, totalReveneu:revenue);
  }
}