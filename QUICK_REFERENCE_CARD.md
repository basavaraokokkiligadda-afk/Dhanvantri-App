# 🚀 QUICK REFERENCE - Production Architecture

## 📦 Import Statements

```dart
// Controllers
import 'package:dhanvantri_healthcare/features/appointments/controllers/appointment_controller.dart';
import 'package:dhanvantri_healthcare/features/doctors/controllers/doctors_controller.dart';
import 'package:dhanvantri_healthcare/features/pharmacy/controllers/pharmacy_controller.dart';
import 'package:dhanvantri_healthcare/features/payment/controllers/payment_controller.dart';
import 'package:dhanvantri_healthcare/core/controllers/booking_controller.dart';

// Widgets
import 'package:dhanvantri_healthcare/shared/widgets/base_screen.dart';
import 'package:dhanvantri_healthcare/shared/widgets/buttons.dart';
import 'package:dhanvantri_healthcare/shared/widgets/input_fields.dart';
import 'package:dhanvantri_healthcare/shared/widgets/state_widgets.dart';

// Navigation
import 'package:dhanvantri_healthcare/navigation/app_router.dart';

// Models
import 'package:dhanvantri_healthcare/data/models/doctor_model.dart';
import 'package:dhanvantri_healthcare/data/models/appointment_model.dart';
import 'package:dhanvantri_healthcare/data/models/medicine_model.dart';

// Provider
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
```

---

## 🎮 Controller Usage

### Access Controller
```dart
// Watch for changes (rebuilds on state change)
final controller = context.watch<AppointmentController>();

// Read once (no rebuild)
context.read<AppointmentController>().fetchAppointments();

// Select specific value (optimized)
final isLoading = context.select<AppointmentController, bool>(
  (controller) => controller.isLoading,
);
```

### Common Controller Methods
```dart
// Appointment Controller
controller.initializeBooking(doctor: doctor);
controller.setSelectedDate(DateTime.now());
controller.setSelectedTimeSlot('10:00 AM');
await controller.createAppointment();
await controller.cancelAppointment(id);

// Doctors Controller
await controller.fetchDoctors();
controller.searchDoctors('cardiologist');
controller.filterBySpecialty('Cardiology');
controller.selectDoctor(doctor);

// Pharmacy Controller
controller.addToCart(medicine, quantity: 2);
controller.removeFromCart(medicineId);
await controller.placeOrder();

// Payment Controller
controller.initializePayment(amount: 800, type: 'appointment');
controller.setPaymentMethod('upi');
await controller.processPayment(upiId: 'user@upi');

// Booking Controller
controller.initializeBooking(type: 'doctor', entity: doctor);
controller.setPatientName('John');
await controller.confirmBooking();
```

---

## 🎨 UI Components

### BaseScreen Template
```dart
BaseScreen(
  title: 'Screen Title',
  showAppBar: true,
  enableScroll: true,
  padding: EdgeInsets.all(4.w),
  body: Column(
    children: [
      // Your content
    ],
  ),
)
```

### Buttons
```dart
// Primary
PrimaryButton(
  text: 'Confirm',
  onPressed: () => controller.confirm(),
  isLoading: controller.isProcessing,
  icon: Icons.check,
)

// Secondary
SecondaryButton(
  text: 'Cancel',
  onPressed: () => Navigator.pop(context),
)
```

### Input Fields
```dart
// Text Field
CustomTextField(
  label: 'Name',
  hint: 'Enter name',
  controller: nameController,
  validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
  prefixIcon: Icon(Icons.person),
)

// Dropdown
CustomDropdown<String>(
  label: 'Gender',
  value: selectedGender,
  items: ['Male', 'Female'].map((g) {
    return DropdownMenuItem(value: g, child: Text(g));
  }).toList(),
  onChanged: (v) => controller.setGender(v),
)
```

### State Widgets
```dart
// Loading
if (controller.isLoading) 
  LoadingIndicator(message: 'Loading...')

// Error
if (controller.errorMessage != null)
  ErrorDisplay(
    message: controller.errorMessage!,
    onRetry: () => controller.fetchData(),
  )

// Empty
if (controller.data.isEmpty)
  EmptyState(
    message: 'No data',
    icon: Icons.inbox,
  )
```

