# 🔗 Flutter-Backend Integration Guide

Complete guide to integrate the Dhanvantri Flutter app with the new backend.

---

## 📋 Overview

This guide shows how to connect your existing Flutter app to the newly created Node.js backend and Python AI service.

---

## 🚀 Quick Setup

### 1. Start Backend Services

```bash
# Terminal 1: Backend
cd backend-new
npm install
cp .env.example .env
# Edit .env file
npm run dev

# Terminal 2: AI Service
cd ai-service
python -m venv venv
venv\Scripts\activate  # Windows
pip install -r requirements.txt
python main.py

# Terminal 3: Flutter App
flutter run
```

---

## 📱 Flutter Integration

### Step 1: Create API Configuration

Create `lib/core/api/api_config.dart`:

```dart
class ApiConfig {
  // Change these to your backend URLs
  static const String backendBaseUrl = 'http://localhost:3000/api/v1';
  static const String aiBaseUrl = 'http://localhost:8000/ai';
  
  // For Android emulator use: http://10.0.2.2:3000/api/v1
  // For iOS simulator use: http://localhost:3000/api/v1
  // For physical device use: http://<your-ip>:3000/api/v1
  
  static const Duration timeoutDuration = Duration(seconds: 30);
}
```

---

### Step 2: Create API Client

Create `lib/core/api/api_client.dart`:

```dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'api_config.dart';

class ApiClient {
  static final _storage = FlutterSecureStorage();
  static String? _token;

  // Initialize token from storage
  static Future<void> initialize() async {
    _token = await _storage.read(key: 'auth_token');
  }

  // Save token
  static Future<void> saveToken(String token) async {
    _token = token;
    await _storage.write(key: 'auth_token', value: token);
  }

  // Clear token
  static Future<void> clearToken() async {
    _token = null;
    await _storage.delete(key: 'auth_token');
  }

  // Get headers
  static Map<String, String> _getHeaders({bool includeAuth = true}) {
    final headers = {
      'Content-Type': 'application/json',
    };
    
    if (includeAuth && _token != null) {
      headers['Authorization'] = 'Bearer $_token';
    }
    
    return headers;
  }

  // GET request
  static Future<http.Response> get(
    String endpoint, {
    bool includeAuth = true,
  }) async {
    final url = Uri.parse('${ApiConfig.backendBaseUrl}$endpoint');
    
    return await http
        .get(url, headers: _getHeaders(includeAuth: includeAuth))
        .timeout(ApiConfig.timeoutDuration);
  }

  // POST request
  static Future<http.Response> post(
    String endpoint, {
    required Map<String, dynamic> body,
    bool includeAuth = true,
  }) async {
    final url = Uri.parse('${ApiConfig.backendBaseUrl}$endpoint');
    
    return await http
        .post(
          url,
          headers: _getHeaders(includeAuth: includeAuth),
          body: json.encode(body),
        )
        .timeout(ApiConfig.timeoutDuration);
  }

  // PATCH request
  static Future<http.Response> patch(
    String endpoint, {
    required Map<String, dynamic> body,
    bool includeAuth = true,
  }) async {
    final url = Uri.parse('${ApiConfig.backendBaseUrl}$endpoint');
    
    return await http
        .patch(
          url,
          headers: _getHeaders(includeAuth: includeAuth),
          body: json.encode(body),
        )
        .timeout(ApiConfig.timeoutDuration);
  }

  // DELETE request
  static Future<http.Response> delete(
    String endpoint, {
    bool includeAuth = true,
  }) async {
    final url = Uri.parse('${ApiConfig.backendBaseUrl}$endpoint');
    
    return await http
        .delete(url, headers: _getHeaders(includeAuth: includeAuth))
        .timeout(ApiConfig.timeoutDuration);
  }

  // AI Service request
  static Future<http.Response> postToAI(
    String endpoint, {
    required Map<String, dynamic> body,
  }) async {
    final url = Uri.parse('${ApiConfig.aiBaseUrl}$endpoint');
    
    return await http
        .post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: json.encode(body),
        )
        .timeout(ApiConfig.timeoutDuration);
  }
}
```

---

### Step 3: Update Authentication Service

Update `lib/services/auth_service.dart`:

