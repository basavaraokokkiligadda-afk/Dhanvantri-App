import 'package:flutter/services.dart';
import '../../core/app_export.dart';
import '../widgets/ai_assistant_popup.dart';

/// Hospital Dashboard - Full page without bottom navigation
/// Contains search bar at top and 3 action buttons at bottom
class HospitalDashboard extends StatefulWidget {
  const HospitalDashboard({super.key});

  @override
  HospitalDashboardState createState() => HospitalDashboardState();
}

class HospitalDashboardState extends State<HospitalDashboard>
    with TickerProviderStateMixin {
  late AnimationController _pharmacyPulseController;
  late AnimationController _campBlinkController;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  bool _showCampWidget = true;

  @override
  void initState() {
    super.initState();
    // Continuous pulse animation for center Pharmacy button
    _pharmacyPulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    // Blinking animation for Free Medical Camp widget
    _campBlinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pharmacyPulseController.dispose();
    _campBlinkController.dispose();
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _showFreeMedicalCampPopup() {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildFreeCampPopup(),
    );
  }

  Widget _buildFreeCampPopup() {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      height: MediaQuery.of(context).size.height * 0.5,
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  '🏥 Free Medical Camps',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
                style: IconButton.styleFrom(
                  backgroundColor: theme.primaryColor.withValues(alpha: 0.1),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.location_on, color: theme.primaryColor, size: 16),
              const SizedBox(width: 4),
              Text(
                'Near you',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: 3,
              itemBuilder: (context, index) {
                final camps = [
                  {
                    'name': 'General Health Checkup',
                    'location': 'Community Hall, Jubilee Hills',
                    'date': 'Jan 15, 2026',
                    'time': '9 AM - 5 PM',
                    'services': ['BP', 'Sugar', 'BMI'],
                  },
                  {
                    'name': 'Eye Care Camp',
                    'location': 'Municipal School, Banjara Hills',
                    'date': 'Jan 18, 2026',
                    'time': '10 AM - 4 PM',
                    'services': ['Eye Test', 'Glasses', 'Consult'],
                  },
                  {
                    'name': 'Dental Care Camp',
                    'location': 'City Hospital, Gachibowli',
                    'date': 'Jan 20, 2026',
                    'time': '8 AM - 2 PM',
                    'services': ['Checkup', 'Cleaning', 'X-Ray'],
                  },
                ];
                final camp = camps[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: theme.primaryColor.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          camp['name'] as String,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(Icons.location_on_outlined,
                                size: 14, color: theme.primaryColor),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                camp['location'] as String,
                                style: theme.textTheme.bodySmall,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.calendar_today,
                                size: 14, color: theme.primaryColor),
                            const SizedBox(width: 4),
                            Text(
                              '${camp['date']} • ${camp['time']}',
                              style: theme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 6,
                          runSpacing: 4,
                          children: (camp['services'] as List).map((s) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color:
                                    theme.primaryColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                s as String,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.primaryColor,
                                  fontSize: 11,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        title: const Text('Hospital Dashboard'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          // AI Assistant Icon
          IconButton(
            icon: const Icon(Icons.smart_toy_outlined),
            tooltip: 'AI Health Assistant',
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => const AiAssistantPopup(),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Notifications coming soon')),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // Search Bar at Top
              _buildSearchBar(theme),

              // Scrollable Content
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Find Doctor & Find Hospitals (Same style as other cards)
                      _buildUniformCard(
                        theme: theme,
                        icon: Icons.person_search,
                        title: 'Find Doctor',
                        subtitle: 'Search doctors by specialty',
                        onTap: () {
                          HapticFeedback.lightImpact();
                          Navigator.pushNamed(context, AppRoutes.findDoctors);
                        },
                      ),

                      const SizedBox(height: 12),

                      _buildUniformCard(
                        theme: theme,
                        icon: Icons.local_hospital,
                        title: 'Find Hospitals',
                        subtitle: 'Locate nearby hospitals',
                        onTap: () {
                          HapticFeedback.lightImpact();
                          Navigator.pushNamed(context, AppRoutes.findHospitals);
                        },
                      ),

                      const SizedBox(height: 12),

                      // Diagnostic Centers
                      _buildUniformCard(
                        theme: theme,
                        icon: Icons.biotech,
                        title: 'Diagnostic Centers',
                        subtitle: 'Book lab tests & health checkups',
                        onTap: () {
                          HapticFeedback.lightImpact();
                          Navigator.pushNamed(
                              context, AppRoutes.diagnosticCenters);
                        },
                      ),

                      const SizedBox(height: 12),

                      // Blood Centers
                      _buildUniformCard(
                        theme: theme,
                        icon: Icons.bloodtype,
                        title: 'Blood Centers',
                        subtitle: 'Find blood banks & donate blood',
                        color: Colors.red,
                        onTap: () {
                          HapticFeedback.lightImpact();
                          Navigator.pushNamed(context, AppRoutes.bloodCenters);
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // Bottom 3 Action Buttons
              _buildBottomActionBar(theme),
            ],
          ),

          // Floating Free Medical Camp Widget (Bottom Right)
          if (_showCampWidget) _buildFloatingCampWidget(theme),
        ],
      ),
    );
  }

  Widget _buildSearchBar(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search doctors, hospitals...',
          prefixIcon: Icon(Icons.search, color: theme.primaryColor),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, size: 20),
                  onPressed: () {
                    setState(() {
                      _searchController.clear();
                    });
                  },
                )
              : null,
          filled: true,
          fillColor: theme.primaryColor.withValues(alpha: 0.05),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
        onChanged: (value) {
          setState(() {}); // Update to show/hide clear button
        },
        onSubmitted: (value) {
          if (value.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Searching for: $value')),
            );
          }
        },
      ),
    );
  }

  Widget _buildFloatingCampWidget(ThemeData theme) {
    return Positioned(
      right: 16,
      bottom: 120,
      child: AnimatedBuilder(
        animation: _campBlinkController,
        builder: (context, child) {
          final opacity = 0.7 + (_campBlinkController.value * 0.3);
          return Opacity(
            opacity: opacity,
            child: child,
          );
        },
        child: GestureDetector(
          onTap: () {
            setState(() {
              _showCampWidget = false;
            });
            _showFreeMedicalCampPopup();
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.orange.withValues(alpha: 0.4),
                  blurRadius: 12,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: const Icon(
              Icons.volunteer_activism,
              color: Colors.white,
              size: 28,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUniformCard({
    required ThemeData theme,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? color,
  }) {
    final cardColor = color ?? theme.primaryColor;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: cardColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: cardColor.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: cardColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, size: 32, color: cardColor),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios, size: 16, color: cardColor),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomActionBar(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // LEFT: Booking Button
            Expanded(
              child: _buildSmallActionButton(
                theme: theme,
                label: 'Booking',
                icon: Icons.event_note,
                onTap: () {
                  HapticFeedback.lightImpact();
                  Navigator.pushNamed(
                    context,
                    AppRoutes.bookingOptions,
                  );
                },
              ),
            ),

            const SizedBox(width: 16),

            // CENTER: Pharmacy Button (BIG & ANIMATED)
            _buildPharmacyButton(theme),

            const SizedBox(width: 16),

            // RIGHT: Appointments Button
            Expanded(
              child: _buildSmallActionButton(
                theme: theme,
                label: 'Appointments',
                icon: Icons.calendar_today,
                onTap: () {
                  HapticFeedback.lightImpact();
                  Navigator.pushNamed(context, AppRoutes.appointmentsHistory);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSmallActionButton({
    required ThemeData theme,
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: theme.primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.primaryColor.withValues(alpha: 0.3),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: theme.primaryColor, size: 24),
              const SizedBox(height: 4),
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPharmacyButton(ThemeData theme) {
    return AnimatedBuilder(
      animation: _pharmacyPulseController,
      builder: (context, child) {
        final scale = 1.0 + (_pharmacyPulseController.value * 0.1);
        final glowOpacity = 0.3 + (_pharmacyPulseController.value * 0.2);

        return Transform.scale(
          scale: scale,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: theme.primaryColor.withValues(alpha: glowOpacity),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  HapticFeedback.mediumImpact();
                  Navigator.pushNamed(context, AppRoutes.pharmacy);
                },
                borderRadius: BorderRadius.circular(35),
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: theme.primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.medical_services,
                    color: Colors.white,
                    size: 36,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
