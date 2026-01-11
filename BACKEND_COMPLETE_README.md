# 🏥 Dhanvantri Healthcare - Complete Backend System

Complete production-grade backend for Dhanvantri Healthcare mobile application.

## 📋 System Overview

### Architecture
- **Node.js Backend**: Express.js + TypeScript + MongoDB
- **AI Service**: Python FastAPI for health AI features
- **Payment Gateway**: Razorpay integration
- **Authentication**: JWT-based with role-based access control

### Technology Stack

#### Backend (Node.js)
- **Runtime**: Node.js 18+
- **Framework**: Express.js 4.x
- **Language**: TypeScript 5.x
- **Database**: MongoDB with Mongoose ODM
- **Authentication**: JWT (jsonwebtoken + bcryptjs)
- **Payment**: Razorpay SDK
- **Security**: Helmet, CORS, express-validator
- **Logging**: Morgan

#### AI Service (Python)
- **Framework**: FastAPI
- **Runtime**: Python 3.9+
- **Server**: Uvicorn
- **Validation**: Pydantic

---

## 🚀 Quick Start

### Prerequisites
- Node.js 18+ and npm/yarn
- Python 3.9+
- MongoDB 5.0+
- Razorpay account (for payments)

### 1. Backend Setup

```bash
cd backend-new

# Install dependencies
npm install

# Create environment file
cp .env.example .env

# Configure .env with your values
# MONGODB_URI, JWT_SECRET, RAZORPAY keys, etc.

# Run development server
npm run dev

# Or build and run production
npm run build
npm start
```

**Backend runs on**: `http://localhost:3000`

### 2. AI Service Setup

```bash
cd ai-service

# Create virtual environment
python -m venv venv

# Activate virtual environment
# Windows
venv\Scripts\activate
# macOS/Linux
source venv/bin/activate

# Install dependencies
pip install -r requirements.txt

# Run AI service
python main.py
```

**AI Service runs on**: `http://localhost:8000`

### 3. Verify Services

```bash
# Check backend health
curl http://localhost:3000/health

# Check AI service health
curl http://localhost:8000/health

# View AI service docs
# Open http://localhost:8000/docs in browser
```

---

## 📁 Project Structure

```
backend-new/
├── src/
│   ├── server.ts                 # Server entry point
│   ├── app.ts                    # Express app configuration
│   ├── config/
│   │   ├── config.ts            # Environment configuration
│   │   └── database.ts          # MongoDB connection
│   ├── common/
│   │   ├── middleware/
│   │   │   ├── auth.middleware.ts
│   │   │   ├── error.middleware.ts
│   │   │   └── validate.middleware.ts
│   │   └── utils/
│   │       ├── jwt.utils.ts
│   │       └── response.utils.ts
│   └── modules/
│       ├── auth/                # Authentication
│       ├── users/               # User management
│       ├── doctors/             # Doctor profiles & search
│       ├── hospitals/           # Hospital management
│       ├── appointments/        # Appointment booking
│       ├── pharmacy/            # Medicine & orders
│       ├── ambulance/           # Ambulance booking
│       ├── payments/            # Payment processing
│       ├── donations/           # Donation campaigns
│       └── notifications/       # Push notifications
│
ai-service/
├── main.py                      # FastAPI application
├── requirements.txt             # Python dependencies
└── .env.example                # Environment template
```

---

## 🔌 API Documentation

### Base URLs
- **Backend API**: `http://localhost:3000/api/v1`
- **AI Service**: `http://localhost:8000/ai`

---

## 🔐 Authentication API

### Register User
```http
POST /api/v1/auth/register
Content-Type: application/json

{
  "email": "patient@example.com",
  "password": "SecurePass123!",
  "name": "John Doe",
  "phone": "+91-9876543210",
  "role": "patient",
  "gender": "male",
  "dateOfBirth": "1990-05-15"
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "user": {
      "_id": "...",
      "email": "patient@example.com",
      "name": "John Doe",
      "role": "patient"
    },
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
  },
  "message": "User registered successfully"
}
```

### Login
```http
POST /api/v1/auth/login
Content-Type: application/json

{
  "email": "patient@example.com",
  "password": "SecurePass123!"
}
```

