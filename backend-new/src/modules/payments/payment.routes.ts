import { Router } from 'express';
import { body } from 'express-validator';
import {
  createOrder,
  verifyPayment,
  getPaymentById,
  getUserPayments,
} from './payment.controller';
import { authenticate } from '../../common/middleware/auth.middleware';
import { validate } from '../../common/middleware/validate.middleware';

const router = Router();

/**
 * @route   POST /api/payments/create
 * @desc    Create payment order
 * @access  Private
 */
router.post(
  '/create',
  [
    authenticate,
    body('type').isIn(['appointment', 'pharmacy', 'ambulance', 'donation']),
    body('referenceId').notEmpty(),
    body('amount').isNumeric(),
    validate,
  ],
  createOrder
);

/**
 * @route   POST /api/payments/verify
 * @desc    Verify payment
 * @access  Private
 */
router.post(
  '/verify',
  [
    authenticate,
    body('razorpayOrderId').notEmpty(),
    body('razorpayPaymentId').notEmpty(),
    body('razorpaySignature').notEmpty(),
    validate,
  ],
  verifyPayment
);

/**
 * @route   GET /api/payments/:id
 * @desc    Get payment by ID
 * @access  Private
 */
router.get('/:id', authenticate, getPaymentById);

/**
 * @route   GET /api/payments
 * @desc    Get user payments
 * @access  Private
 */
router.get('/', authenticate, getUserPayments);

export default router;
