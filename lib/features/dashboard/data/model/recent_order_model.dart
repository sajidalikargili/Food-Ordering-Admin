class RecentOrderModel{
  final String orderId;
  final String customerName;
  final int itemCount;
  final double total;
  final String status;
  final DateTime? createdAt;
  RecentOrderModel({
   required this.orderId,
   required this.customerName,
   required this.itemCount,
   required this.total,
   required this.status,
   required this.createdAt
});
}