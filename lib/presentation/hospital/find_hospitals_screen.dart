import '../../core/app_export.dart';

/// Find Hospitals Screen - Professional hospital listing platform
class FindHospitalsScreen extends StatefulWidget {
  const FindHospitalsScreen({super.key});

  @override
  State<FindHospitalsScreen> createState() => _FindHospitalsScreenState();
}

class _FindHospitalsScreenState extends State<FindHospitalsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String selectedLocation = 'Hyderabad, Telangana';

  // Filter states
  Set<String> selectedHospitalTypes = {};
  Set<String> selectedFeeRanges = {};
  Set<String> selectedSchemes = {};
  double selectedMinRating = 0;

  // Mock hospital data (20 hospitals)
  final List<Map<String, dynamic>> hospitals = [
    {
      'id': 1,
      'name': 'Apollo Care Center',
      'type': 'Multi-Speciality Hospital',
      'image': 'https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d',
      'specializations': ['Cardiology', 'Neurology', 'Orthopedics', 'Oncology'],
      'rating': 4.8,
      'reviews': 2340,
      'distance': 2.5,
      'consultancyFee': '₹500',
      'schemes': ['Aarogyasri', 'PMJAY', 'ESI'],
      'verified': true,
    },
    {
      'id': 2,
      'name': 'Continental Health Hub',
      'type': 'Private Hospital',
      'image': 'https://images.unsplash.com/photo-1587351021759-3e566b6af7cc',
      'specializations': ['Pediatrics', 'Gynecology', 'Dermatology'],
      'rating': 4.5,
      'reviews': 1200,
      'distance': 3.8,
      'consultancyFee': '₹300',
      'schemes': ['Aarogyasri', 'Ayushman Bharat'],
      'verified': true,
    },
    {
      'id': 3,
      'name': 'Sunrise MultiCare Hospital',
      'type': 'Multi-Speciality Hospital',
      'image': 'https://images.unsplash.com/photo-1538108149393-fbbd81895907',
      'specializations': [
        'Cardiology',
        'Nephrology',
        'Gastroenterology',
        'Urology'
      ],
      'rating': 4.7,
      'reviews': 1890,
      'distance': 1.2,
      'consultancyFee': '₹700',
      'schemes': ['PMJAY', 'ESI'],
      'verified': true,
    },
    {
      'id': 4,
      'name': 'LifeSpring Medical Center',
      'type': 'Specialist Hospital',
      'image': 'https://images.unsplash.com/photo-1512678080530-7760d81faba6',
      'specializations': ['Oncology', 'Radiation Therapy'],
      'rating': 4.9,
      'reviews': 980,
      'distance': 5.6,
      'consultancyFee': '₹1000',
      'schemes': ['PMJAY'],
      'verified': true,
    },
    {
      'id': 5,
      'name': 'Green Valley Hospitals',
      'type': 'Government Hospital',
      'image': 'https://images.unsplash.com/photo-1586773860418-d37222d8fce3',
      'specializations': ['General Medicine', 'Surgery', 'Emergency Care'],
      'rating': 4.2,
      'reviews': 3450,
      'distance': 0.8,
      'consultancyFee': 'Free',
      'schemes': ['Aarogyasri', 'Ayushman Bharat', 'PMJAY', 'ESI'],
      'verified': true,
    },
    {
      'id': 6,
      'name': 'MaxCure Hospitals',
      'type': 'Multi-Speciality Hospital',
      'image': 'https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d',
      'specializations': [
        'Cardiology',
        'Orthopedics',
        'Neurology',
        'Pulmonology'
      ],
      'rating': 4.6,
      'reviews': 2100,
      'distance': 4.3,
      'consultancyFee': '₹600',
      'schemes': ['Aarogyasri', 'PMJAY'],
      'verified': true,
    },
    {
      'id': 7,
      'name': 'Care Hospital - Banjara Hills',
      'type': 'Multi-Speciality Hospital',
      'image': 'https://images.unsplash.com/photo-1587351021759-3e566b6af7cc',
      'specializations': ['Cardiology', 'Gastroenterology', 'Nephrology'],
      'rating': 4.8,
      'reviews': 1670,
      'distance': 3.2,
      'consultancyFee': '₹800',
      'schemes': ['PMJAY', 'ESI'],
      'verified': true,
    },
    {
      'id': 8,
      'name': 'Fortis Healthcare',
      'type': 'Multi-Speciality Hospital',
      'image': 'https://images.unsplash.com/photo-1538108149393-fbbd81895907',
      'specializations': ['Neurology', 'Orthopedics', 'Oncology', 'Cardiology'],
      'rating': 4.7,
      'reviews': 2890,
      'distance': 6.1,
      'consultancyFee': '₹900',
      'schemes': ['PMJAY'],
      'verified': true,
    },
    {
      'id': 9,
      'name': 'Citizen Hospital',
      'type': 'Private Hospital',
      'image': 'https://images.unsplash.com/photo-1512678080530-7760d81faba6',
      'specializations': ['Pediatrics', 'Gynecology', 'General Medicine'],
      'rating': 4.3,
      'reviews': 890,
      'distance': 2.0,
      'consultancyFee': '₹400',
      'schemes': ['Aarogyasri', 'Ayushman Bharat'],
      'verified': false,
    },
    {
      'id': 10,
      'name': 'Rainbow Children Hospital',
      'type': 'Specialist Hospital',
      'image': 'https://images.unsplash.com/photo-1586773860418-d37222d8fce3',
      'specializations': ['Pediatrics', 'Neonatology', 'Pediatric Surgery'],
      'rating': 4.9,
      'reviews': 1450,
      'distance': 4.7,
      'consultancyFee': '₹700',
      'schemes': ['PMJAY', 'ESI'],
      'verified': true,
    },
    {
      'id': 11,
      'name': 'Yashoda Hospitals',
      'type': 'Multi-Speciality Hospital',
      'image': 'https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d',
      'specializations': [
        'Cardiology',
        'Neurology',
        'Gastroenterology',
        'Urology'
      ],
      'rating': 4.6,
      'reviews': 3210,
      'distance': 5.4,
      'consultancyFee': '₹650',
      'schemes': ['Aarogyasri', 'PMJAY', 'ESI'],
      'verified': true,
    },
    {
      'id': 12,
      'name': 'Omega Hospitals',
      'type': 'Specialist Hospital',
      'image': 'https://images.unsplash.com/photo-1587351021759-3e566b6af7cc',
      'specializations': ['Oncology', 'Radiation Therapy', 'Surgical Oncology'],
      'rating': 4.8,
      'reviews': 760,
      'distance': 7.2,
      'consultancyFee': '₹1200',
      'schemes': ['PMJAY'],
      'verified': true,
    },
    {
      'id': 13,
      'name': 'KIMS Hospital',
      'type': 'Multi-Speciality Hospital',
      'image': 'https://images.unsplash.com/photo-1538108149393-fbbd81895907',
      'specializations': [
        'Cardiology',
        'Orthopedics',
        'Nephrology',
        'Pulmonology'
      ],
      'rating': 4.5,
      'reviews': 2540,
      'distance': 3.9,
      'consultancyFee': '₹550',
      'schemes': ['Aarogyasri', 'Ayushman Bharat', 'PMJAY'],
      'verified': true,
    },
    {
      'id': 14,
      'name': 'Gleneagles Global Hospitals',
      'type': 'Multi-Speciality Hospital',
      'image': 'https://images.unsplash.com/photo-1512678080530-7760d81faba6',
      'specializations': [
        'Liver Transplant',
        'Kidney Transplant',
        'Cardiology'
      ],
      'rating': 4.9,
      'reviews': 1120,
      'distance': 8.5,
      'consultancyFee': '₹1500',
      'schemes': ['PMJAY'],
      'verified': true,
    },
    {
      'id': 15,
      'name': 'Indo American Hospital',
      'type': 'Private Hospital',
      'image': 'https://images.unsplash.com/photo-1586773860418-d37222d8fce3',
      'specializations': ['General Medicine', 'Gynecology', 'Pediatrics'],
      'rating': 4.4,
      'reviews': 1340,
      'distance': 2.8,
      'consultancyFee': '₹450',
      'schemes': ['Aarogyasri', 'ESI'],
      'verified': true,
    },
    {
      'id': 16,
      'name': 'Aware Gleneagles Hospital',
      'type': 'Multi-Speciality Hospital',
      'image': 'https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d',
      'specializations': ['Neurology', 'Spine Surgery', 'Orthopedics'],
      'rating': 4.7,
      'reviews': 980,
      'distance': 6.7,
      'consultancyFee': '₹850',
      'schemes': ['PMJAY', 'ESI'],
      'verified': true,
    },
    {
      'id': 17,
      'name': 'Medicover Hospitals',
      'type': 'Multi-Speciality Hospital',
      'image': 'https://images.unsplash.com/photo-1587351021759-3e566b6af7cc',
      'specializations': [
        'Cardiology',
        'Neurology',
        'Orthopedics',
        'Gastroenterology'
      ],
      'rating': 4.6,
      'reviews': 1780,
      'distance': 4.1,
      'consultancyFee': '₹700',
      'schemes': ['Aarogyasri', 'PMJAY'],
      'verified': true,
    },
    {
      'id': 18,
      'name': 'Star Hospitals',
      'type': 'Multi-Speciality Hospital',
      'image': 'https://images.unsplash.com/photo-1538108149393-fbbd81895907',
      'specializations': ['Cardiology', 'Nephrology', 'Pulmonology'],
      'rating': 4.5,
      'reviews': 2210,
      'distance': 5.0,
      'consultancyFee': '₹600',
      'schemes': ['PMJAY', 'ESI'],
      'verified': true,
    },
    {
      'id': 19,
      'name': 'Lotus Hospital',
      'type': 'Private Hospital',
      'image': 'https://images.unsplash.com/photo-1512678080530-7760d81faba6',
      'specializations': ['Gynecology', 'Fertility', 'Pediatrics'],
      'rating': 4.7,
      'reviews': 1560,
      'distance': 3.5,
      'consultancyFee': '₹500',
      'schemes': ['Aarogyasri', 'Ayushman Bharat'],
      'verified': true,
    },
    {
      'id': 20,
      'name': 'Global Hospitals',
      'type': 'Multi-Speciality Hospital',
      'image': 'https://images.unsplash.com/photo-1586773860418-d37222d8fce3',
      'specializations': [
        'Liver Transplant',
        'Kidney Transplant',
        'Gastroenterology'
      ],
      'rating': 4.8,
      'reviews': 1890,
      'distance': 7.9,
      'consultancyFee': '₹1100',
      'schemes': ['PMJAY'],
      'verified': true,
    },
  ];

  List<Map<String, dynamic>> get filteredHospitals {
    return hospitals.where((hospital) {
      // Apply filters
      if (selectedHospitalTypes.isNotEmpty &&
          !selectedHospitalTypes.contains(hospital['type'])) {
        return false;
      }

      if (selectedMinRating > 0 && hospital['rating'] < selectedMinRating) {
        return false;
      }

      return true;
    }).toList();
  }

  void _showFiltersBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => DraggableScrollableSheet(
          initialChildSize: 0.75,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) => Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Filters',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    TextButton(
                      onPressed: () {
                        setModalState(() {
                          selectedHospitalTypes.clear();
                          selectedFeeRanges.clear();
                          selectedSchemes.clear();
                          selectedMinRating = 0;
                        });
                        setState(() {});
                      },
                      child: const Text('Clear All'),
                    ),
                  ],
                ),
              ),
              const Divider(),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  children: [
                    _buildFilterSection(
                      'Hospital Type',
                      [
                        'Government Hospital',
                        'Private Hospital',
                        'Multi-Speciality Hospital',
                        'Specialist Hospital'
                      ],
                      selectedHospitalTypes,
                      setModalState,
                    ),
                    const SizedBox(height: 16),
                    _buildFilterSection(
                      'Consultancy Fee',
                      ['Free (Insurance)', '₹0–₹500', '₹500–₹1000'],
                      selectedFeeRanges,
                      setModalState,
                    ),
                    const SizedBox(height: 16),
                    _buildFilterSection(
                      'Schemes',
                      ['Aarogyasri', 'Ayushman Bharat', 'ESI', 'PMJAY'],
                      selectedSchemes,
                      setModalState,
                    ),
                    const SizedBox(height: 16),
                    _buildRatingFilter(setModalState),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {});
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14)),
                    child: const Text('Apply Filters'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterSection(String title, List<String> options,
      Set<String> selected, StateSetter setModalState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options
              .map((option) => FilterChip(
                    label: Text(option, style: const TextStyle(fontSize: 12)),
                    selected: selected.contains(option),
                    onSelected: (value) {
                      setModalState(() {
                        if (value) {
                          selected.add(option);
                        } else {
                          selected.remove(option);
                        }
                      });
                    },
                  ))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildRatingFilter(StateSetter setModalState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Minimum Rating',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            ChoiceChip(
              label: const Text('All', style: TextStyle(fontSize: 12)),
              selected: selectedMinRating == 0,
              onSelected: (selected) =>
                  setModalState(() => selectedMinRating = 0),
            ),
            ChoiceChip(
              label: const Text('4+ Stars', style: TextStyle(fontSize: 12)),
              selected: selectedMinRating == 4.0,
              onSelected: (selected) =>
                  setModalState(() => selectedMinRating = 4.0),
            ),
            ChoiceChip(
              label: const Text('4.5+ Stars', style: TextStyle(fontSize: 12)),
              selected: selectedMinRating == 4.5,
              onSelected: (selected) =>
                  setModalState(() => selectedMinRating = 4.5),
            ),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Find Hospitals'),
        actions: [
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.filter_list),
                if (selectedHospitalTypes.isNotEmpty || selectedMinRating > 0)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                          color: Colors.red, shape: BoxShape.circle),
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            child: Row(
              children: [
                Icon(Icons.location_on,
                    color: theme.colorScheme.primary, size: 18),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    selectedLocation,
                    style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w500,
                        fontSize: 13),
                  ),
                ),
                Icon(Icons.arrow_drop_down,
                    color: theme.colorScheme.primary, size: 20),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search hospitals...',
                hintStyle: const TextStyle(fontSize: 14),
                prefixIcon: const Icon(Icons.search, size: 20),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: filteredHospitals.isEmpty
                ? const Center(child: Text('No hospitals found'))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: filteredHospitals.length,
                    itemBuilder: (context, index) =>
                        _buildHospitalCard(theme, filteredHospitals[index]),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildHospitalCard(ThemeData theme, Map<String, dynamic> hospital) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.network(
              hospital['image'],
              height: 140,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 140,
                color: Colors.grey[300],
                child: const Icon(Icons.local_hospital, size: 50),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        hospital['name'],
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (hospital['verified'])
                      const Icon(Icons.verified, color: Colors.blue, size: 18),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  hospital['type'],
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: (hospital['specializations'] as List)
                      .take(3)
                      .map(
                        (spec) => Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            spec,
                            style: TextStyle(
                                color: theme.colorScheme.primary, fontSize: 11),
                          ),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 14),
                    const SizedBox(width: 3),
                    Text('${hospital['rating']}',
                        style: const TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w600)),
                    Text(' (${hospital['reviews']})',
                        style:
                            TextStyle(color: Colors.grey[600], fontSize: 11)),
                    const SizedBox(width: 12),
                    const Icon(Icons.location_on, color: Colors.grey, size: 14),
                    const SizedBox(width: 2),
                    Text('${hospital['distance']} km',
                        style: const TextStyle(fontSize: 12)),
                    const Spacer(),
                    Text(
                      hospital['consultancyFee'],
                      style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: (hospital['schemes'] as List)
                      .take(3)
                      .map(
                        (scheme) => Chip(
                          label: Text(scheme,
                              style: const TextStyle(fontSize: 10)),
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          visualDensity: VisualDensity.compact,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.hospitalProfile,
                            arguments: hospital,
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          textStyle: const TextStyle(fontSize: 13),
                        ),
                        child: const Text('View'),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
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
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          textStyle: const TextStyle(fontSize: 13),
                        ),
                        child: const Text('Book'),
                      ),
                    ),
                    const SizedBox(width: 6),
                    IconButton.filled(
                      onPressed: () {},
                      icon: const Icon(Icons.phone, size: 18),
                      style: IconButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.all(8),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
