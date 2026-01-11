# 🚀 Dhanvantri Backend - Deployment Guide

Complete guide to deploy backend services to production.

---

## 📋 Pre-Deployment Checklist

- [ ] All environment variables configured
- [ ] Database backup strategy in place
- [ ] SSL certificates obtained
- [ ] Domain names registered
- [ ] Payment gateway in production mode
- [ ] Error monitoring set up
- [ ] Load testing completed
- [ ] Security audit done

---

## 🌐 Deployment Options

### 1. Node.js Backend Deployment

#### Option A: Render (Recommended - Free Tier Available)

**Steps:**
1. Create account at [render.com](https://render.com)
2. Create new Web Service
3. Connect GitHub repository
4. Configure:
   ```
   Build Command: npm install && npm run build
   Start Command: npm start
   Environment: Node
   ```
5. Add environment variables in Render dashboard
6. Deploy!

**Environment Variables:**
```
NODE_ENV=production
PORT=3000
MONGODB_URI=<your_mongodb_atlas_uri>
JWT_SECRET=<strong_secret>
RAZORPAY_KEY_ID=<live_key>
RAZORPAY_KEY_SECRET=<live_secret>
FRONTEND_URL=<your_flutter_app_url>
```

#### Option B: Railway.app

```bash
# Install Railway CLI
npm install -g @railway/cli

# Login
railway login

# Initialize project
cd backend-new
railway init

# Add environment variables
railway variables set MONGODB_URI="..."
railway variables set JWT_SECRET="..."

# Deploy
railway up
```

#### Option C: Heroku

```bash
# Install Heroku CLI
# Login
heroku login

# Create app
cd backend-new
heroku create dhanvantri-backend

# Add environment variables
heroku config:set NODE_ENV=production
heroku config:set MONGODB_URI="..."
heroku config:set JWT_SECRET="..."

# Deploy
git push heroku main
```

#### Option D: DigitalOcean/AWS/Azure

**Server Setup (Ubuntu):**
```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install Node.js
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install -y nodejs

# Install PM2
sudo npm install -g pm2

# Clone repository
git clone <your-repo>
cd backend-new

# Install dependencies
npm install
npm run build

# Create .env file
nano .env
# Add production variables

# Start with PM2
pm2 start dist/server.js --name dhanvantri-backend
pm2 save
pm2 startup

# Setup Nginx reverse proxy
sudo apt install nginx
sudo nano /etc/nginx/sites-available/dhanvantri
```

**Nginx Configuration:**
```nginx
server {
    listen 80;
    server_name api.yourdomain.com;

    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}
```

```bash
# Enable site
sudo ln -s /etc/nginx/sites-available/dhanvantri /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx

# Setup SSL with Let's Encrypt
sudo apt install certbot python3-certbot-nginx
sudo certbot --nginx -d api.yourdomain.com
```

---

### 2. AI Service Deployment

#### Option A: Render

1. Create Python Web Service
2. Configure:
   ```
   Build Command: pip install -r requirements.txt
   Start Command: uvicorn main:app --host 0.0.0.0 --port $PORT
   Environment: Python 3.9+
   ```
3. Add environment variables
4. Deploy!

#### Option B: Railway

```bash
cd ai-service
railway init
railway up
```

#### Option C: Server Deployment

```bash
# Install Python
sudo apt install python3.9 python3-pip python3-venv

# Clone and setup
cd ai-service
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt

# Install Gunicorn
pip install gunicorn

# Create systemd service
sudo nano /etc/systemd/system/dhanvantri-ai.service
```

**Systemd Service File:**
```ini
[Unit]
Description=Dhanvantri AI Service
After=network.target

[Service]
User=www-data
WorkingDirectory=/path/to/ai-service
Environment="PATH=/path/to/ai-service/venv/bin"
ExecStart=/path/to/ai-service/venv/bin/gunicorn -w 4 -k uvicorn.workers.UvicornWorker main:app --bind 0.0.0.0:8000

[Install]
WantedBy=multi-user.target
```

```bash
# Enable and start
sudo systemctl enable dhanvantri-ai
sudo systemctl start dhanvantri-ai
sudo systemctl status dhanvantri-ai
```

---

### 3. Database - MongoDB Atlas (Recommended)

**Steps:**
1. Create account at [mongodb.com/cloud/atlas](https://www.mongodb.com/cloud/atlas)
2. Create new cluster (Free M0 tier available)
3. Configure:
   - Cloud Provider: AWS/GCP/Azure
   - Region: Closest to your backend server
4. Create database user
5. Whitelist IP addresses:
   - Add backend server IP
   - Or use 0.0.0.0/0 for development (not recommended for production)
6. Get connection string:
   ```
   mongodb+srv://username:password@cluster.mongodb.net/dhanvantri?retryWrites=true&w=majority
   ```
7. Add to backend environment variables

**Database Backups:**
```bash
# Export database
mongodump --uri="mongodb+srv://..." --out=./backup

# Import database
mongorestore --uri="mongodb+srv://..." ./backup
```

---

## 🔒 Security Best Practices

### 1. Environment Variables
- Never commit .env files
- Use strong, random JWT_SECRET (32+ characters)
- Use production Razorpay keys in production
- Rotate secrets regularly

### 2. CORS Configuration
```typescript
// Update in app.ts
const corsOptions = {
  origin: [
    'https://yourdomain.com',
    'https://www.yourdomain.com',
    // Add Flutter app URLs
  ],
  credentials: true,
};
```

### 3. Rate Limiting
```bash
npm install express-rate-limit
```

```typescript
import rateLimit from 'express-rate-limit';

const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100 // limit each IP to 100 requests per windowMs
});

app.use('/api', limiter);
```

### 4. Helmet Security Headers
Already configured in app.ts - ensure it's enabled

### 5. MongoDB Security
- Use strong passwords
- Enable IP whitelisting
- Enable MongoDB authentication
- Use encrypted connections (SSL/TLS)

---

## 📊 Monitoring & Logging

### 1. Error Tracking - Sentry

```bash
npm install @sentry/node
```

```typescript
import * as Sentry from '@sentry/node';

Sentry.init({
  dsn: process.env.SENTRY_DSN,
  environment: process.env.NODE_ENV,
});

// Use in error middleware
app.use(Sentry.Handlers.errorHandler());
```

### 2. Application Monitoring - New Relic / Datadog

Follow provider-specific setup guides.

### 3. Log Management

**Using Winston:**
```bash
npm install winston
```

```typescript
import winston from 'winston';

const logger = winston.createLogger({
  level: 'info',
  format: winston.format.json(),
  transports: [
    new winston.transports.File({ filename: 'error.log', level: 'error' }),
    new winston.transports.File({ filename: 'combined.log' }),
  ],
});
```

---

## 🧪 Pre-Production Testing

### 1. Load Testing with Apache Bench

```bash
# Install Apache Bench
sudo apt install apache2-utils

# Test login endpoint
ab -n 1000 -c 10 -p login.json -T application/json \
  http://localhost:3000/api/v1/auth/login
```

### 2. API Testing with Newman (Postman CLI)

```bash
npm install -g newman

# Run Postman collection
newman run dhanvantri-api-tests.json
```

### 3. Security Scanning

```bash
# Install OWASP Dependency Check
npm audit

# Fix vulnerabilities
npm audit fix
```

---

## 🔄 CI/CD Pipeline

### GitHub Actions

Create `.github/workflows/deploy.yml`:

```yaml
name: Deploy Backend

on:
  push:
    branches: [ main ]

jobs:
  deploy:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v2
    
    - name: Setup Node.js
      uses: actions/setup-node@v2
      with:
        node-version: '18'
    
    - name: Install dependencies
      run: |
        cd backend-new
        npm install
    
    - name: Build
      run: |
        cd backend-new
        npm run build
    
    - name: Deploy to Render
      env:
        RENDER_API_KEY: ${{ secrets.RENDER_API_KEY }}
      run: |
        curl -X POST https://api.render.com/v1/services/$RENDER_SERVICE_ID/deploys \
          -H "Authorization: Bearer $RENDER_API_KEY"
```

---

## 📱 Flutter App Configuration

### Update API Base URLs

```dart
// lib/core/config/api_config.dart
class ApiConfig {
  static const String backendBaseUrl = 
    const String.fromEnvironment(
      'API_URL',
      defaultValue: 'https://api.yourdomain.com/api/v1',
    );
  
  static const String aiBaseUrl = 
    const String.fromEnvironment(
      'AI_URL',
      defaultValue: 'https://ai.yourdomain.com/ai',
    );
}
```

**Build with environment variables:**
```bash
flutter build apk --dart-define=API_URL=https://api.yourdomain.com/api/v1
```

---

## 🎯 Post-Deployment

### 1. Health Checks
```bash
# Backend health
curl https://api.yourdomain.com/health

# AI service health
curl https://ai.yourdomain.com/health
```

### 2. Database Seeding (if needed)

Create seed script in `backend-new/src/scripts/seed.ts`:
```typescript
import mongoose from 'mongoose';
import Doctor from '../modules/doctors/doctor.model';

const seedDoctors = async () => {
  await Doctor.insertMany([
    { /* doctor data */ },
  ]);
};

seedDoctors().then(() => process.exit());
```

Run:
```bash
ts-node src/scripts/seed.ts
```

### 3. Documentation
- Update API documentation with production URLs
- Share Postman collection with team
- Document deployment process

### 4. Monitoring Setup
- Configure uptime monitoring (UptimeRobot, Pingdom)
- Set up error alerts
- Monitor database performance

---

## 🆘 Troubleshooting

### Backend Issues

**Port already in use:**
```bash
# Find process
lsof -i :3000
# Kill process
kill -9 <PID>
```

**MongoDB connection timeout:**
- Check MongoDB Atlas IP whitelist
- Verify connection string
- Check network connectivity

**Memory issues:**
- Increase server RAM
- Optimize database queries
- Add indexes

### AI Service Issues

**Import errors:**
```bash
pip install --upgrade -r requirements.txt
```

**Port conflicts:**
```bash
# Run on different port
uvicorn main:app --port 8001
```

---

## 📞 Support Resources

- **MongoDB Atlas**: https://docs.atlas.mongodb.com/
- **Render**: https://render.com/docs
- **Railway**: https://docs.railway.app/
- **Razorpay**: https://razorpay.com/docs/
- **FastAPI**: https://fastapi.tiangolo.com/

---

## ✅ Deployment Checklist

**Before Deployment:**
- [ ] All tests passing
- [ ] Environment variables configured
- [ ] Database migrations completed
- [ ] Security headers configured
- [ ] CORS origins updated
- [ ] Rate limiting enabled
- [ ] Error tracking set up

**After Deployment:**
- [ ] Health checks passing
- [ ] All API endpoints working
- [ ] Payment flow tested
- [ ] Database connected
- [ ] Monitoring configured
- [ ] Backups scheduled
- [ ] SSL certificates valid
- [ ] Documentation updated

---

**🎉 Your backend is now production-ready!**
