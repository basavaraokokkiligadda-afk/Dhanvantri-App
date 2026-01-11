
import '../../core/app_export.dart';
import '../widgets/donation_history_widget.dart';
import '../widgets/health_stats_widget.dart';
import '../widgets/insurance_card_widget.dart';
import '../widgets/medical_history_widget.dart';
import '../widgets/profile_header_widget.dart';
import '../widgets/quick_actions_widget.dart';

class UserDashboardInitialPage extends StatefulWidget {
  const UserDashboardInitialPage({super.key});

  @override
  State<UserDashboardInitialPage> createState() =>
      _UserDashboardInitialPageState();
}

class _UserDashboardInitialPageState extends State<UserDashboardInitialPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
        );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        title: Text(
          'My Health Profile',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
        actions: [
          IconButton(
            icon: CustomIconWidget(
              iconName: 'notifications_outlined',
              color: theme.colorScheme.onSurface,
              size: 24,
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Notifications feature'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
            tooltip: 'Notifications',
          ),
          IconButton(
            icon: CustomIconWidget(
              iconName: 'settings_outlined',
              color: theme.colorScheme.onSurface,
              size: 24,
            ),
            onPressed: () {
              Navigator.of(
                context,
                rootNavigator: true,
              ).pushNamed('/settings-screen');
            },
            tooltip: 'Settings',
          ),
          SizedBox(width: 2.w),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: RefreshIndicator(
            onRefresh: () async {
              await Future.delayed(const Duration(seconds: 1));
              setState(() {});
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Header Section
                    const ProfileHeaderWidget(),
                    SizedBox(height: 2.h),

                    // Health Stats Section
                    const HealthStatsWidget(),
                    SizedBox(height: 2.h),

                    // Quick Actions Section
                    const QuickActionsWidget(),
                    SizedBox(height: 2.h),

                    // Insurance Card Section
                    Text(
                      'Insurance Coverage',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    const InsuranceCardWidget(),
                    SizedBox(height: 2.h),

                    // Medical History Section
                    Text(
                      'Medical History',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    const MedicalHistoryWidget(),
                    SizedBox(height: 2.h),

                    // Donation History Section
                    Text(
                      'Donation History',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    const DonationHistoryWidget(),
                    SizedBox(height: 3.h),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
