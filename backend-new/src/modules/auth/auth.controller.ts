import { Request, Response } from 'express';
import { User } from '../users/user.model';
import { generateToken, generateRefreshToken } from '../../common/utils/jwt.utils';
import { sendSuccess, sendError } from '../../common/utils/response.utils';

/**
 * Register new user
 */
export const register = async (req: Request, res: Response): Promise<void> => {
  try {
    const { name, email, password, phone, role } = req.body;

    // Check if user already exists
    const existingUser = await User.findOne({ email });
    if (existingUser) {
      sendError(res, 400, 'Email already registered');
      return;
    }

    // Create new user
    const user = await User.create({
      name,
      email,
      password,
      phone,
      role: role || 'patient',
    });

    // Generate tokens
    const token = generateToken({
      id: user._id.toString(),
      email: user.email,
      role: user.role,
    });

    const refreshToken = generateRefreshToken({
      id: user._id.toString(),
      email: user.email,
    });

    // Send response
    sendSuccess(res, 201, 'User registered successfully', {
      user: {
        id: user._id.toString(),
        name: user.name,
        email: user.email,
        role: user.role,
      },
      token,
      refreshToken,
    });
  } catch (error: any) {
    sendError(res, 500, 'Error registering user', error.message);
  }
};

/**
 * Login user
 */
export const login = async (req: Request, res: Response): Promise<void> => {
  try {
    const { email, password } = req.body;

    // Find user and include password
    const user = await User.findOne({ email }).select('+password');
    if (!user) {
      sendError(res, 401, 'Invalid email or password');
      return;
    }

    // Check if user is active
    if (!user.isActive) {
      sendError(res, 401, 'Account is inactive. Please contact support');
      return;
    }

    // Compare password
    const isPasswordValid = await user.comparePassword(password);
    if (!isPasswordValid) {
      sendError(res, 401, 'Invalid email or password');
      return;
    }

    // Generate tokens
    const token = generateToken({
      id: user._id.toString(),
      email: user.email,
      role: user.role,
    });

    const refreshToken = generateRefreshToken({
      id: user._id.toString(),
      email: user.email,
    });

    // Send response
    sendSuccess(res, 200, 'Login successful', {
      user: {
        id: user._id.toString(),
        name: user.name,
        email: user.email,
        phone: user.phone,
        role: user.role,
        profileImage: user.profileImage,
      },
      token,
      refreshToken,
    });
  } catch (error: any) {
    sendError(res, 500, 'Error logging in', error.message);
  }
};

/**
 * Get current user
 */
export const getMe = async (req: any, res: Response): Promise<void> => {
  try {
    const user = await User.findById(req.user.id).select('-password');
    
    if (!user) {
      sendError(res, 404, 'User not found');
      return;
    }

    sendSuccess(res, 200, 'User retrieved successfully', { user });
  } catch (error: any) {
    sendError(res, 500, 'Error retrieving user', error.message);
  }
};

/**
 * Update user profile
 */
export const updateProfile = async (req: any, res: Response): Promise<void> => {
  try {
    const allowedUpdates = ['name', 'phone', 'profileImage', 'dateOfBirth', 'gender', 'bloodGroup', 'address', 'emergencyContact'];
    const updates: any = {};

    Object.keys(req.body).forEach(key => {
      if (allowedUpdates.includes(key)) {
        updates[key] = req.body[key];
      }
    });

    const user = await User.findByIdAndUpdate(
      req.user.id,
      updates,
      { new: true, runValidators: true }
    ).select('-password');

    if (!user) {
      sendError(res, 404, 'User not found');
      return;
    }

    sendSuccess(res, 200, 'Profile updated successfully', { user });
  } catch (error: any) {
    sendError(res, 500, 'Error updating profile', error.message);
  }
};

/**
 * Change password
 */
export const changePassword = async (req: any, res: Response): Promise<void> => {
  try {
    const { currentPassword, newPassword } = req.body;

    const user = await User.findById(req.user.id).select('+password');
    if (!user) {
      sendError(res, 404, 'User not found');
      return;
    }

    // Verify current password
    const isPasswordValid = await user.comparePassword(currentPassword);
    if (!isPasswordValid) {
      sendError(res, 401, 'Current password is incorrect');
      return;
    }

    // Update password
    user.password = newPassword;
    await user.save();

    sendSuccess(res, 200, 'Password changed successfully');
  } catch (error: any) {
    sendError(res, 500, 'Error changing password', error.message);
  }
};
