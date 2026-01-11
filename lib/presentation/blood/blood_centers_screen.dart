import 'package:flutter/material.dart';
import '../../core/routes/app_routes.dart';

/// Blood Centers Screen - Mobile optimized
class BloodCentersScreen extends StatefulWidget {
  const BloodCentersScreen({super.key});

  @override
  State<BloodCentersScreen> createState() => _BloodCentersScreenState();
}

class _BloodCentersScreenState extends State<BloodCentersScreen> {
  final TextEditingController _searchController = TextEditingController();
  String selectedLocation = 'Hyderabad, Telangana';

  // Mock blood centers (20 centers)
  final List<Map<String, dynamic>> bloodCenters = [
    {
      'id': 1,
      'name': 'Red Cross Blood Bank',
      'bloodGroups': ['A+', 'B+', 'O+', 'AB+', 'A-', 'B-', 'O-', 'AB-'],
      'distance': 1.2,
      'availability': 'Available',
      'phone': '+91 40 1234 5678',
    },
    {
      'id': 2,
      'name': 'Apollo Blood Bank',
      'bloodGroups': ['A+', 'B+', 'O+', 'AB+'],
      'distance': 2.5,
      'availability': 'Limited',
      'phone': '+91 40 2345 6789',
    },
    {
      'id': 3,
      'name': 'Government General Hospital Blood Bank',
      'bloodGroups': ['A+', 'B+', 'O+', 'AB+', 'O-'],
      'distance': 3.1,
      'availability': 'Available',
      'phone': '+91 40 3456 7890',
    },
    {
      'id': 4,
      'name': 'Care Blood Centre',
      'bloodGroups': ['A+', 'B+', 'O+', 'A-', 'B-'],
      'distance': 1.8,
      'availability': 'Available',
      'phone': '+91 40 4567 8901',
    },
    {
      'id': 5,
      'name': 'Yashoda Blood Bank',
      'bloodGroups': ['A+', 'B+', 'O+', 'AB+', 'AB-'],
      'distance': 4.3,
      'availability': 'Available',
      'phone': '+91 40 5678 9012',
    },
    {
      'id': 6,
      'name': 'Continental Blood Services',
      'bloodGroups': ['A+', 'B+', 'O+'],
      'distance': 2.7,
      'availability': 'Limited',
      'phone': '+91 40 6789 0123',
    },
    {
      'id': 7,
      'name': 'Sunshine Blood Bank',
      'bloodGroups': ['A+', 'B+', 'O+', 'AB+', 'A-', 'O-'],
      'distance': 3.5,
      'availability': 'Available',
      'phone': '+91 40 7890 1234',
    },
    {
      'id': 8,
      'name': 'Fortis Blood Center',
      'bloodGroups': ['A+', 'B+', 'O+', 'AB+'],
      'distance': 5.2,
      'availability': 'Available',
      'phone': '+91 40 8901 2345',
    },
    {
      'id': 9,
      'name': 'Lifeblood Bank',
      'bloodGroups': ['A+', 'B+', 'O+', 'A-', 'B-', 'O-'],
      'distance': 1.5,
      'availability': 'Available',
      'phone': '+91 40 9012 3456',
    },
    {
      'id': 10,
      'name': 'MaxCure Blood Bank',
      'bloodGroups': ['A+', 'O+', 'AB+'],
      'distance': 2.9,
      'availability': 'Limited',
      'phone': '+91 40 0123 4567',
    },
    {
      'id': 11,
      'name': 'Rainbow Blood Services',
      'bloodGroups': ['A+', 'B+', 'O+', 'AB+', 'A-'],
      'distance': 3.8,
      'availability': 'Available',
      'phone': '+91 40 1234 6789',
    },
    {
      'id': 12,
      'name': 'KIMS Blood Bank',
      'bloodGroups': ['A+', 'B+', 'O+', 'AB+', 'O-', 'AB-'],
      'distance': 4.5,
      'availability': 'Available',
      'phone': '+91 40 2345 7890',
    },
    {
      'id': 13,
      'name': 'Citizens Blood Centre',
      'bloodGroups': ['A+', 'B+', 'O+'],
      'distance': 2.1,
      'availability': 'Limited',
      'phone': '+91 40 3456 8901',
    },
    {
      'id': 14,
      'name': 'Lotus Blood Bank',
      'bloodGroups': ['A+', 'B+', 'O+', 'AB+', 'A-', 'B-'],
      'distance': 3.3,
      'availability': 'Available',
      'phone': '+91 40 4567 9012',
    },
    {
      'id': 15,
      'name': 'Global Blood Services',
      'bloodGroups': ['A+', 'B+', 'O+', 'AB+', 'O-'],
      'distance': 5.8,
      'availability': 'Available',
      'phone': '+91 40 5678 0123',
    },
    {
      'id': 16,
      'name': 'Star Blood Bank',
      'bloodGroups': ['A+', 'B+', 'O+', 'AB+'],
      'distance': 2.4,
      'availability': 'Available',
      'phone': '+91 40 6789 1234',
    },
    {
      'id': 17,
      'name': 'Medicover Blood Centre',
      'bloodGroups': ['A+', 'B+', 'O+', 'A-', 'O-'],
      'distance': 3.9,
      'availability': 'Available',
      'phone': '+91 40 7890 2345',
    },
    {
      'id': 18,
      'name': 'Aware Blood Bank',
      'bloodGroups': ['A+', 'B+', 'O+', 'AB+', 'AB-'],
      'distance': 4.7,
      'availability': 'Limited',
      'phone': '+91 40 8901 3456',
    },
    {
      'id': 19,
      'name': 'Gleneagles Blood Services',
      'bloodGroups': ['A+', 'B+', 'O+', 'AB+', 'A-', 'B-', 'O-'],
      'distance': 6.2,
      'availability': 'Available',
      'phone': '+91 40 9012 4567',
    },
    {
      'id': 20,
      'name': 'Indo American Blood Bank',
      'bloodGroups': ['A+', 'B+', 'O+'],
      'distance': 2.8,
      'availability': 'Available',
      'phone': '+91 40 0123 5678',
    },
  ];

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
        title: const Text('Blood Centers'),
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
                hintText: 'Search blood banks, blood groups...',
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
              itemCount: bloodCenters.length,
              itemBuilder: (context, index) =>
                  _buildBloodCenterCard(theme, bloodCenters[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBloodCenterCard(ThemeData theme, Map<String, dynamic> center) {
    final isAvailable = center['availability'] == 'Available';

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            AppRoutes.bloodBankDetails,
            arguments: center,
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.bloodtype,
                        color: Colors.red, size: 28),
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
                            const Icon(Icons.location_on,
                                color: Colors.grey, size: 14),
                            const SizedBox(width: 4),
                            Text('${center['distance']} km away',
                                style: TextStyle(
                                    color: Colors.grey[600], fontSize: 12)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: isAvailable ? Colors.green[50] : Colors.orange[50],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      center['availability'],
                      style: TextStyle(
                        color: isAvailable
                            ? Colors.green[700]
                            : Colors.orange[700],
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text('Available Blood Groups:',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: (center['bloodGroups'] as List)
                    .map(
                      (group) => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.red[50],
                          border: Border.all(color: Colors.red.shade200),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          group,
                          style: TextStyle(
                            color: Colors.red[700],
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.bloodBankDetails,
                      arguments: center,
                    );
                  },
                  icon: const Icon(Icons.info_outline),
                  label: const Text('View Details'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
