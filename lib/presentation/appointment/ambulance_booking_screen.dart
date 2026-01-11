import 'package:flutter/material.dart';
import '../../core/routes/app_routes.dart';

/// Ambulance Booking Screen
/// Allows users to book ambulance service for their appointments
class AmbulanceBookingScreen extends StatefulWidget {
  final Map<String, dynamic>? appointment;

  const AmbulanceBookingScreen({super.key, this.appointment});

  @override
  State<AmbulanceBookingScreen> createState() => _AmbulanceBookingScreenState();
}

class _AmbulanceBookingScreenState extends State<AmbulanceBookingScreen> {
  final TextEditingController _pickupController = TextEditingController();
  final TextEditingController _dropController = TextEditingController();
  String _selectedAmbulanceType = 'Basic Life Support (BLS)';
  bool _isEmergency = false;

  final List<Map<String, dynamic>> _ambulanceTypes = [
    {
      'name': 'Basic Life Support (BLS)',
      'description': 'For stable patients needing basic medical support',
      'usage': 'General transport, minor injuries',
      'price': 500,
      'features': ['Oxygen Support', 'First Aid Kit', 'Trained Staff'],
      'icon': Icons.local_hospital,
    },
    {
      'name': 'Advanced Life Support (ALS)',
      'description': 'Critical care with advanced medical equipment',
      'usage': 'Serious conditions, post-surgery',
      'price': 1200,
      'features': [
        'Ventilator',
        'Cardiac Monitor',
        'Defibrillator',
        'Emergency Medications'
      ],
      'icon': Icons.medical_services,
    },
    {
      'name': 'ICU Ambulance',
      'description': 'Mobile ICU with life support systems',
      'usage': 'Critical patients, inter-hospital transfer',
      'price': 2500,
      'features': [
        'Portable ICU Setup',
        'Ventilator',
        'Multiple Monitors',
        'Critical Care Specialist'
      ],
      'icon': Icons.emergency,
    },
    {
      'name': 'Pregnancy Care Ambulance',
      'description': 'Specialized for expectant mothers',
      'usage': 'Labor emergencies, prenatal care',
      'price': 800,
      'features': [
        'Gynecologist Support',
        'Delivery Equipment',
        'Neonatal Care Kit',
        'Female Paramedics'
      ],
      'icon': Icons.pregnant_woman,
    },
    {
      'name': 'Accident / Trauma Ambulance',
      'description': 'Rapid response for accident victims',
      'usage': 'Road accidents, trauma injuries',
      'price': 1500,
      'features': [
        'Trauma Kit',
        'Spinal Boards',
        'Advanced Monitoring',
        'Paramedic Team'
      ],
      'icon': Icons.car_crash,
    },
    {
      'name': 'Cardiac Emergency Ambulance',
      'description': 'Specialized cardiac care unit',
      'usage': 'Heart attacks, cardiac emergencies',
      'price': 1800,
      'features': [
        'ECG Machine',
        'Defibrillator',
        'Cardiac Medications',
        'Cardiologist on Call'
      ],
      'icon': Icons.favorite,
    },
  ];

  @override
  void initState() {
    super.initState();
    // Pre-fill drop location if appointment has hospital
    if (widget.appointment != null &&
        widget.appointment!['hospitalName'] != null) {
      _dropController.text = widget.appointment!['hospitalName'];
    }
  }

  @override
  void dispose() {
    _pickupController.dispose();
    _dropController.dispose();
    super.dispose();
  }

  void _confirmBooking() {
    if (_pickupController.text.trim().isEmpty ||
        _dropController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all required fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 60,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Ambulance Booked!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Your ambulance will arrive in 10-15 minutes',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  const Text(
                    'Booking ID',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'AMB${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back to previous screen
            },
            child: const Text('Done'),
          ),
          ElevatedButton(
            onPressed: () {
              final bookingId =
                  'AMB${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
              Navigator.pop(context); // Close dialog
              Navigator.pushNamed(
                context,
                AppRoutes.ambulanceTracking,
                arguments: {
                  'ambulanceType': _selectedAmbulanceType,
                  'bookingId': bookingId,
                  'pickup': _pickupController.text,
                  'drop': _dropController.text,
                  'isEmergency': _isEmergency,
                },
              );
            },
            child: const Text('Track Ambulance'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedType = _ambulanceTypes
        .firstWhere((type) => type['name'] == _selectedAmbulanceType);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Ambulance'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Emergency Toggle
            Card(
              elevation: 2,
              color: _isEmergency ? Colors.red.shade50 : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: _isEmergency ? Colors.red : Colors.grey.shade300,
                  width: _isEmergency ? 2 : 1,
                ),
              ),
              child: SwitchListTile(
                title: const Text(
                  'Emergency',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text('Priority dispatch for critical cases'),
                value: _isEmergency,
                activeThumbColor: Colors.red,
                onChanged: (value) {
                  setState(() {
                    _isEmergency = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 20),

            // Pickup Location
            Text(
              'Pickup & Drop Location',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _pickupController,
              decoration: InputDecoration(
                labelText: 'Pickup Location *',
                prefixIcon: const Icon(Icons.location_on),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _dropController,
              decoration: InputDecoration(
                labelText: 'Drop Location *',
                prefixIcon: const Icon(Icons.flag),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Ambulance Type Selection
            Text(
              'Select Ambulance Type',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            RadioGroup<String>(
              groupValue: _selectedAmbulanceType,
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedAmbulanceType = value;
                  });
                }
              },
              child: Column(
                children: _ambulanceTypes.map((type) {
                  return _buildAmbulanceTypeCard(type, theme);
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),

            // Price Summary
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Base Fare',
                        style: TextStyle(fontSize: 14),
                      ),
                      Text(
                        '₹${selectedType['price']}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  if (_isEmergency) ...[
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Emergency Charge',
                          style: TextStyle(fontSize: 14, color: Colors.red),
                        ),
                        Text(
                          '₹${(selectedType['price'] * 0.3).toInt()}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Estimated Total',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '₹${_isEmergency ? (selectedType['price'] * 1.3).toInt() : selectedType['price']}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: theme.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 100),
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
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _confirmBooking,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                'Confirm Booking',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAmbulanceTypeCard(Map<String, dynamic> type, ThemeData theme) {
    final isSelected = _selectedAmbulanceType == type['name'];

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedAmbulanceType = type['name'];
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.primaryColor.withValues(alpha: 0.1)
              : Colors.white,
          border: Border.all(
            color: isSelected ? theme.primaryColor : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected
                    ? theme.primaryColor
                    : theme.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                type['icon'] ?? Icons.local_hospital,
                color: isSelected ? Colors.white : theme.primaryColor,
                size: 28,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    type['name'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: isSelected ? theme.primaryColor : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    type['description'] ?? '',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '💡 ${type['usage'] ?? ''}',
                    style: TextStyle(
                      fontSize: 11,
                      color: theme.primaryColor,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Text(
                  '₹${type['price']}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: isSelected ? theme.primaryColor : Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                if (isSelected)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: theme.primaryColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Selected',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