```dart
import 'dart:convert';
import '../core/api/api_client.dart';

class AuthService {
  // Register
  static Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String name,
    required String phone,
    String role = 'patient',
  }) async {
    try {
      final response = await ApiClient.post(
        '/auth/register',
        body: {
          'email': email,
          'password': password,
          'name': name,
          'phone': phone,
          'role': role,
        },
        includeAuth: false,
      );

      final data = json.decode(response.body);

      if (response.statusCode == 201 && data['success']) {
        // Save token
        await ApiClient.saveToken(data['data']['token']);
        return data['data'];
      } else {
        throw Exception(data['error'] ?? 'Registration failed');
      }
    } catch (e) {
      throw Exception('Registration error: $e');
    }
  }

  // Login
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await ApiClient.post(
        '/auth/login',
        body: {
          'email': email,
          'password': password,
        },
        includeAuth: false,
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200 && data['success']) {
        // Save token
        await ApiClient.saveToken(data['data']['token']);
        return data['data'];
      } else {
        throw Exception(data['error'] ?? 'Login failed');
      }
    } catch (e) {
      throw Exception('Login error: $e');
    }
  }

  // Get Profile
  static Future<Map<String, dynamic>> getProfile() async {
    try {
      final response = await ApiClient.get('/auth/me');
      final data = json.decode(response.body);

      if (response.statusCode == 200 && data['success']) {
        return data['data'];
      } else {
        throw Exception(data['error'] ?? 'Failed to get profile');
      }
    } catch (e) {
      throw Exception('Profile error: $e');
    }
  }

  // Logout
  static Future<void> logout() async {
    await ApiClient.clearToken();
  }
}
```

---

### Step 4: Create Doctors Service

Create `lib/services/doctors_service.dart`:

```dart
import 'dart:convert';
import '../core/api/api_client.dart';

class DoctorsService {
  // Get all doctors
  static Future<List<Map<String, dynamic>>> getDoctors({
    String? specialization,
    bool? available,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      String endpoint = '/doctors?page=$page&limit=$limit';
      
      if (specialization != null) {
        endpoint += '&specialization=$specialization';
      }
      if (available != null) {
        endpoint += '&available=$available';
      }

      final response = await ApiClient.get(endpoint);
      final data = json.decode(response.body);

      if (response.statusCode == 200 && data['success']) {
        return List<Map<String, dynamic>>.from(data['data']['docs']);
      } else {
        throw Exception(data['error'] ?? 'Failed to fetch doctors');
      }
    } catch (e) {
      throw Exception('Doctors error: $e');
    }
  }

  // Get doctor by ID
  static Future<Map<String, dynamic>> getDoctorById(String id) async {
    try {
      final response = await ApiClient.get('/doctors/$id');
      final data = json.decode(response.body);

      if (response.statusCode == 200 && data['success']) {
        return data['data'];
      } else {
        throw Exception(data['error'] ?? 'Failed to fetch doctor');
      }
    } catch (e) {
      throw Exception('Doctor error: $e');
    }
  }

  // Get specializations
  static Future<List<String>> getSpecializations() async {
    try {
      final response = await ApiClient.get('/doctors/specializations/list');
      final data = json.decode(response.body);

      if (response.statusCode == 200 && data['success']) {
        return List<String>.from(data['data']);
      } else {
        throw Exception(data['error'] ?? 'Failed to fetch specializations');
      }
    } catch (e) {
      throw Exception('Specializations error: $e');
    }
  }
}
```

---

### Step 5: Create Appointments Service

Create `lib/services/appointments_service.dart`:

```dart
import 'dart:convert';
import '../core/api/api_client.dart';

class AppointmentsService {
  // Create appointment
  static Future<Map<String, dynamic>> createAppointment({
    required String doctorId,
    required String hospitalId,
    required String appointmentDate,
    required String timeSlot,
    String consultationType = 'in-person',
    String? symptoms,
    String? notes,
  }) async {
    try {
      final response = await ApiClient.post(
        '/appointments',
        body: {
          'doctorId': doctorId,
          'hospitalId': hospitalId,
          'appointmentDate': appointmentDate,
          'timeSlot': timeSlot,
          'consultationType': consultationType,
          if (symptoms != null) 'symptoms': symptoms,
          if (notes != null) 'notes': notes,
        },
      );

      final data = json.decode(response.body);

      if (response.statusCode == 201 && data['success']) {
        return data['data'];
      } else {
        throw Exception(data['error'] ?? 'Failed to create appointment');
      }
    } catch (e) {
      throw Exception('Appointment error: $e');
    }
  }

  // Get appointments
  static Future<List<Map<String, dynamic>>> getAppointments({
    String? status,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      String endpoint = '/appointments?page=$page&limit=$limit';
      
      if (status != null) {
        endpoint += '&status=$status';
      }

      final response = await ApiClient.get(endpoint);
      final data = json.decode(response.body);

      if (response.statusCode == 200 && data['success']) {
        return List<Map<String, dynamic>>.from(data['data']['docs']);
      } else {
        throw Exception(data['error'] ?? 'Failed to fetch appointments');
      }
    } catch (e) {
      throw Exception('Appointments error: $e');
    }
  }

  // Cancel appointment
  static Future<void> cancelAppointment(String id) async {
    try {
      final response = await ApiClient.delete('/appointments/$id');
      final data = json.decode(response.body);

      if (response.statusCode != 200 || !data['success']) {
        throw Exception(data['error'] ?? 'Failed to cancel appointment');
      }
    } catch (e) {
      throw Exception('Cancel error: $e');
    }
  }
}
```

---

### Step 6: Create AI Service

Create `lib/services/ai_service.dart`:

