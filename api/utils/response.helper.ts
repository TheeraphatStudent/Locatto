import { Response } from 'express';
import { ApiResponse, StatusCode } from '../type/response';

type MessageResponse = string | undefined;

function send(res: Response, status: StatusCode, message: MessageResponse, data: any): void {
  res.status(status).json({
    message,
    data
  } as ApiResponse);
}

export function sendSuccess({
  res,
  message,
  data,
  status
}: {
  res: Response;
  message?: MessageResponse;
  data?: any;
  status: StatusCode;
}): void {
  if (![200, 201, 202].includes(status)) {
    throw new Error('Invalid success status code');
  }
  send(res, status, message, data);
}

export function sendError({
  res,
  message,
  data,
  status
}: {
  res: Response;
  message?: MessageResponse;
  data?: any;
  status: StatusCode;
}): void {
  if (![400, 401, 403, 404, 500].includes(status)) {
    throw new Error('Invalid error status code');
  }
  send(res, status, message, data);
}

export function sendRedirect({
  res,
  message,
  data,
  status
}: {
  res: Response, 
  message?: MessageResponse, 
  data?: any,
  status: StatusCode}
): void {
  if (status !== 302) {
    throw new Error('Invalid redirect status code');
  }
  send(res, status, message, data);
}

export function sendFromService({
  res,
  status,
  result,
  message
}: {
  res: Response;
  status: StatusCode;
  result: any;
  message?: string;
}): void {
  const responseMessage = message ?? (result?.message as string | undefined);
  send(res, status, responseMessage, result);
}