import 'package:flutter/foundation.dart';

/// Production-grade Payment Controller
/// Handles all payment-related business logic
class PaymentController extends ChangeNotifier {
  // ========== STATE ==========
  String _selectedPaymentMethod = 'upi';
  bool _isProcessing = false;
  String? _errorMessage;
  String? _transactionId;
  bool _paymentSuccess = false;

  // Payment details
  double _amount = 0.0;
  String _paymentType = ''; // 'appointment', 'pharmacy', 'diagnostic'
  Map<String, dynamic>? _orderDetails;

  // ========== GETTERS ==========
  String get selectedPaymentMethod => _selectedPaymentMethod;
  bool get isProcessing => _isProcessing;
  String? get errorMessage => _errorMessage;
  String? get transactionId => _transactionId;
  bool get paymentSuccess => _paymentSuccess;
  double get amount => _amount;
  String get paymentType => _paymentType;
  Map<String, dynamic>? get orderDetails => _orderDetails;

  // ========== PAYMENT METHODS ==========

  /// Initialize payment
  void initializePayment({
    required double amount,
    required String type,
    Map<String, dynamic>? details,
  }) {
    _amount = amount;
    _paymentType = type;
    _orderDetails = details;
    _selectedPaymentMethod = 'upi';
    _paymentSuccess = false;
    _transactionId = null;
    _errorMessage = null;
    notifyListeners();
  }

  /// Set selected payment method
  void setPaymentMethod(String method) {
    _selectedPaymentMethod = method;
    notifyListeners();
  }

  /// Process payment
  Future<bool> processPayment({
    String? upiId,
    String? cardNumber,
    String? cardExpiry,
    String? cardCvv,
    String? cardHolder,
  }) async {
    _isProcessing = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Validate based on payment method
      if (_selectedPaymentMethod == 'upi') {
        if (upiId == null || upiId.isEmpty) {
          throw Exception('UPI ID is required');
        }
        if (!_isValidUpiId(upiId)) {
          throw Exception('Invalid UPI ID format');
        }
      } else if (_selectedPaymentMethod == 'card') {
        if (cardNumber == null || cardNumber.isEmpty) {
          throw Exception('Card number is required');
        }
        if (!_isValidCardNumber(cardNumber)) {
          throw Exception('Invalid card number');
        }
        if (cardExpiry == null || !_isValidExpiry(cardExpiry)) {
          throw Exception('Invalid card expiry');
        }
        if (cardCvv == null || cardCvv.length < 3) {
          throw Exception('Invalid CVV');
        }
      } else if (_selectedPaymentMethod == 'netbanking') {
        // Net banking validation if needed
      } else if (_selectedPaymentMethod == 'wallet') {
        // Wallet validation if needed
      }

      // TODO: Replace with actual payment gateway integration
      await Future.delayed(const Duration(seconds: 2));

      // Simulate success
      _transactionId = _generateTransactionId();
      _paymentSuccess = true;
      _isProcessing = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _paymentSuccess = false;
      _isProcessing = false;
      notifyListeners();
      return false;
    }
  }

  /// Verify payment status
  Future<bool> verifyPayment(String transactionId) async {
    _isProcessing = true;
    notifyListeners();

    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(seconds: 1));

      _isProcessing = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Payment verification failed';
      _isProcessing = false;
      notifyListeners();
      return false;
    }
  }

  /// Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Reset payment state
  void resetPayment() {
    _selectedPaymentMethod = 'upi';
    _isProcessing = false;
    _errorMessage = null;
    _transactionId = null;
    _paymentSuccess = false;
    _amount = 0.0;
    _paymentType = '';
    _orderDetails = null;
    notifyListeners();
  }

  // ========== VALIDATION HELPERS ==========

  bool _isValidUpiId(String upiId) {
    // Basic UPI ID validation (username@bankname)
    final upiRegex = RegExp(r'^[\w.-]+@[\w.-]+$');
    return upiRegex.hasMatch(upiId);
  }

  bool _isValidCardNumber(String cardNumber) {
    // Remove spaces and validate length
    final cleaned = cardNumber.replaceAll(' ', '');
    if (cleaned.length < 13 || cleaned.length > 19) {
      return false;
    }

    // Luhn algorithm for card validation
    int sum = 0;
    bool alternate = false;
    for (int i = cleaned.length - 1; i >= 0; i--) {
      int digit = int.parse(cleaned[i]);
      if (alternate) {
        digit *= 2;
        if (digit > 9) {
          digit -= 9;
        }
      }
      sum += digit;
      alternate = !alternate;
    }
    return sum % 10 == 0;
  }

  bool _isValidExpiry(String expiry) {
    // Format: MM/YY or MM/YYYY
    final parts = expiry.split('/');
    if (parts.length != 2) return false;

    final month = int.tryParse(parts[0]);
    final year = int.tryParse(parts[1]);

    if (month == null || year == null) return false;
    if (month < 1 || month > 12) return false;

    final now = DateTime.now();
    final fullYear = year < 100 ? 2000 + year : year;
    final expiryDate = DateTime(fullYear, month + 1, 0);

    return expiryDate.isAfter(now);
  }

  String _generateTransactionId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = DateTime.now().microsecond;
    return 'TXN${timestamp}_$random';
  }

  // ========== PAYMENT AMOUNT CALCULATION ==========

  /// Calculate total with taxes and fees
  Map<String, double> calculatePaymentBreakdown({
    required double baseAmount,
    double taxRate = 0.18, // 18% GST
    double processingFee = 0.0,
  }) {
    final tax = baseAmount * taxRate;
    final total = baseAmount + tax + processingFee;

    return {
      'baseAmount': baseAmount,
      'tax': tax,
      'processingFee': processingFee,
      'total': total,
    };
  }
}
