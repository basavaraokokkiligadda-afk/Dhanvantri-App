import mongoose, { Schema, Document, Types } from 'mongoose';

export interface IAmbulance extends Document {
  _id: Types.ObjectId;
  bookingNumber: string;
  userId: mongoose.Types.ObjectId;
  appointmentId?: mongoose.Types.ObjectId;
  type: 'basic' | 'advanced' | 'cardiac';
  pickupAddress: {
    street: string;
    city: string;
    state: string;
    zipCode: string;
    coordinates?: {
      latitude: number;
      longitude: number;
    };
  };
  dropAddress: {
    street: string;
    city: string;
    state: string;
    zipCode: string;
    coordinates?: {
      latitude: number;
      longitude: number;
    };
  };
  patientDetails: {
    name: string;
    age: number;
    condition: string;
  };
  isEmergency: boolean;
  emergencyContact: {
    name: string;
    phone: string;
  };
  status: 'pending' | 'confirmed' | 'dispatched' | 'arrived' | 'in_transit' | 'completed' | 'cancelled';
  driver?: {
    name: string;
    phone: string;
    vehicleNumber: string;
  };
  estimatedTime?: number; // in minutes
  actualTime?: number;
  baseFare: number;
  emergencyCharge: number;
  totalFare: number;
  paymentId?: mongoose.Types.ObjectId;
  paymentStatus: 'pending' | 'paid' | 'failed' | 'refunded';
  dispatchedAt?: Date;
  arrivedAt?: Date;
  completedAt?: Date;
  cancelReason?: string;
  createdAt: Date;
  updatedAt: Date;
}

const AmbulanceSchema: Schema = new Schema(
  {
    bookingNumber: {
      type: String,
      required: true,
      unique: true,
    },
    userId: {
      type: Schema.Types.ObjectId,
      ref: 'User',
      required: [true, 'User ID is required'],
    },
    appointmentId: {
      type: Schema.Types.ObjectId,
      ref: 'Appointment',
    },
    type: {
      type: String,
      enum: ['basic', 'advanced', 'cardiac'],
      required: [true, 'Ambulance type is required'],
    },
    pickupAddress: {
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
    dropAddress: {
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
    patientDetails: {
      name: {
        type: String,
        required: true,
      },
      age: {
        type: Number,
        required: true,
      },
      condition: {
        type: String,
        required: true,
      },
    },
    isEmergency: {
      type: Boolean,
      default: false,
    },
    emergencyContact: {
      name: {
        type: String,
        required: true,
      },
      phone: {
        type: String,
        required: true,
      },
    },
    status: {
      type: String,
      enum: ['pending', 'confirmed', 'dispatched', 'arrived', 'in_transit', 'completed', 'cancelled'],
      default: 'pending',
    },
    driver: {
      name: String,
      phone: String,
      vehicleNumber: String,
    },
    estimatedTime: {
      type: Number,
    },
    actualTime: {
      type: Number,
    },
    baseFare: {
      type: Number,
      required: [true, 'Base fare is required'],
      min: 0,
    },
    emergencyCharge: {
      type: Number,
      default: 0,
      min: 0,
    },
    totalFare: {
      type: Number,
      required: [true, 'Total fare is required'],
      min: 0,
    },
    paymentId: {
      type: Schema.Types.ObjectId,
      ref: 'Payment',
    },
    paymentStatus: {
      type: String,
      enum: ['pending', 'paid', 'failed', 'refunded'],
      default: 'pending',
    },
    dispatchedAt: {
      type: Date,
    },
    arrivedAt: {
      type: Date,
    },
    completedAt: {
      type: Date,
    },
    cancelReason: {
      type: String,
    },
  },
  {
    timestamps: true,
  }
);

// Generate booking number
AmbulanceSchema.pre('save', async function (next) {
  if (!this.bookingNumber) {
    const count = await mongoose.model('Ambulance').countDocuments();
    const date = new Date().toISOString().slice(0, 10).replace(/-/g, '');
    this.bookingNumber = `AMB${date}${String(count + 1).padStart(4, '0')}`;
  }
  next();
});

// Indexes
AmbulanceSchema.index({ userId: 1, createdAt: -1 });
AmbulanceSchema.index({ status: 1, isEmergency: 1 });

export const Ambulance = mongoose.model<IAmbulance>('Ambulance', AmbulanceSchema);
