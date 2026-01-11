import { Router } from 'express';
import { body } from 'express-validator';
import {
  createAppointment,
  getMyAppointments,
  getAppointmentById,
  updateAppointmentStatus,
  cancelAppointment,
} from './appointment.controller';
import { authenticate } from '../../common/middleware/auth.middleware';
import { validate } from '../../common/middleware/validate.middleware';

const router = Router();

/**
 * @route   POST /api/appointments
 * @desc    Create new appointment
 * @access  Private
 */
router.post(
  '/',
  [
    authenticate,
    body('doctorId').notEmpty().withMessage('Doctor ID is required'),
    body('date').isISO8601().withMessage('Valid date is required'),
    body('time').notEmpty().withMessage('Time is required'),
    body('type').isIn(['video', 'clinic', 'home']).withMessage('Valid type is required'),
    validate,
  ],
  createAppointment
);

/**
 * @route   GET /api/appointments
 * @desc    Get all appointments for current user
 * @access  Private
 */
router.get('/', authenticate, getMyAppointments);

/**
 * @route   GET /api/appointments/:id
 * @desc    Get appointment by ID
 * @access  Private
 */
router.get('/:id', authenticate, getAppointmentById);

/**
 * @route   PATCH /api/appointments/:id/status
 * @desc    Update appointment status
 * @access  Private
 */
router.patch('/:id/status', authenticate, updateAppointmentStatus);

/**
 * @route   PATCH /api/appointments/:id/cancel
 * @desc    Cancel appointment
 * @access  Private
 */
router.patch('/:id/cancel', authenticate, cancelAppointment);

export default router;
