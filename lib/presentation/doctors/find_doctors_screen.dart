import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/app_export.dart';
import '../../core/routes/app_routes.dart';

/// Find Doctors Screen - Professional doctor listing platform
class FindDoctorsScreen extends StatefulWidget {
  const FindDoctorsScreen({super.key});

  @override
  State<FindDoctorsScreen> createState() => _FindDoctorsScreenState();
}

class _FindDoctorsScreenState extends State<FindDoctorsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String selectedLocation = 'Hyderabad, Telangana';

  // Filter states
  Set<String> selectedSpecializations = {};
  Set<String> selectedFeeRanges = {};
  Set<String> selectedAvailability = {};
  double selectedMinRating = 0;

  // Mock doctor data (20 doctors)
  final List<Map<String, dynamic>> doctors = [
    {
      'id': 1,
      'name': 'Dr. Sarah Johnson',
      'specialization': 'Cardiologist',
      'image': 'https://images.unsplash.com/photo-1559839734-2b71ea197ec2',
      'experience': 15,
      'rating': 4.9,
      'reviews': 450,
      'consultationFee': '₹800',
      'available': true,
      'hospital': 'Apollo Care Center',
    },
    {
      'id': 2,
      'name': 'Dr. Rajesh Kumar',
      'specialization': 'Neurologist',
      'image': 'https://images.unsplash.com/photo-1612349317150-e413f6a5b16d',
      'experience': 12,
      'rating': 4.7,
      'reviews': 320,
      'consultationFee': '₹700',
      'available': true,
      'hospital': 'Continental Health Hub',
    },
    {
      'id': 3,
      'name': 'Dr. Priya Sharma',
      'specialization': 'Orthopedic Surgeon',
      'image': 'https://images.unsplash.com/photo-1594824476967-48c8b964273f',
      'experience': 18,
      'rating': 4.8,
      'reviews': 560,
      'consultationFee': '₹900',
      'available': false,
      'hospital': 'Sunrise MultiCare Hospital',
    },
    {
      'id': 4,
      'name': 'Dr. Michael Chen',
      'specialization': 'Oncologist',
      'image': 'https://images.unsplash.com/photo-1537368910025-700350fe46c7',
      'experience': 20,
      'rating': 4.9,
      'reviews': 380,
      'consultationFee': '₹1200',
      'available': true,
      'hospital': 'LifeSpring Medical Center',
    },
    {
      'id': 5,
      'name': 'Dr. Anjali Patel',
      'specialization': 'Pediatrician',
      'image': 'https://images.unsplash.com/photo-1638202993928-7267aad84c31',
      'experience': 10,
      'rating': 4.6,
      'reviews': 290,
      'consultationFee': '₹500',
      'available': true,
      'hospital': 'Green Valley Hospitals',
    },
    {
      'id': 6,
      'name': 'Dr. Venkat Reddy',
      'specialization': 'Gastroenterologist',
      'image': 'https://images.unsplash.com/photo-1622253692010-333f2da6031d',
      'experience': 14,
      'rating': 4.7,
      'reviews': 410,
      'consultationFee': '₹750',
      'available': true,
      'hospital': 'MaxCure Hospitals',
    },
    {
      'id': 7,
      'name': 'Dr. Emily Watson',
      'specialization': 'Dermatologist',
      'image': 'https://images.unsplash.com/photo-1594824476967-48c8b964273f',
      'experience': 9,
      'rating': 4.5,
      'reviews': 240,
      'consultationFee': '₹600',
      'available': false,
      'hospital': 'Care Hospital',
    },
    {
      'id': 8,
      'name': 'Dr. Arjun Mehta',
      'specialization': 'Nephrologist',
      'image': 'https://images.unsplash.com/photo-1612349317150-e413f6a5b16d',
      'experience': 16,
      'rating': 4.8,
      'reviews': 370,
      'consultationFee': '₹850',
      'available': true,
      'hospital': 'Fortis Healthcare',
    },
    {
      'id': 9,
      'name': 'Dr. Lisa Anderson',
      'specialization': 'Gynecologist',
      'image': 'https://images.unsplash.com/photo-1559839734-2b71ea197ec2',
      'experience': 13,
      'rating': 4.7,
      'reviews': 480,
      'consultationFee': '₹700',
      'available': true,
      'hospital': 'Citizen Hospital',
    },
    {
      'id': 10,
      'name': 'Dr. Ravi Krishna',
      'specialization': 'Pulmonologist',
      'image': 'https://images.unsplash.com/photo-1537368910025-700350fe46c7',
      'experience': 11,
      'rating': 4.6,
      'reviews': 310,
      'consultationFee': '₹650',
      'available': false,
      'hospital': 'Rainbow Children Hospital',
    },
    {
      'id': 11,
      'name': 'Dr. Meera Nair',
      'specialization': 'Endocrinologist',
      'image': 'https://images.unsplash.com/photo-1638202993928-7267aad84c31',
      'experience': 17,
      'rating': 4.8,
      'reviews': 390,
      'consultationFee': '₹800',
      'available': true,
      'hospital': 'Yashoda Hospitals',
    },
    {
      'id': 12,
      'name': 'Dr. David Lee',
      'specialization': 'Urologist',
      'image': 'https://images.unsplash.com/photo-1622253692010-333f2da6031d',
      'experience': 15,
      'rating': 4.7,
      'reviews': 340,
      'consultationFee': '₹750',
      'available': true,
      'hospital': 'Omega Hospitals',
    },
    {
      'id': 13,
      'name': 'Dr. Kavita Singh',
      'specialization': 'Ophthalmologist',
      'image': 'https://images.unsplash.com/photo-1594824476967-48c8b964273f',
      'experience': 12,
      'rating': 4.6,
      'reviews': 280,
      'consultationFee': '₹600',
      'available': true,
      'hospital': 'KIMS Hospital',
    },
    {
      'id': 14,
      'name': 'Dr. James Wilson',
      'specialization': 'Psychiatrist',
      'image': 'https://images.unsplash.com/photo-1612349317150-e413f6a5b16d',
      'experience': 19,
      'rating': 4.9,
      'reviews': 510,
      'consultationFee': '₹1000',
      'available': false,
      'hospital': 'Gleneagles Global Hospitals',
    },
    {
      'id': 15,
      'name': 'Dr. Sneha Desai',
      'specialization': 'Rheumatologist',
      'image': 'https://images.unsplash.com/photo-1559839734-2b71ea197ec2',
      'experience': 10,
      'rating': 4.5,
      'reviews': 220,
      'consultationFee': '₹700',
      'available': true,
      'hospital': 'Indo American Hospital',
    },
    {
      'id': 16,
      'name': 'Dr. Thomas Brown',
      'specialization': 'General Surgeon',
      'image': 'https://images.unsplash.com/photo-1537368910025-700350fe46c7',
      'experience': 22,
      'rating': 4.8,
      'reviews': 620,
      'consultationFee': '₹900',
      'available': true,
      'hospital': 'Aware Gleneagles Hospital',
    },
    {
      'id': 17,
      'name': 'Dr. Divya Iyer',
      'specialization': 'ENT Specialist',
      'image': 'https://images.unsplash.com/photo-1638202993928-7267aad84c31',
      'experience': 8,
      'rating': 4.4,
      'reviews': 190,
      'consultationFee': '₹550',
      'available': true,
      'hospital': 'Medicover Hospitals',
    },
    {
      'id': 18,
      'name': 'Dr. Robert Garcia',
      'specialization': 'Plastic Surgeon',
      'image': 'https://images.unsplash.com/photo-1622253692010-333f2da6031d',
      'experience': 16,
      'rating': 4.7,
      'reviews': 430,
      'consultationFee': '₹1500',
      'available': false,
      'hospital': 'Star Hospitals',
    },
    {
      'id': 19,
      'name': 'Dr. Nisha Gupta',
      'specialization': 'Dentist',
      'image': 'https://images.unsplash.com/photo-1594824476967-48c8b964273f',
      'experience': 7,
      'rating': 4.6,
      'reviews': 270,
      'consultationFee': '₹500',
      'available': true,
      'hospital': 'Lotus Hospital',
    },
    {
      'id': 20,
      'name': 'Dr. Kevin Martinez',
      'specialization': 'Anesthesiologist',
      'image': 'https://images.unsplash.com/photo-1612349317150-e413f6a5b16d',
      'experience': 14,
      'rating': 4.8,
      'reviews': 350,
      'consultationFee': '₹800',
      'available': true,
      'hospital': 'Global Hospitals',
    },
  ];

  List<Map<String, dynamic>> get filteredDoctors {
    return doctors.where((doctor) {
      // Apply filters
      if (selectedSpecializations.isNotEmpty &&
          !selectedSpecializations.contains(doctor['specialization'])) {
        return false;
      }

      if (selectedMinRating > 0 && doctor['rating'] < selectedMinRating) {
        return false;
      }

      if (selectedAvailability.contains('Available') && !doctor['available']) {
        return false;
      }

      if (selectedAvailability.contains('Busy') && doctor['available']) {
        return false;
      }

      return true;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasActiveFilters = selectedSpecializations.isNotEmpty ||
        selectedFeeRanges.isNotEmpty ||
        selectedAvailability.isNotEmpty ||
        selectedMinRating > 0;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Find Doctors'),
        actions: [
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.filter_list),
                if (hasActiveFilters)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
            onPressed: _showFiltersBottomSheet,
          ),
        ],
      ),
      body: Column(
        children: [
          // Location Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: Colors.white,
            child: Row(
              children: [
                const Icon(Icons.location_on, color: Colors.red, size: 18),
                const SizedBox(width: 6),
                Text(
                  selectedLocation,
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w500),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.arrow_drop_down, size: 18),
              ],
            ),
          ),

          // Search Bar
          Container(
            padding: const EdgeInsets.all(12),
            color: Colors.white,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search doctors, specializations...',
                hintStyle: const TextStyle(fontSize: 14),
                prefixIcon: const Icon(Icons.search, size: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              ),
              onChanged: (value) => setState(() {}),
            ),
          ),

          // Doctor List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 8, bottom: 16),
              itemCount: filteredDoctors.length,
              itemBuilder: (context, index) {
                return _buildDoctorCard(filteredDoctors[index], theme);
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showFiltersBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.75,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) {
          return StatefulBuilder(
            builder: (context, setModalState) {
              return Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Filters',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        TextButton(
                          onPressed: () {
                            setModalState(() {
                              selectedSpecializations.clear();
                              selectedFeeRanges.clear();
                              selectedAvailability.clear();
                              selectedMinRating = 0;
                            });
                            setState(() {});
                          },
                          child: const Text('Clear All'),
                        ),
                      ],
                    ),
                    const Divider(),

                    // Filters Content
                    Expanded(
                      child: ListView(
                        controller: scrollController,
                        children: [
                          _buildFilterSection(
                            'Specialization',
                            [
                              'Cardiologist',
                              'Neurologist',
                              'Orthopedic',
                              'Pediatrician',
                              'Dermatologist',
                              'ENT Specialist',
                              'Gynecologist',
                              'General Physician',
                            ],
                            selectedSpecializations,
                            setModalState,
                          ),
                          _buildFilterSection(
                            'Consultation Fee',
                            ['Under ₹500', '₹500-₹1000', 'Above ₹1000'],
                            selectedFeeRanges,
                            setModalState,
                          ),
                          _buildFilterSection(
                            'Availability',
                            [
                              'Available Today',
                              'Available Tomorrow',
                              'Within a Week'
                            ],
                            selectedAvailability,
                            setModalState,
                          ),
                          _buildRatingFilter(setModalState),
                        ],
                      ),
                    ),

                    // Apply Button
                    SafeArea(
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {});
                            Navigator.pop(context);
                          },
                          child: const Text('Apply Filters'),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildFilterSection(String title, List<String> options,
      Set<String> selectedSet, StateSetter setModalState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 8),
          child: Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((option) {
            final isSelected = selectedSet.contains(option);
            return FilterChip(
              label: Text(option, style: const TextStyle(fontSize: 13)),
              selected: isSelected,
              onSelected: (selected) {
                setModalState(() {
                  if (selected) {
                    selectedSet.add(option);
                  } else {
                    selectedSet.remove(option);
                  }
                });
                setState(() {});
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildRatingFilter(StateSetter setModalState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 16, bottom: 8),
          child: Text(
            'Minimum Rating',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        Wrap(
          spacing: 8,
          children: [0.0, 3.0, 4.0, 4.5].map((rating) {
            return ChoiceChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.star, size: 14, color: Colors.amber),
                  const SizedBox(width: 4),
                  Text(rating == 0 ? 'Any' : '$rating+',
                      style: const TextStyle(fontSize: 13)),
                ],
              ),
              selected: selectedMinRating == rating,
              onSelected: (selected) {
                setModalState(() {
                  selectedMinRating = selected ? rating : 0.0;
                });
                setState(() {});
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDoctorCard(Map<String, dynamic> doctor, ThemeData theme) {
    final isAvailable = doctor['available'] as bool;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Doctor Photo (Reduced from 40 to 30)
            Stack(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(doctor['image']),
                  onBackgroundImageError: (exception, stackTrace) {},
                  child: const Icon(Icons.person, size: 30),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: isAvailable ? Colors.green : Colors.red,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),

            // Doctor Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name (18 → 16)
                  Text(
                    doctor['name'],
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),

                  // Specialization (default → 13)
                  Text(
                    doctor['specialization'],
                    style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 3),

                  // Hospital (13 → 12)
                  Row(
                    children: [
                      const Icon(Icons.local_hospital,
                          size: 12, color: Colors.grey),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          doctor['hospital'],
                          style:
                              TextStyle(color: Colors.grey[600], fontSize: 11),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // Experience & Rating
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '${doctor['experience']} yrs',
                          style:
                              TextStyle(color: Colors.blue[700], fontSize: 10),
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Icon(Icons.star, color: Colors.amber, size: 14),
                      const SizedBox(width: 2),
                      Text('${doctor['rating']}',
                          style: const TextStyle(
                              fontSize: 13, fontWeight: FontWeight.bold)),
                      Text(' (${doctor['reviews']})',
                          style:
                              TextStyle(color: Colors.grey[600], fontSize: 11)),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Fee & Availability
                  Row(
                    children: [
                      Text(
                        'Fee: ',
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                      Text(
                        doctor['consultationFee'],
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color:
                              isAvailable ? Colors.green[50] : Colors.red[50],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          isAvailable ? 'Available' : 'Busy',
                          style: TextStyle(
                            color: isAvailable
                                ? Colors.green[700]
                                : Colors.red[700],
                            fontWeight: FontWeight.w500,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.doctorProfile,
                              arguments: doctor,
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                          ),
                          child: const Text('View',
                              style: TextStyle(fontSize: 12)),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: isAvailable
                              ? () {
                                  Navigator.pushNamed(
                                    context,
                                    AppRoutes.unifiedBooking,
                                    arguments: {
                                      'type': 'doctor',
                                      'data': doctor,
                                    },
                                  );
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                          ),
                          child: const Text('Book',
                              style: TextStyle(fontSize: 12)),
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
    );
  }
}
