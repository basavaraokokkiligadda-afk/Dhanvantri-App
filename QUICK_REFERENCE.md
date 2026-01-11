# 🚀 QUICK REFERENCE - Dhanvantri Healthcare

> **Fast lookup for common tasks after refactoring**

---

## 📦 IMPORTS CHEAT SHEET

### Providers
```dart
import 'package:provider/provider.dart';
import '../../core/providers/doctors_provider.dart';
import '../../core/providers/appointments_provider.dart';
import '../../core/providers/pharmacy_provider.dart';
import '../../core/providers/booking_provider.dart';
import '../../core/providers/app_state_provider.dart';
```

### Models
```dart
import '../../data/models/doctor_model.dart';
import '../../data/models/hospital_model.dart';
import '../../data/models/appointment_model.dart';
import '../../data/models/medicine_model.dart';
```

### Constants
```dart
import '../../core/constants/app_constants.dart';
import '../../core/constants/api_endpoints.dart';
```

### Utils
```dart
import '../../core/utils/validators.dart';
import '../../core/utils/date_utils.dart';
```

### Navigation
```dart
import '../../navigation/app_router.dart';
```

### Theme
```dart
import '../../core/theme/app_theme.dart';
```

---

## 🎯 COMMON TASKS

### 1. Access a Provider

```dart
// In StatelessWidget
final provider = Provider.of<DoctorsProvider>(context);

// With listen: false (for events, not rebuilds)
final provider = Provider.of<DoctorsProvider>(context, listen: false);

// Using Consumer (recommended for partial rebuilds)
Consumer<DoctorsProvider>(
  builder: (context, provider, child) {
    return Text(provider.doctors.length.toString());
  },
)
```

### 2. Navigate to Another Screen

```dart
// Simple navigation
AppRouter.navigateTo(context, AppRouter.findDoctors);

// With data
AppRouter.navigateToDoctorProfile(context, doctorData);

// Replace current screen
AppRouter.navigateAndReplace(context, AppRouter.userDashboard);

// Clear stack
AppRouter.navigateAndRemoveUntil(context, AppRouter.userDashboard);

// Go back
AppRouter.goBack(context);
```

### 3. Use Constants

```dart
// App constants
AppConstants.appName
AppConstants.baseUrl
AppConstants.tokenAmount
AppConstants.userTypePatient
AppConstants.statusConfirmed

// API endpoints
ApiEndpoints.doctors
ApiEndpoints.doctorById('123')
ApiEndpoints.appointments
```

### 4. Validate Forms

```dart
TextFormField(
  validator: Validators.validateEmail,
)

TextFormField(
  validator: Validators.validatePassword,
)

TextFormField(
  validator: (value) => Validators.validateRequired(value, 'Name'),
)
```

### 5. Format Dates

```dart
AppDateUtils.formatDate(DateTime.now())
// Output: "Jan 11, 2026"

AppDateUtils.formatTime(DateTime.now())
// Output: "02:30 PM"

AppDateUtils.formatDateTime(DateTime.now())
// Output: "Jan 11, 2026 at 02:30 PM"

AppDateUtils.getTimeAgo(pastDate)
// Output: "2 hours ago"
```

---

## 🗂️ PROVIDER METHODS

### DoctorsProvider

```dart
final provider = Provider.of<DoctorsProvider>(context);

// Get doctors
provider.doctors

// Loading state
provider.isLoading

// Error state
provider.error

// Filter by specialty
provider.filterBySpecialty('Cardiologist');

// Search
provider.searchDoctors('Dr. Smith');

// Get single doctor
provider.getDoctorById('1');

// Available doctors only
provider.getAvailableDoctors();
```

### AppointmentsProvider

```dart
final provider = Provider.of<AppointmentsProvider>(context);

// All appointments
provider.appointments

// Create appointment
await provider.createAppointment(appointmentModel);

// Get by status
provider.getAppointmentsByStatus(AppConstants.statusPending);

// Upcoming
provider.getUpcomingAppointments();

// Past
provider.getPastAppointments();

// Cancel
await provider.cancelAppointment('appointment-id');

// Update status
await provider.updateAppointmentStatus('id', AppConstants.statusConfirmed);
```

### PharmacyProvider

```dart
final provider = Provider.of<PharmacyProvider>(context);

// All medicines
provider.medicines

// Cart
provider.cartItems
provider.cartCount
provider.cartTotal

// Filter
provider.filterByCategory('Tablets');

// Search
provider.searchMedicines('Paracetamol');

// Cart operations
provider.addToCart(medicine, quantity: 2);
provider.removeFromCart('medicine-id');
provider.updateCartQuantity('medicine-id', 5);
provider.clearCart();

// Check cart
provider.isInCart('medicine-id');
provider.getCartQuantity('medicine-id');
```

### BookingProvider

```dart
final provider = Provider.of<BookingProvider>(context);

// Initialize booking
provider.initializeBooking(
  type: AppConstants.bookingTypeDoctor,
  doctor: doctorModel,
);

// Set details
provider.setSelectedDate(DateTime.now());
provider.setSelectedTimeSlot('10:00 AM');
provider.setPaymentType(AppConstants.paymentTypeFull);
provider.setNotes('Important notes');

// Get info
provider.getConsultationFee();
provider.getFinalAmount();
provider.canProceed;

// Process
await provider.processBooking();

// Reset
provider.resetBooking();
```

