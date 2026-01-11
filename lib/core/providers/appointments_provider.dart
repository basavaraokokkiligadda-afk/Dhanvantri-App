import 'package:flutter/foundation.dart';
import '../../data/models/appointment_model.dart';
import '../../core/constants/app_constants.dart';

/// Provider for managing appointment booking and history
class AppointmentsProvider extends ChangeNotifier {
  final List<Appointment> _appointments = [];
  bool _isLoading = false;
  String? _error;

  List<Appointment> get appointments => _appointments;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Create a new appointment
  Future<bool> createAppointment(Appointment appointment) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      _appointments.add(appointment);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to create appointment: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Get appointments by status
  List<Appointment> getAppointmentsByStatus(String status) {
    return _appointments
        .where((appointment) => appointment.status == status)
        .toList();
  }

  /// Get upcoming appointments
  List<Appointment> getUpcomingAppointments() {
    final now = DateTime.now();
    return _appointments
        .where((appointment) =>
            appointment.date.isAfter(now) &&
            appointment.status != AppConstants.statusCancelled)
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }

  /// Get past appointments
  List<Appointment> getPastAppointments() {
    final now = DateTime.now();
    return _appointments
        .where((appointment) => appointment.date.isBefore(now))
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  /// Cancel appointment
  Future<bool> cancelAppointment(String appointmentId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 500));
      final index = _appointments.indexWhere((a) => a.id == appointmentId);
      if (index != -1) {
        _appointments[index] =
            _appointments[index].copyWith(status: AppConstants.statusCancelled);
      }
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to cancel appointment: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Update appointment status
  Future<bool> updateAppointmentStatus(
      String appointmentId, String status) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 500));
      final index = _appointments.indexWhere((a) => a.id == appointmentId);
      if (index != -1) {
        _appointments[index] = _appointments[index].copyWith(status: status);
      }
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to update appointment: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Get appointment by ID
  Appointment? getAppointmentById(String id) {
    try {
      return _appointments.firstWhere((appointment) => appointment.id == id);
    } catch (e) {
      return null;
    }
  }
}
