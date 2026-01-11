import mongoose, { Schema, Document, Types } from 'mongoose';

export interface IHospital extends Document {
  _id: Types.ObjectId;
  name: string;
  email: string;
  phone: string;
  address: {
    street: string;
    city: string;
    state: string;
    zipCode: string;
    coordinates?: {
      latitude: number;
      longitude: number;
    };
  };
  description?: string;
  imageUrl?: string;
  specialties: string[];
  facilities: string[];
  departments: string[];
  emergencyServices: boolean;
  rating: number;
  reviewCount: number;
  openingHours: {
    start: string;
    end: string;
  };
  beds: {
    total: number;
    available: number;
  };
  isActive: boolean;
  createdAt: Date;
  updatedAt: Date;
}

const HospitalSchema: Schema = new Schema(
  {
    name: {
      type: String,
      required: [true, 'Hospital name is required'],
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
    address: {
      street: {
        type: String,
        required: true,
      },
      city: {
        type: String,
        required: true,
      },
      state: {
        type: String,
        required: true,
      },
      zipCode: {
        type: String,
        required: true,
      },
      coordinates: {
        latitude: Number,
        longitude: Number,
      },
    },
    description: {
      type: String,
    },
    imageUrl: {
      type: String,
    },
    specialties: [{
      type: String,
    }],
    facilities: [{
      type: String,
    }],
    departments: [{
      type: String,
    }],
    emergencyServices: {
      type: Boolean,
      default: true,
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
    },
    openingHours: {
      start: {
        type: String,
        default: '00:00',
      },
      end: {
        type: String,
        default: '23:59',
      },
    },
    beds: {
      total: {
        type: Number,
        default: 0,
      },
      available: {
        type: Number,
        default: 0,
      },
    },
    isActive: {
      type: Boolean,
      default: true,
    },
  },
  {
    timestamps: true,
  }
);

// Indexes
HospitalSchema.index({ 'address.city': 1, emergencyServices: 1 });
HospitalSchema.index({ specialties: 1 });

export const Hospital = mongoose.model<IHospital>('Hospital', HospitalSchema);
