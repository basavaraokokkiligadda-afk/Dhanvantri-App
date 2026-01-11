import 'package:flutter/services.dart';
import '../../core/app_export.dart';

/// Doctor Profile Screen - Detailed doctor information with booking
class DoctorProfileScreen extends StatelessWidget {
  final Map<String, dynamic> doctor;

  const DoctorProfileScreen({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          // App Bar with Doctor Image
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
                  // Doctor Image
                  Image.network(
                    doctor['image'] ?? 'https://via.placeholder.com/400',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: theme.primaryColor.withValues(alpha: 0.2),
                      child: Icon(Icons.person,
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
                  // Doctor name and specialization at bottom
                  Positioned(
                    left: 16,
                    right: 16,
                    bottom: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          doctor['name'] ?? 'Unknown Doctor',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.medical_services,
                                color: Colors.white70, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              doctor['specialization'] ?? 'Specialist',
                              style: const TextStyle(
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
                            value: '${doctor['rating'] ?? 'N/A'}',
                            color: Colors.amber,
                          ),
                          _buildStatItem(
                            icon: Icons.work,
                            label: 'Experience',
                            value: '${doctor['experience'] ?? 0} yrs',
                            color: theme.primaryColor,
                          ),
                          _buildStatItem(
                            icon: Icons.people,
                            label: 'Reviews',
                            value: '${doctor['reviews'] ?? 0}',
                            color: Colors.blue,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Overview Section
                _buildSection(
                  context,
                  title: 'Overview',
                  child: Text(
                    'Dr. ${doctor['name']?.split(' ').last ?? 'Doctor'} is a highly experienced ${doctor['specialization']?.toLowerCase() ?? 'specialist'} with over ${doctor['experience'] ?? 0} years of expertise in the field. Known for providing compassionate patient care and utilizing the latest medical technologies to ensure the best outcomes for patients.',
                    style: theme.textTheme.bodyMedium,
                  ),
                ),

                // Experience Section
                _buildSection(
                  context,
                  title: 'Experience',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildExperienceItem(
                        context,
                        hospital:
                            doctor['hospital'] ?? 'Multi-Speciality Hospital',
                        role:
                            'Senior ${doctor['specialization'] ?? 'Consultant'}',
                        period: '${DateTime.now().year - 5} - Present',
                      ),
                      const SizedBox(height: 12),
                      _buildExperienceItem(
                        context,
                        hospital: 'City General Hospital',
                        role: '${doctor['specialization'] ?? 'Consultant'}',
                        period:
                            '${DateTime.now().year - 10} - ${DateTime.now().year - 5}',
                      ),
                      const SizedBox(height: 12),
                      _buildExperienceItem(
                        context,
                        hospital: 'Medical College Hospital',
                        role: 'Junior ${doctor['specialization'] ?? 'Doctor'}',
                        period:
                            '${DateTime.now().year - 15} - ${DateTime.now().year - 10}',
                      ),
                    ],
                  ),
                ),

                // Education Section
                _buildSection(
                  context,
                  title: 'Education',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildEducationItem(
                        context,
                        degree:
                            'MD - ${doctor['specialization'] ?? 'Medicine'}',
                        institution:
                            'All India Institute of Medical Sciences (AIIMS)',
                        year: '${DateTime.now().year - 15}',
                      ),
                      const SizedBox(height: 12),
                      _buildEducationItem(
                        context,
                        degree: 'MBBS',
                        institution: 'Christian Medical College (CMC), Vellore',
                        year: '${DateTime.now().year - 20}',
                      ),
                    ],
                  ),
                ),

                // Awards & Achievements
                _buildSection(
                  context,
                  title: 'Awards & Achievements',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildAwardItem(
                        context,
                        award:
                            'Best ${doctor['specialization'] ?? 'Doctor'} Award',
                        organization: 'State Medical Council',
                        year: '${DateTime.now().year - 2}',
                      ),
                      const SizedBox(height: 12),
                      _buildAwardItem(
                        context,
                        award: 'Excellence in Patient Care',
                        organization: 'National Health Association',
                        year: '${DateTime.now().year - 4}',
                      ),
                      const SizedBox(height: 12),
                      _buildAwardItem(
                        context,
                        award: 'Research Publication Award',
                        organization: 'International Medical Journal',
                        year: '${DateTime.now().year - 6}',
                      ),
                    ],
                  ),
                ),

                // Hospital Affiliation
                _buildSection(
                  context,
                  title: 'Hospital Affiliation',
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: theme.primaryColor.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.local_hospital, color: theme.primaryColor),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                doctor['hospital'] ??
                                    'Multi-Speciality Hospital',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Hyderabad, Telangana',
                                style: theme.textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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
                          doctor['consultationFee'] ?? '₹500',
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
                  'type': 'doctor',
                  'data': doctor,
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

  Widget _buildExperienceItem(
    BuildContext context, {
    required String hospital,
    required String role,
    required String period,
  }) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 8,
          height: 8,
          margin: const EdgeInsets.only(top: 6),
          decoration: BoxDecoration(
            color: theme.primaryColor,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                role,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(hospital, style: theme.textTheme.bodyMedium),
              const SizedBox(height: 2),
              Text(
                period,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEducationItem(
    BuildContext context, {
    required String degree,
    required String institution,
    required String year,
  }) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.school, color: theme.primaryColor, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                degree,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(institution, style: theme.textTheme.bodyMedium),
              const SizedBox(height: 2),
              Text(
                year,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAwardItem(
    BuildContext context, {
    required String award,
    required String organization,
    required String year,
  }) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.emoji_events, color: Colors.amber, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                award,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(organization, style: theme.textTheme.bodyMedium),
              const SizedBox(height: 2),
              Text(
                year,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
