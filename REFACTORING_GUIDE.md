# 🔧 REFACTORING GUIDE - Dhanvantri Healthcare

> **Complete guide for the refactoring performed on January 11, 2026**

---

## 📋 TABLE OF CONTENTS

1. [Overview](#overview)
2. [What Was Changed](#what-was-changed)
3. [New File Structure](#new-file-structure)
4. [Migration Guide](#migration-guide)
5. [Breaking Changes](#breaking-changes)
6. [Next Steps](#next-steps)

---

## 🎯 OVERVIEW

### Goals Achieved

✅ **Clean Architecture** - Feature-based structure with clear separation  
✅ **Scalable** - Easy to add new features without touching existing code  
✅ **Mobile-First** - Optimized for mobile development  
✅ **Production-Ready** - Following Flutter best practices  
✅ **Maintainable** - Clear code organization and documentation  

### Key Principles Applied

- **Separation of Concerns** - UI, Logic, and Data are separate
- **Single Responsibility** - Each file has one clear purpose
- **DRY** - No code duplication, reusable components
- **Type Safety** - Strong typing with data models
- **Centralization** - Constants, routes, and data in one place

---

## 🔄 WHAT WAS CHANGED

### 1. Project Cleanup

#### .gitignore Updated
```diff
+ # Chrome/Browser Runtime (Development)
+ **/chrome/
+ **/browser/
+ **/.chrome/
+
+ # Local cache and logs
+ *.cache
+ *.tmp
+ coverage/
+ test/.test_coverage.dart
```

**Why:** Prevent unnecessary files from being committed to version control.

---

### 2. New Directory Structure

#### Created Directories
```
lib/core/constants/      ← App-wide constants
lib/core/theme/          ← Theme configuration
lib/core/utils/          ← Utility functions
lib/data/models/         ← Data models
lib/data/mock_data/      ← Centralized mock data
lib/navigation/          ← Routing logic
lib/shared/              ← Shared widgets
```

**Why:** Clear organization makes it easy to find and maintain code.

---

### 3. Constants & Configuration

#### New Files Created

**lib/core/constants/app_constants.dart**
- App name, version
- User types
- Appointment statuses
- Payment types
- Time slots
- Specialties
- Medicine categories

**lib/core/constants/api_endpoints.dart**
- All API URLs in one place
- Easy to update backend URL
- Type-safe endpoint access

**Why:** Change once, update everywhere. No more searching for hard-coded values.

---

### 4. Utility Functions

#### New Files Created

**lib/core/utils/validators.dart**
- Email validation
- Password validation
- Name validation
- Phone validation
- Required field validation

**lib/core/utils/date_utils.dart**
- Format dates
- Format times
- Time ago calculations
- Date comparisons

**Why:** Reusable functions reduce code duplication and ensure consistency.

---

### 5. Data Models

#### Models Created

**lib/data/models/doctor_model.dart**
```dart
class Doctor {
  final String id;
  final String name;
  final String specialty;
  final double rating;
  // ... + JSON serialization
}
```

**lib/data/models/hospital_model.dart**
**lib/data/models/appointment_model.dart**
**lib/data/models/medicine_model.dart**

**Features:**
- Type safety
- Null safety
- JSON serialization (`fromJson`, `toJson`)
- Helper methods
- `copyWith` for appointments

**Why:** Type-safe data prevents runtime errors and provides IDE autocomplete.

---

### 6. Mock Data Centralization

#### Mock Data Files

**lib/data/mock_data/mock_doctors.dart**
- 6 sample doctors with complete data
- Helper methods: `getDoctorById`, `getDoctorsBySpecialty`, `getAvailableDoctors`

**lib/data/mock_data/mock_hospitals.dart**
- 5 sample hospitals
- Helper methods: `getHospitalById`, `getEmergencyHospitals`

**lib/data/mock_data/mock_medicines.dart**
- 6 sample medicines
- Helper methods: `getMedicineById`, `getMedicinesByCategory`, `searchMedicines`

**Why:** 
- Easy to replace with API calls later
- No hard-coded data in UI files
- Consistent test data across app

---

### 7. State Management - Providers

#### Providers Created

**lib/core/providers/doctors_provider.dart**
```dart
class DoctorsProvider extends ChangeNotifier {
  List<Doctor> _doctors = [];
  String _selectedSpecialty = 'All';
  
  void loadDoctors() { }
  void filterBySpecialty(String specialty) { }
  void searchDoctors(String query) { }
}
```

**Features:**
- Load doctors from mock data
- Filter by specialty
- Search functionality
- Loading states
- Error handling

**lib/core/providers/appointments_provider.dart**
- Create appointments
- Get by status (pending, confirmed, completed)
- Get upcoming/past appointments
- Cancel appointments
- Update status

**lib/core/providers/pharmacy_provider.dart**
- Load medicines
- Filter by category
- Search medicines
- Cart management (add, remove, update quantity)
- Calculate totals

**lib/core/providers/booking_provider.dart**
- Unified booking for all services
- Date/time selection
- Payment type selection
- Calculate fees
- Process booking

**Why:** 
- Separates business logic from UI
- Reusable across multiple screens
- Testable
- Reactive updates

---

### 8. Navigation Centralization

#### New Router

**lib/navigation/app_router.dart**

**Features:**
- All route names in one place
- Navigation helper methods
- Feature-specific navigation
- Type-safe routing

**Example Usage:**
```dart
// Before
Navigator.pushNamed(context, '/doctor-profile', arguments: doctor);

// After
AppRouter.navigateToDoctorProfile(context, doctor);
```

**Why:**
- Cleaner code
- Type safety
- Easy refactoring
- No typos in route names

---

### 9. Main App Update

#### lib/main.dart Changes

**Before:**
```dart
providers: [
  ChangeNotifierProvider(create: (_) => AppStateProvider()),
],
```

**After:**
```dart
providers: [
  ChangeNotifierProvider(create: (_) => AppStateProvider()),
  ChangeNotifierProvider(create: (_) => DoctorsProvider()),
  ChangeNotifierProvider(create: (_) => AppointmentsProvider()),
  ChangeNotifierProvider(create: (_) => PharmacyProvider()),
  ChangeNotifierProvider(create: (_) => BookingProvider()),
],
```

**Why:** All providers registered and available app-wide.

---

### 10. Theme Organization

#### Moved Theme File

**From:** `lib/core/app_theme.dart`  
**To:** `lib/core/theme/app_theme.dart`

**Why:** Better organization, follows convention.

---

## 📁 NEW FILE STRUCTURE

### Complete Structure
```
lib/
├── core/
│   ├── constants/
│   │   ├── app_constants.dart         ← NEW
│   │   └── api_endpoints.dart         ← NEW
│   │
│   ├── theme/
│   │   └── app_theme.dart             ← MOVED
│   │
│   ├── utils/
│   │   ├── validators.dart            ← NEW
│   │   └── date_utils.dart            ← NEW
│   │
│   ├── providers/
│   │   ├── app_state_provider.dart    ← EXISTING
│   │   ├── doctors_provider.dart      ← NEW (replaced old)
│   │   ├── appointments_provider.dart ← NEW (replaced old)
│   │   ├── pharmacy_provider.dart     ← NEW (replaced old)
│   │   └── booking_provider.dart      ← NEW (replaced old)
│   │
│   └── routes/
│       └── app_routes.dart            ← EXISTING
│
├── data/
│   ├── models/                        ← NEW
│   │   ├── doctor_model.dart
│   │   ├── hospital_model.dart
│   │   ├── appointment_model.dart
│   │   └── medicine_model.dart
│   │
│   └── mock_data/                     ← NEW
│       ├── mock_doctors.dart
│       ├── mock_hospitals.dart
│       └── mock_medicines.dart
│
├── navigation/
│   └── app_router.dart                ← NEW
│
├── presentation/                      ← EXISTING (not changed yet)
│   ├── splash/
│   ├── auth/
│   ├── dashboard/
│   └── ...
│
├── shared/
│   └── widgets.dart                   ← NEW
│
└── main.dart                          ← UPDATED
```

---

## 🔄 MIGRATION GUIDE

### For Screen Developers

#### Step 1: Import Provider

**Old Way:**
```dart
// Hard-coded data in screen
final doctors = [
  {'name': 'Dr. Smith', ...},
  {'name': 'Dr. Jones', ...},
];
```

**New Way:**
```dart
import 'package:provider/provider.dart';
import '../../core/providers/doctors_provider.dart';

final doctorsProvider = Provider.of<DoctorsProvider>(context);
final doctors = doctorsProvider.doctors;
```

#### Step 2: Use Models

**Old Way:**
```dart
Text('${doctor['name']}')
```

**New Way:**
```dart
Text(doctor.name)  // Type-safe!
```

#### Step 3: Use Navigation Helpers

**Old Way:**
```dart
Navigator.pushNamed(
  context, 
  '/doctor-profile',
  arguments: doctorData,
);
```

**New Way:**
```dart
import '../../navigation/app_router.dart';

AppRouter.navigateToDoctorProfile(context, doctorData);
```

#### Step 4: Use Constants

**Old Way:**
```dart
if (status == 'confirmed') { ... }
```

**New Way:**
```dart
import '../../core/constants/app_constants.dart';

if (status == AppConstants.statusConfirmed) { ... }
```

#### Step 5: Use Validators

**Old Way:**
```dart
validator: (value) {
  if (value == null || value.isEmpty) return 'Email required';
  if (!value.contains('@')) return 'Invalid email';
  return null;
}
```

**New Way:**
```dart
import '../../core/utils/validators.dart';

validator: Validators.validateEmail,
```

---

## ⚠️ BREAKING CHANGES

### None Yet!

The refactoring created **new** files without breaking existing code.

**Existing screens still work** because:
- Old routes are still in `app_routes.dart`
- Providers were added, not replaced (except for enhanced ones)
- No files were deleted from `presentation/`

### Future Breaking Changes

When screens are refactored:
- Hard-coded data will be removed
- Direct Navigator calls will be replaced
- Provider imports will be required

---

## 🚀 NEXT STEPS

### Immediate (Can Do Now)

1. **Test the app** - Run `flutter run` and verify everything works
2. **Read the new code** - Familiarize yourself with the structure
3. **Start using providers** - In new screens or when editing existing ones

### Phase 2: Screen Refactoring (Recommended)

Each screen should be refactored to:

1. **Remove hard-coded data**
   - Use providers instead
   - Import from mock_data if needed

2. **Use data models**
   - Convert `Map<String, dynamic>` to proper models
   - Get type safety and autocomplete

3. **Use navigation helpers**
   - Replace `Navigator.pushNamed` with `AppRouter.navigateTo`

4. **Use constants**
   - Replace string literals with `AppConstants`

5. **Use validators**
   - Replace custom validation with `Validators`

### Phase 3: UI Fixes

1. **Add scrolling** - Wrap pages in `SingleChildScrollView`
2. **Fix overflow** - Use `Expanded`, `Flexible`, `LayoutBuilder`
3. **Test on small screens** - Ensure no content is cut off
4. **Remove fixed heights** - Use responsive layouts

### Phase 4: Booking Flow Unification

1. **Implement unified booking screen** - One screen for all booking types
2. **Standardize summary** - Consistent appointment summary
3. **Integrate payment** - Connect booking to payment flow

### Phase 5: API Integration

1. **Create API service** - Replace mock data with real API calls
2. **Add error handling** - Show errors to users gracefully
3. **Add loading states** - Show spinners during API calls
4. **Implement offline mode** - Cache data locally

---

## 📚 REFERENCE

### File Import Patterns

#### From Screens to Providers
```dart
import '../../core/providers/doctors_provider.dart';
import '../../core/providers/appointments_provider.dart';
import '../../core/providers/pharmacy_provider.dart';
import '../../core/providers/booking_provider.dart';
```

#### From Screens to Constants
```dart
import '../../core/constants/app_constants.dart';
import '../../core/constants/api_endpoints.dart';
```

#### From Screens to Utils
```dart
import '../../core/utils/validators.dart';
import '../../core/utils/date_utils.dart';
```

#### From Screens to Models
```dart
import '../../data/models/doctor_model.dart';
import '../../data/models/hospital_model.dart';
import '../../data/models/appointment_model.dart';
import '../../data/models/medicine_model.dart';
```

#### From Screens to Navigation
```dart
import '../../navigation/app_router.dart';
```

---

## 🎯 BEST PRACTICES

### DO ✅

- Use providers for all business logic
- Use models for type safety
- Use constants for string literals
- Use validators for form validation
- Use AppRouter for navigation
- Keep screens as simple presentational components
- Add loading and error states
- Write comments for complex logic

### DON'T ❌

- Put business logic in UI files
- Hard-code data in screens
- Use string literals for constants
- Write custom validators when reusable ones exist
- Use Navigator directly (use AppRouter instead)
- Mix data fetching with UI rendering
- Ignore loading and error states
- Leave code uncommented

---

## 🤝 CONTRIBUTING

When adding new features:

1. **Create provider** in `lib/core/providers/`
2. **Create model** in `lib/data/models/` (if needed)
3. **Add mock data** in `lib/data/mock_data/` (for testing)
4. **Register provider** in `lib/main.dart`
5. **Add routes** to `AppRouter` (if needed)
6. **Keep UI clean** - no business logic in screens!

---

## 📝 SUMMARY

### What You Get

✅ **Cleaner Code** - Easy to read and maintain  
✅ **Type Safety** - Fewer runtime errors  
✅ **Reusability** - DRY code across the app  
✅ **Testability** - Easy to write unit tests  
✅ **Scalability** - Add features without breaking existing code  
✅ **Team-Friendly** - Clear structure for multiple developers  

### Time Investment

- **Initial Setup:** Complete ✅
- **Learning Curve:** 1-2 hours
- **Refactoring Existing Screens:** 30min - 1hr per screen
- **Long-term Benefit:** Massive time savings

---

**Questions?** Refer to the code examples in this guide or check the source files.

**Need Help?** Review the inline comments in the new files - they're comprehensive!

---

*Last updated: January 11, 2026*
