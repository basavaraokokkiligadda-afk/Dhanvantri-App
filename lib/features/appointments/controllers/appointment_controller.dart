import 'package:flutter/foundation.dart';
import '../../../data/models/appointment_model.dart';
import '../../../data/models/doctor_model.dart';
import '../../../data/models/hospital_model.dart';

/// Production-grade Appointment Controller
/// Handles all appointment-related business logic
class AppointmentController extends ChangeNotifier {
  // ========== STATE ==========
  List<Appointment> _appointments = [];
  Appointment? _currentAppointment;
  bool _isLoading = false;
  String? _errorMessage;

  // Booking state
  DateTime? _selectedDate;
  String? _selectedTimeSlot;
  Doctor? _selectedDoctor;
  Hospital? _selectedHospital;
  String _consultationType = 'video';
  String? _symptoms;
  String? _concerns;

  // ========== GETTERS ==========
  List<Appointment> get appointments => _appointments;
  Appointment? get currentAppointment => _currentAppointment;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  DateTime? get selectedDate => _selectedDate;
  String? get selectedTimeSlot => _selectedTimeSlot;
  Doctor? get selectedDoctor => _selectedDoctor;
  Hospital? get selectedHospital => _selectedHospital;
  String get consultationType => _consultationType;
  String? get symptoms => _symptoms;
  String? get concerns => _concerns;

  bool get canProceedToSummary =>
      _selectedDate != null && _selectedTimeSlot != null;

  // ========== APPOINTMENT MANAGEMENT ==========

  /// Initialize a new appointment booking
  void initializeBooking({Doctor? doctor, Hospital? hospital}) {
    _selectedDoctor = doctor;
    _selectedHospital = hospital;
    _selectedDate = null;
    _selectedTimeSlot = null;
    _consultationType = 'video';
    _symptoms = null;
    _concerns = null;
    _errorMessage = null;
    notifyListeners();
  }

  /// Set selected date
  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    _selectedTimeSlot = null; // Reset time slot when date changes
    notifyListeners();
  }

  /// Set selected time slot
  void setSelectedTimeSlot(String timeSlot) {
    _selectedTimeSlot = timeSlot;
    notifyListeners();
  }

  /// Set consultation type
  void setConsultationType(String type) {
    _consultationType = type;
    notifyListeners();
  }

  /// Set symptoms
  void setSymptoms(String? value) {
    _symptoms = value;
    notifyListeners();
  }

  /// Set concerns
  void setConcerns(String? value) {
    _concerns = value;
    notifyListeners();
  }

  /// Fetch all appointments
  Future<void> fetchAppointments() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(seconds: 1));

      // Mock data for now
      _appointments = _generateMockAppointments();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to fetch appointments: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Create a new appointment
  Future<bool> createAppointment() async {
    if (!canProceedToSummary) {
      _errorMessage = 'Please select date and time slot';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(seconds: 2));

      final newAppointment = Appointment(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        doctorName: _selectedDoctor?.name ?? 'Unknown Doctor',
        specialty: _selectedDoctor?.specialization ?? 'General',
        date: _selectedDate!,
        time: _selectedTimeSlot!,
        type: _consultationType,
        status: 'upcoming',
        fee: _selectedDoctor?.fee ?? 0.0,
      );

      _appointments.insert(0, newAppointment);
      _currentAppointment = newAppointment;

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to create appointment: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Cancel an appointment
  Future<bool> cancelAppointment(String appointmentId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(seconds: 1));

      final index = _appointments.indexWhere((a) => a.id == appointmentId);
      if (index != -1) {
        _appointments[index] =
            _appointments[index].copyWith(status: 'cancelled');
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to cancel appointment: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Reschedule an appointment
  Future<bool> rescheduleAppointment(
    String appointmentId,
    DateTime newDate,
    String newTimeSlot,
  ) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(seconds: 1));

      final index = _appointments.indexWhere((a) => a.id == appointmentId);
      if (index != -1) {
        _appointments[index] = _appointments[index].copyWith(
          date: newDate,
          time: newTimeSlot,
        );
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to reschedule appointment: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Get appointment by ID
  Appointment? getAppointmentById(String id) {
    try {
      return _appointments.firstWhere((a) => a.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Filter appointments by status
  List<Appointment> getAppointmentsByStatus(String status) {
    return _appointments.where((a) => a.status == status).toList();
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Reset booking state
  void resetBooking() {
    _selectedDate = null;
    _selectedTimeSlot = null;
    _selectedDoctor = null;
    _selectedHospital = null;
    _consultationType = 'video';
    _symptoms = null;
    _concerns = null;
    _errorMessage = null;
    notifyListeners();
  }

  // ========== PRIVATE HELPERS ==========

  List<Appointment> _generateMockAppointments() {
    final now = DateTime.now();
    return [
      Appointment(
        id: '1',
        doctorName: 'Dr. Sarah Johnson',
        specialty: 'Cardiologist',
        date: now.add(const Duration(days: 2)),
        time: '10:00 AM',
        type: 'video',
        status: 'upcoming',
        fee: 800.0,
      ),
      Appointment(
        id: '2',
        doctorName: 'Dr. Michael Chen',
        specialty: 'Dermatologist',
        date: now.add(const Duration(days: 5)),
        time: '02:30 PM',
        type: 'clinic',
        status: 'upcoming',
        fee: 600.0,
      ),
      Appointment(
        id: '3',
        doctorName: 'Dr. Priya Sharma',
        specialty: 'Pediatrician',
        date: now.subtract(const Duration(days: 3)),
        time: '11:00 AM',
        type: 'video',
        status: 'completed',
        fee: 500.0,
      ),
    ];
  }
}
