import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/routes/app_routes.dart';
import 'dart:math';

/// Unified Booking Screen - Handles both Hospital and Doctor bookings
class UnifiedBookingScreen extends StatefulWidget {
  final String type; // 'hospital' or 'doctor'
  final Map<String, dynamic> data;

  const UnifiedBookingScreen({
    super.key,
    required this.type,
    required this.data,
  });

  @override
  State<UnifiedBookingScreen> createState() => _UnifiedBookingScreenState();
}

class _UnifiedBookingScreenState extends State<UnifiedBookingScreen> {
  // Form controllers
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _mobileController = TextEditingController();

  // Booking selections
  DateTime? selectedDate;
  String? selectedTimeSlot;
  String? selectedGender;
  String? selectedDepartment;
  String? selectedDoctor;

  // Mock departments for hospital booking
  final List<String> departments = [
    'Cardiology',
    'Neurology',
    'Orthopedics',
    'Pediatrics',
    'General Medicine',
    'ENT',
    'Dermatology',
    'Gynecology',
  ];

  // Mock doctors for hospital booking
  final Map<String, List<String>> departmentDoctors = {
    'Cardiology': ['Dr. Sarah Johnson', 'Dr. Rajesh Kumar', 'Dr. Emily Chen'],
    'Neurology': ['Dr. Michael Brown', 'Dr. Priya Sharma', 'Dr. David Lee'],
    'Orthopedics': ['Dr. James Wilson', 'Dr. Anita Patel', 'Dr. Robert Taylor'],
    'Pediatrics': ['Dr. Lisa Anderson', 'Dr. Amit Verma', 'Dr. Maria Garcia'],
    'General Medicine': [
      'Dr. John Smith',
      'Dr. Sneha Reddy',
      'Dr. Chris Evans'
    ],
    'ENT': ['Dr. Rachel Green', 'Dr. Vikram Singh', 'Dr. Olivia Martin'],
    'Dermatology': ['Dr. Sophia White', 'Dr. Arjun Nair', 'Dr. Emma Thompson'],
    'Gynecology': [
      'Dr. Jennifer Lopez',
      'Dr. Kavita Desai',
      'Dr. Laura Harris'
    ],
  };

  // Time slots
  final Map<String, List<String>> timeSlots = {
    'Morning': [
      '09:00 AM',
      '09:30 AM',
      '10:00 AM',
      '10:30 AM',
      '11:00 AM',
      '11:30 AM'
    ],
    'Afternoon': [
      '02:00 PM',
      '02:30 PM',
      '03:00 PM',
      '03:30 PM',
      '04:00 PM',
      '04:30 PM'
    ],
    'Evening': [
      '05:00 PM',
      '05:30 PM',
      '06:00 PM',
      '06:30 PM',
      '07:00 PM',
      '07:30 PM'
    ],
  };

