import 'package:flutter/material.dart';
import 'package:foodie_admin/features/order/model/order_model.dart';
class OrderDetailsScreen extends StatelessWidget {
  final OrderModel order;

  const OrderDetailsScreen({
    super.key,
    required this.order,
  });

  static const orange = Color(0xFFFF6B35);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Order #${order.id}',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text('Status: ${order.status}'),
                const SizedBox(height: 24),

                _section(
                  context,
                  title: 'Order Items',
                  icon: Icons.shopping_bag_outlined,
                  child: Column(
                    children: order.items.map((item) {
                      final name =
                          item['name']?.toString() ?? 'Unnamed product';

                      final quantity =
                          (item['quantity'] as num?)?.toInt() ?? 1;

                      final price =
                          (item['totalPrice'] as num?)?.toDouble() ??
                              (item['price'] as num?)?.toDouble() ??
                              0;

                      final image = item['image']?.toString() ?? '';

                      final extras = (item['extras'] as List? ?? [])
                          .whereType<Map>()
                          .map(
                            (extra) =>
                        extra['name']?.toString() ?? '',
                      )
                          .where((name) => name.isNotEmpty)
                          .toList();

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: image.isNotEmpty
                                  ? Image.network(
                                image,
                                width: 64,
                                height: 64,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) =>
                                const SizedBox(
                                  width: 64,
                                  height: 64,
                                  child: Icon(Icons.fastfood),
                                ),
                              )
                                  : const SizedBox(
                                width: 64,
                                height: 64,
                                child: Icon(Icons.fastfood),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text('Quantity: $quantity'),
                                  if (extras.isNotEmpty)
                                    Text('Extras: ${extras.join(', ')}'),
                                ],
                              ),
                            ),
                            Text(
                              'PKR ${price.toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(height: 16),

                _section(
                  context,
                  title: 'Order Summary',
                  icon: Icons.receipt_long_outlined,
                  child: Column(
                    children: [
                      _summaryRow(
                        'Subtotal',
                        order.subtotal,
                      ),
                      _summaryRow(
                        'Delivery Fee',
                        order.deliveryFee,
                      ),
                      const Divider(height: 24),
                      _summaryRow(
                        'Total',
                        order.total,
                        bold: true,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                _section(
                  context,
                  title: 'Delivery Address',
                  icon: Icons.location_on_outlined,
                  child: Text(
                    order.address.isEmpty
                        ? 'No delivery address'
                        : order.address,
                  ),
                ),

                const SizedBox(height: 16),

                _section(
                  context,
                  title: 'Payment Method',
                  icon: Icons.payments_outlined,
                  child: Text(order.paymentMethod),
                ),

                const SizedBox(height: 24),

                OutlinedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Back to Orders'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: orange,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _section(
      BuildContext context, {
        required String title,
        required IconData icon,
        required Widget child,
      }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: orange),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            child,
          ],
        ),
      ),
    );
  }

  Widget _summaryRow(
      String label,
      double amount, {
        bool bold = false,
      }) {
    final style = TextStyle(
      fontWeight: bold ? FontWeight.bold : FontWeight.normal,
      fontSize: bold ? 16 : 14,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: style),
          Text('PKR ${amount.toStringAsFixed(0)}', style: style),
        ],
      ),
    );
  }
}