### Get Profile
```http
GET /api/v1/auth/me
Authorization: Bearer <token>
```

---

## 👨‍⚕️ Doctors API

### Get All Doctors
```http
GET /api/v1/doctors?specialization=Cardiologist&available=true&page=1&limit=10
Authorization: Bearer <token>
```

**Response:**
```json
{
  "success": true,
  "data": {
    "docs": [
      {
        "_id": "...",
        "userId": {...},
        "specialization": "Cardiologist",
        "qualification": "MD, DM Cardiology",
        "experience": 15,
        "consultationFee": 1500,
        "rating": 4.8,
        "reviewCount": 120,
        "availableDays": ["Monday", "Wednesday", "Friday"],
        "availableTimeSlots": ["09:00-10:00", "10:00-11:00"]
      }
    ],
    "totalDocs": 45,
    "page": 1,
    "totalPages": 5
  }
}
```

### Get Doctor by ID
```http
GET /api/v1/doctors/:id
Authorization: Bearer <token>
```

### Get Specializations
```http
GET /api/v1/doctors/specializations/list
```

**Response:**
```json
{
  "success": true,
  "data": [
    "Cardiologist",
    "Dermatologist",
    "Orthopedic",
    "Pediatrician",
    "Neurologist"
  ]
}
```

---

## 📅 Appointments API

### Create Appointment
```http
POST /api/v1/appointments
Authorization: Bearer <token>
Content-Type: application/json

{
  "doctorId": "doctor_id_here",
  "hospitalId": "hospital_id_here",
  "appointmentDate": "2024-02-15",
  "timeSlot": "10:00-11:00",
  "consultationType": "in-person",
  "symptoms": "Chest pain, shortness of breath",
  "notes": "Patient has history of hypertension"
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "_id": "...",
    "appointmentNumber": "APT-20240115-001",
    "patient": {...},
    "doctor": {...},
    "hospital": {...},
    "appointmentDate": "2024-02-15T00:00:00.000Z",
    "timeSlot": "10:00-11:00",
    "status": "pending",
    "consultationFee": 1500
  },
  "message": "Appointment created successfully"
}
```

### Get User Appointments
```http
GET /api/v1/appointments?status=confirmed&page=1&limit=10
Authorization: Bearer <token>
```

### Cancel Appointment
```http
DELETE /api/v1/appointments/:id
Authorization: Bearer <token>
```

---

## 💊 Pharmacy API

### Get Medicines
```http
GET /api/v1/pharmacy/medicines?category=Antibiotics&search=amox&page=1
Authorization: Bearer <token>
```

**Response:**
```json
{
  "success": true,
  "data": {
    "docs": [
      {
        "_id": "...",
        "name": "Amoxicillin 500mg",
        "genericName": "Amoxicillin",
        "manufacturer": "Sun Pharma",
        "category": "Antibiotics",
        "price": 120,
        "discountedPrice": 100,
        "stock": 500,
        "requiresPrescription": true,
        "description": "Antibiotic for bacterial infections"
      }
    ],
    "totalDocs": 5,
    "page": 1
  }
}
```

### Create Pharmacy Order
```http
POST /api/v1/pharmacy/orders
Authorization: Bearer <token>
Content-Type: application/json

{
  "items": [
    {
      "medicineId": "medicine_id_1",
      "quantity": 2,
      "price": 100
    },
    {
      "medicineId": "medicine_id_2",
      "quantity": 1,
      "price": 250
    }
  ],
  "deliveryAddress": {
    "street": "123 Main Street",
    "city": "Mumbai",
    "state": "Maharashtra",
    "pincode": "400001"
  },
  "prescriptionUrl": "https://cloudinary.com/prescription.jpg"
}
```

### Get Order Details
```http
GET /api/v1/pharmacy/orders/:id
Authorization: Bearer <token>
```

---

## 🚑 Ambulance API

