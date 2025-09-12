import { Response } from 'express';
import { ApiResponse, StatusCode } from '../type/response';

type MessageResponse = string | undefined;

function send(res: Response, status: StatusCode, message: MessageResponse, data: any): void {
  res.status(status).json({
    message,
    data
  } as ApiResponse);
}

export function sendSuccess(res: Response, message: MessageResponse = 'Success', data: any = null, status: StatusCode = 200): void {
  if (![200, 201, 202].includes(status)) {
    throw new Error('Invalid success status code');
  }
  send(res, status, message, data);
}

export function sendError(res: Response, message: MessageResponse = 'Error', data: any = null, status: StatusCode = 400): void {
  if (![400, 401, 404, 500].includes(status)) {
    throw new Error('Invalid error status code');
  }
  send(res, status, message, data);
}

export function sendRedirect(res: Response, message: MessageResponse = 'Redirect', data: any = null, status: StatusCode = 302): void {
  if (status !== 302) {
    throw new Error('Invalid redirect status code');
  }
  send(res, status, message, data);
}