# 🏗️ PRODUCTION-GRADE ARCHITECTURE GUIDE

## 📋 Overview

This document outlines the **industry-standard architecture** implemented in Dhanvantri Healthcare app. The refactoring follows **clean architecture principles** with complete separation of concerns.

---

## 🎯 Architecture Principles

### 1. Separation of Concerns
- **UI Layer**: Only layout and visual presentation
- **Business Logic Layer**: Controllers handle all logic
- **Data Layer**: Models and data sources

### 2. Single Responsibility
- Each class has ONE clear purpose
- Controllers manage specific features
- Widgets focus on UI only

### 3. Dependency Injection
- Controllers provided via `ChangeNotifierProvider`
- UI consumes controllers via `Provider.of` or `context.watch`

---

## 📁 New Architecture Structure

```
lib/
├── core/
│   ├── theme/                 # Theme configuration
│   │   └── app_theme.dart
│   ├── routes/                # Legacy routes (to be migrated)
│   │   └── app_routes.dart
│   ├── controllers/           # Global controllers
│   │   └── booking_controller.dart
│   └── providers/             # Legacy (being phased out)
│       └── app_state_provider.dart
│
├── data/
│   ├── models/                # Data models
│   │   ├── doctor_model.dart
│   │   ├── appointment_model.dart
│   │   ├── medicine_model.dart
│   │   └── hospital_model.dart
│   └── mock_data/             # Centralized mock data
│       ├── mock_doctors.dart
│       ├── mock_hospitals.dart
│       └── mock_medicines.dart
│
├── features/                  # Feature-based architecture
│   ├── appointments/
│   │   ├── controllers/
│   │   │   └── appointment_controller.dart
│   │   ├── screens/
│   │   │   └── (appointment screens here)
│   │   └── widgets/
│   │       └── (appointment-specific widgets)
│   │
│   ├── doctors/
│   │   ├── controllers/
│   │   │   └── doctors_controller.dart
│   │   ├── screens/
│   │   └── widgets/
│   │
│   ├── pharmacy/
│   │   ├── controllers/
│   │   │   └── pharmacy_controller.dart
│   │   ├── screens/
│   │   └── widgets/
│   │
│   ├── payment/
│   │   ├── controllers/
│   │   │   └── payment_controller.dart
│   │   ├── screens/
│   │   └── widgets/
│   │
│   └── hospitals/
│       ├── controllers/
│       ├── screens/
│       └── widgets/
│
├── navigation/
│   └── app_router.dart        # Centralized navigation
│
├── shared/
│   └── widgets/               # Reusable UI components
│       ├── base_screen.dart   # Base screen template
│       ├── buttons.dart       # Button components
│       ├── input_fields.dart  # Form fields
│       └── state_widgets.dart # Loading, error, empty states
│
├── presentation/              # Legacy screens (to be migrated)
│   └── (existing screens)
│
└── main.dart                  # App entry point
```

---

## 🎮 Controllers (Business Logic)

### Purpose
Controllers handle ALL business logic, keeping UI clean.

### Key Controllers

#### 1. **AppointmentController**
Location: `lib/features/appointments/controllers/appointment_controller.dart`

**Responsibilities:**
- Manage appointment state
- Fetch appointments
- Create/cancel/reschedule appointments
- Handle booking flow state

**Key Methods:**
```dart
- initializeBooking({Doctor? doctor, Hospital? hospital})
- setSelectedDate(DateTime date)
- setSelectedTimeSlot(String timeSlot)
- createAppointment() → Future<bool>
- cancelAppointment(String id) → Future<bool>
- fetchAppointments() → Future<void>
```

#### 2. **DoctorsController**
Location: `lib/features/doctors/controllers/doctors_controller.dart`

**Responsibilities:**
- Manage doctors list
- Search and filter doctors
- Handle doctor selection

**Key Methods:**
```dart
- fetchDoctors() → Future<void>
- searchDoctors(String query)
- filterBySpecialty(String? specialty)
- selectDoctor(Doctor doctor)
```