  // Genders
  final List<String> genders = ['Male', 'Female', 'Other'];

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _mobileController.dispose();
    super.dispose();
  }

  bool get isHospitalBooking => widget.type == 'hospital';

  String get consultationFee => isHospitalBooking
      ? '₹${500 + Random().nextInt(500)}'
      : (widget.data['consultationFee'] ?? '₹800');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Book Appointment'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Booking Details Section
            _buildBookingDetailsCard(theme),

            // Date Selection
            _buildDateSelectionCard(theme),

            // Time Slot Selection
            if (selectedDate != null) _buildTimeSlotCard(theme),

            // Patient Details Form
            if (selectedTimeSlot != null) _buildPatientDetailsCard(theme),

            // Confirmation Section
            if (_formKey.currentState != null &&
                selectedDate != null &&
                selectedTimeSlot != null)
              _buildConfirmationCard(theme),

            const SizedBox(height: 100), // Space for floating button
          ],
        ),
      ),
      floatingActionButton: _canConfirmBooking()
          ? FloatingActionButton.extended(
              onPressed: _confirmBooking,
              icon: const Icon(Icons.check_circle),
              label: const Text('Confirm Booking'),
            )
          : null,
    );
  }

  Widget _buildBookingDetailsCard(ThemeData theme) {
    return Card(
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isHospitalBooking ? Icons.local_hospital : Icons.person,
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  isHospitalBooking ? 'Hospital Booking' : 'Doctor Booking',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(height: 24),

            // Hospital/Doctor Name
            _buildInfoRow(
              isHospitalBooking ? 'Hospital' : 'Doctor',
              widget.data['name'] ?? 'N/A',
            ),
            const SizedBox(height: 8),

            // Specialization/Type
            if (!isHospitalBooking)
              _buildInfoRow(
                'Specialization',
                widget.data['specialization'] ?? 'N/A',
              ),
            if (isHospitalBooking)
              _buildInfoRow(
                'Type',
                widget.data['type'] ?? 'N/A',
              ),
            const SizedBox(height: 8),

            // Hospital for doctor OR Department selection for hospital
            if (!isHospitalBooking)
              _buildInfoRow(
                'Hospital',
                widget.data['hospital'] ?? 'Apollo Care Center',
              ),
            if (isHospitalBooking) ...[
              const SizedBox(height: 12),
              const Text(
                'Select Department *',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                initialValue: selectedDepartment,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[50],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                ),
                hint: const Text('Choose department'),
                items: departments.map((dept) {
                  return DropdownMenuItem(value: dept, child: Text(dept));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedDepartment = value;
                    selectedDoctor =
                        null; // Reset doctor when department changes
                  });
                },
              ),
            ],

            // Doctor selection for hospital
            if (isHospitalBooking && selectedDepartment != null) ...[
              const SizedBox(height: 16),
              const Text(
                'Select Doctor *',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                initialValue: selectedDoctor,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[50],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                ),
                hint: const Text('Choose doctor'),
                items: (departmentDoctors[selectedDepartment] ?? []).map((doc) {
                  return DropdownMenuItem(value: doc, child: Text(doc));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedDoctor = value;
                  });
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 110,
          child: Text(
            '$label:',
            style: TextStyle(color: Colors.grey[700], fontSize: 14),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildDateSelectionCard(ThemeData theme) {
    // Only show if hospital has department+doctor selected OR if it's doctor booking
    if (isHospitalBooking &&
        (selectedDepartment == null || selectedDoctor == null)) {
      return const SizedBox.shrink();
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Date *',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            InkWell(
              onTap: () => _selectDate(context),
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.calendar_today,
                        color: theme.colorScheme.primary, size: 20),
                    const SizedBox(width: 12),
                    Text(
                      selectedDate == null
                          ? 'Choose appointment date'
                          : DateFormat('EEEE, MMM dd, yyyy')
                              .format(selectedDate!),
                      style: TextStyle(
                        fontSize: 14,
                        color: selectedDate == null
                            ? Colors.grey[600]
                            : Colors.black87,
                        fontWeight: selectedDate == null
                            ? FontWeight.normal
                            : FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeSlotCard(ThemeData theme) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Time Slot *',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...timeSlots.entries.map((entry) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.key,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: entry.value.map((slot) {
                      final isSelected = selectedTimeSlot == slot;
                      return ChoiceChip(
                        label: Text(slot, style: const TextStyle(fontSize: 12)),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            selectedTimeSlot = selected ? slot : null;
                          });
                        },
                        selectedColor: theme.colorScheme.primary,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Colors.black87,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 12),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildPatientDetailsCard(ThemeData theme) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Patient Details',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // Name
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name *',
                  prefixIcon: Icon(Icons.person_outline, size: 20),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter patient name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Age and Gender Row
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _ageController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Age *',
                        prefixIcon: Icon(Icons.calendar_today, size: 20),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Required';
                        }
                        final age = int.tryParse(value);
                        if (age == null || age < 1 || age > 120) {
                          return 'Invalid age';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: selectedGender,
                      decoration: const InputDecoration(
                        labelText: 'Gender *',
                        prefixIcon: Icon(Icons.wc, size: 20),
                        border: OutlineInputBorder(),
                      ),
                      items: genders.map((gender) {
                        return DropdownMenuItem(
                            value: gender, child: Text(gender));
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedGender = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) return 'Required';
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Mobile Number
              TextFormField(
                controller: _mobileController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Mobile Number *',
                  prefixIcon: Icon(Icons.phone, size: 20),
                  border: OutlineInputBorder(),
                  prefixText: '+91 ',
                ),
                maxLength: 10,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter mobile number';
                  }
                  if (value.trim().length != 10) {
                    return 'Mobile number must be 10 digits';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConfirmationCard(ThemeData theme) {
    if (!_canConfirmBooking()) return const SizedBox.shrink();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      color: theme.colorScheme.primaryContainer.withOpacity(0.3),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.receipt_long,
                    color: theme.colorScheme.primary, size: 20),
                const SizedBox(width: 8),
                const Text(
                  'Booking Summary',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(height: 20),
            _buildSummaryRow(
                'Date', DateFormat('EEEE, MMM dd, yyyy').format(selectedDate!)),
            _buildSummaryRow('Time', selectedTimeSlot!),
            _buildSummaryRow('Patient', _nameController.text.trim()),
            if (isHospitalBooking) ...[
              _buildSummaryRow('Department', selectedDepartment!),
              _buildSummaryRow('Doctor', selectedDoctor!),
            ] else ...[
              _buildSummaryRow('Doctor', widget.data['name']),
            ],
            const Divider(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Consultation Fee:',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
                Text(
                  consultationFee,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: TextStyle(color: Colors.grey[700], fontSize: 13),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  bool _canConfirmBooking() {
    if (selectedDate == null || selectedTimeSlot == null) return false;
    if (_nameController.text.trim().isEmpty) return false;
    if (_ageController.text.trim().isEmpty) return false;
    if (selectedGender == null) return false;
    if (_mobileController.text.trim().length != 10) return false;
    if (isHospitalBooking &&
        (selectedDepartment == null || selectedDoctor == null)) {
      return false;
    }
    return true;
  }

  Future<void> _selectDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 90)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).colorScheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
        selectedTimeSlot = null; // Reset time slot when date changes
      });
    }
  }

  void _confirmBooking() {
    if (_formKey.currentState!.validate()) {
      // Navigate directly to appointment summary (no confirmation dialog)
      Navigator.pushNamed(
        context,
        AppRoutes.appointmentSummary,
        arguments: {
          'type': widget.type,
          'data': widget.data,
          'bookingInfo': {
            'name': _nameController.text.trim(),
            'age': _ageController.text.trim(),
            'gender': selectedGender,
            'mobile': _mobileController.text.trim(),
            'date': selectedDate,
            'timeSlot': selectedTimeSlot,
            'department': selectedDepartment,
            'doctor': selectedDoctor,
          },
        },
      );
    }
  }
}
