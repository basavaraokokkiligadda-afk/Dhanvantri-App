import 'package:flutter/material.dart';
import '../../core/routes/app_routes.dart';

/// Pharmacy Checkout Screen
/// Shows order summary with medicines, quantities, prices, and delivery options
class PharmacyCheckoutScreen extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;

  const PharmacyCheckoutScreen({
    super.key,
    required this.cartItems,
  });

  @override
  State<PharmacyCheckoutScreen> createState() => _PharmacyCheckoutScreenState();
}

class _PharmacyCheckoutScreenState extends State<PharmacyCheckoutScreen> {
  String _deliveryType = 'home'; // 'home' or 'pickup'
  final String _selectedAddress = '123 Main Street, Hyderabad, 500032';
  final TextEditingController _instructionsController = TextEditingController();

  @override
  void dispose() {
    _instructionsController.dispose();
    super.dispose();
  }

  double get _subtotal {
    return widget.cartItems.fold(0.0, (sum, item) {
      final price = (item['price'] as num).toDouble();
      final quantity = (item['quantity'] as int);
      return sum + (price * quantity);
    });
  }

  double get _deliveryCharges => _deliveryType == 'home' ? 40.0 : 0.0;
  double get _taxes => _subtotal * 0.05; // 5% tax
  double get _total => _subtotal + _deliveryCharges + _taxes;

  void _proceedToPayment() {
    // Show confirmation dialog first
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Order?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Total Amount: ₹${_total.toStringAsFixed(2)}'),
            const SizedBox(height: 8),
            Text(
              _deliveryType == 'home'
                  ? 'Delivery Address: $_selectedAddress'
                  : 'Pickup from pharmacy',
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pushNamed(
                context,
                AppRoutes.payment,
                arguments: {
                  'type': 'pharmacy',
                  'orderDetails': {
                    'items': widget.cartItems,
                    'subtotal': _subtotal,
                    'deliveryCharges': _deliveryCharges,
                    'taxes': _taxes,
                    'total': _total,
                    'deliveryType': _deliveryType,
                    'address': _selectedAddress,
                    'instructions': _instructionsController.text,
                  },
                },
              );
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Summary
            Text(
              'Order Summary',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...widget.cartItems.map((item) => _buildMedicineItem(item, theme)),
            const Divider(height: 32),

            // Delivery Options
            Text(
              'Delivery Option',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildDeliveryOptions(theme),
            const SizedBox(height: 16),

            // Address (if home delivery)
            if (_deliveryType == 'home') ...[
              Text(
                'Delivery Address',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.red),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(_selectedAddress),
                    ),
                    TextButton(
                      onPressed: () {
                        // Mock address change
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Address change coming soon'),
                          ),
                        );
                      },
                      child: const Text('Change'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Special Instructions
            Text(
              'Special Instructions',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _instructionsController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Add delivery instructions (optional)...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),

            // Price Breakdown
            _buildPriceBreakdown(theme),
            const SizedBox(height: 100), // Space for bottom button
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total Amount',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '₹${_total.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: theme.primaryColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _proceedToPayment,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Proceed to Payment'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMedicineItem(Map<String, dynamic> item, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Medicine Icon
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: theme.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.medication,
              color: theme.primaryColor,
              size: 32,
            ),
          ),
          const SizedBox(width: 12),
          // Medicine Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['name'] as String,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${item['dosage']} • Qty: ${item['quantity']}',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          // Price
          Text(
            '₹${((item['price'] as num) * (item['quantity'] as int)).toStringAsFixed(2)}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: theme.primaryColor,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryOptions(ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: _buildDeliveryOption(
            icon: Icons.home,
            label: 'Home Delivery',
            value: 'home',
            charge: '₹40',
            theme: theme,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildDeliveryOption(
            icon: Icons.store,
            label: 'Store Pickup',
            value: 'pickup',
            charge: 'Free',
            theme: theme,
          ),
        ),
      ],
    );
  }

  Widget _buildDeliveryOption({
    required IconData icon,
    required String label,
    required String value,
    required String charge,
    required ThemeData theme,
  }) {
    final isSelected = _deliveryType == value;

    return GestureDetector(
      onTap: () => setState(() => _deliveryType = value),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.primaryColor.withValues(alpha: 0.1)
              : Colors.grey.shade100,
          border: Border.all(
            color: isSelected ? theme.primaryColor : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? theme.primaryColor : Colors.grey,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isSelected ? theme.primaryColor : Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              charge,
              style: TextStyle(
                fontSize: 12,
                color: isSelected ? theme.primaryColor : Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceBreakdown(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _buildPriceRow('Subtotal', _subtotal),
          const SizedBox(height: 8),
          _buildPriceRow('Delivery Charges', _deliveryCharges),
          const SizedBox(height: 8),
          _buildPriceRow('Taxes (5%)', _taxes),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '₹${_total.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: theme.primaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, double amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.grey),
        ),
        Text(
          '₹${amount.toStringAsFixed(2)}',
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
