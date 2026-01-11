import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

// Core imports
import 'core/theme/app_theme.dart';
import 'core/routes/app_routes.dart';

// Providers
import 'core/providers/app_state_provider.dart';
import 'core/providers/doctors_provider.dart';
import 'core/providers/appointments_provider.dart';
import 'core/providers/pharmacy_provider.dart';
import 'core/providers/booking_provider.dart';

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
            // App State Provider (Authentication & User Data)
            ChangeNotifierProvider(create: (_) => AppStateProvider()),

            // Feature Providers
            ChangeNotifierProvider(create: (_) => DoctorsProvider()),
            ChangeNotifierProvider(create: (_) => AppointmentsProvider()),
            ChangeNotifierProvider(create: (_) => PharmacyProvider()),
            ChangeNotifierProvider(create: (_) => BookingProvider()),
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
