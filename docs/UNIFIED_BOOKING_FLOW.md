# 🏥 Complete Unified Appointment Booking Flow

## ✅ Implementation Status: COMPLETE

This document describes the **UNIFIED** appointment booking flow that works identically for both **Doctors** and **Hospitals**.

---

## 📱 User Journey

### 1️⃣ ENTRY POINTS (Shared)

**Two ways to start booking:**

#### Option A: Find Doctor → Book Appointment
- Navigate to [find_doctors_screen.dart](lib/presentation/doctors/find_doctors_screen.dart)
- Select a doctor from list
- Opens [doctor_profile_screen.dart](lib/presentation/doctors/doctor_profile_screen.dart)
- Click **"Book Appointment"** button

#### Option B: Find Hospital → Book Appointment  
- Navigate to [find_hospitals_screen.dart](lib/presentation/hospital/find_hospitals_screen.dart)
- Select a hospital from list
- Opens [hospital_profile_screen.dart](lib/presentation/hospital/hospital_profile_screen.dart)
- Click **"Book Appointment"** button

**Both navigate to the same screen:** [unified_booking_screen.dart](lib/presentation/booking/unified_booking_screen.dart)

---

### 2️⃣ BOOKING DETAILS FORM
**Screen:** [unified_booking_screen.dart](lib/presentation/booking/unified_booking_screen.dart)

**Doctor Booking Shows:**
- Doctor name (auto-filled)
- Specialization (auto-filled)
- Hospital (auto-filled)
- Select Date (date picker)
- Select Time Slot (morning/afternoon/evening)
- Patient Name (text field)
- Age (text field)
- Gender (dropdown: Male/Female/Other)
- Phone Number (10 digits with +91 prefix)

**Hospital Booking Shows:**
- Hospital name (auto-filled)
- Hospital type (auto-filled)
- Select Department (dropdown: Cardiology, Neurology, etc.)
- Select Doctor (dropdown: dynamically filtered by department)
- Select Date (date picker)
- Select Time Slot (morning/afternoon/evening)
- Patient Name (text field)
- Age (text field)
- Gender (dropdown: Male/Female/Other)
- Phone Number (10 digits with +91 prefix)

**Validation:**
- All fields are required
- Age must be numeric
- Phone must be exactly 10 digits
- Date must be future date (up to 90 days)

**Action Button:** Floating "Confirm Booking" button appears when all fields are valid

---

### 3️⃣ BOOKING CONFIRMATION
**Action:** User clicks "Confirm Booking"

**Navigation:** → [appointment_summary_screen.dart](lib/presentation/appointment/appointment_summary_screen.dart)

---

### 4️⃣ BOOKING SUMMARY PAGE
**Screen:** [appointment_summary_screen.dart](lib/presentation/appointment/appointment_summary_screen.dart)

**Displays:**

#### Header
- ✅ Green confirmation badge
- Booking ID (auto-generated: APT + timestamp)

#### Appointment Details Card
- Doctor/Hospital avatar
- Doctor/Hospital name
- Specialization/Department
- Patient name, age, gender, phone
- If hospital: Shows selected department and doctor
- Selected date (formatted: dd MMM yyyy)
- Selected time slot

#### Coupon Section
- **Apply Coupon** text field
- **Apply** button
- **Valid coupons** (mock):
  - `HEALTH10` → 10% discount
  - `FIRST20` → 20% discount
  - `SAVE50` → ₹50 flat discount
- When applied: Shows green success badge with discount amount
- **Remove** button to clear coupon

#### Payment Options (Radio Buttons)

**Option 1: Pay Token Amount**
- Amount: **₹100** (fixed)
- Description: "Pay ₹100 now, rest at clinic"
- Shows remaining amount to pay at clinic
- **Selected by default**

**Option 2: Pay Full Amount**
- Amount: **Full consultation fee minus discount**
- Description: "Complete payment now"
- Shows original fee (strikethrough if discount applied)
- Shows final amount after discount
- Badge: "SAVE" if discount applied

#### Payment Summary Card
- Consultation Fee: ₹XXX
- Discount: - ₹XX (if coupon applied, shown in green)
- **Amount to Pay:** ₹XXX (bold, primary color)
- If token: Shows "Remaining: ₹XX (Pay at clinic)"

**Action Button:** "Proceed to Payment - ₹XXX"

---

### 5️⃣ PAYMENT PAGE
**Screen:** [payment_screen.dart](lib/presentation/payment/payment_screen.dart)

**Displays:**
- Amount to pay (large, centered)
- Description: "Token payment for Dr. XXX" or "Full payment for Dr. XXX"

**Payment Methods** (Radio selection):
1. **UPI** - Google Pay, PhonePe, Paytm
2. **Credit/Debit Card** - Visa, Mastercard, RuPay
3. **Net Banking** - All major banks
4. **Wallet** - Paytm, PhonePe, Amazon Pay

**Action Button:** "Pay ₹XXX"

**On Click:**
1. Validates payment method selected
2. Shows 2-second processing animation
3. Opens success dialog

**Success Dialog Shows:**
- ✅ Green checkmark icon
- "Payment Successful!"
- "Your appointment has been confirmed"
- **Booking ID:** APT123456789
- **Transaction ID:** TXN987654321
- Two buttons:
  - "Go to Dashboard" (outlined)
  - "View My Appointments" (filled, primary)

---

### 6️⃣ APPOINTMENTS HISTORY PAGE
**Screen:** [appointments_history_screen.dart](lib/presentation/appointment/appointments_history_screen.dart)

