import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodie_admin/features/order/model/order_model.dart';

class OrderService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;
  Stream<List<OrderModel>> getOrders() {
    return _firestore.collection('orders').snapshots().map(
          (snapshot) {
        final orders = snapshot.docs
            .map((doc) => OrderModel.fromFirestore(doc))
            .toList();
        orders.sort((a, b) {
          if (a.createdAt == null) return 1;
          if (b.createdAt == null) return -1;

          return b.createdAt!.compareTo(a.createdAt!);
        });

        return orders;
      },
    );
  }
  Future<String> getCustomerName(String userId) async {
    if (userId.isEmpty) return 'Unknown customer';
    final doc =
    await _firestore.collection('users').doc(userId).get();
    final data = doc.data();
    if (data == null) return 'Unknown customer';
    return data['name']?.toString() ?? 'Unknown customer';
  }
}