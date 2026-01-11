import 'package:flutter/material.dart';
import '../../core/routes/app_routes.dart';

/// Diagnostic Centers Screen - Mobile optimized
class DiagnosticCentersScreen extends StatefulWidget {
  const DiagnosticCentersScreen({super.key});

  @override
  State<DiagnosticCentersScreen> createState() =>
      _DiagnosticCentersScreenState();
}

class _DiagnosticCentersScreenState extends State<DiagnosticCentersScreen> {
  final TextEditingController _searchController = TextEditingController();
  String selectedLocation = 'Hyderabad, Telangana';

  // Filter states
  Set<String> selectedTests = {};
  Set<String> selectedPriceRanges = {};
  double selectedMinRating = 0;

  // Mock diagnostic centers (20 centers)
  final List<Map<String, dynamic>> diagnosticCenters = [
    {
      'id': 1,
      'name': 'Apollo Diagnostics',
      'image': 'https://images.unsplash.com/photo-1579154341394-6e063c19609f',
      'tests': ['Blood Test', 'X-Ray', 'MRI', 'CT Scan', 'Ultrasound'],
      'rating': 4.8,
      'reviews': 1250,
      'distance': 1.5,
      'priceRange': '₹200 - ₹5000',
    },
    {
      'id': 2,
      'name': 'Vijaya Diagnostic Centre',
      'image': 'https://images.unsplash.com/photo-1631815587646-b85a1bb027e1',
      'tests': ['Blood Test', 'ECG', 'Echo', 'Pathology'],
      'rating': 4.7,
      'reviews': 980,
      'distance': 2.3,
      'priceRange': '₹150 - ₹3000',
    },
    {
      'id': 3,
      'name': 'Dr. Lal PathLabs',
      'image': 'https://images.unsplash.com/photo-1579154341394-6e063c19609f',
      'tests': ['Blood Test', 'Pathology', 'Biopsy', 'Culture Test'],
      'rating': 4.6,
      'reviews': 2100,
      'distance': 3.1,
      'priceRange': '₹100 - ₹2500',
    },
    {
      'id': 4,
      'name': 'Metropolis Healthcare',
      'image': 'https://images.unsplash.com/photo-1631815587646-b85a1bb027e1',
      'tests': ['Blood Test', 'Hormone Test', 'Diabetes Test', 'Thyroid Test'],
      'rating': 4.8,
      'reviews': 1560,
      'distance': 1.8,
      'priceRange': '₹120 - ₹2800',
    },
    {
      'id': 5,
      'name': 'SRL Diagnostics',
      'image': 'https://images.unsplash.com/photo-1579154341394-6e063c19609f',
      'tests': ['Blood Test', 'MRI', 'CT Scan', 'X-Ray', 'PET Scan'],
      'rating': 4.7,
      'reviews': 1890,
      'distance': 4.2,
      'priceRange': '₹250 - ₹8000',
    },
    {
      'id': 6,
      'name': 'Quest Diagnostics',
      'image': 'https://images.unsplash.com/photo-1631815587646-b85a1bb027e1',
      'tests': ['Blood Test', 'Urine Test', 'Stool Test', 'Culture'],
      'rating': 4.5,
      'reviews': 780,
      'distance': 2.7,
      'priceRange': '₹80 - ₹1500',
    },
    {
      'id': 7,
      'name': 'Thyrocare Technologies',
      'image': 'https://images.unsplash.com/photo-1579154341394-6e063c19609f',
      'tests': ['Thyroid Test', 'Blood Test', 'Full Body Checkup'],
      'rating': 4.6,
      'reviews': 1340,
      'distance': 3.5,
      'priceRange': '₹100 - ₹2000',
    },
    {
      'id': 8,
      'name': 'Suburban Diagnostics',
      'image': 'https://images.unsplash.com/photo-1631815587646-b85a1bb027e1',
      'tests': ['Blood Test', 'X-Ray', 'Mammography', 'Bone Density'],
      'rating': 4.7,
      'reviews': 920,
      'distance': 1.2,
      'priceRange': '₹200 - ₹4000',
    },
    {
      'id': 9,
      'name': 'Oncquest Laboratories',
      'image': 'https://images.unsplash.com/photo-1579154341394-6e063c19609f',
      'tests': ['Cancer Screening', 'Biopsy', 'Pathology', 'Blood Test'],
      'rating': 4.9,
      'reviews': 670,
      'distance': 5.8,
      'priceRange': '₹500 - ₹10000',
    },
    {
      'id': 10,
      'name': 'Healthians',
      'image': 'https://images.unsplash.com/photo-1631815587646-b85a1bb027e1',
      'tests': ['Home Collection', 'Blood Test', 'Full Body Checkup'],
      'rating': 4.5,
      'reviews': 1120,
      'distance': 2.9,
      'priceRange': '₹150 - ₹3500',
    },
    {
      'id': 11,
      'name': 'Max Lab',
      'image': 'https://images.unsplash.com/photo-1579154341394-6e063c19609f',
      'tests': ['Blood Test', 'CT Scan', 'MRI', 'Ultrasound'],
      'rating': 4.7,
      'reviews': 1450,
      'distance': 3.8,
      'priceRange': '₹300 - ₹6000',
    },
    {
      'id': 12,
      'name': 'iGenetic Diagnostics',
      'image': 'https://images.unsplash.com/photo-1631815587646-b85a1bb027e1',
      'tests': ['Genetic Testing', 'DNA Test', 'Paternity Test'],
      'rating': 4.8,
      'reviews': 540,
      'distance': 6.5,
      'priceRange': '₹1000 - ₹15000',
    },
    {
      'id': 13,
      'name': 'Redcliffe Labs',
      'image': 'https://images.unsplash.com/photo-1579154341394-6e063c19609f',
      'tests': ['Blood Test', 'COVID Test', 'Fever Panel', 'Allergy Test'],
      'rating': 4.6,
      'reviews': 890,
      'distance': 2.1,
      'priceRange': '₹100 - ₹2200',
    },
    {
      'id': 14,
      'name': 'Core Diagnostics',
      'image': 'https://images.unsplash.com/photo-1631815587646-b85a1bb027e1',
      'tests': ['Pathology', 'Radiology', 'Blood Test', 'X-Ray'],
      'rating': 4.5,
      'reviews': 1230,
      'distance': 4.0,
      'priceRange': '₹150 - ₹3800',
    },
    {
      'id': 15,
      'name': 'Orange Health Labs',
      'image': 'https://images.unsplash.com/photo-1579154341394-6e063c19609f',
      'tests': ['Blood Test', 'Home Collection', '60 Min Reports'],
      'rating': 4.7,
      'reviews': 760,
      'distance': 1.9,
      'priceRange': '₹200 - ₹2500',
    },
    {
      'id': 16,
      'name': 'Aster Labs',
      'image': 'https://images.unsplash.com/photo-1631815587646-b85a1bb027e1',
      'tests': ['Blood Test', 'MRI', 'CT Scan', 'Mammography'],
      'rating': 4.8,
      'reviews': 1340,
      'distance': 3.3,
      'priceRange': '₹250 - ₹7000',
    },
    {
      'id': 17,
      'name': 'Neuberg Diagnostics',
      'image': 'https://images.unsplash.com/photo-1579154341394-6e063c19609f',
      'tests': ['Pathology', 'Genomics', 'Molecular Tests', 'Blood Test'],
      'rating': 4.9,
      'reviews': 620,
      'distance': 5.2,
      'priceRange': '₹400 - ₹12000',
    },
    {
      'id': 18,
      'name': 'Curelife Diagnostics',
      'image': 'https://images.unsplash.com/photo-1631815587646-b85a1bb027e1',
      'tests': ['Blood Test', 'ECG', 'Echo', 'Stress Test'],
      'rating': 4.6,
      'reviews': 870,
      'distance': 2.6,
      'priceRange': '₹180 - ₹3200',
    },
    {
      'id': 19,
      'name': 'Wellness Forever Labs',
      'image': 'https://images.unsplash.com/photo-1579154341394-6e063c19609f',
      'tests': ['Full Body Checkup', 'Blood Test', 'Diabetes Package'],
      'rating': 4.5,
      'reviews': 1050,
      'distance': 3.7,
      'priceRange': '₹300 - ₹4500',
    },
    {
      'id': 20,
      'name': 'Spark Diagnostics',
      'image': 'https://images.unsplash.com/photo-1631815587646-b85a1bb027e1',
      'tests': ['Blood Test', 'X-Ray', 'Ultrasound', 'Pathology'],
      'rating': 4.7,
      'reviews': 940,
      'distance': 1.6,
      'priceRange': '₹120 - ₹2800',
    },
  ];

