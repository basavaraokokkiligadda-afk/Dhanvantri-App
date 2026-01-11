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
      prescriptionRequired: false,
      inStock: true,
    ),
    Medicine(
      id: '2',
      name: 'Amoxicillin 250mg',
      category: 'Capsules',
      price: 120.0,
      imageUrl: 'https://picsum.photos/200/200?random=2',
      description: 'Antibiotic for bacterial infections',
      manufacturer: 'MediLife Inc.',
      prescriptionRequired: true,
      inStock: true,
    ),
    Medicine(
      id: '3',
      name: 'Cough Syrup',
      category: 'Syrups',
      price: 85.0,
      imageUrl: 'https://picsum.photos/200/200?random=3',
      description: 'Relief from cough and cold symptoms',
      manufacturer: 'HealthCare Labs',
      prescriptionRequired: false,
      inStock: true,
    ),
    Medicine(
      id: '4',
      name: 'Vitamin D3',
      category: 'Tablets',
      price: 150.0,
      imageUrl: 'https://picsum.photos/200/200?random=4',
      description: 'Vitamin D supplement for bone health',
      manufacturer: 'NutriWell',
      prescriptionRequired: false,
      inStock: true,
    ),
    Medicine(
      id: '5',
      name: 'Eye Drops',
      category: 'Drops',
      price: 95.0,
      imageUrl: 'https://picsum.photos/200/200?random=5',
      description: 'Relieves dry and irritated eyes',
      manufacturer: 'VisionCare',
      prescriptionRequired: false,
      inStock: true,
    ),
    Medicine(
      id: '6',
      name: 'Pain Relief Ointment',
      category: 'Ointments',
      price: 110.0,
      imageUrl: 'https://picsum.photos/200/200?random=6',
      description: 'Topical pain relief for muscles and joints',
      manufacturer: 'PainFree Solutions',
      prescriptionRequired: false,
      inStock: false,
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
    return medicines.where((medicine) => medicine.inStock).toList();
  }

  static List<Medicine> searchMedicines(String query) {
    final lowerQuery = query.toLowerCase();
    return medicines
        .where((medicine) =>
            medicine.name.toLowerCase().contains(lowerQuery) ||
            medicine.description.toLowerCase().contains(lowerQuery))
        .toList();
  }
}
