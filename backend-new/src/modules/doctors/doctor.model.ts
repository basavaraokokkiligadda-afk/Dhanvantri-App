import mongoose, { Schema, Document, Types } from 'mongoose';

export interface IDoctor extends Document {
  _id: Types.ObjectId;
  userId: mongoose.Types.ObjectId;
  name: string;
  email: string;
  phone: string;
  specialization: string;
  experience: number;
  qualifications: string[];
  registrationNumber: string;
  hospital?: string;
  hospitalId?: mongoose.Types.ObjectId;
  address?: string;
  about?: string;
  consultationFee: number;
  rating: number;
  reviewCount: number;
  imageUrl?: string;
  languages?: string[];
  availableDays?: string[];
  workingHours?: {
    start: string;
    end: string;
  };
  isAvailable: boolean;
  isVerified: boolean;
  createdAt: Date;
  updatedAt: Date;
}

const DoctorSchema: Schema = new Schema(
  {
    userId: {
      type: Schema.Types.ObjectId,
      ref: 'User',
      required: true,
    },
    name: {
      type: String,
      required: [true, 'Doctor name is required'],
      trim: true,
    },
    email: {
      type: String,
      required: [true, 'Email is required'],
      unique: true,
      lowercase: true,
    },
    phone: {
      type: String,
      required: [true, 'Phone number is required'],
    },
    specialization: {
      type: String,
      required: [true, 'Specialization is required'],
    },
    experience: {
      type: Number,
      required: [true, 'Experience is required'],
      min: 0,
    },
    qualifications: [{
      type: String,
    }],
    registrationNumber: {
      type: String,
      required: [true, 'Medical registration number is required'],
      unique: true,
    },
    hospital: {
      type: String,
    },
    hospitalId: {
      type: Schema.Types.ObjectId,
      ref: 'Hospital',
    },
    address: {
      type: String,
    },
    about: {
      type: String,
    },
    consultationFee: {
      type: Number,
      required: [true, 'Consultation fee is required'],
      min: 0,
    },
    rating: {
      type: Number,
      default: 0,
      min: 0,
      max: 5,
    },
    reviewCount: {
      type: Number,
      default: 0,
      min: 0,
    },
    imageUrl: {
      type: String,
    },
    languages: [{
      type: String,
    }],
    availableDays: [{
      type: String,
      enum: ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'],
    }],
    workingHours: {
      start: {
        type: String,
        default: '09:00',
      },
      end: {
        type: String,
        default: '18:00',
      },
    },
    isAvailable: {
      type: Boolean,
      default: true,
    },
    isVerified: {
      type: Boolean,
      default: false,
    },
  },
  {
    timestamps: true,
  }
);

// Index for efficient queries
DoctorSchema.index({ specialization: 1, isAvailable: 1 });
DoctorSchema.index({ rating: -1 });

export const Doctor = mongoose.model<IDoctor>('Doctor', DoctorSchema);
