import mongoose, { Schema, Document, Types } from 'mongoose';

export interface IPayment extends Document {
  _id: Types.ObjectId;
  userId: mongoose.Types.ObjectId;
  orderId: string;
  razorpayOrderId?: string;
  razorpayPaymentId?: string;
  razorpaySignature?: string;
  type: 'appointment' | 'pharmacy' | 'ambulance' | 'donation';
  referenceId: mongoose.Types.ObjectId; // Reference to Appointment, PharmacyOrder, Ambulance, or Donation
  amount: number;
  currency: string;
  status: 'pending' | 'processing' | 'success' | 'failed' | 'refunded';
  paymentMethod?: 'card' | 'upi' | 'netbanking' | 'wallet';
  failureReason?: string;
  refundAmount?: number;
  refundedAt?: Date;
  metadata?: Record<string, any>;
  createdAt: Date;
  updatedAt: Date;
}

const PaymentSchema: Schema = new Schema(
  {
    userId: {
      type: Schema.Types.ObjectId,
      ref: 'User',
      required: [true, 'User ID is required'],
    },
    orderId: {
      type: String,
      required: true,
      unique: true,
    },
    razorpayOrderId: {
      type: String,
    },
    razorpayPaymentId: {
      type: String,
    },
    razorpaySignature: {
      type: String,
    },
    type: {
      type: String,
      enum: ['appointment', 'pharmacy', 'ambulance', 'donation'],
      required: [true, 'Payment type is required'],
    },
    referenceId: {
      type: Schema.Types.ObjectId,
      required: [true, 'Reference ID is required'],
    },
    amount: {
      type: Number,
      required: [true, 'Amount is required'],
      min: 0,
    },
    currency: {
      type: String,
      default: 'INR',
    },
    status: {
      type: String,
      enum: ['pending', 'processing', 'success', 'failed', 'refunded'],
      default: 'pending',
    },
    paymentMethod: {
      type: String,
      enum: ['card', 'upi', 'netbanking', 'wallet'],
    },
    failureReason: {
      type: String,
    },
    refundAmount: {
      type: Number,
      min: 0,
    },
    refundedAt: {
      type: Date,
    },
    metadata: {
      type: Schema.Types.Mixed,
    },
  },
  {
    timestamps: true,
  }
);

// Generate order ID
PaymentSchema.pre('save', async function (next) {
  if (!this.orderId) {
    const count = await mongoose.model('Payment').countDocuments();
    const date = new Date().toISOString().slice(0, 10).replace(/-/g, '');
    this.orderId = `PAY${date}${String(count + 1).padStart(6, '0')}`;
  }
  next();
});

// Indexes
PaymentSchema.index({ userId: 1, createdAt: -1 });
PaymentSchema.index({ status: 1, type: 1 });
PaymentSchema.index({ razorpayOrderId: 1 });

export const Payment = mongoose.model<IPayment>('Payment', PaymentSchema);
