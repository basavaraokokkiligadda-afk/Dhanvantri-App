import { Request, Response } from 'express';
// @ts-ignore - Razorpay doesn't have TypeScript definitions
import Razorpay from 'razorpay';
import crypto from 'crypto';
import { config } from '../../config/config';
import { Payment } from './payment.model';
import { Appointment } from '../appointments/appointment.model';
import { PharmacyOrder } from '../pharmacy/pharmacy.model';
import { Ambulance } from '../ambulance/ambulance.model';
import { sendSuccess, sendError } from '../../common/utils/response.utils';

// Initialize Razorpay
const razorpay = new Razorpay({
  key_id: config.razorpay.keyId,
  key_secret: config.razorpay.keySecret,
});

/**
 * Create Razorpay order
 */
export const createOrder = async (req: any, res: Response): Promise<void> => {
  try {
    const { type, referenceId, amount } = req.body;

    // Validate reference
    let reference;
    switch (type) {
      case 'appointment':
        reference = await Appointment.findById(referenceId);
        break;
      case 'pharmacy':
        reference = await PharmacyOrder.findById(referenceId);
        break;
      case 'ambulance':
        reference = await Ambulance.findById(referenceId);
        break;
      default:
        sendError(res, 400, 'Invalid payment type');
        return;
    }

    if (!reference) {
      sendError(res, 404, 'Reference not found');
      return;
    }

    // Create Razorpay order
    const options = {
      amount: amount * 100, // amount in paise
      currency: 'INR',
      receipt: `${type}_${referenceId}`,
    };

    const razorpayOrder = await razorpay.orders.create(options);

    // Create payment record
    const payment = await Payment.create({
      userId: req.user.id,
      type,
      referenceId,
      amount,
      razorpayOrderId: razorpayOrder.id,
      status: 'pending',
    });

    sendSuccess(res, 201, 'Payment order created successfully', {
      payment,
      razorpayOrder,
      razorpayKeyId: config.razorpay.keyId,
    });
  } catch (error: any) {
    sendError(res, 500, 'Error creating payment order', error.message);
  }
};

/**
 * Verify payment
 */
export const verifyPayment = async (req: any, res: Response): Promise<void> => {
  try {
    const { razorpayOrderId, razorpayPaymentId, razorpaySignature } = req.body;

    // Verify signature
    const generatedSignature = crypto
      .createHmac('sha256', config.razorpay.keySecret)
      .update(`${razorpayOrderId}|${razorpayPaymentId}`)
      .digest('hex');

    if (generatedSignature !== razorpaySignature) {
      sendError(res, 400, 'Invalid payment signature');
      return;
    }

    // Update payment
    const payment = await Payment.findOneAndUpdate(
      { razorpayOrderId },
      {
        razorpayPaymentId,
        razorpaySignature,
        status: 'success',
      },
      { new: true }
    );

    if (!payment) {
      sendError(res, 404, 'Payment not found');
      return;
    }

    // Update reference (appointment/order/ambulance)
    switch (payment.type) {
      case 'appointment':
        await Appointment.findByIdAndUpdate(payment.referenceId, {
          paymentId: payment._id,
          paymentStatus: 'paid',
          status: 'confirmed',
        });
        break;
      case 'pharmacy':
        await PharmacyOrder.findByIdAndUpdate(payment.referenceId, {
          paymentId: payment._id,
          paymentStatus: 'paid',
          status: 'confirmed',
        });
        break;
      case 'ambulance':
        await Ambulance.findByIdAndUpdate(payment.referenceId, {
          paymentId: payment._id,
          paymentStatus: 'paid',
          status: 'confirmed',
        });
        break;
    }

    sendSuccess(res, 200, 'Payment verified successfully', { payment });
  } catch (error: any) {
    sendError(res, 500, 'Error verifying payment', error.message);
  }
};

/**
 * Get payment by ID
 */
export const getPaymentById = async (req: Request, res: Response): Promise<void> => {
  try {
    const { id } = req.params;

    const payment = await Payment.findById(id).populate('userId', 'name email');

    if (!payment) {
      sendError(res, 404, 'Payment not found');
      return;
    }

    sendSuccess(res, 200, 'Payment retrieved successfully', { payment });
  } catch (error: any) {
    sendError(res, 500, 'Error retrieving payment', error.message);
  }
};

/**
 * Get user payments
 */
export const getUserPayments = async (req: any, res: Response): Promise<void> => {
  try {
    const { type, status } = req.query;
    const query: any = { userId: req.user.id };

    if (type) query.type = type;
    if (status) query.status = status;

    const payments = await Payment.find(query).sort({ createdAt: -1 });

    sendSuccess(res, 200, 'Payments retrieved successfully', { payments });
  } catch (error: any) {
    sendError(res, 500, 'Error retrieving payments', error.message);
  }
};
