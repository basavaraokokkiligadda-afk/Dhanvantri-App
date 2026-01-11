import 'package:flutter/material.dart';
import '../../presentation/splash/splash_screen.dart';
import '../../presentation/auth/login_screen.dart';
import '../../presentation/auth/signup_screen.dart';
import '../../presentation/dashboard/user_dashboard.dart';
import '../../presentation/dashboard/hospital_dashboard.dart';
import '../../presentation/feed/feed_screen.dart';
import '../../presentation/clicks/clicks_video_feed.dart';
import '../../presentation/stories/snip_stories_screen.dart';
import '../../presentation/messaging/chit_chat_messaging.dart';
import '../../presentation/appointment/appointment_booking.dart';
import '../../presentation/ai_assistant/ai_health_assistant.dart';
import '../../presentation/pharmacy/pharmacy_hub.dart';
import '../../presentation/pharmacy/pharmacy_checkout_screen.dart';
import '../../presentation/notifications/notifications_screen.dart';
import '../../presentation/settings/settings_screen.dart';
import '../../presentation/hospital/find_hospitals_screen.dart';
import '../../presentation/hospital/hospital_profile_screen.dart';
import '../../presentation/doctors/find_doctors_screen.dart';
import '../../presentation/doctors/doctor_profile_screen.dart';
import '../../presentation/diagnostic/diagnostic_centers_screen.dart';
import '../../presentation/diagnostic/diagnostic_center_details_screen.dart';
import '../../presentation/blood/blood_centers_screen.dart';
import '../../presentation/blood/blood_bank_details_screen.dart';
import '../../presentation/booking/unified_booking_screen.dart';
import '../../presentation/appointment/appointment_summary_screen.dart';
import '../../presentation/payment/payment_screen.dart';
import '../../presentation/appointment/appointments_history_screen.dart';
import '../../presentation/appointment/appointment_details_screen.dart';
import '../../presentation/appointment/ambulance_booking_screen.dart';
import '../../presentation/appointment/medicine_order_details_screen.dart';

class AppRoutes {
  AppRoutes._();

  // Route names
  static const String splash = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String userDashboard = '/user-dashboard';
  static const String notifications = '/notifications-screen';
  static const String settings = '/settings-screen';
  static const String hospitalDashboard = '/hospital-dashboard';
  static const String feed = '/feed-screen';
  static const String clicks = '/clicks-video-feed';
  static const String stories = '/snip-stories-screen';
  static const String messaging = '/chit-chat-messaging';
  static const String appointment = '/appointment-booking';
  static const String aiAssistant = '/ai-assistant';
  static const String pharmacy = '/pharmacy-hub';
  static const String findHospitals = '/find-hospitals';
  static const String hospitalProfile = '/hospital-profile';
  static const String findDoctors = '/find-doctors';
  static const String doctorProfile = '/doctor-profile';
  static const String diagnosticCenters = '/diagnostic-centers';
  static const String diagnosticCenterDetails = '/diagnostic-center-details';
  static const String bloodCenters = '/blood-centers';
  static const String bloodBankDetails = '/blood-bank-details';
  static const String unifiedBooking = '/unified-booking';
  static const String appointmentSummary = '/appointment-summary';
  static const String payment = '/payment';
  static const String pharmacyCheckout = '/pharmacy-checkout';
  static const String appointmentsHistory = '/appointments-history';
  static const String appointmentDetails = '/appointment-details';
  static const String ambulanceBooking = '/ambulance-booking';
  static const String medicineOrderDetails = '/medicine-order-details';

  // Route map
  static Map<String, WidgetBuilder> get routes {
    return {
      splash: (context) => const SplashScreen(),
      login: (context) => const LoginScreen(),
      signup: (context) => const SignupScreen(),
      userDashboard: (context) => const UserDashboard(),
      notifications: (context) => const NotificationsScreen(),
      settings: (context) => const SettingsScreen(),
      hospitalDashboard: (context) => const HospitalDashboard(),
      feed: (context) => const FeedScreen(),
      clicks: (context) => const ClicksVideoFeed(),
      stories: (context) => const SnipStoriesScreen(),
      messaging: (context) => const ChitChatMessaging(),
      appointment: (context) => const AppointmentBooking(),
      aiAssistant: (context) => const AiHealthAssistant(),
      pharmacy: (context) => const PharmacyHub(),
      findHospitals: (context) => const FindHospitalsScreen(),
      hospitalProfile: (context) {
        final hospital =
            ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
        return HospitalProfileScreen(hospital: hospital);
      },
      findDoctors: (context) => const FindDoctorsScreen(),
      doctorProfile: (context) {
        final doctor =
            ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
        return DoctorProfileScreen(doctor: doctor);
      },
      diagnosticCenters: (context) => const DiagnosticCentersScreen(),
      diagnosticCenterDetails: (context) {
        final center =
            ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
        return DiagnosticCenterDetailsScreen(center: center);
      },
      bloodCenters: (context) => const BloodCentersScreen(),
      bloodBankDetails: (context) {
        final bloodBank =
            ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
        return BloodBankDetailsScreen(bloodBank: bloodBank);
      },
      unifiedBooking: (context) {
        final args =
            ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
        return UnifiedBookingScreen(
          type: args['type'],
          data: args['data'],
        );
      },
      appointmentSummary: (context) {
        final args =
            ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
        return AppointmentSummaryScreen(appointmentDetails: args);
      },
      payment: (context) {
        final args =
            ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
        return PaymentScreen(
          type: args['type'],
          orderDetails: args['orderDetails'],
        );
      },
      pharmacyCheckout: (context) {
        final args =
            ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
        return PharmacyCheckoutScreen(
          cartItems: args['cartItems'] as List<Map<String, dynamic>>,
        );
      },
      appointmentsHistory: (context) => const AppointmentsHistoryScreen(),
      appointmentDetails: (context) {
        final appointment =
            ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
        return AppointmentDetailsScreen(appointment: appointment);
      },
      ambulanceBooking: (context) {
        final appointment =
            ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
        return AmbulanceBookingScreen(appointment: appointment);
      },
      medicineOrderDetails: (context) => const MedicineOrderDetailsScreen(),
    };
  }

  // Navigation helper methods
  static void navigateTo(BuildContext context, String routeName) {
    Navigator.pushNamed(context, routeName);
  }

  static void navigateAndReplace(BuildContext context, String routeName) {
    Navigator.pushReplacementNamed(context, routeName);
  }

  static void navigateAndRemoveUntil(BuildContext context, String routeName) {
    Navigator.pushNamedAndRemoveUntil(context, routeName, (route) => false);
  }

  static void goBack(BuildContext context) {
    Navigator.pop(context);
  }
}
