import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../core/app_export.dart';
import '../../core/routes/app_routes.dart';

/// Appointment Summary Screen - Shows booking details before payment
class AppointmentSummaryScreen extends StatelessWidget {
  final Map<String, dynamic> appointmentDetails;

  const AppointmentSummaryScreen({
    super.key,
    required this.appointmentDetails,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final type = appointmentDetails['type'] ?? 'doctor';
    final data = appointmentDetails['data'] ?? {};
    final bookingInfo = appointmentDetails['bookingInfo'] ?? {};

    // Generate appointment ID
    final appointmentId =
        'APT${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointment Summary'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () =>
              Navigator.popUntil(context, (route) => route.isFirst),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Success Icon
            Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 64,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                'Appointment Confirmed!',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Appointment ID Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Appointment ID',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          appointmentId,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: appointmentId));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Appointment ID copied')),
                        );
                      },
                      icon: const Icon(Icons.copy),
                      tooltip: 'Copy ID',
                    ),
                  ],
                ),
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
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Doctor/Hospital Info
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: data['image'] != null
                              ? NetworkImage(data['image'])
                              : null,
                          child: data['image'] == null
                              ? Icon(
                                  type == 'doctor'
                                      ? Icons.person
                                      : Icons.local_hospital,
                                  size: 30,
                                )
                              : null,
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
                                style: TextStyle(color: Colors.grey[600]),
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

            // Payment Summary
            Text(
              'Payment Summary',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Consultation Fee'),
                        Text(
                          data['consultationFee'] ??
                              data['consultancyFee'] ??
                              '₹500',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const Divider(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Amount',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          data['consultationFee'] ??
                              data['consultancyFee'] ??
                              '₹500',
                          style: theme.textTheme.titleLarge?.copyWith(
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

            const SizedBox(height: 80),
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
                  'amount': data['consultationFee'] ??
                      data['consultancyFee'] ??
                      '₹500',
                  'description': 'Appointment with ${data['name'] ?? 'Doctor'}',
                },
              );
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Make Payment',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
