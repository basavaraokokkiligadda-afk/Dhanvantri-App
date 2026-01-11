/// Doctor model
class Doctor {
  final String id;
  final String name;
  final String specialty;
  final String imageUrl;
  final double rating;
  final int experience;
  final String hospital;
  final String address;
  final String? about;
  final double consultationFee;
  final bool isAvailable;

  Doctor({
    required this.id,
    required this.name,
    required this.specialty,
    required this.imageUrl,
    required this.rating,
    required this.experience,
    required this.hospital,
    required this.address,
    this.about,
    required this.consultationFee,
    this.isAvailable = true,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      specialty: json['specialty'] ?? '',
      imageUrl: json['image'] ?? json['imageUrl'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      experience: json['experience'] ?? 0,
      hospital: json['hospital'] ?? '',
      address: json['address'] ?? '',
      about: json['about'],
      consultationFee: (json['consultationFee'] ?? 0).toDouble(),
      isAvailable: json['available'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'specialty': specialty,
      'image': imageUrl,
      'rating': rating,
      'experience': experience,
      'hospital': hospital,
      'address': address,
      'about': about,
      'consultationFee': consultationFee,
      'available': isAvailable,
    };
  }
}
