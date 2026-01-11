import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../core/app_export.dart';

/// Appointment Summary Screen - Shows booking details before payment
class AppointmentSummaryScreen extends StatefulWidget {
  final Map<String, dynamic> appointmentDetails;

  const AppointmentSummaryScreen({
    super.key,
    required this.appointmentDetails,
  });

  @override
  State<AppointmentSummaryScreen> createState() =>
      _AppointmentSummaryScreenState();
}

class _AppointmentSummaryScreenState extends State<AppointmentSummaryScreen> {
  final TextEditingController _couponController = TextEditingController();
  String? appliedCoupon;
  double discountAmount = 0;
  String selectedPaymentType = 'token'; // 'token' or 'full'

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  void _applyCoupon() {
    final couponCode = _couponController.text.trim().toUpperCase();
    if (couponCode.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a coupon code')),
      );
      return;
    }

    // Mock coupon validation
    final validCoupons = {
      'HEALTH10': 0.10, // 10% discount
      'FIRST20': 0.20, // 20% discount
      'SAVE50': 50.0, // ₹50 flat discount
    };

    if (validCoupons.containsKey(couponCode)) {
      final data = widget.appointmentDetails['data'] ?? {};
      final feeString =
          data['consultationFee'] ?? data['consultancyFee'] ?? '₹500';
      final fee = double.parse(feeString.replaceAll('₹', '').trim());

      setState(() {
        appliedCoupon = couponCode;
        if (couponCode == 'SAVE50') {
          discountAmount = validCoupons[couponCode]!;
        } else {
          discountAmount = fee * validCoupons[couponCode]!;
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Coupon "$couponCode" applied successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid coupon code'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _removeCoupon() {
    setState(() {
      appliedCoupon = null;
      discountAmount = 0;
      _couponController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final type = widget.appointmentDetails['type'] ?? 'doctor';
    final data = widget.appointmentDetails['data'] ?? {};
    final bookingInfo = widget.appointmentDetails['bookingInfo'] ?? {};

    // Generate appointment ID
    final appointmentId =
        'APT${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}';

    // Calculate amounts
    final feeString =
        data['consultationFee'] ?? data['consultancyFee'] ?? '₹500';
    final consultationFee = double.parse(feeString.replaceAll('₹', '').trim());
    const tokenAmount = 100.0;
    final finalAmount = consultationFee - discountAmount;
    final amountToPay =
        selectedPaymentType == 'token' ? tokenAmount : finalAmount;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Booking Summary'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Booking Confirmation Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Booking Details Confirmed',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Appointment ID: $appointmentId',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Appointment Details
            Text(
              'Appointment Details',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Doctor/Hospital Info
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor:
                              theme.primaryColor.withValues(alpha: 0.1),
                          child: Icon(
                            type == 'doctor'
                                ? Icons.person
                                : Icons.local_hospital,
                            size: 30,
                            color: theme.primaryColor,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data['name'] ?? 'Unknown',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                type == 'doctor'
                                    ? data['specialization'] ?? 'Specialist'
                                    : data['type'] ?? 'Hospital',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 24),

                    // Patient Info
                    _buildDetailRow(Icons.person, 'Patient Name',
                        bookingInfo['name'] ?? 'N/A'),
                    _buildDetailRow(Icons.cake, 'Age',
                        '${bookingInfo['age'] ?? 'N/A'} years'),
                    _buildDetailRow(
                        Icons.wc, 'Gender', bookingInfo['gender'] ?? 'N/A'),
                    _buildDetailRow(
                        Icons.phone, 'Mobile', bookingInfo['mobile'] ?? 'N/A'),

                    if (type == 'hospital') ...[
                      _buildDetailRow(Icons.medical_services, 'Department',
                          bookingInfo['department'] ?? 'N/A'),
                      _buildDetailRow(Icons.person_outline, 'Doctor',
                          bookingInfo['doctor'] ?? 'N/A'),
                    ],

                    const Divider(height: 24),

                    // Date & Time
                    _buildDetailRow(
                      Icons.calendar_today,
                      'Date',
                      bookingInfo['date'] != null
                          ? DateFormat('dd MMM yyyy')
                              .format(bookingInfo['date'])
                          : 'N/A',
                    ),
                    _buildDetailRow(Icons.access_time, 'Time',
                        bookingInfo['timeSlot'] ?? 'N/A'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Coupon Section
            Text(
              'Apply Coupon',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: appliedCoupon == null
                    ? Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _couponController,
                              textCapitalization: TextCapitalization.characters,
                              decoration: InputDecoration(
                                hintText: 'Enter coupon code',
                                prefixIcon: const Icon(Icons.local_offer),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 12,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton(
                            onPressed: _applyCoupon,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 16,
                              ),
                            ),
                            child: const Text('Apply'),
                          ),
                        ],
                      )
                    : Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.green.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.check_circle, color: Colors.green),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Coupon "$appliedCoupon" applied',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.green,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'You saved ₹${discountAmount.toStringAsFixed(0)}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: _removeCoupon,
                              icon: const Icon(Icons.close, color: Colors.red),
                              tooltip: 'Remove coupon',
                            ),
                          ],
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 12),

            // Available coupons hint
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.withValues(alpha: 0.2)),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, size: 16, color: Colors.blue[700]),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Try: HEALTH10, FIRST20, SAVE50',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue[700],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Payment Options
            Text(
              'Select Payment Option',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            // Token Amount Option
            GestureDetector(
              onTap: () {
                setState(() => selectedPaymentType = 'token');
                HapticFeedback.lightImpact();
              },
              child: Card(
                elevation: selectedPaymentType == 'token' ? 4 : 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: selectedPaymentType == 'token'
                        ? theme.primaryColor
                        : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Radio<String>(
                        value: 'token',
                        groupValue: selectedPaymentType,
                        onChanged: (value) {
                          setState(() => selectedPaymentType = value!);
                          HapticFeedback.lightImpact();
                        },
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Pay Token Amount',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Pay ₹$tokenAmount now, rest at clinic',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '₹$tokenAmount',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: theme.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Full Amount Option
            GestureDetector(
              onTap: () {
                setState(() => selectedPaymentType = 'full');
                HapticFeedback.lightImpact();
              },
              child: Card(
                elevation: selectedPaymentType == 'full' ? 4 : 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: selectedPaymentType == 'full'
                        ? theme.primaryColor
                        : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Radio<String>(
                        value: 'full',
                        groupValue: selectedPaymentType,
                        onChanged: (value) {
                          setState(() => selectedPaymentType = value!);
                          HapticFeedback.lightImpact();
                        },
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  'Pay Full Amount',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                if (discountAmount > 0) ...[
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Text(
                                      'SAVE',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Complete payment now',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (discountAmount > 0) ...[
                            Text(
                              '₹${consultationFee.toStringAsFixed(0)}',
                              style: TextStyle(
                                fontSize: 14,
                                decoration: TextDecoration.lineThrough,
                                color: Colors.grey[500],
                              ),
                            ),
                            const SizedBox(height: 2),
                          ],
                          Text(
                            '₹${finalAmount.toStringAsFixed(0)}',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: theme.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Payment Summary
            Text(
              'Payment Summary',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            Card(
              elevation: 2,
              color: theme.primaryColor.withValues(alpha: 0.05),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Consultation Fee'),
                        Text(
                          '₹${consultationFee.toStringAsFixed(0)}',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    if (discountAmount > 0) ...[
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Discount',
                              style: TextStyle(color: Colors.green)),
                          Text(
                            '- ₹${discountAmount.toStringAsFixed(0)}',
                            style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                    const Divider(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Amount to Pay',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '₹${amountToPay.toStringAsFixed(0)}',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.primaryColor,
                          ),
                        ),
                      ],
                    ),
                    if (selectedPaymentType == 'token') ...[
                      const SizedBox(height: 8),
                      Text(
                        'Remaining: ₹${(finalAmount - tokenAmount).toStringAsFixed(0)} (Pay at clinic)',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: ElevatedButton(
            onPressed: () {
              HapticFeedback.mediumImpact();
              Navigator.pushNamed(
                context,
                AppRoutes.payment,
                arguments: {
                  'type': 'appointment',
                  'amount': '₹${amountToPay.toStringAsFixed(0)}',
                  'description':
                      '${selectedPaymentType == 'token' ? 'Token payment' : 'Full payment'} for ${data['name'] ?? 'Doctor'}',
                  'orderDetails': {
                    'appointmentId': appointmentId,
                    'paymentType': selectedPaymentType,
                    'consultationFee': consultationFee,
                    'discount': discountAmount,
                    'finalAmount': finalAmount,
                    'tokenAmount': tokenAmount,
                  },
                },
              );
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Proceed to Payment - ₹${amountToPay.toStringAsFixed(0)}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
