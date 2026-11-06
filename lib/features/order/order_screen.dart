import 'package:flutter/material.dart';
import 'package:foodie_admin/features/order/model/order_model.dart';
import 'package:foodie_admin/features/order/order_detail_screen.dart';
import 'package:foodie_admin/features/order/order_service.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final OrderService _service = OrderService();
  final TextEditingController _searchController =
  TextEditingController();

  String _selectedStatus = 'all';

  static const orange = Color(0xFFFF6B35);

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Orders',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Manage customer orders and delivery details.',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
      
            // Search and filter
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                SizedBox(
                  width: 300,
                  child: TextField(
                    controller: _searchController,
                    onChanged: (_) => setState(() {}),
                    decoration: const InputDecoration(
                      hintText: 'Search by order ID or customer...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(
                  width: 180,
                  child: DropdownButtonFormField<String>(
                    value: _selectedStatus,
                    decoration: const InputDecoration(
                      labelText: 'Status',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'all',
                        child: Text('All statuses'),
                      ),
                      DropdownMenuItem(
                        value: 'confirmed',
                        child: Text('Confirmed'),
                      ),
                      DropdownMenuItem(
                        value: 'preparing',
                        child: Text('Preparing'),
                      ),
                      DropdownMenuItem(
                        value: 'out_for_delivery',
                        child: Text('Out for delivery'),
                      ),
                      DropdownMenuItem(
                        value: 'delivery',
                        child: Text('Delivery'),
                      ),
                      DropdownMenuItem(
                        value: 'delivered',
                        child: Text('Delivered'),
                      ),
                      DropdownMenuItem(
                        value: 'cancelled',
                        child: Text('Cancelled'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedStatus = value ?? 'all';
                      });
                    },
                  ),
                ),
              ],
            ),
      
            const SizedBox(height: 20),
      
            Expanded(
              child: StreamBuilder<List<OrderModel>>(
                stream: _service.getOrders(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error loading orders: ${snapshot.error}',
                      ),
                    );
                  }
      
                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: orange,
                      ),
                    );
                  }
      
                  final allOrders = snapshot.data ?? [];
      
                  final orders = allOrders.where((order){
                    final query =
                    _searchController.text.trim().toLowerCase();
                    final matchesSearch =
                        order.id.toLowerCase().contains(query) ||
                            order.userId.toLowerCase().contains(query);
      
                    final matchesStatus = _selectedStatus == 'all' ||
                        order.status.toLowerCase() ==
                            _selectedStatus.toLowerCase();
      
                    return matchesSearch && matchesStatus;
                  }).toList();
      
                  if (orders.isEmpty) {
                    return const Center(
                      child: Text('No matching orders found'),
                    );
                  }
      
                  return LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxWidth < 700) {
                        return ListView.separated(
                          itemCount: orders.length,
                          separatorBuilder: (_, __) =>
                          const SizedBox(height: 12),
                          itemBuilder: (context, index) =>
                              _buildOrderCard(context, orders[index]),
                        );
                      }
      
                      return SingleChildScrollView(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minWidth: constraints.maxWidth,
                            ),
                            child: DataTable(
                              headingRowColor:
                              WidgetStateProperty.all(
                                theme.colorScheme.surfaceContainerHighest,
                              ),
                              columns: const [
                                DataColumn(label: Text('Order ID')),
                                DataColumn(label: Text('Customer')),
                                DataColumn(label: Text('Date')),
                                DataColumn(label: Text('Total')),
                                DataColumn(label: Text('Status')),
                                DataColumn(label: Text('Action')),
                              ],
                              rows: orders.map((order) {
                                return DataRow(
                                  cells: [
                                    DataCell(
                                      SizedBox(
                                        width: 100,
                                        child: Text(
                                          order.id,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      SizedBox(
                                        width: 140,
                                        child: FutureBuilder<String>(
                                          future: _service.getCustomerName(
                                            order.userId,
                                          ),
                                          builder: (context, customer) {
                                            if (customer.hasError) {
                                              return const Text(
                                                'Customer unavailable',
                                              );
                                            }
      
                                            return Text(
                                              customer.data ??
                                                  order.userId,
                                              overflow: TextOverflow.ellipsis,
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      Text(
                                        order.createdAt == null
                                            ? 'N/A'
                                            : _formatDate(order.createdAt!),
                                      ),
                                    ),
                                    DataCell(
                                      Text(
                                        'PKR ${order.total.toStringAsFixed(0)}',
                                      ),
                                    ),
                                    DataCell(
                                      _statusChip(order.status),
                                    ),
                                    DataCell(
                                      OutlinedButton.icon(
                                        onPressed: () =>
                                            _openDetails(context, order),
                                        icon: const Icon(
                                          Icons.visibility_outlined,
                                          size: 16,
                                        ),
                                        label: const Text('View Details'),
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor: orange,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderCard(
      BuildContext context,
      OrderModel order,
      ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order ${order.id}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Customer ID: ${order.userId}'),
            Text(
              'Date: ${order.createdAt == null ? 'N/A' : _formatDate(order.createdAt!)}',
            ),
            Text('Total: PKR ${order.total.toStringAsFixed(0)}'),
            const SizedBox(height: 8),
            _statusChip(order.status),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: OutlinedButton(
                onPressed: () => _openDetails(context, order),
                child: const Text('View Details'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusChip(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: orange.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.replaceAll('_', ' '),
        style: const TextStyle(
          color: orange,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final local = date.toLocal();

    return '${local.day}/${local.month}/${local.year} '
        '${local.hour.toString().padLeft(2, '0')}:'
        '${local.minute.toString().padLeft(2, '0')}';
  }

  void _openDetails(BuildContext context, OrderModel order) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => OrderDetailsScreen(order: order),
      ),
    );
  }
}