import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodie_admin/features/dashboard/data/model/recent_order_model.dart';

import '../model/recent_order_model.dart';

class RecentOrderService {
  FirebaseFirestore _firebaseFirestore;
  RecentOrderService({FirebaseFirestore? firebaseFirestore}):_firebaseFirestore=firebaseFirestore??FirebaseFirestore.instance;
  Future<List<RecentOrderModel>> getRecentOrder() async{
     final snapshotData= await _firebaseFirestore.collection('orders').orderBy('createdAt',descending: true).limit(5).get();
     final result= await Future.wait(
       snapshotData.docs.map((order)async {
           final data=order.data();
          final userId=data['userId']?.toString();
          String customerName="Uknown Customer";
          if(userId !=null && userId.isNotEmpty){
            final userDoc=await _firebaseFirestore.collection('users').doc(userId).get();
            if(userDoc.exists){
               customerName=userDoc.data()?['name']?? "Unknown Customer".toString();
            }
           }
          final items=data['items'];
          var itemCount =0;
           if (items is List) {
             for (final item in items) {
               if (item is Map) {
                 final quantity = item['quantity'];
                 itemCount += quantity is num ? quantity.toInt() : 1;
               } else {
                 itemCount++;
               }
             }
           }
           final rawTotal=data['total'];
           final total=rawTotal is num ? rawTotal.toDouble() : double.tryParse(rawTotal?.toString() ?? '') ?? 0.0;
           final rawDate=data['createdAt'];
           final createdAt=rawDate is  Timestamp ? rawDate.toDate() : rawDate is DateTime ? rawDate : null;
           final status=(data['status'] ?? 'pending').toString();
          return RecentOrderModel(orderId: order.id, customerName: customerName, itemCount: itemCount, total: total, status: status, createdAt: createdAt);
       })
     );
     return result;
    
  }

}