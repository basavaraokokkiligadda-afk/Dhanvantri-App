import mongoose, { Schema, Document, Types } from 'mongoose';

export interface IMedicine extends Document {
  _id: Types.ObjectId;
  name: string;
  category: string;
  manufacturer: string;
  description?: string;
  composition?: string;
  dosage?: string;
  price: number;
  stock: number;
  requiresPrescription: boolean;
  imageUrl?: string;
  expiryDate?: Date;
  sideEffects?: string[];
  precautions?: string[];
  isActive: boolean;
  createdAt: Date;
  updatedAt: Date;
}

const MedicineSchema: Schema = new Schema(
  {
    name: {
      type: String,
      required: [true, 'Medicine name is required'],
      trim: true,
    },
    category: {
      type: String,
      required: [true, 'Category is required'],
    },
    manufacturer: {
      type: String,
      required: [true, 'Manufacturer is required'],
    },
    description: {
      type: String,
    },
    composition: {
      type: String,
    },
    dosage: {
      type: String,
    },
    price: {
      type: Number,
      required: [true, 'Price is required'],
      min: 0,
    },
    stock: {
      type: Number,
      required: [true, 'Stock is required'],
      min: 0,
      default: 0,
    },
    requiresPrescription: {
      type: Boolean,
      default: false,
    },
    imageUrl: {
      type: String,
    },
    expiryDate: {
      type: Date,
    },
    sideEffects: [{
      type: String,
    }],
    precautions: [{
      type: String,
    }],
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
MedicineSchema.index({ name: 'text', category: 1 });
MedicineSchema.index({ category: 1, isActive: 1 });

export const Medicine = mongoose.model<IMedicine>('Medicine', MedicineSchema);

export interface IPharmacyOrder extends Document {
  _id: Types.ObjectId;
  orderNumber: string;
  userId: mongoose.Types.ObjectId;
  items: {
    medicineId: mongoose.Types.ObjectId;
    name: string;
    quantity: number;
    price: number;
  }[];
  totalAmount: number;
  deliveryAddress: {
    street: string;
    city: string;
    state: string;
    zipCode: string;
  };
  deliveryCharge: number;
  prescriptionUrl?: string;
  status: 'pending' | 'confirmed' | 'processing' | 'out_for_delivery' | 'delivered' | 'cancelled';
  paymentId?: mongoose.Types.ObjectId;
  paymentStatus: 'pending' | 'paid' | 'failed' | 'refunded';
  deliveryDate?: Date;
  cancelReason?: string;
  createdAt: Date;
  updatedAt: Date;
}

const PharmacyOrderSchema: Schema = new Schema(
  {
    orderNumber: {
      type: String,
      required: true,
      unique: true,
    },
    userId: {
      type: Schema.Types.ObjectId,
      ref: 'User',
      required: [true, 'User ID is required'],
    },
    items: [{
      medicineId: {
        type: Schema.Types.ObjectId,
        ref: 'Medicine',
        required: true,
      },
      name: {
        type: String,
        required: true,
      },
      quantity: {
        type: Number,
        required: true,
        min: 1,
      },
      price: {
        type: Number,
        required: true,
        min: 0,
      },
    }],
    totalAmount: {
      type: Number,
      required: [true, 'Total amount is required'],
      min: 0,
    },
    deliveryAddress: {
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
    },
    deliveryCharge: {
      type: Number,
      default: 0,
      min: 0,
    },
    prescriptionUrl: {
      type: String,
    },
    status: {
      type: String,
      enum: ['pending', 'confirmed', 'processing', 'out_for_delivery', 'delivered', 'cancelled'],
      default: 'pending',
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
    deliveryDate: {
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

// Generate order number
PharmacyOrderSchema.pre('save', async function (next) {
  if (!this.orderNumber) {
    const count = await mongoose.model('PharmacyOrder').countDocuments();
    const date = new Date().toISOString().slice(0, 10).replace(/-/g, '');
    this.orderNumber = `MED${date}${String(count + 1).padStart(4, '0')}`;
  }
  next();
});

// Indexes
PharmacyOrderSchema.index({ userId: 1, createdAt: -1 });
PharmacyOrderSchema.index({ status: 1 });

export const PharmacyOrder = mongoose.model<IPharmacyOrder>('PharmacyOrder', PharmacyOrderSchema);
