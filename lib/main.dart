import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

// Core imports
import 'core/theme/app_theme.dart';
import 'core/routes/app_routes.dart';

// Providers - Legacy (to be migrated)
import 'core/providers/app_state_provider.dart';

// New Production-Grade Controllers
import 'core/controllers/booking_controller.dart';
import 'features/appointments/controllers/appointment_controller.dart';
import 'features/doctors/controllers/doctors_controller.dart';
import 'features/pharmacy/controllers/pharmacy_controller.dart';
import 'features/payment/controllers/payment_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations - Portrait only for mobile-first design
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const DhanvantriApp());
}

class DhanvantriApp extends StatelessWidget {
  const DhanvantriApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MultiProvider(
          providers: [
            // ========== AUTHENTICATION & APP STATE ==========
            ChangeNotifierProvider(create: (_) => AppStateProvider()),

            // ========== PRODUCTION-GRADE CONTROLLERS ==========

            // Booking Management
            ChangeNotifierProvider(create: (_) => BookingController()),

            // Appointments Management
            ChangeNotifierProvider(create: (_) => AppointmentController()),

            // Doctors Management
            ChangeNotifierProvider(create: (_) => DoctorsController()),

            // Pharmacy Management
            ChangeNotifierProvider(create: (_) => PharmacyController()),

            // Payment Management
            ChangeNotifierProvider(create: (_) => PaymentController()),
          ],
          child: MaterialApp(
            title: 'Dhanvantri Healthcare',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: ThemeMode.light,
            initialRoute: AppRoutes.splash,
            routes: AppRoutes.routes,
          ),
        );
      },
    );
  }
}
