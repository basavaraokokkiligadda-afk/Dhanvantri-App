import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/routes/app_routes.dart';

/// Appointments History Page
/// Shows current/upcoming appointments, previous appointments, and pill reminders
class AppointmentsHistoryScreen extends StatefulWidget {
  const AppointmentsHistoryScreen({super.key});

  @override
  State<AppointmentsHistoryScreen> createState() =>
      _AppointmentsHistoryScreenState();
}

class _AppointmentsHistoryScreenState extends State<AppointmentsHistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<Map<String, dynamic>> _pillReminders = [];

  // Mock data for appointments
  final List<Map<String, dynamic>> _upcomingAppointments = [
    {
      'id': 'APT001',
      'doctorName': 'Dr. Sarah Johnson',
      'specialty': 'Cardiologist',
      'date': DateTime.now().add(const Duration(days: 2)),
      'time': '10:00 AM',
      'hospitalName': 'Apollo Care Center',
      'fee': '₹500',
      'status': 'Confirmed',
    },
    {
      'id': 'APT002',
      'doctorName': 'Dr. Rajesh Kumar',
      'specialty': 'Orthopedic',
      'date': DateTime.now().add(const Duration(days: 5)),
      'time': '2:30 PM',
      'hospitalName': 'Sunrise Hospital',
      'fee': '₹400',
      'status': 'Upcoming',
    },
  ];

  final List<Map<String, dynamic>> _previousAppointments = [
    {
      'id': 'APT003',
      'doctorName': 'Dr. Emily Williams',
      'specialty': 'General Physician',
      'date': DateTime.now().subtract(const Duration(days: 10)),
      'time': '11:00 AM',
      'status': 'Completed',
    },
    {
      'id': 'APT004',
      'doctorName': 'Dr. Michael Chen',
      'specialty': 'Dermatologist',
      'date': DateTime.now().subtract(const Duration(days: 25)),
      'time': '3:00 PM',
      'status': 'Completed',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _addPillReminder() {
    showDialog(
      context: context,
      builder: (context) => _PillReminderDialog(
        onAdd: (reminder) {
          setState(() {
            _pillReminders.add(reminder);
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Appointments'),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Upcoming'),
            Tab(text: 'Previous'),
            Tab(text: 'Reminders'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Upcoming Appointments
          _buildUpcomingTab(theme),
          // Previous Appointments
          _buildPreviousTab(theme),
          // Pill Reminders
          _buildRemindersTab(theme),
        ],
      ),
      floatingActionButton: _tabController.index == 2
          ? FloatingActionButton.extended(
              onPressed: _addPillReminder,
              icon: const Icon(Icons.add),
              label: const Text('Add Reminder'),
            )
          : null,
    );
  }

  Widget _buildUpcomingTab(ThemeData theme) {
    if (_upcomingAppointments.isEmpty) {
      return _buildEmptyState('No upcoming appointments');
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _upcomingAppointments.length,
      itemBuilder: (context, index) {
        final appointment = _upcomingAppointments[index];
        return _buildUpcomingAppointmentCard(appointment, theme);
      },
    );
  }

  Widget _buildPreviousTab(ThemeData theme) {
    if (_previousAppointments.isEmpty) {
      return _buildEmptyState('No previous appointments');
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _previousAppointments.length,
      itemBuilder: (context, index) {
        final appointment = _previousAppointments[index];
        return _buildPreviousAppointmentCard(appointment, theme);
      },
    );
  }

  Widget _buildRemindersTab(ThemeData theme) {
    if (_pillReminders.isEmpty) {
      return _buildEmptyState('No pill reminders set');
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _pillReminders.length,
      itemBuilder: (context, index) {
        final reminder = _pillReminders[index];
        return _buildReminderCard(reminder, theme, index);
      },
    );
  }

  Widget _buildUpcomingAppointmentCard(
      Map<String, dynamic> appointment, ThemeData theme) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: appointment['status'] == 'Confirmed'
                        ? Colors.green.withValues(alpha: 0.1)
                        : Colors.orange.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    appointment['status'],
                    style: TextStyle(
                      color: appointment['status'] == 'Confirmed'
                          ? Colors.green
                          : Colors.orange,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
                Text(
                  appointment['id'],
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Doctor Info
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: theme.primaryColor.withValues(alpha: 0.1),
                  child:
                      Icon(Icons.person, color: theme.primaryColor, size: 30),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appointment['doctorName'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        appointment['specialty'],
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 24),

            // Appointment Details
            _buildDetailRow(
              Icons.calendar_today,
              DateFormat('EEEE, MMM dd, yyyy').format(appointment['date']),
            ),
            const SizedBox(height: 8),
            _buildDetailRow(Icons.access_time, appointment['time']),
            const SizedBox(height: 8),
            _buildDetailRow(Icons.local_hospital, appointment['hospitalName']),
            const SizedBox(height: 8),
            _buildDetailRow(Icons.payments, appointment['fee']),
            const SizedBox(height: 16),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.appointmentDetails,
                        arguments: appointment,
                      );
                    },
                    icon: const Icon(Icons.info_outline, size: 18),
                    label: const Text('View Details'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.ambulanceBooking,
                        arguments: appointment,
                      );
                    },
                    icon: const Icon(Icons.local_hospital, size: 18),
                    label: const Text('Ambulance'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
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

  Widget _buildPreviousAppointmentCard(
      Map<String, dynamic> appointment, ThemeData theme) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.grey.shade200,
          child: const Icon(Icons.check_circle, color: Colors.green),
        ),
        title: Text(
          appointment['doctorName'],
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(appointment['specialty']),
            const SizedBox(height: 2),
            Text(
              DateFormat('MMM dd, yyyy').format(appointment['date']),
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.green.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text(
            'Completed',
            style: TextStyle(
              color: Colors.green,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        isThreeLine: true,
      ),
    );
  }

  Widget _buildReminderCard(
      Map<String, dynamic> reminder, ThemeData theme, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: theme.primaryColor.withValues(alpha: 0.1),
          child: Icon(Icons.medication, color: theme.primaryColor),
        ),
        title: Text(
          reminder['pillName'],
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text('Time: ${reminder['time']}'),
            const SizedBox(height: 2),
            Text('Days: ${reminder['days']}'),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.red),
          onPressed: () {
            setState(() {
              _pillReminders.removeAt(index);
            });
          },
        ),
        isThreeLine: true,
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.calendar_today_outlined,
              size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

/// Pill Reminder Dialog
class _PillReminderDialog extends StatefulWidget {
  final Function(Map<String, dynamic>) onAdd;

  const _PillReminderDialog({required this.onAdd});

  @override
  State<_PillReminderDialog> createState() => _PillReminderDialogState();
}

class _PillReminderDialogState extends State<_PillReminderDialog> {
  final TextEditingController _pillNameController = TextEditingController();
  TimeOfDay _selectedTime = TimeOfDay.now();
  String _selectedDays = 'Daily';

  @override
  void dispose() {
    _pillNameController.dispose();
    super.dispose();
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text('Add Pill Reminder'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _pillNameController,
              decoration: const InputDecoration(
                labelText: 'Medicine Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: Colors.grey.shade300),
              ),
              leading: const Icon(Icons.access_time),
              title: Text(_selectedTime.format(context)),
              subtitle: const Text('Select Time'),
              onTap: _selectTime,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _selectedDays,
              decoration: const InputDecoration(
                labelText: 'Frequency',
                border: OutlineInputBorder(),
              ),
              items: ['Daily', 'Every 2 Days', 'Weekly', 'Custom']
                  .map((day) => DropdownMenuItem(
                        value: day,
                        child: Text(day),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedDays = value!;
                });
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_pillNameController.text.trim().isNotEmpty) {
              widget.onAdd({
                'pillName': _pillNameController.text.trim(),
                'time': _selectedTime.format(context),
                'days': _selectedDays,
              });
              Navigator.pop(context);
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
