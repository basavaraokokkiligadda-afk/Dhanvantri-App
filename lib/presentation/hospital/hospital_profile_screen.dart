import 'package:flutter/services.dart';
import '../../core/app_export.dart';

/// Hospital Profile Screen - Detailed hospital information with booking
class HospitalProfileScreen extends StatelessWidget {
  final Map<String, dynamic> hospital;

  const HospitalProfileScreen({super.key, required this.hospital});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          // App Bar with Hospital Image
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Hospital Image
                  Image.network(
                    hospital['image'] ?? 'https://via.placeholder.com/400',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: theme.primaryColor.withValues(alpha: 0.2),
                      child: Icon(Icons.local_hospital,
                          size: 80, color: theme.primaryColor),
                    ),
                  ),
                  // Gradient overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.7),
                        ],
                      ),
                    ),
                  ),
                  // Hospital name and type at bottom
                  Positioned(
                    left: 16,
                    right: 16,
                    bottom: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          hospital['name'] ?? 'Unknown Hospital',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Row(
                          children: [
                            Icon(Icons.location_on,
                                color: Colors.white70, size: 16),
                            SizedBox(width: 4),
                            Text(
                              'Hyderabad, Telangana',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Quick Stats Card
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatItem(
                            icon: Icons.star,
                            label: 'Rating',
                            value: '${hospital['rating'] ?? 'N/A'}',
                            color: Colors.amber,
                          ),
                          _buildStatItem(
                            icon: Icons.people,
                            label: 'Reviews',
                            value: '${hospital['reviews'] ?? 0}',
                            color: Colors.blue,
                          ),
                          _buildStatItem(
                            icon: Icons.near_me,
                            label: 'Distance',
                            value: '${hospital['distance'] ?? 0} km',
                            color: theme.primaryColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Hospital Type Badge
                if (hospital['verified'] == true)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: Colors.green.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.verified,
                              color: Colors.green, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            hospital['type'] ?? 'Multi-Speciality Hospital',
                            style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                const SizedBox(height: 16),

                // Overview Section
                _buildSection(
                  context,
                  title: 'About Hospital',
                  child: Text(
                    '${hospital['name']} is a premier ${hospital['type']?.toLowerCase() ?? 'healthcare facility'} offering world-class medical services. With state-of-the-art infrastructure and highly qualified medical professionals, we are committed to providing exceptional patient care and advanced medical treatments.',
                    style: theme.textTheme.bodyMedium,
                  ),
                ),

                // Specializations
                _buildSection(
                  context,
                  title: 'Specializations',
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: (hospital['specializations'] as List?)
                            ?.map((spec) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: theme.primaryColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color:
                                    theme.primaryColor.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Text(
                              spec,
                              style: TextStyle(
                                color: theme.primaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }).toList() ??
                        [],
                  ),
                ),

                // Facilities
                _buildSection(
                  context,
                  title: 'Facilities',
                  child: Column(
                    children: [
                      _buildFacilityItem(context,
                          icon: Icons.local_parking,
                          facility: '24/7 Parking Available'),
                      _buildFacilityItem(context,
                          icon: Icons.restaurant,
                          facility: 'In-house Cafeteria'),
                      _buildFacilityItem(context,
                          icon: Icons.local_pharmacy, facility: 'Pharmacy'),
                      _buildFacilityItem(context,
                          icon: Icons.emergency,
                          facility: '24/7 Emergency Services'),
                      _buildFacilityItem(context,
                          icon: Icons.hotel, facility: 'Patient Rooms with AC'),
                      _buildFacilityItem(context,
                          icon: Icons.science,
                          facility: 'Advanced Diagnostic Lab'),
                      _buildFacilityItem(context,
                          icon: Icons.local_atm, facility: 'ATM & Banking'),
                      _buildFacilityItem(context,
                          icon: Icons.wifi, facility: 'Free WiFi'),
                    ],
                  ),
                ),

                // Available Schemes
                if (hospital['schemes'] != null)
                  _buildSection(
                    context,
                    title: 'Accepted Health Schemes',
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: (hospital['schemes'] as List).map((scheme) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.blue.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color: Colors.blue.withValues(alpha: 0.3)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.check_circle,
                                  color: Colors.blue, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                scheme,
                                style: const TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                // Doctors List
                _buildSection(
                  context,
                  title: 'Our Doctors',
                  child: Column(
                    children: [
                      _buildDoctorItem(context,
                          name: 'Dr. Sarah Johnson',
                          specialization: 'Cardiologist'),
                      _buildDoctorItem(context,
                          name: 'Dr. Rajesh Kumar',
                          specialization: 'Neurologist'),
                      _buildDoctorItem(context,
                          name: 'Dr. Priya Sharma',
                          specialization: 'Orthopedic Surgeon'),
                      _buildDoctorItem(context,
                          name: 'Dr. Michael Chen',
                          specialization: 'Oncologist'),
                      _buildDoctorItem(context,
                          name: 'Dr. Anjali Patel',
                          specialization: 'Pediatrician'),
                    ],
                  ),
                ),

                // Consultation Fee
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.secondary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Consultation Fee',
                          style: theme.textTheme.titleMedium,
                        ),
                        Text(
                          hospital['consultancyFee'] ?? '₹500',
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: theme.colorScheme.secondary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 80), // Space for button
              ],
            ),
          ),
        ],
      ),

      // Book Appointment Button (Fixed at bottom)
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: ElevatedButton(
            onPressed: () {
              HapticFeedback.mediumImpact();
              Navigator.pushNamed(
                context,
                AppRoutes.unifiedBooking,
                arguments: {
                  'type': 'hospital',
                  'data': hospital,
                },
              );
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Book Appointment',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildSection(BuildContext context,
      {required String title, required Widget child}) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildFacilityItem(BuildContext context,
      {required IconData icon, required String facility}) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: theme.primaryColor, size: 20),
          const SizedBox(width: 12),
          Text(facility, style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }

  Widget _buildDoctorItem(BuildContext context,
      {required String name, required String specialization}) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: theme.primaryColor.withValues(alpha: 0.2),
            child: Icon(Icons.person, color: theme.primaryColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  specialization,
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
