/// Medicine model
class Medicine {
  final String id;
  final String name;
  final String category;
  final double price;
  final String imageUrl;
  final String description;
  final String manufacturer;
  final bool prescriptionRequired;
  final bool inStock;

  Medicine({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.imageUrl,
    required this.description,
    required this.manufacturer,
    this.prescriptionRequired = false,
    this.inStock = true,
  });

  factory Medicine.fromJson(Map<String, dynamic> json) {
    return Medicine(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      category: json['category'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      imageUrl: json['image'] ?? json['imageUrl'] ?? '',
      description: json['description'] ?? '',
      manufacturer: json['manufacturer'] ?? '',
      prescriptionRequired: json['prescriptionRequired'] ?? false,
      inStock: json['inStock'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'price': price,
      'image': imageUrl,
      'description': description,
      'manufacturer': manufacturer,
      'prescriptionRequired': prescriptionRequired,
      'inStock': inStock,
    };
  }
}