---

## 🧭 Navigation

```dart
// Navigate to route
AppRouter.navigateTo(context, AppRouter.doctorProfile);

// With arguments
AppRouter.goToDoctorProfile(context, doctorData);

// Replace current
AppRouter.navigateAndReplace(context, AppRouter.userDashboard);

// Clear stack
AppRouter.navigateAndClearAll(context, AppRouter.login);

// Go back
AppRouter.goBack(context);

// Specific navigations
AppRouter.goToPayment(context, type: 'appointment', orderDetails: data);
AppRouter.goToAppointmentSummary(context, appointmentData);
AppRouter.goToPharmacyCheckout(context, cartItems);
```

---

## 📊 Common Patterns

### Screen Structure
```dart
class MyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = context.watch<MyController>();
    
    return BaseScreen(
      title: 'Title',
      enableScroll: true,
      body: _buildContent(controller),
    );
  }
  
  Widget _buildContent(MyController controller) {
    if (controller.isLoading) return LoadingIndicator();
    if (controller.errorMessage != null) return ErrorDisplay(...);
    if (controller.data.isEmpty) return EmptyState(...);
    
    return Column(
      children: [
        _buildHeader(controller),
        _buildList(controller),
        _buildActions(controller),
      ],
    );
  }
}
```

### Form Handling
```dart
class MyFormScreen extends StatefulWidget {
  @override
  _MyFormScreenState createState() => _MyFormScreenState();
}

class _MyFormScreenState extends State<MyFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  
  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final controller = context.watch<MyController>();
    
    return BaseScreen(
      title: 'Form',
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            CustomTextField(
              controller: _nameController,
              validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
            ),
            PrimaryButton(
              text: 'Submit',
              onPressed: () => _handleSubmit(controller),
              isLoading: controller.isProcessing,
            ),
          ],
        ),
      ),
    );
  }
  
  Future<void> _handleSubmit(MyController controller) async {
    if (_formKey.currentState!.validate()) {
      controller.setName(_nameController.text);
      final success = await controller.submit();
      if (success) {
        AppRouter.goBack(context);
      }
    }
  }
}
```

### List with Pull-to-Refresh
```dart
RefreshIndicator(
  onRefresh: () => controller.fetchData(),
  child: ListView.builder(
    itemCount: controller.items.length,
    itemBuilder: (context, index) {
      final item = controller.items[index];
      return ListTile(
        title: Text(item.name),
        onTap: () => _handleItemTap(item),
      );
    },
  ),
)
```

---

## ✅ Checklist for New Features

- [ ] Create controller in `features/[feature]/controllers/`
- [ ] Register controller in `main.dart` MultiProvider
- [ ] Create screen using `BaseScreen`
- [ ] Use `context.watch<>()` to access controller
- [ ] UI calls controller methods only
- [ ] Handle loading/error/empty states
- [ ] Use shared widgets (buttons, inputs)
- [ ] Add navigation via `AppRouter`
- [ ] No fixed heights in UI
- [ ] Enable scroll for long content
- [ ] Add null checks
- [ ] Test on different screen sizes

---

## 🎯 Quick Tips

- **Always use BaseScreen** - Prevents 90% of layout issues
- **Controllers for logic** - Keep UI pure
- **context.watch vs read** - watch = rebuild, read = no rebuild
- **Dispose controllers** - Don't forget TextEditingController.dispose()
- **Responsive sizing** - Use Sizer (2.w, 3.h, 10.sp)
- **Error handling** - Always handle controller.errorMessage
- **Loading states** - Show feedback during async operations
- **Navigation** - Use AppRouter methods, not Navigator.push directly

---

## 📝 File Naming Convention

- Controllers: `feature_controller.dart`
- Screens: `feature_screen.dart`
- Widgets: `feature_widget.dart`
- Models: `feature_model.dart`

---

**Print this and keep it handy! 📌**
