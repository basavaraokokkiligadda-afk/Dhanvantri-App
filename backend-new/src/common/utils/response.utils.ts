import { Response } from 'express';

interface ApiResponse {
  success: boolean;
  message?: string;
  data?: any;
  error?: any;
  pagination?: {
    page: number;
    limit: number;
    total: number;
    pages: number;
  };
}

/**
 * Send success response
 */
export const sendSuccess = (
  res: Response,
  statusCode: number = 200,
  message: string,
  data?: any,
  pagination?: ApiResponse['pagination']
): void => {
  const response: ApiResponse = {
    success: true,
    message,
    ...(data && { data }),
    ...(pagination && { pagination }),
  };

  res.status(statusCode).json(response);
};

/**
 * Send error response
 */
export const sendError = (
  res: Response,
  statusCode: number = 500,
  message: string,
  error?: any
): void => {
  const response: ApiResponse = {
    success: false,
    message,
    ...(error && { error }),
  };

  res.status(statusCode).json(response);
};

/**
 * Calculate pagination
 */
export const getPagination = (
  page: number = 1,
  limit: number = 10,
  total: number
): ApiResponse['pagination'] => {
  const pages = Math.ceil(total / limit);
  return {
    page,
    limit,
    total,
    pages,
  };
};
