import 'package:flutter/material.dart';

/// Centralized app router - All route names and navigation in one place
class AppRouter {
  AppRouter._();

  // ============ ROUTE NAMES ============

  // Authentication
  static const String splash = '/';
  static const String login = '/login';
  static const String signup = '/signup';

  // Dashboard
  static const String userDashboard = '/user-dashboard';
  static const String hospitalDashboard = '/hospital-dashboard';

  // Doctors
  static const String findDoctors = '/find-doctors';
  static const String doctorProfile = '/doctor-profile';

  // Hospitals
  static const String findHospitals = '/find-hospitals';
  static const String hospitalProfile = '/hospital-profile';

  // Appointments
  static const String appointmentBooking = '/appointment-booking';
  static const String appointmentSummary = '/appointment-summary';
  static const String appointmentsHistory = '/appointments-history';
  static const String appointmentDetails = '/appointment-details';

  // Booking
  static const String unifiedBooking = '/unified-booking';
  static const String bookingOptions = '/booking-options';

  // Pharmacy
  static const String pharmacy = '/pharmacy-hub';
  static const String pharmacyCheckout = '/pharmacy-checkout';
  static const String medicineOrderDetails = '/medicine-order-details';

  // Ambulance
  static const String ambulanceBooking = '/ambulance-booking';
  static const String ambulanceTracking = '/ambulance-tracking';

  // Diagnostic & Blood Banks
  static const String diagnosticCenters = '/diagnostic-centers';
  static const String diagnosticCenterDetails = '/diagnostic-center-details';
  static const String bloodCenters = '/blood-centers';
  static const String bloodBankDetails = '/blood-bank-details';

  // Social Features
  static const String feed = '/feed-screen';
  static const String clicks = '/clicks-video-feed';
  static const String stories = '/snip-stories-screen';
  static const String messaging = '/chit-chat-messaging';

  // AI Assistant
  static const String aiAssistant = '/ai-assistant';

  // Payment
  static const String payment = '/payment';

  // Settings & Notifications
  static const String notifications = '/notifications';
  static const String settings = '/settings';

  // ============ NAVIGATION HELPERS ============

  /// Navigate to a route
  static void navigateTo(BuildContext context, String routeName,
      {Object? arguments}) {
    Navigator.pushNamed(context, routeName, arguments: arguments);
  }

  /// Navigate and replace current route
  static void navigateAndReplace(BuildContext context, String routeName,
      {Object? arguments}) {
    Navigator.pushReplacementNamed(context, routeName, arguments: arguments);
  }

  /// Navigate and remove all previous routes
  static void navigateAndRemoveUntil(BuildContext context, String routeName,
      {Object? arguments}) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      routeName,
      (route) => false,
      arguments: arguments,
    );
  }

  /// Go back
  static void goBack(BuildContext context, {Object? result}) {
    Navigator.pop(context, result);
  }

  /// Check if can pop
  static bool canPop(BuildContext context) {
    return Navigator.canPop(context);
  }

  // ============ FEATURE-SPECIFIC NAVIGATION ============

  /// Navigate to doctor profile
  static void navigateToDoctorProfile(
    BuildContext context,
    Map<String, dynamic> doctor,
  ) {
    navigateTo(context, doctorProfile, arguments: doctor);
  }

  /// Navigate to hospital profile
  static void navigateToHospitalProfile(
    BuildContext context,
    Map<String, dynamic> hospital,
  ) {
    navigateTo(context, hospitalProfile, arguments: hospital);
  }

  /// Navigate to unified booking
  static void navigateToUnifiedBooking(
    BuildContext context, {
    required String type,
    required Map<String, dynamic> data,
  }) {
    navigateTo(context, unifiedBooking,
        arguments: {'type': type, 'data': data});
  }

  /// Navigate to appointment summary
  static void navigateToAppointmentSummary(
    BuildContext context,
    Map<String, dynamic> appointmentDetails,
  ) {
    navigateTo(context, appointmentSummary, arguments: appointmentDetails);
  }

  /// Navigate to payment
  static void navigateToPayment(
    BuildContext context, {
    required String type,
    required Map<String, dynamic> orderDetails,
  }) {
    navigateTo(context, payment,
        arguments: {'type': type, 'orderDetails': orderDetails});
  }

  /// Navigate to pharmacy checkout
  static void navigateToPharmacyCheckout(
    BuildContext context,
    List<Map<String, dynamic>> cartItems,
  ) {
    navigateTo(context, pharmacyCheckout, arguments: {'cartItems': cartItems});
  }

  /// Navigate to appointment details
  static void navigateToAppointmentDetails(
    BuildContext context,
    Map<String, dynamic> appointment,
  ) {
    navigateTo(context, appointmentDetails, arguments: appointment);
  }

  /// Navigate to ambulance tracking
  static void navigateToAmbulanceTracking(
    BuildContext context,
    Map<String, dynamic> bookingDetails,
  ) {
    navigateTo(context, ambulanceTracking, arguments: bookingDetails);
  }

  /// Navigate to dashboard based on user type
  static void navigateToDashboard(BuildContext context, String userType) {
    if (userType == 'hospital') {
      navigateAndRemoveUntil(context, hospitalDashboard);
    } else {
      navigateAndRemoveUntil(context, userDashboard);
    }
  }

  /// Navigate to doctor profile (alias for backward compatibility)
  static void goToDoctorProfile(
    BuildContext context,
    Map<String, dynamic> doctor,
  ) {
    navigateToDoctorProfile(context, doctor);
  }
}
