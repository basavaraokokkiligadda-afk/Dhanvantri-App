
import '../../core/app_export.dart';
import '../widgets/calendar_widget.dart';
import '../widgets/doctor_summary_card.dart';
import '../widgets/insurance_info_card.dart';
import '../widgets/patient_details_form.dart';
import '../widgets/time_slot_selector.dart';

/// Appointment Booking Screen
/// Facilitates medical appointment scheduling with calendar integration
class AppointmentBooking extends StatefulWidget {
  const AppointmentBooking({super.key});

  @override
  State<AppointmentBooking> createState() => _AppointmentBookingState();
}

class _AppointmentBookingState extends State<AppointmentBooking> {
  DateTime _selectedDate = DateTime.now();
  DateTime _focusedDate = DateTime.now();
  String? _selectedTimeSlot;
  String _selectedConsultationType = 'video';
  bool _isLoading = false;

  final TextEditingController _symptomsController = TextEditingController();
  final TextEditingController _concernsController = TextEditingController();

  final Map<String, dynamic> _doctorData = {
    'name': 'Dr. Priya Sharma',
    'specialization': 'Cardiologist',
    'experience': 15,
    'rating': 4.8,
    'reviews': 342,
    'fee': '₹ 800',
    'photo': 'https://img.rocket.new/generatedImages/rocket_gen_img_155748a5d-1763296653785.png',
    'photoSemanticLabel':
        'Professional photo of female doctor in white coat with stethoscope smiling at camera',
  };

  final Map<String, dynamic> _insuranceData = {
    'provider': 'X Health Insurance',
    'coverage': '₹ 5,00,000',
    'copay': '₹ 200',
    'yourPayment': '₹ 600',
  };

  final Map<DateTime, String> _availabilityMap = {};

  final List<String> _timeSlots = [
    '09:00 AM',
    '09:30 AM',
    '10:00 AM',
    '10:30 AM',
    '11:00 AM',
    '11:30 AM',
    '02:00 PM',
    '02:30 PM',
    '03:00 PM',
    '03:30 PM',
    '04:00 PM',
    '04:30 PM',
  ];

  @override
  void initState() {
    super.initState();
    _initializeAvailability();
  }

  void _initializeAvailability() {
    final now = DateTime.now();
    for (int i = 0; i < 90; i++) {
      final date = DateTime(now.year, now.month, now.day + i);
      if (i % 3 == 0) {
        _availabilityMap[date] = 'available';
      } else if (i % 3 == 1) {
        _availabilityMap[date] = 'limited';
      } else {
        _availabilityMap[date] = 'unavailable';
      }
    }
  }

  @override
  void dispose() {
    _symptomsController.dispose();
    _concernsController.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDate = selectedDay;
      _focusedDate = focusedDay;
      _selectedTimeSlot = null;
    });
  }

  void _onTimeSlotSelected(String timeSlot) {
    setState(() {
      _selectedTimeSlot = timeSlot;
    });
  }

  void _onConsultationTypeChanged(String type) {
    setState(() {
      _selectedConsultationType = type;
    });
  }

  Future<void> _bookAppointment() async {
    if (_selectedTimeSlot == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a time slot'),
          backgroundColor: Color(0xFFEF4444),
        ),
      );
      return;
    }

    if (_symptomsController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please describe your symptoms'),
          backgroundColor: Color(0xFFEF4444),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    _showConfirmationDialog();
  }

  void _showConfirmationDialog() {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: EdgeInsets.all(5.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const CustomIconWidget(
                  iconName: 'check_circle',
                  color: Color(0xFF10B981),
                  size: 48,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                'Appointment Confirmed!',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 1.h),
              Text(
                'Your appointment has been successfully booked',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 2.h),
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    _buildConfirmationRow(
                      context,
                      'Doctor',
                      _doctorData['name'] as String,
                    ),
                    SizedBox(height: 1.h),
                    _buildConfirmationRow(
                      context,
                      'Date',
                      '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                    ),
                    SizedBox(height: 1.h),
                    _buildConfirmationRow(
                      context,
                      'Time',
                      _selectedTimeSlot ?? '',
                    ),
                    SizedBox(height: 1.h),
                    _buildConfirmationRow(
                      context,
                      'Type',
                      _selectedConsultationType == 'video'
                          ? 'Video Call'
                          : 'In-Person',
                    ),
                  ],
                ),
              ),
              SizedBox(height: 3.h),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(
                          context,
                          rootNavigator: true,
                        ).pushNamed('/user-dashboard');
                      },
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 1.5.h),
                        side: BorderSide(
                          color: theme.colorScheme.primary,
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'View Details',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(
                          context,
                          rootNavigator: true,
                        ).pushNamed('/splash-screen');
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 1.5.h),
                        backgroundColor: theme.colorScheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Done',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConfirmationRow(
    BuildContext context,
    String label,
    String value,
  ) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: theme.colorScheme.onSurface,
            size: 24,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Book Appointment',
          style: theme.appBarTheme.titleTextStyle,
        ),
        actions: [
          IconButton(
            icon: CustomIconWidget(
              iconName: 'info_outline',
              color: theme.colorScheme.onSurface,
              size: 24,
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Appointment booking information'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                DoctorSummaryCard(
                  doctorData: _doctorData,
                  selectedConsultationType: _selectedConsultationType,
                  onConsultationTypeChanged: _onConsultationTypeChanged,
                ),
                CalendarWidget(
                  selectedDate: _selectedDate,
                  focusedDate: _focusedDate,
                  onDaySelected: _onDaySelected,
                  availabilityMap: _availabilityMap,
                ),
                TimeSlotSelector(
                  timeSlots: _timeSlots,
                  selectedTimeSlot: _selectedTimeSlot,
                  onTimeSlotSelected: _onTimeSlotSelected,
                ),
                PatientDetailsForm(
                  symptomsController: _symptomsController,
                  concernsController: _concernsController,
                ),
                InsuranceInfoCard(insuranceData: _insuranceData),
                SizedBox(height: 10.h),
              ],
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withValues(alpha: 0.3),
              child: Center(
                child: Container(
                  padding: EdgeInsets.all(5.w),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(
                        color: theme.colorScheme.primary,
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'Confirming Appointment...',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor,
              blurRadius: 8,
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
                  Text(
                    'Total Amount',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    _insuranceData['yourPayment'] as String,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 1.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _bookAppointment,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 1.8.h),
                    backgroundColor: theme.colorScheme.primary,
                    disabledBackgroundColor: theme.colorScheme.primary
                        .withValues(alpha: 0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Book Appointment',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
