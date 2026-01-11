import jwt from 'jsonwebtoken';
import { config } from '../../config/config';

/**
 * Generate JWT access token
 */
export const generateToken = (payload: {
  id: string;
  email: string;
  role: string;
}): string => {
  // @ts-ignore - JWT type overload issue
  return jwt.sign(payload, config.jwt.secret as string, {
    expiresIn: config.jwt.expiresIn as string,
  });
};

/**
 * Generate JWT refresh token
 */
export const generateRefreshToken = (payload: {
  id: string;
  email: string;
}): string => {
  // @ts-ignore - JWT type overload issue
  return jwt.sign(payload, config.jwt.refreshSecret as string, {
    expiresIn: config.jwt.refreshExpiresIn as string,
  });
};

/**
 * Verify JWT token
 */
export const verifyToken = (token: string): any => {
  return jwt.verify(token, config.jwt.secret);
};

/**
 * Verify refresh token
 */
export const verifyRefreshToken = (token: string): any => {
  return jwt.verify(token, config.jwt.refreshSecret);
};