### Book Ambulance
```http
POST /api/v1/ambulance/book
Authorization: Bearer <token>
Content-Type: application/json

{
  "ambulanceType": "advanced",
  "pickupAddress": {
    "street": "456 Emergency Lane",
    "city": "Delhi",
    "state": "Delhi",
    "pincode": "110001",
    "latitude": 28.6139,
    "longitude": 77.2090
  },
  "dropAddress": {
    "street": "789 Hospital Road",
    "city": "Delhi",
    "state": "Delhi",
    "pincode": "110002"
  },
  "patientName": "Emergency Patient",
  "patientAge": 45,
  "contactNumber": "+91-9876543210",
  "emergency": true,
  "medicalCondition": "Cardiac arrest"
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "_id": "...",
    "bookingNumber": "AMB-20240115-001",
    "patient": {...},
    "ambulanceType": "advanced",
    "status": "dispatched",
    "baseFare": 1500,
    "emergencyCharges": 500,
    "totalFare": 2000,
    "estimatedArrivalTime": "15 minutes"
  }
}
```

### Track Ambulance
```http
GET /api/v1/ambulance/:id/track
Authorization: Bearer <token>
```

---

## 💳 Payment API

### Create Payment Order
```http
POST /api/v1/payments/create
Authorization: Bearer <token>
Content-Type: application/json

{
  "amount": 1500,
  "type": "appointment",
  "referenceId": "appointment_id_here"
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "orderId": "order_xyz123",
    "amount": 1500,
    "currency": "INR",
    "razorpayKey": "rzp_test_xxxxx"
  }
}
```

### Verify Payment
```http
POST /api/v1/payments/verify
Authorization: Bearer <token>
Content-Type: application/json

{
  "razorpayOrderId": "order_xyz123",
  "razorpayPaymentId": "pay_abc456",
  "razorpaySignature": "signature_hash_here"
}
```

---

## 🤖 AI Health Assistant API

### Symptom Checker
```http
POST /ai/symptom-check
Content-Type: application/json

{
  "symptoms": ["headache", "fever", "body ache"],
  "age": 30,
  "gender": "male",
  "budget": 2000
}
```

**Response:**
```json
{
  "severity": "moderate",
  "recommended_specialists": [
    {
      "specialization": "General Physician",
      "priority": "medium",
      "reason": "Fever evaluation by general physician",
      "estimated_consultation_fee": 800
    }
  ],
  "suggested_hospitals": [
    {
      "name": "Apollo Hospital",
      "rating": 4.8,
      "estimated_cost": 1500,
      "distance": "5 km"
    }
  ],
  "first_aid_tips": [
    "Drink plenty of fluids",
    "Rest adequately",
    "Take paracetamol if needed",
    "Monitor temperature regularly"
  ],
  "urgency_level": "medium"
}
```

### Prescription Analysis
```http
POST /ai/analyze-prescription
Content-Type: application/json

{
  "prescription_text": "Amoxicillin 500mg, 3 times daily for 7 days. Paracetamol as needed.",
  "patient_age": 35,
  "existing_conditions": ["hypertension"]
}
```

**Response:**
```json
{
  "medicines": [
    {
      "name": "Amoxicillin",
      "dosage": "500mg",
      "frequency": "3 times daily"
    },
    {
      "name": "Paracetamol",
      "dosage": "500mg",
      "frequency": "As needed"
    }
  ],
  "suggested_tests": [
    "Complete Blood Count",
    "Liver Function Test"
  ],
  "precautions": [
    "Take medicines as prescribed",
    "Complete the full course of antibiotics",
    "Avoid alcohol while on medication"
  ],
  "side_effects": [
    "Nausea or upset stomach",
    "Drowsiness",
    "Allergic reactions"
  ],
  "confidence": 0.75
}
```

### Health Tips
```http
GET /ai/health-tips?category=nutrition
```

---

## 🔒 Security Features

### Authentication
- JWT tokens with 7-day expiry
- Password hashing with bcrypt (10 rounds)
- Role-based access control (patient, doctor, hospital_admin)

### API Security
- Helmet.js for HTTP headers
- CORS with origin whitelist
- Request validation with express-validator
- Rate limiting (recommended for production)

### Payment Security
- Razorpay signature verification using HMAC SHA256
- Secure webhook handling
- PCI-DSS compliant payment flow

---

## 🌐 Environment Variables