  List<Map<String, dynamic>> get filteredCenters {
    return diagnosticCenters.where((center) {
      if (selectedMinRating > 0 && center['rating'] < selectedMinRating) {
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
          initialChildSize: 0.7,
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
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    TextButton(
                      onPressed: () {
                        setModalState(() {
                          selectedTests.clear();
                          selectedPriceRanges.clear();
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
                        padding: const EdgeInsets.symmetric(vertical: 16)),
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

  Widget _buildRatingFilter(StateSetter setModalState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Minimum Rating',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            ChoiceChip(
              label: const Text('All'),
              selected: selectedMinRating == 0,
              onSelected: (selected) =>
                  setModalState(() => selectedMinRating = 0),
            ),
            ChoiceChip(
              label: const Text('4+ Stars'),
              selected: selectedMinRating == 4.0,
              onSelected: (selected) =>
                  setModalState(() => selectedMinRating = 4.0),
            ),
            ChoiceChip(
              label: const Text('4.5+ Stars'),
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
        title: const Text('Diagnostic Centers'),
        actions: [
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.filter_list),
                if (selectedMinRating > 0)
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
                    color: theme.colorScheme.primary, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    selectedLocation,
                    style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                Icon(Icons.arrow_drop_down, color: theme.colorScheme.primary),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search tests, diagnostic centers...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: filteredCenters.length,
              itemBuilder: (context, index) =>
                  _buildCenterCard(theme, filteredCenters[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCenterCard(ThemeData theme, Map<String, dynamic> center) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.biotech,
                      color: theme.colorScheme.primary, size: 32),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(center['name'],
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text('${center['rating']}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600)),
                          Text(' (${center['reviews']})',
                              style: TextStyle(
                                  color: Colors.grey[600], fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: (center['tests'] as List)
                  .take(4)
                  .map(
                    (test) => Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(test,
                          style:
                              TextStyle(color: Colors.blue[700], fontSize: 12)),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.grey, size: 16),
                const SizedBox(width: 4),
                Text('${center['distance']} km away'),
                const Spacer(),
                Text(
                  center['priceRange'],
                  style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.diagnosticCenterDetails,
                    arguments: center,
                  );
                },
                child: const Text('Book Test'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
