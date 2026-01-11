import { Request, Response } from 'express';
import { Appointment } from './appointment.model';
import { Doctor } from '../doctors/doctor.model';
import { sendSuccess, sendError, getPagination } from '../../common/utils/response.utils';

/**
 * Create new appointment
 */
export const createAppointment = async (req: any, res: Response): Promise<void> => {
  try {
    const appointmentData = {
      ...req.body,
      patientId: req.user.id,
    };

    // Check if doctor exists and is available
    const doctor = await Doctor.findById(req.body.doctorId);
    if (!doctor) {
      sendError(res, 404, 'Doctor not found');
      return;
    }

    if (!doctor.isAvailable) {
      sendError(res, 400, 'Doctor is not available');
      return;
    }

    // Set fee from doctor's consultation fee
    appointmentData.fee = req.body.fee || doctor.consultationFee;

    const appointment = await Appointment.create(appointmentData);

    sendSuccess(res, 201, 'Appointment created successfully', { appointment });
  } catch (error: any) {
    sendError(res, 500, 'Error creating appointment', error.message);
  }
};

/**
 * Get all appointments for current user
 */
export const getMyAppointments = async (req: any, res: Response): Promise<void> => {
  try {
    const { status, page = 1, limit = 10 } = req.query;
    const query: any = {};

    if (req.user.role === 'patient') {
      query.patientId = req.user.id;
    } else if (req.user.role === 'doctor') {
      const doctor = await Doctor.findOne({ userId: req.user.id });
      if (doctor) {
        query.doctorId = doctor._id;
      }
    }

    if (status) query.status = status;

    const skip = (Number(page) - 1) * Number(limit);

    const appointments = await Appointment.find(query)
      .populate('doctorId', 'name specialization imageUrl')
      .populate('patientId', 'name email phone')
      .sort({ date: -1, createdAt: -1 })
      .limit(Number(limit))
      .skip(skip);

    const total = await Appointment.countDocuments(query);

    sendSuccess(
      res,
      200,
      'Appointments retrieved successfully',
      { appointments },
      getPagination(Number(page), Number(limit), total)
    );
  } catch (error: any) {
    sendError(res, 500, 'Error retrieving appointments', error.message);
  }
};

/**
 * Get appointment by ID
 */
export const getAppointmentById = async (req: Request, res: Response): Promise<void> => {
  try {
    const { id } = req.params;

    const appointment = await Appointment.findById(id)
      .populate('doctorId', 'name specialization imageUrl consultationFee')
      .populate('patientId', 'name email phone')
      .populate('hospitalId', 'name address');

    if (!appointment) {
      sendError(res, 404, 'Appointment not found');
      return;
    }

    sendSuccess(res, 200, 'Appointment retrieved successfully', { appointment });
  } catch (error: any) {
    sendError(res, 500, 'Error retrieving appointment', error.message);
  }
};

/**
 * Update appointment status
 */
export const updateAppointmentStatus = async (req: any, res: Response): Promise<void> => {
  try {
    const { id } = req.params;
    const { status, cancelReason } = req.body;

    const appointment = await Appointment.findById(id);
    if (!appointment) {
      sendError(res, 404, 'Appointment not found');
      return;
    }

    appointment.status = status;
    
    if (status === 'cancelled') {
      appointment.cancelReason = cancelReason;
      appointment.cancelledBy = req.user.role === 'patient' ? 'patient' : 'doctor';
      appointment.cancelledAt = new Date();
    } else if (status === 'completed') {
      appointment.completedAt = new Date();
    }

    await appointment.save();

    sendSuccess(res, 200, 'Appointment status updated successfully', { appointment });
  } catch (error: any) {
    sendError(res, 500, 'Error updating appointment', error.message);
  }
};

/**
 * Cancel appointment
 */
export const cancelAppointment = async (req: any, res: Response): Promise<void> => {
  try {
    const { id } = req.params;
    const { cancelReason } = req.body;

    const appointment = await Appointment.findById(id);
    if (!appointment) {
      sendError(res, 404, 'Appointment not found');
      return;
    }

    if (appointment.status === 'completed' || appointment.status === 'cancelled') {
      sendError(res, 400, 'Cannot cancel this appointment');
      return;
    }

    appointment.status = 'cancelled';
    appointment.cancelReason = cancelReason;
    appointment.cancelledBy = req.user.role === 'patient' ? 'patient' : 'doctor';
    appointment.cancelledAt = new Date();

    await appointment.save();

    sendSuccess(res, 200, 'Appointment cancelled successfully', { appointment });
  } catch (error: any) {
    sendError(res, 500, 'Error cancelling appointment', error.message);
  }
};
