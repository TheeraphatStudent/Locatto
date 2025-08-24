import { NextFunction, Request, Response } from 'express';

// eslint-disable-next-line @typescript-eslint/no-explicit-any
export const errorHandler = (err: any, _req: Request, res: Response, _next: NextFunction) => {
  // eslint-disable-next-line no-console
  console.error(err);
  const statusCode = err?.statusCode ?? 500;
  res.status(statusCode).json({
    success: false,
    message: err?.message ?? 'Internal server error',
  });
};


