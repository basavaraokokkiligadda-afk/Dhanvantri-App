import { Router } from 'express';
import {
  getAllDoctors,
  getDoctorById,
  getSpecializations,
  createDoctor,
  updateDoctor,
  deleteDoctor,
} from './doctor.controller';
import { authenticate, authorize } from '../../common/middleware/auth.middleware';

const router = Router();

/**
 * @route   GET /api/doctors
 * @desc    Get all doctors
 * @access  Public
 */
router.get('/', getAllDoctors);

/**
 * @route   GET /api/doctors/specializations
 * @desc    Get all specializations
 * @access  Public
 */
router.get('/specializations', getSpecializations);

/**
 * @route   GET /api/doctors/:id
 * @desc    Get doctor by ID
 * @access  Public
 */
router.get('/:id', getDoctorById);

/**
 * @route   POST /api/doctors
 * @desc    Create new doctor
 * @access  Private (Doctor/Admin)
 */
router.post('/', authenticate, authorize('doctor', 'hospital_admin'), createDoctor);

/**
 * @route   PUT /api/doctors/:id
 * @desc    Update doctor
 * @access  Private (Doctor/Admin)
 */
router.put('/:id', authenticate, authorize('doctor', 'hospital_admin'), updateDoctor);

/**
 * @route   DELETE /api/doctors/:id
 * @desc    Delete doctor
 * @access  Private (Admin)
 */
router.delete('/:id', authenticate, authorize('hospital_admin'), deleteDoctor);

export default router;
