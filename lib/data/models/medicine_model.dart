/// Production-grade Medicine Model
class Medicine {
  final String id;
  final String name;
  final String category;
  final double price;
  final String? imageUrl;
  final String? description;
  final String? manufacturer;
  final bool requiresPrescription;
  final int stock;
  final String? dosage;
  final String? composition;

  Medicine({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    this.imageUrl,
    this.description,
    this.manufacturer,
    this.requiresPrescription = false,
    this.stock = 0,
    this.dosage,
    this.composition,
  });

  bool get isInStock => stock > 0;
  bool get isLowStock => stock > 0 && stock <= 10;

  factory Medicine.fromJson(Map<String, dynamic> json) {
    return Medicine(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      category: json['category'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      imageUrl: json['imageUrl'] ?? json['image'],
      description: json['description'],
      manufacturer: json['manufacturer'],
      requiresPrescription:
          json['requiresPrescription'] ?? json['prescriptionRequired'] ?? false,
      stock: json['stock'] ?? 0,
      dosage: json['dosage'],
      composition: json['composition'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'price': price,
      'imageUrl': imageUrl,
      'description': description,
      'manufacturer': manufacturer,
      'requiresPrescription': requiresPrescription,
      'stock': stock,
      'dosage': dosage,
      'composition': composition,
    };
  }

  Medicine copyWith({
    String? id,
    String? name,
    String? category,
    double? price,
    String? imageUrl,
    String? description,
    String? manufacturer,
    bool? requiresPrescription,
    int? stock,
    String? dosage,
    String? composition,
  }) {
    return Medicine(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
      manufacturer: manufacturer ?? this.manufacturer,
      requiresPrescription: requiresPrescription ?? this.requiresPrescription,
      stock: stock ?? this.stock,
      dosage: dosage ?? this.dosage,
      composition: composition ?? this.composition,
    );
  }
}
