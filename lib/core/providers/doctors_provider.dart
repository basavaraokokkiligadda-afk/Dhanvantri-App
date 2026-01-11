import 'package:flutter/foundation.dart';
import '../../data/models/doctor_model.dart';
import '../../data/mock_data/mock_doctors.dart';

/// Provider for managing doctor-related state and logic
class DoctorsProvider extends ChangeNotifier {
  List<Doctor> _doctors = [];
  List<Doctor> _filteredDoctors = [];
  String _selectedSpecialty = 'All';
  bool _isLoading = false;
  String? _error;

  List<Doctor> get doctors => _filteredDoctors;
  String get selectedSpecialty => _selectedSpecialty;
  bool get isLoading => _isLoading;
  String? get error => _error;

  DoctorsProvider() {
    loadDoctors();
  }

  /// Load doctors from mock data
  Future<void> loadDoctors() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 500));
      _doctors = MockDoctors.doctors;
      _filteredDoctors = _doctors;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load doctors: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Filter doctors by specialty
  void filterBySpecialty(String specialty) {
    _selectedSpecialty = specialty;
    if (specialty == 'All') {
      _filteredDoctors = _doctors;
    } else {
      _filteredDoctors = _doctors
          .where((doctor) => doctor.specialization == specialty)
          .toList();
    }
    notifyListeners();
  }

  /// Search doctors by name or specialty
  void searchDoctors(String query) {
    if (query.isEmpty) {
      _filteredDoctors = _doctors;
    } else {
      final lowerQuery = query.toLowerCase();
      _filteredDoctors = _doctors
          .where((doctor) =>
              doctor.name.toLowerCase().contains(lowerQuery) ||
              doctor.specialization.toLowerCase().contains(lowerQuery))
          .toList();
    }
    notifyListeners();
  }

  /// Get doctor by ID
  Doctor? getDoctorById(String id) {
    return MockDoctors.getDoctorById(id);
  }

  /// Get available doctors only
  List<Doctor> getAvailableDoctors() {
    return _doctors.where((doctor) => doctor.isAvailable).toList();
  }
}
