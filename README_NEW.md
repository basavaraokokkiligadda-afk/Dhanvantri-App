# 🏥 Dhanvantri Healthcare - Production-Grade Flutter App

![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue.svg)
![Architecture](https://img.shields.io/badge/Architecture-Clean-green.svg)
![State Management](https://img.shields.io/badge/State-Provider-orange.svg)
![License](https://img.shields.io/badge/License-ISC-yellow.svg)

**Enterprise-grade healthcare mobile application with Flutter frontend and Node.js backend.**

---

## 🌟 What's New - Production Refactoring Complete

This app has been completely refactored to **industry-standard, production-grade architecture**:

✅ **Clean Architecture** - Separation of UI, logic, and data  
✅ **Feature-Based Structure** - Organized by features, not file types  
✅ **Production Controllers** - All business logic centralized  
✅ **No UI Anti-Patterns** - Zero overflow issues, responsive design  
✅ **Reusable Components** - Shared widgets for consistency  
✅ **State Management** - ChangeNotifier with Provider  
✅ **Type-Safe Models** - Complete with fromJson, toJson, copyWith  

---

## 📁 Project Structure

```
lib/
├── core/                          # Core functionality
│   ├── theme/app_theme.dart      # Material Design 3 theme
│   ├── controllers/              # Global controllers
│   │   └── booking_controller.dart
│   └── providers/                # Legacy (being phased out)
│
├── data/                          # Data layer
│   ├── models/                   # Data models
│   │   ├── doctor_model.dart
│   │   ├── appointment_model.dart
│   │   ├── medicine_model.dart
│   │   └── hospital_model.dart
│   └── mock_data/                # Centralized mock data
│
├── features/                      # Feature modules
│   ├── appointments/
│   │   ├── controllers/          # Appointment business logic
│   │   ├── screens/              # Appointment UI
│   │   └── widgets/              # Appointment-specific widgets
│   ├── doctors/
│   │   ├── controllers/
│   │   ├── screens/
│   │   └── widgets/
│   ├── pharmacy/
│   │   ├── controllers/
│   │   ├── screens/
│   │   └── widgets/
│   ├── payment/
│   │   ├── controllers/
│   │   ├── screens/
│   │   └── widgets/
│   └── hospitals/
│
├── shared/                        # Shared UI components
│   └── widgets/
│       ├── base_screen.dart      # Base screen template
│       ├── buttons.dart          # Button components
│       ├── input_fields.dart     # Form inputs
│       └── state_widgets.dart    # Loading/error/empty states
│
├── navigation/
│   └── app_router.dart           # Centralized navigation
│
├── presentation/                  # Legacy screens (migrating)
└── main.dart                      # App entry point
```

---

## 🚀 Quick Start

### Prerequisites
- **Flutter SDK** 3.0+
- **Node.js** 16+
- **Dart SDK** 3.0+

### 1. Install Dependencies

```bash
# Flutter dependencies
flutter pub get

# Backend dependencies
cd backend && npm install
```

### 2. Start Backend Server

```bash
cd backend
npm start
# Server runs on http://localhost:3000
```

### 3. Run Flutter App

```bash
flutter run
```

---

## 🎮 Production Controllers

### AppointmentController
**Location**: `lib/features/appointments/controllers/appointment_controller.dart`

Manages all appointment operations:
```dart
final controller = context.watch<AppointmentController>();

// Initialize booking
controller.initializeBooking(doctor: selectedDoctor);

// Set details
controller.setSelectedDate(DateTime.now());
controller.setSelectedTimeSlot('10:00 AM');

// Create appointment
await controller.createAppointment();
```

### DoctorsController
**Location**: `lib/features/doctors/controllers/doctors_controller.dart`

Handles doctor search and filtering:
```dart
final controller = context.watch<DoctorsController>();

// Fetch doctors
await controller.fetchDoctors();

// Search
controller.searchDoctors('cardiologist');

// Filter
controller.filterBySpecialty('Cardiology');
```

### PharmacyController
**Location**: `lib/features/pharmacy/controllers/pharmacy_controller.dart`

Manages pharmacy and cart:
```dart
final controller = context.watch<PharmacyController>();

// Add to cart
controller.addToCart(medicine, quantity: 2);

// Place order
await controller.placeOrder();
```

### PaymentController
**Location**: `lib/features/payment/controllers/payment_controller.dart`

Handles payments:
```dart
final controller = context.watch<PaymentController>();

// Initialize
controller.initializePayment(amount: 800.0, type: 'appointment');

// Process
await controller.processPayment(upiId: 'user@upi');
```

### BookingController
**Location**: `lib/core/controllers/booking_controller.dart`

Unified booking flow:
```dart
final controller = context.watch<BookingController>();

// Initialize
controller.initializeBooking(type: 'doctor', entity: doctor);

// Set patient details
controller.setPatientName('John Doe');
controller.setPatientAge(30);

// Confirm
final result = await controller.confirmBooking();
```

---

## 🎨 UI Components

### BaseScreen - Eliminates Overflow Issues

```dart
import 'package:dhanvantri_healthcare/shared/widgets/base_screen.dart';

BaseScreen(
  title: 'My Screen',
  enableScroll: true,  // Auto handles scrolling
  padding: EdgeInsets.all(16),
  body: Column(
    children: [
      // No overflow worries!
    ],
  ),
)
```

### Production Buttons

```dart
import 'package:dhanvantri_healthcare/shared/widgets/buttons.dart';

// Primary button with loading
PrimaryButton(
  text: 'Confirm',
  onPressed: () => controller.confirm(),
  isLoading: controller.isProcessing,
  icon: Icons.check,
)

// Secondary button
SecondaryButton(
  text: 'Cancel',
  onPressed: () => Navigator.pop(context),
)
```

### State Management Widgets

```dart
import 'package:dhanvantri_healthcare/shared/widgets/state_widgets.dart';

// Loading
LoadingIndicator(message: 'Loading...')

// Error
ErrorDisplay(
  message: controller.errorMessage!,
  onRetry: () => controller.fetchData(),
)

// Empty
EmptyState(
  message: 'No data available',
  icon: Icons.inbox,
)
```

---

## 📱 Features

### ✅ Completed
- User Authentication (Login/Register)
- Doctor Directory with Search/Filter
- Hospital Listings
- Appointment Booking
- Pharmacy with Cart
- Payment Processing
- AI Health Assistant
- Social Feed & Stories
- Messaging (ChitChat)
- Production Controllers
- Reusable UI Components

### 🔄 Migration In Progress
- Migrating old screens to new architecture
- Removing legacy providers
- Adding comprehensive tests

---

## 🧭 Navigation

Use centralized AppRouter:

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
```

---

## 🔑 Test Credentials

**Patient Account**
- Email: `patient@test.com`
- Password: `password123`

**Hospital Account**
- Email: `hospital@test.com`
- Password: `password123`

---

## 📚 Documentation

### Essential Reading
1. **[PRODUCTION_ARCHITECTURE_GUIDE.md](./PRODUCTION_ARCHITECTURE_GUIDE.md)** - Complete architecture guide
2. **[REFACTORING_COMPLETE_SUMMARY.md](./REFACTORING_COMPLETE_SUMMARY.md)** - Refactoring summary
3. **[FLUTTER_README.md](./FLUTTER_README.md)** - API documentation

### Example Code
- **[Refactored Doctors Screen](./lib/features/doctors/screens/refactored_doctors_screen.dart)** - Production-grade example

---

## 🛠️ Development Workflow

### Creating a New Screen

1. **Create controller** (if needed):
```dart
// lib/features/my_feature/controllers/my_controller.dart
class MyController extends ChangeNotifier {
  // State and logic here
}
```

2. **Create screen using BaseScreen**:
```dart
// lib/features/my_feature/screens/my_screen.dart
class MyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = context.watch<MyController>();
    
    return BaseScreen(
      title: 'My Screen',
      enableScroll: true,
      body: Column(
        children: [
          // UI only - no business logic!
        ],
      ),
    );
  }
}
```

3. **Register controller in main.dart**:
```dart
ChangeNotifierProvider(create: (_) => MyController()),
```

---

## 🧪 Testing

```bash
# Run tests
flutter test

# Analyze code
flutter analyze

# Format code
flutter format lib/
```

---

## 🚀 Deployment

```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release
```

---

## 📊 API Endpoints

**Base URL**: `http://localhost:3000/api`

### Authentication
- `POST /auth/login` - User login
- `POST /auth/register` - User registration

### Doctors
- `GET /doctors` - List all doctors
- `GET /doctors/:id` - Get doctor details
- `GET /doctors/specialties/list` - Get specialties

### Appointments
- `GET /appointments` - List appointments
- `POST /appointments` - Create appointment
- `PATCH /appointments/:id` - Update appointment
- `DELETE /appointments/:id` - Cancel appointment

### Pharmacy
- `GET /pharmacy/medicines` - List medicines
- `GET /pharmacy/medicines/:id` - Get medicine details

### Hospitals
- `GET /hospitals` - List hospitals
- `GET /hospitals/:id` - Get hospital details

---

## 🎯 Best Practices

### DO ✅
- Use `BaseScreen` for all new screens
- Put business logic in controllers
- Use shared widgets for consistency
- Handle loading/error/empty states
- Use `AppRouter` for navigation
- Follow feature-based architecture

### DON'T ❌
- Mix business logic with UI
- Use fixed heights
- Create nested scrolls without physics
- Hardcode mock data in UI
- Use excessive `setState()`
- Create duplicate widgets

---

## 🤝 Contributing

1. Study the architecture guide
2. Follow existing patterns
3. Create feature branches
4. Write tests
5. Submit pull request

---

## 📞 Support

For architecture questions, see:
- `PRODUCTION_ARCHITECTURE_GUIDE.md`
- Example refactored screen
- Controller documentation

---

## 📝 License

ISC License

---

## 🎉 Status

**PRODUCTION-READY ARCHITECTURE** ✅

The app is now built with:
- Clean architecture principles
- Separation of concerns
- Reusable components
- Type-safe state management
- Industry best practices

**Ready for long-term development and scaling!**

---

**Built with 💪 for Healthcare Excellence**
