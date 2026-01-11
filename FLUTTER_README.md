# 🏥 Dhanvantri Healthcare - Complete Flutter + Node.js Application

A comprehensive healthcare mobile application built with Flutter for the frontend and Node.js for the backend.

## 📋 Table of Contents
- [Features](#features)
- [Project Structure](#project-structure)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Running the Application](#running-the-application)
- [API Documentation](#api-documentation)
- [Screens Overview](#screens-overview)

---

## ✨ Features

### Frontend (Flutter)
- ✅ **User Authentication** - Login/Register with role-based access
- 🏥 **Hospital Dashboard** - Manage hospital operations
- 👤 **Patient Dashboard** - Personal health management
- 👨‍⚕️ **Doctor Directory** - Browse and search doctors by specialty
- 📅 **Appointment Booking** - Schedule appointments with doctors
- 💊 **Pharmacy Hub** - Browse and order medicines
- 🤖 **AI Health Assistant** - Get health advice and symptom assessment
- 📱 **Social Features** - Feed, Stories (Snips), Video Feed (Clicks)
- 💬 **Messaging** - ChitChat for patient-doctor communication
- 🎨 **Modern UI** - Material Design 3 with custom theme
- 🌓 **Dark Mode** - Support for light and dark themes

### Backend (Node.js)
- 🔐 **Authentication API** - Login and registration endpoints
- 👨‍⚕️ **Doctors API** - CRUD operations for doctors
- 📅 **Appointments API** - Manage appointments
- 🏥 **Hospitals API** - Hospital information and search
- 💊 **Pharmacy API** - Medicine catalog and ordering
- 🤖 **AI Assistant API** - Chat-based health assistance

---

## 📁 Project Structure

```
Dhanvantri app/
├── lib/                          # Flutter app source code
│   ├── main.dart                # App entry point
│   ├── core/                    # Core functionality
│   │   ├── app_theme.dart      # Global theme configuration
│   │   ├── routes/
│   │   │   └── app_routes.dart # Route definitions
│   │   └── providers/
│   │       └── app_state_provider.dart
│   └── presentation/            # UI screens
│       ├── splash/             # Splash screen
│       ├── auth/               # Login & registration
│       ├── dashboard/          # User & hospital dashboards
│       ├── feed/               # Social feed
│       ├── clicks/             # Video feed
│       ├── stories/            # Stories (Snips)
│       ├── messaging/          # Chat messaging
│       ├── appointment/        # Appointment booking
│       ├── ai_assistant/       # AI health assistant
│       ├── pharmacy/           # Pharmacy hub
│       └── widgets/            # Reusable widgets
│
├── backend/                     # Node.js backend
│   ├── server.js               # Express server
│   ├── routes/                 # API routes
│   │   ├── auth.js            # Authentication endpoints
│   │   ├── doctors.js         # Doctors API
│   │   ├── appointments.js    # Appointments API
│   │   ├── hospitals.js       # Hospitals API
│   │   ├── pharmacy.js        # Pharmacy API
│   │   └── ai-assistant.js    # AI Assistant API
│   ├── package.json
│   └── .env                   # Environment variables
│
├── pubspec.yaml               # Flutter dependencies
└── README.md                  # This file
```

---

## 🔧 Prerequisites

### For Flutter App:
- **Flutter SDK** (3.0.0 or higher)
- **Dart SDK** (3.0.0 or higher)
- **Android Studio** / **Xcode** (for mobile deployment)
- **VS Code** with Flutter extension

### For Backend:
- **Node.js** (v16 or higher)
- **npm** or **yarn**

### Recommended:
- **Git**
- **Postman** (for API testing)
- **MongoDB** (optional, for database integration)

---

## 📦 Installation

### 1. Clone/Open the Repository
The project is already in your workspace.

### 2. Install Flutter Dependencies
```bash
# Navigate to project root
cd "C:\Users\Lenovo\OneDrive\المستندات\Desktop\Dhanvantri app"

# Get Flutter packages
flutter pub get
```

### 3. Install Backend Dependencies
```bash
# Navigate to backend folder
cd backend

# Install Node.js packages
npm install
```

---

## 🚀 Running the Application

### Start the Backend Server

1. **Navigate to backend folder:**
   ```bash
   cd backend
   ```

2. **Start the server:**
   ```bash
   npm start
   ```
   
   Or for development with auto-reload:
   ```bash
   npm run dev
   ```

3. **Verify backend is running:**
   - Open browser: `http://localhost:3000`
   - Health check: `http://localhost:3000/health`

### Run the Flutter App

1. **Check available devices:**
   ```bash
   flutter devices
   ```

2. **Run on Android Emulator/Device:**
   ```bash
   flutter run
   ```

3. **Run on specific device:**
   ```bash
   flutter run -d <device-id>
   ```

4. **Build for release:**
   ```bash
   # Android
   flutter build apk

   # iOS
   flutter build ios
   ```

---

## 🔌 API Documentation

### Base URL
```
http://localhost:3000/api
```

### Authentication Endpoints

#### POST `/api/auth/login`
Login user
```json
{
  "email": "patient@test.com",
  "password": "password123"
}
```

#### POST `/api/auth/register`
Register new user
```json
{
  "name": "John Doe",
  "email": "john@example.com",
  "password": "password123",
  "type": "patient"
}
```

### Doctors Endpoints

#### GET `/api/doctors`
Get all doctors (with optional filters)
- Query params: `specialty`, `available`

#### GET `/api/doctors/:id`
Get specific doctor details

#### GET `/api/doctors/specialties/list`
Get list of all specialties

### Appointments Endpoints

#### GET `/api/appointments`
Get all appointments
- Query params: `patientId`, `status`

#### POST `/api/appointments`
Create new appointment
```json
{
  "patientId": 1,
  "doctorId": 1,
  "doctorName": "Dr. Sarah Johnson",
  "specialty": "Cardiologist",
  "date": "2026-01-15",
  "time": "10:00 AM",
  "type": "consultation"
}
```

#### PATCH `/api/appointments/:id`
Update appointment status

#### DELETE `/api/appointments/:id`
Cancel appointment

### Hospital Endpoints

#### GET `/api/hospitals`
Get all hospitals
- Query params: `emergency`, `specialty`

#### GET `/api/hospitals/:id`
Get specific hospital

### Pharmacy Endpoints

#### GET `/api/pharmacy/medicines`
Get all medicines
- Query params: `category`, `search`

#### GET `/api/pharmacy/medicines/:id`
Get specific medicine

### AI Assistant Endpoints

#### POST `/api/ai-assistant/chat`
Send message to AI assistant
```json
{
  "message": "I have a headache",
  "userId": 1
}
```

#### GET `/api/ai-assistant/history`
Get conversation history

#### DELETE `/api/ai-assistant/history`
Clear conversation history

---

## 📱 Screens Overview

### 1. **Splash Screen**
- Initial loading screen with app logo

### 2. **Login Screen**
- Email/password authentication
- Biometric login support
- User type selection (Patient/Hospital)

### 3. **User Dashboard**
- Home feed
- Quick actions
- Health stats
- Navigation to all features

### 4. **Hospital Dashboard**
- Hospital management interface
- Patient appointments
- Staff management

### 5. **Feed Screen**
- Social feed with health posts
- Like, comment, share functionality
- Post creation

### 6. **Clicks (Video Feed)**
- Short-form video content
- Swipe navigation
- Health tips and exercises

### 7. **Snip Stories**
- Instagram-style stories
- Health journey sharing
- 24-hour expiry

### 8. **ChitChat Messaging**
- Direct messaging
- Patient-doctor communication
- Voice messages support

### 9. **Appointment Booking**
- Doctor search and filter
- Calendar view
- Time slot selection
- Appointment management

### 10. **AI Health Assistant**
- Symptom checker
- Health advice
- Voice input support
- Doctor recommendations

### 11. **Pharmacy Hub**
- Medicine catalog
- Search and filter
- Prescription upload
- Order medicines

---

## 🎨 Theme & Styling

The app uses a custom theme defined in `lib/core/app_theme.dart`:

- **Primary Color:** Medical Green (#2E7D5A)
- **Secondary Color:** Calming Blue (#4A90A4)
- **Font Family:** Google Inter
- **Design Style:** Medical Minimalism
- **Color Palette:** Therapeutic Harmony

### Customizing Theme
Edit `lib/core/app_theme.dart` to modify colors, fonts, and styling.

---

## 🔐 Test Credentials

### Patient Account
- **Email:** patient@test.com
- **Password:** password123

### Hospital Account
- **Email:** hospital@test.com
- **Password:** password123

---

## 🛠️ Development Tips

### Hot Reload (Flutter)
Press `r` in terminal while app is running to hot reload changes.

### Full Restart
Press `R` in terminal for full app restart.

### Check for Errors
```bash
flutter analyze
```

### Format Code
```bash
flutter format lib/
```

### Backend Development
The backend uses `nodemon` for auto-reload during development:
```bash
cd backend
npm run dev
```

---

## 📚 Additional Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Material Design 3](https://m3.material.io/)
- [Express.js Documentation](https://expressjs.com/)
- [Node.js Best Practices](https://github.com/goldbergyoni/nodebestpractices)

---

## 🤝 Contributing

1. Create a feature branch
2. Make your changes
3. Test thoroughly
4. Submit a pull request

---

## 📝 License

ISC License

---

## 💡 Support

For issues or questions:
- Check existing documentation
- Review API endpoints
- Test with provided credentials

---

## 🎯 Next Steps

1. ✅ Install dependencies (Flutter & Backend)
2. ✅ Start backend server
3. ✅ Run Flutter app
4. 🔄 Customize as needed
5. 🚀 Deploy to production

---

**Built with ❤️ using Flutter & Node.js**
