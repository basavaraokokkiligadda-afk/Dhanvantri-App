import 'package:flutter/foundation.dart';
import '../../../data/models/doctor_model.dart';

/// Production-grade Doctors Controller
/// Handles all doctor-related business logic
class DoctorsController extends ChangeNotifier {
  // ========== STATE ==========
  List<Doctor> _allDoctors = [];
  List<Doctor> _filteredDoctors = [];
  Doctor? _selectedDoctor;
  bool _isLoading = false;
  String? _errorMessage;

  // Filters
  String _searchQuery = '';
  String? _selectedSpecialty;
  String? _selectedExperience;
  double? _maxFee;
  bool _onlyAvailableToday = false;

  // ========== GETTERS ==========
  List<Doctor> get allDoctors => _allDoctors;
  List<Doctor> get filteredDoctors => _filteredDoctors;
  Doctor? get selectedDoctor => _selectedDoctor;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;
  String? get selectedSpecialty => _selectedSpecialty;

  List<String> get availableSpecialties {
    return _allDoctors.map((d) => d.specialization).toSet().toList()..sort();
  }

  // ========== DOCTOR MANAGEMENT ==========

  /// Fetch all doctors
  Future<void> fetchDoctors() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(seconds: 1));

      _allDoctors = _generateMockDoctors();
      _filteredDoctors = _allDoctors;

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to fetch doctors: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Search doctors
  void searchDoctors(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  /// Filter by specialty
  void filterBySpecialty(String? specialty) {
    _selectedSpecialty = specialty;
    _applyFilters();
  }

  /// Filter by experience
  void filterByExperience(String? experience) {
    _selectedExperience = experience;
    _applyFilters();
  }

  /// Filter by max fee
  void filterByMaxFee(double? fee) {
    _maxFee = fee;
    _applyFilters();
  }

  /// Toggle available today filter
  void toggleAvailableToday() {
    _onlyAvailableToday = !_onlyAvailableToday;
    _applyFilters();
  }

  void _applyFilters() {
    _filteredDoctors = _allDoctors.where((doctor) {
      final matchesSearch = _searchQuery.isEmpty ||
          doctor.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          doctor.specialization
              .toLowerCase()
              .contains(_searchQuery.toLowerCase());

      final matchesSpecialty = _selectedSpecialty == null ||
          _selectedSpecialty == 'All' ||
          doctor.specialization == _selectedSpecialty;

      final matchesFee = _maxFee == null || doctor.fee <= _maxFee!;

      final matchesExperience = _selectedExperience == null ||
          _matchesExperienceRange(doctor.experience, _selectedExperience!);

      final matchesAvailability = !_onlyAvailableToday || doctor.isAvailable;

      return matchesSearch &&
          matchesSpecialty &&
          matchesFee &&
          matchesExperience &&
          matchesAvailability;
    }).toList();
    notifyListeners();
  }

  bool _matchesExperienceRange(int experience, String range) {
    switch (range) {
      case '0-5':
        return experience <= 5;
      case '5-10':
        return experience > 5 && experience <= 10;
      case '10+':
        return experience > 10;
      default:
        return true;
    }
  }

  /// Clear all filters
  void clearFilters() {
    _searchQuery = '';
    _selectedSpecialty = null;
    _selectedExperience = null;
    _maxFee = null;
    _onlyAvailableToday = false;
    _filteredDoctors = _allDoctors;
    notifyListeners();
  }

  /// Select a doctor
  void selectDoctor(Doctor doctor) {
    _selectedDoctor = doctor;
    notifyListeners();
  }

  /// Clear selected doctor
  void clearSelectedDoctor() {
    _selectedDoctor = null;
    notifyListeners();
  }

  /// Get doctor by ID
  Doctor? getDoctorById(String id) {
    try {
      return _allDoctors.firstWhere((d) => d.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // ========== MOCK DATA ==========

  List<Doctor> _generateMockDoctors() {
    return [
      Doctor(
        id: '1',
        name: 'Dr. Sarah Johnson',
        specialization: 'Cardiologist',
        experience: 15,
        rating: 4.8,
        reviewCount: 342,
        fee: 800.0,
        isAvailable: true,
        qualifications: ['MBBS', 'MD Cardiology', 'FACC'],
        languages: ['English', 'Hindi'],
      ),
      Doctor(
        id: '2',
        name: 'Dr. Rajesh Kumar',
        specialization: 'Orthopedic',
        experience: 12,
        rating: 4.7,
        reviewCount: 256,
        fee: 700.0,
        isAvailable: true,
        qualifications: ['MBBS', 'MS Orthopedics'],
        languages: ['English', 'Hindi', 'Tamil'],
      ),
      Doctor(
        id: '3',
        name: 'Dr. Priya Sharma',
        specialization: 'Pediatrician',
        experience: 8,
        rating: 4.9,
        reviewCount: 421,
        fee: 600.0,
        isAvailable: false,
        qualifications: ['MBBS', 'MD Pediatrics'],
        languages: ['English', 'Hindi'],
      ),
      Doctor(
        id: '4',
        name: 'Dr. Michael Chen',
        specialization: 'Dermatologist',
        experience: 10,
        rating: 4.6,
        reviewCount: 198,
        fee: 900.0,
        isAvailable: true,
        qualifications: ['MBBS', 'MD Dermatology'],
        languages: ['English'],
      ),
      Doctor(
        id: '5',
        name: 'Dr. Anita Patel',
        specialization: 'Gynecologist',
        experience: 18,
        rating: 4.9,
        reviewCount: 512,
        fee: 1000.0,
        isAvailable: true,
        qualifications: ['MBBS', 'MS Gynecology', 'FICOG'],
        languages: ['English', 'Hindi', 'Gujarati'],
      ),
      Doctor(
        id: '6',
        name: 'Dr. Amit Verma',
        specialization: 'Neurologist',
        experience: 14,
        rating: 4.7,
        reviewCount: 287,
        fee: 1200.0,
        isAvailable: false,
        qualifications: ['MBBS', 'DM Neurology'],
        languages: ['English', 'Hindi'],
      ),
      Doctor(
        id: '7',
        name: 'Dr. Lisa Anderson',
        specialization: 'General Physician',
        experience: 6,
        rating: 4.5,
        reviewCount: 156,
        fee: 400.0,
        isAvailable: true,
        qualifications: ['MBBS'],
        languages: ['English'],
      ),
      Doctor(
        id: '8',
        name: 'Dr. Vikram Singh',
        specialization: 'ENT Specialist',
        experience: 11,
        rating: 4.8,
        reviewCount: 234,
        fee: 750.0,
        isAvailable: true,
        qualifications: ['MBBS', 'MS ENT'],
        languages: ['English', 'Hindi', 'Punjabi'],
      ),
    ];
  }
}
