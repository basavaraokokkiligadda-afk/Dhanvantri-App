import { Request, Response } from 'express';
import { Doctor } from './doctor.model';
import { sendSuccess, sendError, getPagination } from '../../common/utils/response.utils';

/**
 * Get all doctors with optional filters
 */
export const getAllDoctors = async (req: Request, res: Response): Promise<void> => {
  try {
    const {
      specialization,
      isAvailable,
      page = 1,
      limit = 10,
      search,
    } = req.query;

    const query: any = {};

    if (specialization) query.specialization = specialization;
    if (isAvailable !== undefined) query.isAvailable = isAvailable === 'true';
    if (search) {
      query.$or = [
        { name: { $regex: search, $options: 'i' } },
        { specialization: { $regex: search, $options: 'i' } },
      ];
    }

    const skip = (Number(page) - 1) * Number(limit);
    
    const doctors = await Doctor.find(query)
      .limit(Number(limit))
      .skip(skip)
      .sort({ rating: -1 });

    const total = await Doctor.countDocuments(query);

    sendSuccess(
      res,
      200,
      'Doctors retrieved successfully',
      { doctors },
      getPagination(Number(page), Number(limit), total)
    );
  } catch (error: any) {
    sendError(res, 500, 'Error retrieving doctors', error.message);
  }
};

/**
 * Get doctor by ID
 */
export const getDoctorById = async (req: Request, res: Response): Promise<void> => {
  try {
    const { id } = req.params;

    const doctor = await Doctor.findById(id).populate('userId', 'name email phone');

    if (!doctor) {
      sendError(res, 404, 'Doctor not found');
      return;
    }

    sendSuccess(res, 200, 'Doctor retrieved successfully', { doctor });
  } catch (error: any) {
    sendError(res, 500, 'Error retrieving doctor', error.message);
  }
};

/**
 * Get all specializations
 */
export const getSpecializations = async (_req: Request, res: Response): Promise<void> => {
  try {
    const specializations = await Doctor.distinct('specialization');
    
    sendSuccess(res, 200, 'Specializations retrieved successfully', { specializations });
  } catch (error: any) {
    sendError(res, 500, 'Error retrieving specializations', error.message);
  }
};

/**
 * Create new doctor (Admin/Doctor only)
 */
export const createDoctor = async (req: any, res: Response): Promise<void> => {
  try {
    const doctorData = {
      ...req.body,
      userId: req.user.id,
    };

    const doctor = await Doctor.create(doctorData);

    sendSuccess(res, 201, 'Doctor created successfully', { doctor });
  } catch (error: any) {
    sendError(res, 500, 'Error creating doctor', error.message);
  }
};

/**
 * Update doctor
 */
export const updateDoctor = async (req: any, res: Response): Promise<void> => {
  try {
    const { id } = req.params;

    const doctor = await Doctor.findByIdAndUpdate(
      id,
      req.body,
      { new: true, runValidators: true }
    );

    if (!doctor) {
      sendError(res, 404, 'Doctor not found');
      return;
    }

    sendSuccess(res, 200, 'Doctor updated successfully', { doctor });
  } catch (error: any) {
    sendError(res, 500, 'Error updating doctor', error.message);
  }
};

/**
 * Delete doctor
 */
export const deleteDoctor = async (req: Request, res: Response): Promise<void> => {
  try {
    const { id } = req.params;

    const doctor = await Doctor.findByIdAndDelete(id);

    if (!doctor) {
      sendError(res, 404, 'Doctor not found');
      return;
    }

    sendSuccess(res, 200, 'Doctor deleted successfully');
  } catch (error: any) {
    sendError(res, 500, 'Error deleting doctor', error.message);
  }
};
