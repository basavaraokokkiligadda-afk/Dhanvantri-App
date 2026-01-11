import 'package:flutter/material.dart';
import '../../core/routes/app_routes.dart';
import '../widgets/custom_bottom_bar.dart';
import './user_dashboard_initial_page.dart';

class UserDashboard extends StatefulWidget {
  const UserDashboard({super.key});

  @override
  UserDashboardState createState() => UserDashboardState();
}

class UserDashboardState extends State<UserDashboard> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  int currentIndex = 0;

  // Bottom navigation routes matching CustomBottomBar order:
  // 0: Feed, 1: Clips, 2: Hospital (center), 3: Moments, 4: ChitChat
  final List<String> routes = [
    AppRoutes.feed, // 0: Feed
    AppRoutes.clicks, // 1: Clips (video feed)
    AppRoutes.hospitalDashboard, // 2: Hospital (center button)
    AppRoutes.stories, // 3: Moments (stories/snips)
    AppRoutes.messaging, // 4: ChitChat (messaging)
  ];

  @override
  void initState() {
    super.initState();
    // Navigate to Feed after the frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      navigatorKey.currentState?.pushReplacementNamed(AppRoutes.feed);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Navigator(
        key: navigatorKey,
        initialRoute: '/user-dashboard',
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/user-dashboard':
            case '/':
              return MaterialPageRoute(
                builder: (context) => const UserDashboardInitialPage(),
                settings: settings,
              );
            default:
              // Check AppRoutes.routes for all other routes
              if (AppRoutes.routes.containsKey(settings.name)) {
                return MaterialPageRoute(
                  builder: AppRoutes.routes[settings.name]!,
                  settings: settings,
                );
              }
              return null;
          }
        },
      ),
      bottomNavigationBar: CustomBottomBar(
        currentIndex: currentIndex,
        onTap: (index) {
          // Special handling for Hospital button (index 2)
          // Navigate to full-screen Hospital page (outside nested navigator)
          if (index == 2) {
            Navigator.of(context).pushNamed(AppRoutes.hospitalDashboard);
            return;
          }

          // For the routes that are not in the AppRoutes.routes, do not navigate to them.
          if (!AppRoutes.routes.containsKey(routes[index])) {
            return;
          }
          if (currentIndex != index) {
            setState(() => currentIndex = index);
            navigatorKey.currentState?.pushReplacementNamed(routes[index]);
          }
        },
      ),
    );
  }
}