#### 3. **PharmacyController**
Location: `lib/features/pharmacy/controllers/pharmacy_controller.dart`

**Responsibilities:**
- Manage medicines catalog
- Handle cart operations
- Process orders

**Key Methods:**
```dart
- fetchMedicines() → Future<void>
- searchMedicines(String query)
- addToCart(Medicine medicine, {int quantity})
- removeFromCart(String medicineId)
- placeOrder() → Future<bool>
```

#### 4. **PaymentController**
Location: `lib/features/payment/controllers/payment_controller.dart`

**Responsibilities:**
- Handle payment processing
- Validate payment details
- Manage payment methods

**Key Methods:**
```dart
- initializePayment({required double amount, required String type})
- setPaymentMethod(String method)
- processPayment({...}) → Future<bool>
```

#### 5. **BookingController**
Location: `lib/core/controllers/booking_controller.dart`

**Responsibilities:**
- Unified booking flow for doctors/hospitals
- Manage patient details
- Handle booking confirmation

**Key Methods:**
```dart
- initializeBooking({required String type, required dynamic entity})
- setPatientName(String name)
- setPatientAge(int? age)
- confirmBooking() → Future<Map<String, dynamic>?>
```

---

## 🎨 UI Best Practices

### 1. Use BaseScreen Widget
**NO MORE overflow issues!**

```dart
import 'package:dhanvantri_healthcare/shared/widgets/base_screen.dart';

class MyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: 'Screen Title',
      enableScroll: true,  // Automatically wraps in ScrollView
      padding: EdgeInsets.all(16),
      body: Column(
        children: [
          // Your content here
          // No need to worry about overflow!
        ],
      ),
    );
  }
}
```

### 2. Use Production-Grade Buttons

```dart
import 'package:dhanvantri_healthcare/shared/widgets/buttons.dart';

// Primary Button
PrimaryButton(
  text: 'Confirm',
  onPressed: () => controller.confirmBooking(),
  isLoading: controller.isProcessing,
  icon: Icons.check,
)

// Secondary Button
SecondaryButton(
  text: 'Cancel',
  onPressed: () => Navigator.pop(context),
)
```

### 3. Handle Loading/Error States

```dart
import 'package:dhanvantri_healthcare/shared/widgets/state_widgets.dart';

// Loading State
if (controller.isLoading) {
  return LoadingIndicator(message: 'Loading appointments...');
}

// Error State
if (controller.errorMessage != null) {
  return ErrorDisplay(
    message: controller.errorMessage!,
    onRetry: () => controller.fetchAppointments(),
  );
}

// Empty State
if (controller.appointments.isEmpty) {
  return EmptyState(
    message: 'No appointments found',
    icon: Icons.calendar_today,
  );
}
```

### 4. Use Custom Input Fields

```dart
import 'package:dhanvantri_healthcare/shared/widgets/input_fields.dart';

CustomTextField(
  label: 'Patient Name',
  hint: 'Enter patient name',
  controller: nameController,
  validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
  prefixIcon: Icon(Icons.person),
)

CustomDropdown<String>(
  label: 'Gender',
  value: selectedGender,
  items: ['Male', 'Female', 'Other'].map((gender) {
    return DropdownMenuItem(value: gender, child: Text(gender));
  }).toList(),
  onChanged: (value) => controller.setPatientGender(value),
)
```

---

## 🔄 Migration Guide

### Migrating a Screen to New Architecture

#### BEFORE (Anti-Pattern ❌)
```dart
class OldBookingScreen extends StatefulWidget {
  @override
  _OldBookingScreenState createState() => _OldBookingScreenState();
}

class _OldBookingScreenState extends State<OldBookingScreen> {
  DateTime? selectedDate;
  String? selectedTime;
  bool isLoading = false;
  
  // Business logic in UI ❌
  Future<void> confirmBooking() async {
    setState(() => isLoading = true);
    // API call logic here...
    // Payment logic here...
    setState(() => isLoading = false);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(  // ❌ No scroll, will overflow!
        children: [
          // Fixed heights ❌
          Container(height: 200, child: ...),
          // Nested columns without scrolling ❌
        ],
      ),
    );
  }
}
```

