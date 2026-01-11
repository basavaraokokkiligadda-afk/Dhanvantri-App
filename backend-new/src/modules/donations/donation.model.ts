import mongoose, { Schema, Document, Types } from 'mongoose';

export interface IDonation extends Document {
  _id: Types.ObjectId;
  donationNumber: string;
  userId: mongoose.Types.ObjectId;
  campaign: {
    title: string;
    description: string;
    targetAmount: number;
    raisedAmount: number;
  };
  amount: number;
  isAnonymous: boolean;
  message?: string;
  paymentId?: mongoose.Types.ObjectId;
  status: 'pending' | 'completed' | 'failed' | 'refunded';
  certificateUrl?: string;
  createdAt: Date;
  updatedAt: Date;
}

const DonationSchema: Schema = new Schema(
  {
    donationNumber: {
      type: String,
      required: true,
      unique: true,
    },
    userId: {
      type: Schema.Types.ObjectId,
      ref: 'User',
      required: [true, 'User ID is required'],
    },
    campaign: {
      title: {
        type: String,
        required: true,
      },
      description: {
        type: String,
      },
      targetAmount: {
        type: Number,
        required: true,
        min: 0,
      },
      raisedAmount: {
        type: Number,
        default: 0,
        min: 0,
      },
    },
    amount: {
      type: Number,
      required: [true, 'Donation amount is required'],
      min: 1,
    },
    isAnonymous: {
      type: Boolean,
      default: false,
    },
    message: {
      type: String,
    },
    paymentId: {
      type: Schema.Types.ObjectId,
      ref: 'Payment',
    },
    status: {
      type: String,
      enum: ['pending', 'completed', 'failed', 'refunded'],
      default: 'pending',
    },
    certificateUrl: {
      type: String,
    },
  },
  {
    timestamps: true,
  }
);

// Generate donation number
DonationSchema.pre('save', async function (next) {
  if (!this.donationNumber) {
    const count = await mongoose.model('Donation').countDocuments();
    const date = new Date().toISOString().slice(0, 10).replace(/-/g, '');
    this.donationNumber = `DON${date}${String(count + 1).padStart(4, '0')}`;
  }
  next();
});

// Indexes
DonationSchema.index({ userId: 1, createdAt: -1 });
DonationSchema.index({ status: 1 });

export const Donation = mongoose.model<IDonation>('Donation', DonationSchema);