```dart
import 'dart:convert';
import '../core/api/api_client.dart';

class AIService {
  // Symptom check
  static Future<Map<String, dynamic>> checkSymptoms({
    required List<String> symptoms,
    int? age,
    String? gender,
    double? budget,
  }) async {
    try {
      final response = await ApiClient.postToAI(
        '/symptom-check',
        body: {
          'symptoms': symptoms,
          if (age != null) 'age': age,
          if (gender != null) 'gender': gender,
          if (budget != null) 'budget': budget,
        },
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200) {
        return data;
      } else {
        throw Exception(data['detail'] ?? 'Symptom check failed');
      }
    } catch (e) {
      throw Exception('AI error: $e');
    }
  }

  // Analyze prescription
  static Future<Map<String, dynamic>> analyzePrescription({
    required String prescriptionText,
    int? patientAge,
    List<String>? existingConditions,
  }) async {
    try {
      final response = await ApiClient.postToAI(
        '/analyze-prescription',
        body: {
          'prescription_text': prescriptionText,
          if (patientAge != null) 'patient_age': patientAge,
          if (existingConditions != null) 'existing_conditions': existingConditions,
        },
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200) {
        return data;
      } else {
        throw Exception(data['detail'] ?? 'Prescription analysis failed');
      }
    } catch (e) {
      throw Exception('AI error: $e');
    }
  }

  // Get health tips
  static Future<Map<String, dynamic>> getHealthTips({
    String category = 'general',
  }) async {
    try {
      final url = Uri.parse('${ApiConfig.aiBaseUrl}/health-tips?category=$category');
      final response = await http.get(url);
      
      final data = json.decode(response.body);

      if (response.statusCode == 200) {
        return data;
      } else {
        throw Exception('Failed to get health tips');
      }
    } catch (e) {
      throw Exception('AI error: $e');
    }
  }
}
```

---

### Step 7: Update Main.dart

Add API initialization in `lib/main.dart`:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize API client
  await ApiClient.initialize();
  
  runApp(const DhanvantriApp());
}
```

---

### Step 8: Add Dependencies

Add to `pubspec.yaml`:

```yaml
dependencies:
  http: ^1.1.0
  flutter_secure_storage: ^9.0.0
```

Then run:
```bash
flutter pub get
```

---

## 🔧 Android Emulator Configuration

For Android emulator to access localhost backend:

1. Use `10.0.2.2` instead of `localhost`
2. Update `api_config.dart`:

```dart
static const String backendBaseUrl = 'http://10.0.2.2:3000/api/v1';
static const String aiBaseUrl = 'http://10.0.2.2:8000/ai';
```

---

## 📱 Physical Device Configuration

For testing on physical device:

1. Find your computer's IP address:
   ```bash
   # Windows
   ipconfig
   
   # macOS/Linux
   ifconfig
   ```

2. Update `api_config.dart`:
   ```dart
   static const String backendBaseUrl = 'http://192.168.1.100:3000/api/v1';
   ```

3. Make sure device and computer are on same WiFi network

---

## 🧪 Testing Integration

### Test 1: Authentication

```dart
// In your login screen
final result = await AuthService.login(
  email: 'test@example.com',
  password: 'Test123!',
);

print('Token: ${result['token']}');
print('User: ${result['user']}');
```

### Test 2: Fetch Doctors

```dart
final doctors = await DoctorsService.getDoctors(
  specialization: 'Cardiologist',
  page: 1,
  limit: 10,
);

print('Doctors: $doctors');
```

### Test 3: AI Symptom Check

```dart
final result = await AIService.checkSymptoms(
  symptoms: ['headache', 'fever'],
  age: 30,
);

print('Recommended specialists: ${result['recommended_specialists']}');
```

---

## ⚠️ Common Issues & Solutions

### Issue 1: Connection Refused

**Solution**: Make sure backend is running:
```bash
cd backend-new
npm run dev
```

### Issue 2: Token Expired

**Solution**: Implement token refresh or re-login:
```dart
if (response.statusCode == 401) {
  await AuthService.logout();
  // Navigate to login screen
}
```

### Issue 3: CORS Error

**Solution**: Backend already configured. If issue persists, check `app.ts` CORS settings.

---

## 📊 API Response Handling

All backend responses follow this format:

```json
{
  "success": true,
  "data": { /* your data */ },
  "message": "Operation successful"
}
```

Error response:
```json
{
  "success": false,
  "error": "Error message",
  "statusCode": 400
}
```

---

## 🔒 Security Best Practices

1. **Never commit tokens or secrets**
2. **Use flutter_secure_storage for tokens**
3. **Implement token refresh logic**
4. **Handle 401 errors globally**
5. **Validate user input before sending**

---

## 🚀 Next Steps

1. ✅ Create API services for all modules
2. ✅ Update existing screens to use new API
3. ✅ Test authentication flow
4. ✅ Test payment integration
5. ✅ Test AI features
6. ✅ Handle errors gracefully
7. ✅ Add loading states
8. ✅ Implement offline mode (optional)

---

**Happy Coding! 🎉**