#### AFTER (Production-Grade ✅)
```dart
import 'package:provider/provider.dart';
import 'package:dhanvantri_healthcare/core/controllers/booking_controller.dart';
import 'package:dhanvantri_healthcare/shared/widgets/base_screen.dart';
import 'package:dhanvantri_healthcare/shared/widgets/buttons.dart';

class NewBookingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = context.watch<BookingController>();
    
    return BaseScreen(  // ✅ Handles SafeArea, Scaffold, Scroll
      title: 'Book Appointment',
      enableScroll: true,
      body: Column(
        children: [
          // No fixed heights ✅
          _buildDateSelector(controller),
          _buildTimeSelector(controller),
          _buildPatientForm(controller),
          
          SizedBox(height: 20),
          
          // UI only calls controller methods ✅
          PrimaryButton(
            text: 'Confirm Booking',
            onPressed: () => _handleConfirm(context, controller),
            isLoading: controller.isProcessing,
          ),
        ],
      ),
    );
  }
  
  // UI logic only ✅
  Future<void> _handleConfirm(BuildContext context, BookingController controller) async {
    final result = await controller.confirmBooking();
    if (result != null) {
      // Navigate to summary
      AppRouter.goToAppointmentSummary(context, result);
    }
  }
}
```

---

## 📊 Data Models

### Production-Grade Model Structure

All models now include:
- ✅ `fromJson()` factory
- ✅ `toJson()` method
- ✅ `copyWith()` method
- ✅ Null safety
- ✅ Helper getters

**Example:**
```dart
class Doctor {
  final String id;
  final String name;
  final String specialization;
  final double rating;
  final double fee;
  final bool isAvailable;
  
  Doctor({required this.id, ...});
  
  factory Doctor.fromJson(Map<String, dynamic> json) {...}
  Map<String, dynamic> toJson() {...}
  Doctor copyWith({...}) {...}
}
```

---

## 🧭 Navigation

### Use Centralized AppRouter

```dart
import 'package:dhanvantri_healthcare/navigation/app_router.dart';

// Navigate to doctor profile
AppRouter.goToDoctorProfile(context, doctorData);

// Navigate to payment
AppRouter.goToPayment(
  context,
  type: 'appointment',
  orderDetails: appointmentData,
);

// Go back
AppRouter.goBack(context);

// Logout
AppRouter.logout(context);
```

---

## ✅ Checklist for New Screens

When creating a new screen:

- [ ] Use `BaseScreen` widget
- [ ] NO fixed heights
- [ ] Enable scrolling for long content
- [ ] Use `context.watch<Controller>()` to access state
- [ ] UI only calls controller methods
- [ ] NO business logic in UI
- [ ] Use shared widgets (buttons, inputs)
- [ ] Handle loading/error/empty states
- [ ] Use `AppRouter` for navigation
- [ ] Add proper null checks

---

## 🚀 Next Steps

### For Developers:

1. **Study the controllers** - Understand separation of logic
2. **Use BaseScreen** - Eliminates 90% of UI issues
3. **Migrate screens gradually** - One feature at a time
4. **Test thoroughly** - Verify no regressions
5. **Remove old providers** - Once migration complete

### Migration Priority:

1. ✅ **Completed**: Controllers created
2. 🔄 **Next**: Migrate appointment screens
3. 🔄 **Then**: Migrate pharmacy screens
4. 🔄 **Then**: Migrate doctor/hospital screens
5. 🔄 **Finally**: Clean up old providers

---

## 📞 Support

For questions about the architecture:
- Review controller documentation
- Check example implementations
- Follow the patterns established

---

**Built with 💪 for Production Excellence**
