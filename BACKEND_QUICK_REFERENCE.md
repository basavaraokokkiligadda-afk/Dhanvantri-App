# 🏥 Dhanvantri Backend - Quick Reference

## 🚀 Start Services

### Backend
```bash
cd backend-new
npm run dev        # Development with auto-reload
npm start          # Production
```
**URL**: http://localhost:3000

### AI Service
```bash
cd ai-service
python main.py
```
**URL**: http://localhost:8000
**Docs**: http://localhost:8000/docs

---

## 📋 API Endpoints Cheat Sheet

### Authentication
| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/v1/auth/register` | Register new user |
| POST | `/api/v1/auth/login` | Login user |
| GET | `/api/v1/auth/me` | Get profile |
| PATCH | `/api/v1/auth/profile` | Update profile |
| PATCH | `/api/v1/auth/password` | Change password |

### Doctors
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/v1/doctors` | List all doctors |
| GET | `/api/v1/doctors/:id` | Get doctor details |
| GET | `/api/v1/doctors/specializations/list` | Get specializations |

### Appointments
| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/v1/appointments` | Create appointment |
| GET | `/api/v1/appointments` | List appointments |
| DELETE | `/api/v1/appointments/:id` | Cancel appointment |

### Pharmacy
| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/v1/pharmacy/medicines` | List medicines |
| POST | `/api/v1/pharmacy/orders` | Create order |
| GET | `/api/v1/pharmacy/orders/:id` | Get order details |

### Ambulance
| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/v1/ambulance/book` | Book ambulance |
| GET | `/api/v1/ambulance/:id/track` | Track ambulance |

### Payments
| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/v1/payments/create` | Create payment order |
| POST | `/api/v1/payments/verify` | Verify payment |
| GET | `/api/v1/payments/:id` | Get payment details |

### AI Assistant
| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/ai/symptom-check` | Analyze symptoms |
| POST | `/ai/analyze-prescription` | Analyze prescription |
| GET | `/ai/health-tips` | Get health tips |

---

## 🔐 Authentication Flow

```
1. Register/Login → Get JWT token
2. Store token in Flutter app (flutter_secure_storage)
3. Include in headers: Authorization: Bearer <token>
4. Token expires in 7 days
```

---

## 💳 Payment Flow (Razorpay)

```
1. Create Order: POST /payments/create → Get orderId
2. Show Razorpay checkout in Flutter
3. On success: Get paymentId, signature
4. Verify: POST /payments/verify
5. Backend updates appointment/order status
```

---

## 📦 Response Format

### Success
```json
{
  "success": true,
  "data": { /* response data */ },
  "message": "Operation successful"
}
```

### Error
```json
{
  "success": false,
  "error": "Error message",
  "statusCode": 400
}
```

---

## 🗄️ Database Collections

- **users** - User accounts
- **doctors** - Doctor profiles
- **hospitals** - Hospital information
- **appointments** - Appointments
- **medicines** - Medicine catalog
- **pharmacyorders** - Pharmacy orders
- **ambulances** - Ambulance bookings
- **payments** - Payment records
- **donations** - Donation campaigns
- **notifications** - Push notifications

---

## 🛠️ Development Commands

### Backend
```bash
npm run dev        # Development mode
npm run build      # Build TypeScript
npm start          # Production
npm run lint       # Run ESLint
```

### AI Service
```bash
python main.py                    # Start server
uvicorn main:app --reload        # Auto-reload mode
uvicorn main:app --port 8001     # Custom port
```

---

## 🔧 Environment Variables

### Backend (.env)
```env
NODE_ENV=development
PORT=3000
MONGODB_URI=mongodb://localhost:27017/dhanvantri
JWT_SECRET=your_secret_here
JWT_EXPIRES_IN=7d
RAZORPAY_KEY_ID=rzp_test_xxxxx
RAZORPAY_KEY_SECRET=your_secret
```

### AI Service (.env)
```env
ENVIRONMENT=development
PORT=8000
LOG_LEVEL=INFO
```

---

## 📱 Flutter Integration

### API Client
```dart
class ApiClient {
  static const baseUrl = 'http://localhost:3000/api/v1';
  static String? token;
  
  static Future<Response> get(String endpoint) async {
    return http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: {'Authorization': 'Bearer $token'},
    );
  }
}
```

### Example: Login
```dart
final response = await http.post(
  Uri.parse('$baseUrl/auth/login'),
  body: json.encode({
    'email': 'test@example.com',
    'password': 'password123'
  }),
  headers: {'Content-Type': 'application/json'},
);

final data = json.decode(response.body);
final token = data['data']['token'];
await storage.write(key: 'token', value: token);
```

---

## 🧪 Quick Test with cURL

### Register
```bash
curl -X POST http://localhost:3000/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"Test123!","name":"Test User","phone":"+91-9999999999","role":"patient"}'
```

### Login
```bash
curl -X POST http://localhost:3000/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"Test123!"}'
```

### Get Doctors
```bash
curl http://localhost:3000/api/v1/doctors \
  -H "Authorization: Bearer YOUR_TOKEN"
```

### AI Symptom Check
```bash
curl -X POST http://localhost:8000/ai/symptom-check \
  -H "Content-Type: application/json" \
  -d '{"symptoms":["headache","fever"],"age":30}'
```

---

## 🐛 Troubleshooting

### Backend won't start
- Check MongoDB is running: `mongod --version`
- Check .env file exists and has correct values
- Check port 3000 is not in use

### AI Service won't start
- Check Python virtual environment is activated
- Check all dependencies installed: `pip list`
- Check port 8000 is not in use

### Database connection error
- Verify MongoDB URI in .env
- Check MongoDB service is running
- Try: `mongodb://127.0.0.1:27017/dhanvantri`

### Razorpay errors
- Verify RAZORPAY_KEY_ID and RAZORPAY_KEY_SECRET
- Use test keys for development (rzp_test_)
- Check signature verification logic

---

## 📚 Documentation Links

- **Backend README**: [BACKEND_COMPLETE_README.md](BACKEND_COMPLETE_README.md)
- **AI Service README**: [ai-service/README.md](ai-service/README.md)
- **Flutter README**: [FLUTTER_README.md](FLUTTER_README.md)
- **FastAPI Docs**: http://localhost:8000/docs

---

## 🎯 Common Tasks

### Add New API Endpoint
1. Create controller in `src/modules/<module>/<module>.controller.ts`
2. Create routes in `src/modules/<module>/<module>.routes.ts`
3. Register routes in `src/app.ts`

### Add Database Model
1. Create schema in `src/modules/<module>/<module>.model.ts`
2. Use Mongoose for schema definition
3. Add indexes for frequently queried fields

### Add Middleware
1. Create in `src/common/middleware/`
2. Use in routes or globally in `app.ts`

---

**Need help? Check the full documentation or API docs at /docs**
