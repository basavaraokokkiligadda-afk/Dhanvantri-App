import mongoose, { Schema, Document, Types } from 'mongoose';

export interface IAppointment extends Document {
  _id: Types.ObjectId;
  appointmentNumber: string;
  patientId: mongoose.Types.ObjectId;
  doctorId: mongoose.Types.ObjectId;
  hospitalId?: mongoose.Types.ObjectId;
  date: Date;
  time: string;
  type: 'video' | 'clinic' | 'home';
  status: 'pending' | 'confirmed' | 'completed' | 'cancelled' | 'rescheduled';
  reason?: string;
  symptoms?: string[];
  notes?: string;
  prescriptions?: string[];
  fee: number;
  paymentId?: mongoose.Types.ObjectId;
  paymentStatus: 'pending' | 'paid' | 'failed' | 'refunded';
  cancelReason?: string;
  cancelledBy?: 'patient' | 'doctor' | 'admin';
  cancelledAt?: Date;
  completedAt?: Date;
  reminderSent: boolean;
  createdAt: Date;
  updatedAt: Date;
}

const AppointmentSchema: Schema = new Schema(
  {
    appointmentNumber: {
      type: String,
      required: true,
      unique: true,
    },
    patientId: {
      type: Schema.Types.ObjectId,
      ref: 'User',
      required: [true, 'Patient ID is required'],
    },
    doctorId: {
      type: Schema.Types.ObjectId,
      ref: 'Doctor',
      required: [true, 'Doctor ID is required'],
    },
    hospitalId: {
      type: Schema.Types.ObjectId,
      ref: 'Hospital',
    },
    date: {
      type: Date,
      required: [true, 'Appointment date is required'],
    },
    time: {
      type: String,
      required: [true, 'Appointment time is required'],
    },
    type: {
      type: String,
      enum: ['video', 'clinic', 'home'],
      default: 'clinic',
    },
    status: {
      type: String,
      enum: ['pending', 'confirmed', 'completed', 'cancelled', 'rescheduled'],
      default: 'pending',
    },
    reason: {
      type: String,
    },
    symptoms: [{
      type: String,
    }],
    notes: {
      type: String,
    },
    prescriptions: [{
      type: String,
    }],
    fee: {
      type: Number,
      required: [true, 'Appointment fee is required'],
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
    cancelReason: {
      type: String,
    },
    cancelledBy: {
      type: String,
      enum: ['patient', 'doctor', 'admin'],
    },
    cancelledAt: {
      type: Date,
    },
    completedAt: {
      type: Date,
    },
    reminderSent: {
      type: Boolean,
      default: false,
    },
  },
  {
    timestamps: true,
  }
);

// Generate appointment number
AppointmentSchema.pre('save', async function (next) {
  if (!this.appointmentNumber) {
    const count = await mongoose.model('Appointment').countDocuments();
    this.appointmentNumber = `APT${String(count + 1).padStart(6, '0')}`;
  }
  next();
});

// Indexes
AppointmentSchema.index({ patientId: 1, date: -1 });
AppointmentSchema.index({ doctorId: 1, date: 1 });
AppointmentSchema.index({ status: 1, date: 1 });

export const Appointment = mongoose.model<IAppointment>('Appointment', AppointmentSchema);
