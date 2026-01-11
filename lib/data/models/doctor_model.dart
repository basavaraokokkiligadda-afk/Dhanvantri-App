/// Production-grade Doctor Model
class Doctor {
  final String id;
  final String name;
  final String specialization;
  final String? imageUrl;
  final double rating;
  final int reviewCount;
  final int experience;
  final String? hospital;
  final String? address;
  final String? about;
  final double fee;
  final bool isAvailable;
  final List<String>? qualifications;
  final List<String>? languages;
  final List<String>? availableDays;

  Doctor({
    required this.id,
    required this.name,
    required this.specialization,
    this.imageUrl,
    required this.rating,
    required this.reviewCount,
    required this.experience,
    this.hospital,
    this.address,
    this.about,
    required this.fee,
    this.isAvailable = true,
    this.qualifications,
    this.languages,
    this.availableDays,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      specialization: json['specialization'] ?? json['specialty'] ?? '',
      imageUrl: json['imageUrl'] ?? json['image'],
      rating: (json['rating'] ?? 0).toDouble(),
      reviewCount: json['reviewCount'] ?? json['reviews'] ?? 0,
      experience: json['experience'] ?? 0,
      hospital: json['hospital'],
      address: json['address'],
      about: json['about'],
      fee: (json['fee'] ?? json['consultationFee'] ?? 0).toDouble(),
      isAvailable: json['isAvailable'] ?? json['available'] ?? true,
      qualifications: json['qualifications'] != null
          ? List<String>.from(json['qualifications'])
          : null,
      languages: json['languages'] != null
          ? List<String>.from(json['languages'])
          : null,
      availableDays: json['availableDays'] != null
          ? List<String>.from(json['availableDays'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'specialization': specialization,
      'imageUrl': imageUrl,
      'rating': rating,
      'reviewCount': reviewCount,
      'experience': experience,
      'hospital': hospital,
      'address': address,
      'about': about,
      'fee': fee,
      'isAvailable': isAvailable,
      'qualifications': qualifications,
      'languages': languages,
      'availableDays': availableDays,
    };
  }

  Doctor copyWith({
    String? id,
    String? name,
    String? specialization,
    String? imageUrl,
    double? rating,
    int? reviewCount,
    int? experience,
    String? hospital,
    String? address,
    String? about,
    double? fee,
    bool? isAvailable,
    List<String>? qualifications,
    List<String>? languages,
    List<String>? availableDays,
  }) {
    return Doctor(
      id: id ?? this.id,
      name: name ?? this.name,
      specialization: specialization ?? this.specialization,
      imageUrl: imageUrl ?? this.imageUrl,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      experience: experience ?? this.experience,
      hospital: hospital ?? this.hospital,
      address: address ?? this.address,
      about: about ?? this.about,
      fee: fee ?? this.fee,
      isAvailable: isAvailable ?? this.isAvailable,
      qualifications: qualifications ?? this.qualifications,
      languages: languages ?? this.languages,
      availableDays: availableDays ?? this.availableDays,
    );
  }
}
