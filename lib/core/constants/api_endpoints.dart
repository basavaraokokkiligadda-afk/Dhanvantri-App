import 'app_constants.dart';

/// API endpoint paths
class ApiEndpoints {
  ApiEndpoints._();

  static const String _base = AppConstants.baseUrl;

  // Auth Endpoints
  static const String login = '$_base/auth/login';
  static const String register = '$_base/auth/register';

  // Doctor Endpoints
  static const String doctors = '$_base/doctors';
  static String doctorById(String id) => '$_base/doctors/$id';
  static const String specialties = '$_base/doctors/specialties/list';

  // Appointment Endpoints
  static const String appointments = '$_base/appointments';
  static String appointmentById(String id) => '$_base/appointments/$id';

  // Hospital Endpoints
  static const String hospitals = '$_base/hospitals';
  static String hospitalById(String id) => '$_base/hospitals/$id';

  // Pharmacy Endpoints
  static const String medicines = '$_base/pharmacy/medicines';
  static String medicineById(String id) => '$_base/pharmacy/medicines/$id';

  // AI Assistant Endpoints
  static const String aiChat = '$_base/ai-assistant/chat';
  static const String aiHistory = '$_base/ai-assistant/history';
}
