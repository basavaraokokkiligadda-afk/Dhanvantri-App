/// Hospital model
class Hospital {
  final String id;
  final String name;
  final String imageUrl;
  final double rating;
  final String address;
  final String? phone;
  final bool emergency;
  final List<String> specialties;
  final int beds;
  final String type;

  Hospital({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.rating,
    required this.address,
    this.phone,
    this.emergency = false,
    this.specialties = const [],
    this.beds = 0,
    required this.type,
  });

  factory Hospital.fromJson(Map<String, dynamic> json) {
    return Hospital(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      imageUrl: json['image'] ?? json['imageUrl'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      address: json['address'] ?? '',
      phone: json['phone'],
      emergency: json['emergency'] ?? false,
      specialties: (json['specialties'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      beds: json['beds'] ?? 0,
      type: json['type'] ?? 'General',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': imageUrl,
      'rating': rating,
      'address': address,
      'phone': phone,
      'emergency': emergency,
      'specialties': specialties,
      'beds': beds,
      'type': type,
    };
  }
}
