import '../models/medicine_model.dart';

/// Centralized mock medicine data
class MockMedicines {
  MockMedicines._();

  static final List<Medicine> medicines = [
    Medicine(
      id: '1',
      name: 'Paracetamol 500mg',
      category: 'Tablets',
      price: 50.0,
      imageUrl: 'https://picsum.photos/200/200?random=1',
      description: 'Pain reliever and fever reducer',
      manufacturer: 'PharmaCo Ltd.',
      requiresPrescription: false,
      stock: 150,
    ),
    Medicine(
      id: '2',
      name: 'Amoxicillin 250mg',
      category: 'Capsules',
      price: 120.0,
      imageUrl: 'https://picsum.photos/200/200?random=2',
      description: 'Antibiotic for bacterial infections',
      manufacturer: 'MediLife Inc.',
      requiresPrescription: true,
      stock: 85,
    ),
    Medicine(
      id: '3',
      name: 'Cough Syrup',
      category: 'Syrups',
      price: 85.0,
      imageUrl: 'https://picsum.photos/200/200?random=3',
      description: 'Relief from cough and cold symptoms',
      manufacturer: 'HealthCare Labs',
      requiresPrescription: false,
      stock: 100,
    ),
    Medicine(
      id: '4',
      name: 'Vitamin D3',
      category: 'Tablets',
      price: 150.0,
      imageUrl: 'https://picsum.photos/200/200?random=4',
      description: 'Vitamin D supplement for bone health',
      manufacturer: 'NutriWell',
      requiresPrescription: false,
      stock: 120,
    ),
    Medicine(
      id: '5',
      name: 'Eye Drops',
      category: 'Drops',
      price: 95.0,
      imageUrl: 'https://picsum.photos/200/200?random=5',
      description: 'Relieves dry and irritated eyes',
      manufacturer: 'VisionCare',
      requiresPrescription: false,
      stock: 75,
    ),
    Medicine(
      id: '6',
      name: 'Pain Relief Ointment',
      category: 'Ointments',
      price: 110.0,
      imageUrl: 'https://picsum.photos/200/200?random=6',
      description: 'Topical pain relief for muscles and joints',
      manufacturer: 'PainFree Solutions',
      requiresPrescription: false,
      stock: 0,
    ),
  ];

  static Medicine? getMedicineById(String id) {
    try {
      return medicines.firstWhere((medicine) => medicine.id == id);
    } catch (e) {
      return null;
    }
  }

  static List<Medicine> getMedicinesByCategory(String category) {
    if (category == 'All') return medicines;
    return medicines
        .where((medicine) => medicine.category == category)
        .toList();
  }

  static List<Medicine> getInStockMedicines() {
    return medicines.where((medicine) => medicine.isInStock).toList();
  }

  static List<Medicine> searchMedicines(String query) {
    final lowerQuery = query.toLowerCase();
    return medicines
        .where((medicine) =>
            medicine.name.toLowerCase().contains(lowerQuery) ||
            (medicine.description?.toLowerCase().contains(lowerQuery) ?? false))
        .toList();
  }
}
