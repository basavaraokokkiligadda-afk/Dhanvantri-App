/// Application-wide constants
class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'Dhanvantri Healthcare';
  static const String appVersion = '1.0.0';

  // API Configuration
  static const String baseUrl = 'http://localhost:3000/api';
  static const Duration apiTimeout = Duration(seconds: 30);

  // User Types
  static const String userTypePatient = 'patient';
  static const String userTypeHospital = 'hospital';

  // Appointment Status
  static const String statusPending = 'pending';
  static const String statusConfirmed = 'confirmed';
  static const String statusCompleted = 'completed';
  static const String statusCancelled = 'cancelled';

  // Payment Types
  static const String paymentTypeFull = 'full';
  static const String paymentTypeToken = 'token';
  static const double tokenAmount = 500.0;

  // Booking Types
  static const String bookingTypeDoctor = 'doctor';
  static const String bookingTypeHospital = 'hospital';
  static const String bookingTypeDiagnostic = 'diagnostic';
  static const String bookingTypeBloodBank = 'blood_bank';

  // Time Slots
  static const List<String> morningSlots = [
    '08:00 AM',
    '09:00 AM',
    '10:00 AM',
    '11:00 AM',
  ];

  static const List<String> afternoonSlots = [
    '02:00 PM',
    '03:00 PM',
    '04:00 PM',
    '05:00 PM',
  ];

  static const List<String> eveningSlots = [
    '06:00 PM',
    '07:00 PM',
    '08:00 PM',
  ];

  // Specialties
  static const List<String> doctorSpecialties = [
    'All',
    'Cardiologist',
    'Dermatologist',
    'Pediatrician',
    'Orthopedic',
    'Neurologist',
    'General Physician',
  ];

  // Medicine Categories
  static const List<String> medicineCategories = [
    'All',
    'Tablets',
    'Capsules',
    'Syrups',
    'Injections',
    'Ointments',
    'Drops',
  ];
}
