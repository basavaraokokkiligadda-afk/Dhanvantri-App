import 'package:flutter/services.dart';

import '../../core/app_export.dart';
import '../widgets/ai_assistant_modal_widget.dart';
import '../widgets/doctor_card_widget.dart';
import '../widgets/hospital_card_widget.dart';
import '../widgets/quick_action_card_widget.dart';

class HospitalDashboardInitialPage extends StatefulWidget {
  const HospitalDashboardInitialPage({super.key});

  @override
  State<HospitalDashboardInitialPage> createState() =>
      _HospitalDashboardInitialPageState();
}

class _HospitalDashboardInitialPageState
    extends State<HospitalDashboardInitialPage>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _fadeController;
  bool _showFreeCamp = true;

  final List<Map<String, dynamic>> _doctors = [
    {
      "id": 1,
      "name": "Dr. Rajesh Kumar",
      "specialization": "Cardiologist",
      "experience": "15 years",
      "rating": 4.8,
      "isOnline": true,
      "image":
          "https://img.rocket.new/generatedImages/rocket_gen_img_104008a87-1763299273300.png",
      "semanticLabel":
          "Professional photo of Dr. Rajesh Kumar, a cardiologist with short black hair wearing white medical coat and stethoscope",
    },
    {
      "id": 2,
      "name": "Dr. Priya Sharma",
      "specialization": "Pediatrician",
      "experience": "12 years",
      "rating": 4.9,
      "isOnline": true,
      "image":
          "https://img.rocket.new/generatedImages/rocket_gen_img_19c27b25f-1763300463391.png",
      "semanticLabel":
          "Professional photo of Dr. Priya Sharma, a pediatrician with long black hair wearing white medical coat with stethoscope",
    },
    {
      "id": 3,
      "name": "Dr. Anil Reddy",
      "specialization": "Orthopedic",
      "experience": "18 years",
      "rating": 4.7,
      "isOnline": false,
      "image":
          "https://img.rocket.new/generatedImages/rocket_gen_img_1faf6faf8-1763294988170.png",
      "semanticLabel":
          "Professional photo of Dr. Anil Reddy, an orthopedic surgeon with short grey hair wearing white medical coat",
    },
    {
      "id": 4,
      "name": "Dr. Lakshmi Devi",
      "specialization": "Gynecologist",
      "experience": "14 years",
      "rating": 4.9,
      "isOnline": true,
      "image":
          "https://img.rocket.new/generatedImages/rocket_gen_img_19c27b25f-1763300463391.png",
      "semanticLabel":
          "Professional photo of Dr. Lakshmi Devi, a gynecologist with shoulder-length black hair wearing white medical coat",
    },
    {
      "id": 5,
      "name": "Dr. Venkat Rao",
      "specialization": "Neurologist",
      "experience": "20 years",
      "rating": 4.8,
      "isOnline": true,
      "image":
          "https://img.rocket.new/generatedImages/rocket_gen_img_1faf6faf8-1763294988170.png",
      "semanticLabel":
          "Professional photo of Dr. Venkat Rao, a neurologist with short black hair and glasses wearing white medical coat",
    },
  ];

  final List<Map<String, dynamic>> _hospitals = [
    {
      "id": 1,
      "name": "Apollo Hospitals",
      "type": "Multi-Specialty",
      "rating": 4.7,
      "distance": "2.5 km",
      "departments": ["Cardiology", "Neurology", "Orthopedics"],
      "image":
          "https://images.unsplash.com/photo-1656932867014-1f86699fc7c4",
      "semanticLabel":
          "Modern multi-story hospital building with glass facade and emergency entrance",
    },
    {
      "id": 2,
      "name": "Care Hospital",
      "type": "General",
      "rating": 4.5,
      "distance": "3.8 km",
      "departments": ["General Medicine", "Surgery", "Pediatrics"],
      "image":
          "https://img.rocket.new/generatedImages/rocket_gen_img_1ae839a75-1765152871111.png",
      "semanticLabel":
          "Large hospital complex with white exterior and ambulance bay",
    },
    {
      "id": 3,
      "name": "Yashoda Hospitals",
      "type": "Super Specialty",
      "rating": 4.8,
      "distance": "4.2 km",
      "departments": ["Oncology", "Cardiology", "Nephrology"],
      "image":
          "https://images.unsplash.com/photo-1497728303956-c7f2a6dce680",
      "semanticLabel":
          "Modern super specialty hospital with curved architecture and landscaped entrance",
    },
    {
      "id": 4,
      "name": "KIMS Hospital",
      "type": "Multi-Specialty",
      "rating": 4.6,
      "distance": "5.1 km",
      "departments": ["Gastroenterology", "Pulmonology", "Urology"],
      "image":
          "https://images.unsplash.com/photo-1601789970063-6ece30fb8cd7",
      "semanticLabel":
          "Contemporary hospital building with blue glass panels and main entrance",
    },
    {
      "id": 5,
      "name": "Continental Hospitals",
      "type": "Super Specialty",
      "rating": 4.9,
      "distance": "6.3 km",
      "departments": ["Cardiac Surgery", "Neurosurgery", "Transplant"],
      "image":
          "https://img.rocket.new/generatedImages/rocket_gen_img_189839124-1767030086182.png",
      "semanticLabel":
          "Premium hospital facility with modern architecture and landscaped grounds",
    },
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..forward();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _refreshData() async {
    HapticFeedback.lightImpact();
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) {
      setState(() {
        _showFreeCamp = true;
      });
    }
  }

  void _showAIAssistant() {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AIAssistantModalWidget(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return RefreshIndicator(
      onRefresh: _refreshData,
      color: theme.colorScheme.primary,
      child: CustomScrollView(
        slivers: [
          // Safe Area Header
          SliverToBoxAdapter(
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                child: Row(
                  children: [
                    // Location Indicator
                    Expanded(
                      child: Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'location_on',
                            color: theme.colorScheme.primary,
                            size: 20,
                          ),
                          SizedBox(width: 2.w),
                          Expanded(
                            child: Text(
                              'Vijayawada, AP',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Search Bar
                    Expanded(
                      flex: 2,
                      child: Container(
                        height: 6.h,
                        margin: EdgeInsets.symmetric(horizontal: 2.w),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: theme.colorScheme.outline.withValues(
                              alpha: 0.3,
                            ),
                          ),
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Search doctors, hospitals...',
                            hintStyle: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant
                                  .withValues(alpha: 0.6),
                            ),
                            prefixIcon: CustomIconWidget(
                              iconName: 'search',
                              color: theme.colorScheme.onSurfaceVariant,
                              size: 20,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 1.5.h,
                            ),
                          ),
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                    ),

                    // AI Assistant Button
                    GestureDetector(
                      onTap: _showAIAssistant,
                      child: Container(
                        width: 6.h,
                        height: 6.h,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withValues(
                            alpha: 0.1,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            AnimatedBuilder(
                              animation: _pulseController,
                              builder: (context, child) {
                                return Container(
                                  width: 6.h + (_pulseController.value * 8),
                                  height: 6.h + (_pulseController.value * 8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: theme.colorScheme.primary.withValues(
                                      alpha: 0.2 * (1 - _pulseController.value),
                                    ),
                                  ),
                                );
                              },
                            ),
                            CustomIconWidget(
                              iconName: 'psychology',
                              color: theme.colorScheme.primary,
                              size: 24,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Free Medical Camp Card
          if (_showFreeCamp)
            SliverToBoxAdapter(
              child: FadeTransition(
                opacity: _fadeController,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        theme.colorScheme.primary.withValues(alpha: 0.1),
                        theme.colorScheme.secondary.withValues(alpha: 0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: theme.colorScheme.primary.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                AnimatedBuilder(
                                  animation: _pulseController,
                                  builder: (context, child) {
                                    return Opacity(
                                      opacity:
                                          0.3 + (_pulseController.value * 0.7),
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 2.w,
                                          vertical: 0.5.h,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFDC2626),
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                        ),
                                        child: Text(
                                          'LIVE',
                                          style: theme.textTheme.labelSmall
                                              ?.copyWith(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                SizedBox(width: 2.w),
                                Text(
                                  'Free Medical Camp',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 1.h),
                            Text(
                              'Near your location • 1.2 km away',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      CustomIconWidget(
                        iconName: 'arrow_forward',
                        color: theme.colorScheme.primary,
                        size: 24,
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // Quick Actions Section
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quick Actions',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 2.h,
                    crossAxisSpacing: 4.w,
                    childAspectRatio: 1.5,
                    children: [
                      QuickActionCardWidget(
                        title: 'Ambulance',
                        icon: 'local_hospital',
                        color: const Color(0xFFDC2626),
                        onTap: () {
                          HapticFeedback.mediumImpact();
                        },
                      ),
                      QuickActionCardWidget(
                        title: 'Pharmacy',
                        icon: 'medication',
                        color: const Color(0xFF059669),
                        onTap: () {
                          HapticFeedback.lightImpact();
                        },
                      ),
                      QuickActionCardWidget(
                        title: 'Appointments',
                        icon: 'calendar_today',
                        color: const Color(0xFF4A90B8),
                        onTap: () {
                          HapticFeedback.lightImpact();
                        },
                      ),
                      QuickActionCardWidget(
                        title: 'Diagnostics',
                        icon: 'science',
                        color: const Color(0xFF9333EA),
                        onTap: () {
                          HapticFeedback.lightImpact();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Doctors Section
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Top Doctors',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                    },
                    child: const Text('View All'),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: SizedBox(
              height: 28.h,
              child: ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                scrollDirection: Axis.horizontal,
                itemCount: _doctors.length,
                separatorBuilder: (context, index) => SizedBox(width: 3.w),
                itemBuilder: (context, index) {
                  return DoctorCardWidget(
                    doctor: _doctors[index],
                    onTap: () {
                      HapticFeedback.lightImpact();
                    },
                  );
                },
              ),
            ),
          ),

          // Hospitals Section
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Nearby Hospitals',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                    },
                    child: const Text('View All'),
                  ),
                ],
              ),
            ),
          ),

          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return HospitalCardWidget(
                hospital: _hospitals[index],
                onTap: () {
                  HapticFeedback.lightImpact();
                },
              );
            }, childCount: _hospitals.length),
          ),

          // Emergency Services Banner
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.all(4.w),
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: const Color(0xFFDC2626),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFDC2626).withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 12.w,
                    height: 12.w,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const CustomIconWidget(
                      iconName: 'emergency',
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Emergency Services',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          'Book ambulance with oxygen support',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const CustomIconWidget(
                    iconName: 'arrow_forward',
                    color: Colors.white,
                    size: 24,
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(child: SizedBox(height: 2.h)),
        ],
      ),
    );
  }
}
