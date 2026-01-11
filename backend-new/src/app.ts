import express, { Application } from 'express';
import cors from 'cors';
import helmet from 'helmet';
import morgan from 'morgan';
import { config } from './config/config';
import { errorHandler, notFoundHandler } from './common/middleware/error.middleware';

// Import routes
import authRoutes from './modules/auth/auth.routes';
import doctorRoutes from './modules/doctors/doctor.routes';
import appointmentRoutes from './modules/appointments/appointment.routes';
import paymentRoutes from './modules/payments/payment.routes';

const app: Application = express();

// Security middleware
app.use(helmet());
app.use(cors({
  origin: config.cors.origins,
  credentials: true,
}));

// Body parsing middleware
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true, limit: '10mb' }));

// Logging middleware
if (config.env === 'development') {
  app.use(morgan('dev'));
}

// Health check
app.get('/health', (_req, res) => {
  res.json({
    success: true,
    message: 'Dhanvantri Healthcare API is running',
    version: config.apiVersion,
    environment: config.env,
    timestamp: new Date().toISOString(),
  });
});

// API Routes
const API_PREFIX = `/api/${config.apiVersion}`;

app.use(`${API_PREFIX}/auth`, authRoutes);
app.use(`${API_PREFIX}/doctors`, doctorRoutes);
app.use(`${API_PREFIX}/appointments`, appointmentRoutes);
app.use(`${API_PREFIX}/payments`, paymentRoutes);

// Error handling
app.use(notFoundHandler);
app.use(errorHandler);

export default app;