### Backend (.env)
```env
# Server
NODE_ENV=development
PORT=3000

# Database
MONGODB_URI=mongodb://localhost:27017/dhanvantri

# JWT
JWT_SECRET=your_super_secret_jwt_key_change_in_production
JWT_EXPIRES_IN=7d

# Razorpay
RAZORPAY_KEY_ID=rzp_test_xxxxxxxx
RAZORPAY_KEY_SECRET=your_razorpay_secret

# Frontend URL
FRONTEND_URL=http://localhost:8080

# File Upload
MAX_FILE_SIZE=5242880
ALLOWED_FILE_TYPES=image/jpeg,image/png,application/pdf
```

### AI Service (.env)
```env
ENVIRONMENT=development
HOST=0.0.0.0
PORT=8000
LOG_LEVEL=INFO
```

---

## 📊 Database Models

### User Schema
- email, password (hashed), name, phone, role
- gender, dateOfBirth, bloodGroup, address
- profilePicture, isActive, isVerified

### Doctor Schema
- userId (ref), specialization, qualification, experience
- consultationFee, rating, reviewCount
- hospital, availableDays, availableTimeSlots

### Appointment Schema
- appointmentNumber (auto-generated: APT-YYYYMMDD-XXX)
- patient, doctor, hospital
- appointmentDate, timeSlot, status
- consultationType, symptoms, diagnosis, prescription

### Medicine Schema
- name, genericName, manufacturer, category
- price, discountedPrice, stock, unit
- requiresPrescription, description, images

### PharmacyOrder Schema
- orderNumber (auto-generated: MED-YYYYMMDD-XXX)
- patient, items, totalAmount, paymentStatus
- deliveryAddress, prescriptionUrl

### Ambulance Schema
- bookingNumber (auto-generated: AMB-YYYYMMDD-XXX)
- patient, ambulanceType, status
- pickupAddress, dropAddress, baseFare, totalFare

### Payment Schema
- paymentNumber (auto-generated: PAY-YYYYMMDD-XXX)
- user, amount, type (appointment/pharmacy/ambulance/donation)
- razorpayOrderId, razorpayPaymentId, status

---

## 🧪 Testing

### Manual Testing with Postman/cURL

```bash
# Register user
curl -X POST http://localhost:3000/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "Test123!",
    "name": "Test User",
    "phone": "+91-9999999999",
    "role": "patient"
  }'

# Login
curl -X POST http://localhost:3000/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "Test123!"
  }'

# Use token in subsequent requests
curl http://localhost:3000/api/v1/doctors \
  -H "Authorization: Bearer YOUR_TOKEN_HERE"
```

---

## 🚀 Deployment

### Backend Deployment (Heroku/Render/Railway)

```bash
# Build production
npm run build

# Start production
npm start
```

### AI Service Deployment

```bash
# Using Gunicorn
gunicorn -w 4 -k uvicorn.workers.UvicornWorker main:app
```

### Environment Setup
- Set all environment variables in hosting platform
- Configure MongoDB Atlas for production database
- Update CORS origins with production frontend URL
- Enable SSL/HTTPS
- Set up domain and DNS

---

## 📝 Development Notes

### Code Style
- TypeScript strict mode enabled
- ESLint + Prettier for code formatting
- Async/await for asynchronous operations
- Try-catch with proper error handling

### Best Practices
- Modular architecture with separation of concerns
- Validation middleware for all input
- Response utilities for consistent API responses
- Error middleware for centralized error handling
- JWT authentication on protected routes

---

## 🤝 Integration with Flutter App

### API Client Setup
```dart
// lib/core/api/api_client.dart
class ApiClient {
  static const String baseUrl = 'http://localhost:3000/api/v1';
  static const String aiBaseUrl = 'http://localhost:8000/ai';
  
  static String? _token;
  
  static void setToken(String token) {
    _token = token;
  }
  
  static Future<http.Response> get(String endpoint) {
    return http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        'Authorization': 'Bearer $_token',
        'Content-Type': 'application/json',
      },
    );
  }
}
```

### Authentication Flow
1. User logs in via Flutter app
2. Backend returns JWT token
3. Store token securely (flutter_secure_storage)
4. Include token in all API requests
5. Handle token expiry with refresh logic

---

## 📞 Support & Contact

For issues or questions:
- Backend API: Check `/health` endpoint
- AI Service: Check `/health` endpoint
- API Documentation: FastAPI auto-docs at `/docs`

---

## 📄 License

ISC License

---

**Built with ❤️ for Dhanvantri Healthcare**
