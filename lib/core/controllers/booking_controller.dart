import 'package:flutter/foundation.dart';
import '../../../data/models/doctor_model.dart';
import '../../../data/models/hospital_model.dart';

/// Production-grade Booking Controller
/// Unified controller for doctor, hospital, and diagnostic center bookings
class BookingController extends ChangeNotifier {
  // ========== STATE ==========
  String? _bookingType; // 'doctor', 'hospital', 'diagnostic', 'ambulance'
  dynamic _selectedEntity; // Doctor, Hospital, or DiagnosticCenter
  DateTime? _selectedDate;
  String? _selectedTimeSlot;
  String? _selectedDepartment;
  String? _selectedDoctor; // For hospital bookings

  // Patient details
  String _patientName = '';
  int? _patientAge;
  String? _patientGender;
  String _patientMobile = '';
  String? _patientEmail;
  String? _symptoms;

  // Payment
  String _paymentType = 'full'; // 'full' or 'partial'

  bool _isProcessing = false;
  String? _errorMessage;

  // ========== GETTERS ==========
  String? get bookingType => _bookingType;
  dynamic get selectedEntity => _selectedEntity;
  DateTime? get selectedDate => _selectedDate;
  String? get selectedTimeSlot => _selectedTimeSlot;
  String? get selectedDepartment => _selectedDepartment;
  String? get selectedDoctor => _selectedDoctor;
  String get patientName => _patientName;
  int? get patientAge => _patientAge;
  String? get patientGender => _patientGender;
  String get patientMobile => _patientMobile;
  String? get patientEmail => _patientEmail;
  String? get symptoms => _symptoms;
  String get paymentType => _paymentType;
  bool get isProcessing => _isProcessing;
  String? get errorMessage => _errorMessage;

  bool get canProceedToSummary =>
      _selectedDate != null &&
      _selectedTimeSlot != null &&
      _patientName.isNotEmpty &&
      _patientAge != null &&
      _patientGender != null &&
      _patientMobile.isNotEmpty;

  double get bookingFee {
    if (_selectedEntity == null) return 0.0;

    if (_selectedEntity is Doctor) {
      return (_selectedEntity as Doctor).fee;
    } else if (_selectedEntity is Hospital) {
      return 500.0; // Default hospital consultation fee
    }
    return 0.0;
  }

  // ========== INITIALIZATION ==========

  /// Initialize booking
  void initializeBooking({
    required String type,
    required dynamic entity,
  }) {
    _bookingType = type;
    _selectedEntity = entity;
    resetBookingDetails();
    notifyListeners();
  }

  /// Reset booking details
  void resetBookingDetails() {
    _selectedDate = null;
    _selectedTimeSlot = null;
    _selectedDepartment = null;
    _selectedDoctor = null;
    _patientName = '';
    _patientAge = null;
    _patientGender = null;
    _patientMobile = '';
    _patientEmail = null;
    _symptoms = null;
    _paymentType = 'full';
    _errorMessage = null;
  }

  /// Complete reset
  void reset() {
    _bookingType = null;
    _selectedEntity = null;
    resetBookingDetails();
    notifyListeners();
  }

  // ========== BOOKING DETAILS ==========

  /// Set selected date
  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    _selectedTimeSlot = null; // Reset time when date changes
    notifyListeners();
  }

  /// Set selected time slot
  void setSelectedTimeSlot(String timeSlot) {
    _selectedTimeSlot = timeSlot;
    notifyListeners();
  }

  /// Set selected department (for hospital bookings)
  void setSelectedDepartment(String? department) {
    _selectedDepartment = department;
    _selectedDoctor = null; // Reset doctor when department changes
    notifyListeners();
  }

  /// Set selected doctor (for hospital bookings)
  void setSelectedDoctor(String? doctor) {
    _selectedDoctor = doctor;
    notifyListeners();
  }

  // ========== PATIENT DETAILS ==========

  /// Set patient name
  void setPatientName(String name) {
    _patientName = name;
    notifyListeners();
  }

  /// Set patient age
  void setPatientAge(int? age) {
    _patientAge = age;
    notifyListeners();
  }

  /// Set patient gender
  void setPatientGender(String? gender) {
    _patientGender = gender;
    notifyListeners();
  }

  /// Set patient mobile
  void setPatientMobile(String mobile) {
    _patientMobile = mobile;
    notifyListeners();
  }

  /// Set patient email
  void setPatientEmail(String? email) {
    _patientEmail = email;
    notifyListeners();
  }

  /// Set symptoms
  void setSymptoms(String? symptoms) {
    _symptoms = symptoms;
    notifyListeners();
  }

  /// Set payment type
  void setPaymentType(String type) {
    _paymentType = type;
    notifyListeners();
  }

  // ========== BOOKING CONFIRMATION ==========

  /// Confirm booking
  Future<Map<String, dynamic>?> confirmBooking() async {
    if (!canProceedToSummary) {
      _errorMessage = 'Please fill all required fields';
      notifyListeners();
      return null;
    }

    _isProcessing = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(seconds: 2));

      final bookingData = {
        'id': _generateBookingId(),
        'type': _bookingType,
        'entityName': _getEntityName(),
        'date': _selectedDate,
        'time': _selectedTimeSlot,
        'department': _selectedDepartment,
        'doctor': _selectedDoctor,
        'patientName': _patientName,
        'patientAge': _patientAge,
        'patientGender': _patientGender,
        'patientMobile': _patientMobile,
        'patientEmail': _patientEmail,
        'symptoms': _symptoms,
        'fee': bookingFee,
        'paymentType': _paymentType,
        'status': 'confirmed',
        'createdAt': DateTime.now(),
      };

      _isProcessing = false;
      notifyListeners();
      return bookingData;
    } catch (e) {
      _errorMessage = 'Failed to confirm booking: ${e.toString()}';
      _isProcessing = false;
      notifyListeners();
      return null;
    }
  }

  /// Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // ========== HELPERS ==========

  String _getEntityName() {
    if (_selectedEntity == null) return 'Unknown';

    if (_selectedEntity is Doctor) {
      return (_selectedEntity as Doctor).name;
    } else if (_selectedEntity is Hospital) {
      return (_selectedEntity as Hospital).name;
    }
    return 'Unknown';
  }

  String _generateBookingId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final prefix = _bookingType?.substring(0, 3).toUpperCase() ?? 'BKG';
    return '$prefix$timestamp';
  }

  /// Validate mobile number
  bool isValidMobile(String mobile) {
    final cleaned = mobile.replaceAll(RegExp(r'\D'), '');
    return cleaned.length == 10;
  }

  /// Validate email
  bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }
}
