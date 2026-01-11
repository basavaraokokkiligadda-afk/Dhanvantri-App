import 'package:flutter/foundation.dart';
import '../../../data/models/medicine_model.dart';

/// Production-grade Pharmacy Controller
/// Handles all pharmacy and medicine-related business logic
class PharmacyController extends ChangeNotifier {
  // ========== STATE ==========
  List<Medicine> _allMedicines = [];
  List<Medicine> _filteredMedicines = [];
  final List<CartItem> _cartItems = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _searchQuery = '';
  String? _selectedCategory;

  // Order state
  String? _currentOrderId;
  String _deliveryAddress = '';
  String _contactNumber = '';

  // ========== GETTERS ==========
  List<Medicine> get allMedicines => _allMedicines;
  List<Medicine> get filteredMedicines => _filteredMedicines;
  List<CartItem> get cartItems => _cartItems;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;
  String? get selectedCategory => _selectedCategory;
  String? get currentOrderId => _currentOrderId;

  int get cartItemCount =>
      _cartItems.fold(0, (sum, item) => sum + item.quantity);

  double get cartSubtotal => _cartItems.fold(
        0.0,
        (sum, item) => sum + (item.medicine.price * item.quantity),
      );

  double get cartTotal {
    final subtotal = cartSubtotal;
    final deliveryFee = subtotal > 500 ? 0.0 : 50.0;
    return subtotal + deliveryFee;
  }

  bool get hasItemsInCart => _cartItems.isNotEmpty;

  // ========== MEDICINE MANAGEMENT ==========

  /// Fetch all medicines
  Future<void> fetchMedicines() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(seconds: 1));

      _allMedicines = _generateMockMedicines();
      _filteredMedicines = _allMedicines;

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to fetch medicines: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Search medicines
  void searchMedicines(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  /// Filter by category
  void filterByCategory(String? category) {
    _selectedCategory = category;
    _applyFilters();
  }

  void _applyFilters() {
    _filteredMedicines = _allMedicines.where((medicine) {
      final matchesSearch = _searchQuery.isEmpty ||
          medicine.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          (medicine.description
                  ?.toLowerCase()
                  .contains(_searchQuery.toLowerCase()) ??
              false);

      final matchesCategory = _selectedCategory == null ||
          _selectedCategory == 'All' ||
          medicine.category == _selectedCategory;

      return matchesSearch && matchesCategory;
    }).toList();
    notifyListeners();
  }

  /// Clear filters
  void clearFilters() {
    _searchQuery = '';
    _selectedCategory = null;
    _filteredMedicines = _allMedicines;
    notifyListeners();
  }

  // ========== CART MANAGEMENT ==========

  /// Add item to cart
  void addToCart(Medicine medicine, {int quantity = 1}) {
    final existingIndex = _cartItems.indexWhere(
      (item) => item.medicine.id == medicine.id,
    );

    if (existingIndex != -1) {
      _cartItems[existingIndex] = _cartItems[existingIndex].copyWith(
        quantity: _cartItems[existingIndex].quantity + quantity,
      );
    } else {
      _cartItems.add(CartItem(medicine: medicine, quantity: quantity));
    }
    notifyListeners();
  }

  /// Remove item from cart
  void removeFromCart(String medicineId) {
    _cartItems.removeWhere((item) => item.medicine.id == medicineId);
    notifyListeners();
  }

  /// Update cart item quantity
  void updateCartItemQuantity(String medicineId, int newQuantity) {
    if (newQuantity <= 0) {
      removeFromCart(medicineId);
      return;
    }

    final index = _cartItems.indexWhere(
      (item) => item.medicine.id == medicineId,
    );

    if (index != -1) {
      _cartItems[index] = _cartItems[index].copyWith(quantity: newQuantity);
      notifyListeners();
    }
  }

  /// Clear cart
  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  // ========== ORDER MANAGEMENT ==========

  /// Set delivery details
  void setDeliveryDetails({
    required String address,
    required String contact,
  }) {
    _deliveryAddress = address;
    _contactNumber = contact;
    notifyListeners();
  }

  /// Place order
  Future<bool> placeOrder() async {
    if (_cartItems.isEmpty) {
      _errorMessage = 'Cart is empty';
      notifyListeners();
      return false;
    }

    if (_deliveryAddress.isEmpty || _contactNumber.isEmpty) {
      _errorMessage = 'Please provide delivery details';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(seconds: 2));

      _currentOrderId = _generateOrderId();
      _cartItems.clear();

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to place order: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // ========== HELPERS ==========

  String _generateOrderId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return 'ORD$timestamp';
  }

  List<Medicine> _generateMockMedicines() {
    return [
      Medicine(
        id: '1',
        name: 'Paracetamol 500mg',
        category: 'Pain Relief',
        price: 25.0,
        description: 'Pain and fever relief',
        stock: 100,
        requiresPrescription: false,
      ),
      Medicine(
        id: '2',
        name: 'Amoxicillin 250mg',
        category: 'Antibiotics',
        price: 120.0,
        description: 'Antibiotic for bacterial infections',
        stock: 50,
        requiresPrescription: true,
      ),
      Medicine(
        id: '3',
        name: 'Cetirizine 10mg',
        category: 'Allergy',
        price: 45.0,
        description: 'Antihistamine for allergies',
        stock: 80,
        requiresPrescription: false,
      ),
      Medicine(
        id: '4',
        name: 'Omeprazole 20mg',
        category: 'Digestive',
        price: 85.0,
        description: 'Acid reflux and heartburn relief',
        stock: 60,
        requiresPrescription: false,
      ),
      Medicine(
        id: '5',
        name: 'Vitamin D3 1000IU',
        category: 'Supplements',
        price: 150.0,
        description: 'Bone health supplement',
        stock: 120,
        requiresPrescription: false,
      ),
    ];
  }
}

/// Cart Item Model
class CartItem {
  final Medicine medicine;
  final int quantity;

  CartItem({
    required this.medicine,
    required this.quantity,
  });

  CartItem copyWith({
    Medicine? medicine,
    int? quantity,
  }) {
    return CartItem(
      medicine: medicine ?? this.medicine,
      quantity: quantity ?? this.quantity,
    );
  }
}
