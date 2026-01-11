import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Medicine Order Details Screen
/// Shows tracking information for pharmacy orders
class MedicineOrderDetailsScreen extends StatelessWidget {
  const MedicineOrderDetailsScreen({super.key});

  // Mock order data
  final List<Map<String, dynamic>> _orders = const [
    {
      'orderId': 'MED20260111001',
      'orderDate': '2026-01-09',
      'status': 'Out for Delivery',
      'expectedDelivery': '2026-01-11',
      'items': [
        {'name': 'Paracetamol 500mg', 'quantity': 10, 'price': 50.0},
        {'name': 'Amoxicillin 250mg', 'quantity': 15, 'price': 120.0},
      ],
      'total': 210.0,
      'deliveryAddress': '123 Main Street, Hyderabad, 500032',
    },
    {
      'orderId': 'MED20260105002',
      'orderDate': '2026-01-05',
      'status': 'Delivered',
      'deliveryDate': '2026-01-07',
      'items': [
        {'name': 'Cetirizine 10mg', 'quantity': 20, 'price': 80.0},
      ],
      'total': 120.0,
      'deliveryAddress': '123 Main Street, Hyderabad, 500032',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Medicine Orders'),
        elevation: 0,
      ),
      body: _orders.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _orders.length,
              itemBuilder: (context, index) {
                final order = _orders[index];
                return _buildOrderCard(order, theme, context);
              },
            ),
    );
  }

  Widget _buildOrderCard(
      Map<String, dynamic> order, ThemeData theme, BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Order Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.primaryColor.withValues(alpha: 0.05),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order['orderId'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Ordered on ${DateFormat('MMM dd, yyyy').format(DateTime.parse(order['orderDate']))}',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildStatusBadge(order['status']),
              ],
            ),
          ),

          // Order Items
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Items',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 12),
                ...(order['items'] as List).map((item) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.medication,
                                  size: 20,
                                  color: Colors.blue,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['name'],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      'Qty: ${item['quantity']}',
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '₹${item['price']}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                const Divider(height: 24),

                // Delivery Info
                if (order['status'] == 'Delivered') ...[
                  _buildInfoRow(
                    Icons.check_circle,
                    'Delivered on',
                    DateFormat('MMM dd, yyyy')
                        .format(DateTime.parse(order['deliveryDate'])),
                    Colors.green,
                  ),
                ] else ...[
                  _buildInfoRow(
                    Icons.local_shipping,
                    'Expected Delivery',
                    DateFormat('MMM dd, yyyy')
                        .format(DateTime.parse(order['expectedDelivery'])),
                    theme.primaryColor,
                  ),
                ],
                const SizedBox(height: 8),
                _buildInfoRow(
                  Icons.location_on,
                  'Delivery Address',
                  order['deliveryAddress'],
                  Colors.grey,
                ),
                const Divider(height: 24),

                // Total
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Amount',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      '₹${order['total']}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: theme.primaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Actions
                if (order['status'] == 'Out for Delivery')
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        _showTrackingDialog(context, order);
                      },
                      icon: const Icon(Icons.location_searching),
                      label: const Text('Track Order'),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    IconData icon;

    switch (status) {
      case 'Delivered':
        color = Colors.green;
        icon = Icons.check_circle;
        break;
      case 'Out for Delivery':
        color = Colors.blue;
        icon = Icons.local_shipping;
        break;
      case 'Processing':
        color = Colors.orange;
        icon = Icons.hourglass_empty;
        break;
      default:
        color = Colors.grey;
        icon = Icons.info;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 6),
          Text(
            status,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, Color color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.medication_outlined,
              size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            'No medicine orders yet',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  void _showTrackingDialog(BuildContext context, Map<String, dynamic> order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Order Tracking'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTrackingStep(
              'Order Confirmed',
              DateFormat('MMM dd, hh:mm a')
                  .format(DateTime.parse(order['orderDate'])),
              true,
              true,
            ),
            _buildTrackingLine(true),
            _buildTrackingStep(
              'Packed',
              DateFormat('MMM dd, hh:mm a').format(
                  DateTime.parse(order['orderDate'])
                      .add(const Duration(hours: 2))),
              true,
              true,
            ),
            _buildTrackingLine(true),
            _buildTrackingStep(
              'Out for Delivery',
              'Today, 9:00 AM',
              true,
              false,
            ),
            _buildTrackingLine(false),
            _buildTrackingStep(
              'Delivered',
              'Expected by ${DateFormat('hh:mm a').format(DateTime.now().add(const Duration(hours: 2)))}',
              false,
              false,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildTrackingStep(
      String title, String time, bool isCompleted, bool isCurrent) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isCompleted ? Colors.green : Colors.grey.shade300,
            border: Border.all(
              color: isCurrent ? Colors.green : Colors.transparent,
              width: 2,
            ),
          ),
          child: isCompleted
              ? const Icon(Icons.check, color: Colors.white, size: 16)
              : null,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                  fontSize: 14,
                ),
              ),
              Text(
                time,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTrackingLine(bool isCompleted) {
    return Container(
      margin: const EdgeInsets.only(left: 11),
      width: 2,
      height: 30,
      color: isCompleted ? Colors.green : Colors.grey.shade300,
    );
  }
}