---

## 🎨 THEME COLORS

```dart
// Primary colors
AppTheme.primaryLight      // #2E7D5A
AppTheme.primaryDark       // #3A9B6F

// Secondary colors
AppTheme.secondaryLight    // #4A90A4
AppTheme.secondaryDark     // #5BA3B8

// Status colors
AppTheme.success           // #10B981
AppTheme.warning           // #F59E0B
AppTheme.error             // #EF4444
AppTheme.info              // #3B82F6

// Spacing
AppTheme.spacingXS         // 4.0
AppTheme.spacingS          // 8.0
AppTheme.spacingM          // 16.0
AppTheme.spacingL          // 24.0
AppTheme.spacingXL         // 32.0

// Border radius
AppTheme.radiusS           // 8.0
AppTheme.radiusM           // 12.0
AppTheme.radiusL           // 16.0
AppTheme.radiusXL          // 24.0
```

---

## 📋 COMMON PATTERNS

### Loading State

```dart
Consumer<DoctorsProvider>(
  builder: (context, provider, child) {
    if (provider.isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    
    if (provider.error != null) {
      return Center(child: Text('Error: ${provider.error}'));
    }
    
    return ListView.builder(
      itemCount: provider.doctors.length,
      itemBuilder: (context, index) {
        return DoctorCard(doctor: provider.doctors[index]);
      },
    );
  },
)
```

### Form with Validation

```dart
final _formKey = GlobalKey<FormState>();

Form(
  key: _formKey,
  child: Column(
    children: [
      TextFormField(
        validator: Validators.validateEmail,
        decoration: InputDecoration(labelText: 'Email'),
      ),
      ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            // Submit
          }
        },
        child: Text('Submit'),
      ),
    ],
  ),
)
```

### Provider Action with Feedback

```dart
Future<void> _bookAppointment() async {
  final bookingProvider = Provider.of<BookingProvider>(context, listen: false);
  
  final success = await bookingProvider.processBooking();
  
  if (success) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Booking successful!')),
    );
    AppRouter.navigateAndRemoveUntil(context, AppRouter.userDashboard);
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Booking failed. Try again.')),
    );
  }
}
```

---

## 🗄️ FILE LOCATIONS

| What | Where |
|------|-------|
| Providers | `lib/core/providers/` |
| Models | `lib/data/models/` |
| Mock Data | `lib/data/mock_data/` |
| Constants | `lib/core/constants/` |
| Utils | `lib/core/utils/` |
| Theme | `lib/core/theme/` |
| Navigation | `lib/navigation/` |
| Screens | `lib/presentation/` |
| Widgets | `lib/presentation/widgets/` |

---

## 🔍 TROUBLESHOOTING

### Provider not found
```dart
// ❌ Wrong
final provider = DoctorsProvider();

// ✅ Correct
final provider = Provider.of<DoctorsProvider>(context);
```

### Provider not updating UI
```dart
// ❌ Wrong
final provider = Provider.of<DoctorsProvider>(context, listen: false);

// ✅ Correct (for UI updates)
final provider = Provider.of<DoctorsProvider>(context);
// OR use Consumer
```

### Import path errors
```dart
// ✅ Use relative imports from screens
import '../../core/providers/doctors_provider.dart';

// ❌ Don't use package imports for local files
import 'package:dhanvantri_healthcare/core/providers/doctors_provider.dart';
```

### Model conversion
```dart
// ✅ Use from mock data
final doctor = MockDoctors.getDoctorById('1');

// ✅ Use from JSON (API responses)
final doctor = Doctor.fromJson(jsonData);

// ✅ Convert to JSON
final json = doctor.toJson();
```

---

## 📝 BEST PRACTICES

### DO ✅
- Use providers for state management
- Use models for type safety
- Use constants for string literals
- Use validators for forms
- Use AppRouter for navigation
- Add loading states
- Handle errors gracefully
- Write comments

### DON'T ❌
- Put logic in UI widgets
- Hard-code data
- Use string literals
- Use Navigator directly
- Ignore loading states
- Skip error handling
- Leave code uncommented

---

## 🚀 QUICK START NEW FEATURE

1. **Create model** (if needed)
   - File: `lib/data/models/my_model.dart`
   - Add `fromJson`, `toJson`

2. **Add mock data** (for testing)
   - File: `lib/data/mock_data/mock_my_data.dart`
   - Export helper methods

3. **Create provider**
   - File: `lib/core/providers/my_provider.dart`
   - Extend `ChangeNotifier`
   - Add business logic

4. **Register provider**
   - File: `lib/main.dart`
   - Add to `MultiProvider`

5. **Create screen**
   - File: `lib/presentation/my_feature/my_screen.dart`
   - Use provider
   - Keep UI clean

6. **Add routes** (if needed)
   - File: `lib/navigation/app_router.dart`
   - Add route name
   - Add navigation method

---

## 📚 DOCUMENTATION

- **Overview:** `README.md`
- **Detailed Guide:** `REFACTORING_GUIDE.md`
- **Summary:** `REFACTORING_SUMMARY.md`
- **Quick Reference:** This file
- **Backend API:** `backend/README.md`

---

**Happy Coding! 🎉**

*Last updated: January 11, 2026*
