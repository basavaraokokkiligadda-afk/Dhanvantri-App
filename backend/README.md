# Backend API Setup Guide

## Quick Start

### 1. Install Dependencies
```bash
cd backend
npm install
```

### 2. Environment Configuration
The `.env` file is already configured with:
```
PORT=3000
NODE_ENV=development
JWT_SECRET=your_jwt_secret_key_here
```

### 3. Start Server
```bash
npm start
```

## API Endpoints

### Health Check
```
GET http://localhost:3000/health
```

### Authentication
- `POST /api/auth/login` - User login
- `POST /api/auth/register` - User registration

### Doctors
- `GET /api/doctors` - List all doctors
- `GET /api/doctors/:id` - Get doctor by ID
- `GET /api/doctors/specialties/list` - Get specialties

### Appointments
- `GET /api/appointments` - List appointments
- `POST /api/appointments` - Create appointment
- `PATCH /api/appointments/:id` - Update appointment
- `DELETE /api/appointments/:id` - Cancel appointment

### Hospitals
- `GET /api/hospitals` - List hospitals
- `GET /api/hospitals/:id` - Get hospital by ID

### Pharmacy
- `GET /api/pharmacy/medicines` - List medicines
- `GET /api/pharmacy/medicines/:id` - Get medicine by ID

### AI Assistant
- `POST /api/ai-assistant/chat` - Chat with AI
- `GET /api/ai-assistant/history` - Get chat history
- `DELETE /api/ai-assistant/history` - Clear history

## Testing with Postman

Import the base URL: `http://localhost:3000/api`

### Example: Login Request
```
POST http://localhost:3000/api/auth/login
Content-Type: application/json

{
  "email": "patient@test.com",
  "password": "password123"
}
```

## Development

### Auto-reload with Nodemon
```bash
npm run dev
```

### Add New Route
1. Create file in `routes/` folder
2. Define endpoints
3. Import in `server.js`
4. Add to middleware with `app.use()`