**After clicking "View My Appointments":**
1. Closes payment dialog
2. Navigates back to dashboard
3. Auto-opens appointments history screen (after 300ms delay)

**Displays:**
- **3 Tabs:**
  1. **Upcoming** - Current/future appointments
  2. **Previous** - Completed appointments
  3. **Reminders** - Pill reminders

**Each Appointment Card Shows:**
- Doctor/Hospital name
- Date & time
- Status badge (Upcoming/Completed)
- Payment type (Token/Full)
- Action buttons: View Details, Book Ambulance

---

## 🎯 Key Features

### ✅ Unified Implementation
- **Single booking screen** for both doctors and hospitals
- **Same summary page** with dynamic content
- **Same payment flow** for both types
- No duplicate code or screens

### ✅ Mobile-First UI
- No global bottom navigation in booking flow
- Clean navigation using Navigator.push/pop
- Back button returns to previous screen
- Close button (X) exits entire flow

### ✅ Mock/Dummy Data
- No backend or API calls
- Hardcoded departments and doctors
- Mock coupon validation
- Simulated payment processing
- Generated IDs using timestamps

### ✅ Smart Features
- **Department selection** (hospitals only)
- **Dynamic doctor filtering** by department
- **Coupon system** with multiple codes
- **Token vs Full payment** options
- **Discount calculation** and display
- **Payment type tracking** (shown in appointments)
- **Auto-navigation** to appointments after payment

---

## 🗂️ File Structure

```
lib/presentation/
├── doctors/
│   ├── find_doctors_screen.dart       # Entry point
│   └── doctor_profile_screen.dart     # Entry point
├── hospital/
│   ├── find_hospitals_screen.dart     # Entry point
│   └── hospital_profile_screen.dart   # Entry point
├── booking/
│   └── unified_booking_screen.dart    # Step 1: Form
├── appointment/
│   ├── appointment_summary_screen.dart # Step 2: Summary
│   └── appointments_history_screen.dart # Step 4: View bookings
└── payment/
    └── payment_screen.dart            # Step 3: Payment
```

---

## 🔄 Navigation Flow

```
Doctor Profile / Hospital Profile
         ↓
  Book Appointment (Button)
         ↓
unified_booking_screen.dart
  (Fill patient details, select date/time)
         ↓
  Confirm Booking (Button)
         ↓
appointment_summary_screen.dart
  (Apply coupon, select payment type)
         ↓
  Proceed to Payment (Button)
         ↓
payment_screen.dart
  (Select payment method, pay)
         ↓
  Success Dialog
  ├─ Go to Dashboard
  └─ View My Appointments
         ↓
appointments_history_screen.dart
  (View upcoming/previous appointments)
```

---

## 📋 Testing Checklist

### Doctor Booking
- ✅ Navigate from Find Doctors → Doctor Profile → Book
- ✅ Fill all patient details
- ✅ Select future date
- ✅ Select time slot
- ✅ Confirm booking → See summary
- ✅ Apply coupon (try HEALTH10, FIRST20, SAVE50)
- ✅ Select Token payment (₹100)
- ✅ Select Full payment
- ✅ Proceed to payment
- ✅ Select payment method
- ✅ Complete payment
- ✅ See Booking ID & Transaction ID
- ✅ Navigate to appointments

### Hospital Booking
- ✅ Navigate from Find Hospitals → Hospital Profile → Book
- ✅ Select department (e.g., Cardiology)
- ✅ Select doctor (filtered by department)
- ✅ Fill all patient details
- ✅ Select future date
- ✅ Select time slot
- ✅ Confirm booking → See summary
- ✅ Apply coupon
- ✅ Select payment type
- ✅ Complete payment flow
- ✅ Navigate to appointments

### Edge Cases
- ✅ Invalid coupon code → Error message
- ✅ No payment method selected → Warning
- ✅ Back button navigation works
- ✅ Close (X) button exits flow
- ✅ Form validation prevents empty fields
- ✅ Phone number must be 10 digits

---

## 🎨 UI/UX Highlights

### Colors
- **Primary:** Medical Green (#2E7D5A)
- **Success:** Green (#10B981) for confirmations
- **Error:** Red (#EF4444) for invalid inputs
- **Discount:** Green for savings display

### Typography
- **Headers:** Bold, 16-18px
- **Body:** Regular, 14px
- **Captions:** Grey, 12px

### Cards
- Elevation: 2-4px (selected cards have higher elevation)
- Border radius: 12px
- Selected items: 2px primary color border

### Buttons
- **Primary:** Filled, rounded, 16px padding
- **Secondary:** Outlined, rounded
- **Floating:** Appears when form is valid

---

## 🚀 Future Enhancements (Not Implemented)

- ❌ Real backend API integration
- ❌ Actual payment gateway (Razorpay/Stripe)
- ❌ Database storage for appointments
- ❌ SMS/Email notifications
- ❌ Calendar integration
- ❌ Real-time doctor availability
- ❌ Video consultation option
- ❌ Prescription upload
- ❌ Medical history integration

---

## 📝 Notes

1. **All data is mock/dummy** - No real appointments are created
2. **IDs are generated using timestamps** - APT + milliseconds
3. **Coupons are hardcoded** - Only 3 valid codes
4. **Token amount is fixed** - Always ₹100
5. **Payment is simulated** - 2-second delay, always succeeds
6. **Department-doctor mapping** - Hardcoded in unified_booking_screen.dart

---

**Built with ❤️ for Dhanvantri Healthcare**
