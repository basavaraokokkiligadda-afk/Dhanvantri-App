import 'package:flutter/foundation.dart';
import '../../data/models/doctor_model.dart';
import '../../data/models/hospital_model.dart';
import '../../core/constants/app_constants.dart';

/// Unified booking provider for doctors, hospitals, diagnostic centers
class BookingProvider extends ChangeNotifier {
  String? _bookingType;
  Doctor? _selectedDoctor;
  Hospital? _selectedHospital;
  Map<String, dynamic>? _selectedEntity;
  DateTime? _selectedDate;
  String? _selectedTimeSlot;
  String _paymentType = AppConstants.paymentTypeFull;
  String? _notes;
  bool _isProcessing = false;

  String? get bookingType => _bookingType;
  Doctor? get selectedDoctor => _selectedDoctor;
  Hospital? get selectedHospital => _selectedHospital;
  Map<String, dynamic>? get selectedEntity => _selectedEntity;
  DateTime? get selectedDate => _selectedDate;
  String? get selectedTimeSlot => _selectedTimeSlot;
  String get paymentType => _paymentType;
  String? get notes => _notes;
  bool get isProcessing => _isProcessing;
  bool get canProceed => _selectedDate != null && _selectedTimeSlot != null;

  /// Initialize booking
  void initializeBooking({
    required String type,
    Doctor? doctor,
    Hospital? hospital,
    Map<String, dynamic>? entity,
  }) {
    _bookingType = type;
    _selectedDoctor = doctor;
    _selectedHospital = hospital;
    _selectedEntity = entity;
    _selectedDate = null;
    _selectedTimeSlot = null;
    _paymentType = AppConstants.paymentTypeFull;
    _notes = null;
    notifyListeners();
  }

  /// Set selected date
  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  /// Set selected time slot
  void setSelectedTimeSlot(String timeSlot) {
    _selectedTimeSlot = timeSlot;
    notifyListeners();
  }

  /// Set payment type
  void setPaymentType(String paymentType) {
    _paymentType = paymentType;
    notifyListeners();
  }

  /// Set notes
  void setNotes(String notes) {
    _notes = notes;
    notifyListeners();
  }

  /// Get consultation fee
  double getConsultationFee() {
    if (_selectedDoctor != null) {
      return _selectedDoctor!.fee;
    } else if (_selectedEntity != null && _selectedEntity!['fee'] != null) {
      return (_selectedEntity!['fee'] as num).toDouble();
    }
    return 0;
  }

  /// Get final amount based on payment type
  double getFinalAmount() {
    final fee = getConsultationFee();
    if (_paymentType == AppConstants.paymentTypeToken) {
      return AppConstants.tokenAmount;
    }
    return fee;
  }

  /// Reset booking
  void resetBooking() {
    _bookingType = null;
    _selectedDoctor = null;
    _selectedHospital = null;
    _selectedEntity = null;
    _selectedDate = null;
    _selectedTimeSlot = null;
    _paymentType = AppConstants.paymentTypeFull;
    _notes = null;
    _isProcessing = false;
    notifyListeners();
  }

  /// Process booking
  Future<bool> processBooking() async {
    if (!canProceed) return false;

    _isProcessing = true;
    notifyListeners();

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      _isProcessing = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isProcessing = false;
      notifyListeners();
      return false;
    }
  }
}
