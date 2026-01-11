import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../../features/doctors/controllers/doctors_controller.dart';
import '../../../shared/widgets/base_screen.dart';
import '../../../shared/widgets/state_widgets.dart';
import '../../../shared/widgets/input_fields.dart';
import '../../../navigation/app_router.dart';
import '../../../data/models/doctor_model.dart';

/// PRODUCTION-GRADE EXAMPLE: Refactored Doctors Screen
///
/// ✅ UI separated from logic
/// ✅ Uses controller for state management
/// ✅ No business logic in UI
/// ✅ Proper error/loading/empty states
/// ✅ No fixed heights or overflow issues
/// ✅ Responsive design with Sizer
///
class RefactoredDoctorsScreen extends StatefulWidget {
  const RefactoredDoctorsScreen({super.key});

  @override
  State<RefactoredDoctorsScreen> createState() =>
      _RefactoredDoctorsScreenState();
}

class _RefactoredDoctorsScreenState extends State<RefactoredDoctorsScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Fetch data on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DoctorsController>().fetchDoctors();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Watch controller for state changes
    final controller = context.watch<DoctorsController>();

    return BaseScreen(
      title: 'Find Doctors',
      enableScroll: true,
      padding: EdgeInsets.all(4.w),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Bar
          _buildSearchBar(controller),
          SizedBox(height: 2.h),

          // Filters
          _buildFilters(controller),
          SizedBox(height: 2.h),

          // Content based on state
          _buildContent(controller),
        ],
      ),
    );
  }

  /// Search Bar Widget
  Widget _buildSearchBar(DoctorsController controller) {
    return CustomTextField(
      controller: _searchController,
      hint: 'Search doctors by name or specialty',
      prefixIcon: const Icon(Icons.search),
      onChanged: (value) => controller.searchDoctors(value),
      suffixIcon: _searchController.text.isNotEmpty
          ? IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _searchController.clear();
                controller.searchDoctors('');
              },
            )
          : null,
    );
  }

  /// Filters Section
  Widget _buildFilters(DoctorsController controller) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          // Specialty Filter
          _buildFilterChip(
            label: 'Specialty',
            isActive: controller.selectedSpecialty != null,
            onTap: () => _showSpecialtyBottomSheet(controller),
          ),
          SizedBox(width: 2.w),

          // Experience Filter
          _buildFilterChip(
            label: 'Experience',
            isActive: controller.selectedSpecialty != null,
            onTap: () => _showExperienceFilter(controller),
          ),
          SizedBox(width: 2.w),

          // Available Today
          _buildFilterChip(
            label: 'Available Today',
            isActive: controller.selectedSpecialty != null,
            onTap: () => controller.toggleAvailableToday(),
          ),
          SizedBox(width: 2.w),

          // Clear Filters
          if (controller.selectedSpecialty != null)
            TextButton.icon(
              onPressed: () => controller.clearFilters(),
              icon: const Icon(Icons.clear_all),
              label: const Text('Clear'),
            ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return FilterChip(
      label: Text(label),
      selected: isActive,
      onSelected: (_) => onTap(),
    );
  }

  /// Main Content - State Management
  Widget _buildContent(DoctorsController controller) {
    // Loading State
    if (controller.isLoading) {
      return LoadingIndicator(message: 'Loading doctors...');
    }

    // Error State
    if (controller.errorMessage != null) {
      return ErrorDisplay(
        message: controller.errorMessage!,
        onRetry: () => controller.fetchDoctors(),
      );
    }

    // Empty State
    if (controller.filteredDoctors.isEmpty) {
      return EmptyState(
        message: 'No doctors found',
        icon: Icons.medical_services_outlined,
        actionText: 'Clear Filters',
        onAction: () => controller.clearFilters(),
      );
    }

    // Success State - Display Doctors List
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${controller.filteredDoctors.length} doctors found',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        SizedBox(height: 2.h),

        // Doctors List
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: controller.filteredDoctors.length,
          separatorBuilder: (_, __) => SizedBox(height: 2.h),
          itemBuilder: (context, index) {
            final doctor = controller.filteredDoctors[index];
            return _buildDoctorCard(doctor, controller);
          },
        ),
      ],
    );
  }

  /// Doctor Card Widget
  Widget _buildDoctorCard(Doctor doctor, DoctorsController controller) {
    return Card(
      child: InkWell(
        onTap: () {
          // Select doctor and navigate
          controller.selectDoctor(doctor);
          AppRouter.goToDoctorProfile(context, doctor.toJson());
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(3.w),
          child: Row(
            children: [
              // Doctor Image
              CircleAvatar(
                radius: 30,
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                child: Icon(
                  Icons.person,
                  size: 30,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              SizedBox(width: 3.w),

              // Doctor Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doctor.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      doctor.specialization,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    SizedBox(height: 0.5.h),
                    Row(
                      children: [
                        Icon(Icons.star, size: 16, color: Colors.amber),
                        SizedBox(width: 1.w),
                        Text(
                          '${doctor.rating} (${doctor.reviewCount} reviews)',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      '${doctor.experience} years exp • ₹${doctor.fee}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),

              // Availability Badge
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: doctor.isAvailable
                      ? Colors.green.withOpacity(0.1)
                      : Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  doctor.isAvailable ? 'Available' : 'Busy',
                  style: TextStyle(
                    color: doctor.isAvailable ? Colors.green : Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 10.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Show Specialty Filter Bottom Sheet
  void _showSpecialtyBottomSheet(DoctorsController controller) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        final specialties = controller.availableSpecialties;
        return Container(
          padding: EdgeInsets.all(4.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Specialty',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: 2.h),
              ListView.builder(
                shrinkWrap: true,
                itemCount: specialties.length,
                itemBuilder: (context, index) {
                  final specialty = specialties[index];
                  return ListTile(
                    title: Text(specialty),
                    selected: controller.selectedSpecialty == specialty,
                    onTap: () {
                      controller.filterBySpecialty(specialty);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  /// Show Experience Filter
  void _showExperienceFilter(DoctorsController controller) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Filter by Experience'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _experienceOption('0-5 years', '0-5', controller),
              _experienceOption('5-10 years', '5-10', controller),
              _experienceOption('10+ years', '10+', controller),
            ],
          ),
        );
      },
    );
  }

  Widget _experienceOption(
      String label, String value, DoctorsController controller) {
    return ListTile(
      title: Text(label),
      onTap: () {
        controller.filterByExperience(value);
        Navigator.pop(context);
      },
    );
  }
}
