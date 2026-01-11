import 'package:flutter/foundation.dart';
import '../../data/models/medicine_model.dart';
import '../../data/mock_data/mock_medicines.dart';

/// Cart item model
class CartItem {
  final Medicine medicine;
  int quantity;

  CartItem({
    required this.medicine,
    this.quantity = 1,
  });

  double get totalPrice => medicine.price * quantity;
}

/// Provider for managing pharmacy cart and medicines
class PharmacyProvider extends ChangeNotifier {
  List<Medicine> _medicines = [];
  List<Medicine> _filteredMedicines = [];
  final List<CartItem> _cartItems = [];
  String _selectedCategory = 'All';
  bool _isLoading = false;
  String? _error;

  List<Medicine> get medicines => _filteredMedicines;
  List<CartItem> get cartItems => _cartItems;
  String get selectedCategory => _selectedCategory;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get cartCount => _cartItems.fold(0, (sum, item) => sum + item.quantity);
  double get cartTotal =>
      _cartItems.fold(0, (sum, item) => sum + item.totalPrice);

  PharmacyProvider() {
    loadMedicines();
  }

  /// Load medicines from mock data
  Future<void> loadMedicines() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 500));
      _medicines = MockMedicines.medicines;
      _filteredMedicines = _medicines;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load medicines: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Filter medicines by category
  void filterByCategory(String category) {
    _selectedCategory = category;
    _filteredMedicines = MockMedicines.getMedicinesByCategory(category);
    notifyListeners();
  }

  /// Search medicines
  void searchMedicines(String query) {
    if (query.isEmpty) {
      _filteredMedicines = _medicines;
    } else {
      _filteredMedicines = MockMedicines.searchMedicines(query);
    }
    notifyListeners();
  }

  /// Add medicine to cart
  void addToCart(Medicine medicine, {int quantity = 1}) {
    final existingIndex =
        _cartItems.indexWhere((item) => item.medicine.id == medicine.id);

    if (existingIndex >= 0) {
      _cartItems[existingIndex].quantity += quantity;
    } else {
      _cartItems.add(CartItem(medicine: medicine, quantity: quantity));
    }
    notifyListeners();
  }

  /// Remove medicine from cart
  void removeFromCart(String medicineId) {
    _cartItems.removeWhere((item) => item.medicine.id == medicineId);
    notifyListeners();
  }

  /// Update cart item quantity
  void updateCartQuantity(String medicineId, int quantity) {
    final index =
        _cartItems.indexWhere((item) => item.medicine.id == medicineId);
    if (index >= 0) {
      if (quantity <= 0) {
        _cartItems.removeAt(index);
      } else {
        _cartItems[index].quantity = quantity;
      }
      notifyListeners();
    }
  }

  /// Clear cart
  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  /// Check if medicine is in cart
  bool isInCart(String medicineId) {
    return _cartItems.any((item) => item.medicine.id == medicineId);
  }

  /// Get cart quantity for a medicine
  int getCartQuantity(String medicineId) {
    final item = _cartItems.firstWhere((item) => item.medicine.id == medicineId,
        orElse: () => CartItem(
              medicine: Medicine(
                id: '',
                name: '',
                category: '',
                price: 0,
                imageUrl: '',
                description: '',
                manufacturer: '',
              ),
              quantity: 0,
            ));
    return item.quantity;
  }
}
