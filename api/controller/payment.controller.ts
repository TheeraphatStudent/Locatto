import { Request, Response } from 'express';
import { PaymentService, PaymentData } from '../service/payment.service';
import { sendError, sendFromService } from '../utils/response.helper';

export class PaymentController {
  static async create(req: Request, res: Response): Promise<void> {
    try {
      const { uid, provider, revenue } = req.body;

      if (!uid || !provider || revenue === undefined) {
        sendError({ res, status: 400, message: 'uid, provider, and revenue are required' });
        return;
      }

      const result = await PaymentService.create({ uid, provider, revenue });
      const status = result.success ? 201 : 400;
      sendFromService({ res, status, result });
    } catch (error) {
      console.error('Create payment error:', error);
      sendError({ res, status: 500, message: 'Internal server error' });
    }
  }

  static async getAll(req: Request, res: Response): Promise<void> {
    try {
      if (req.query.id) {
        const id = +req.query.id;
        const payment = await PaymentService.getById(id);
        if (payment) {
          sendFromService({ res, status: 200, result: payment, message: 'Payment found' });
        } else {
          sendError({ res, status: 404, message: 'Payment not found' });
        }
      } else if (req.query.uid) {
        const uid = +req.query.uid;
        const payments = await PaymentService.getByUserId(uid);
        sendFromService({ res, status: 200, result: payments, message: 'Payments fetched' });
      } else {
        const payments = await PaymentService.getAll();
        sendFromService({ res, status: 200, result: payments, message: 'Payments fetched' });
      }
    } catch (error) {
      console.error('Get payments error:', error);
      sendError({ res, status: 500, message: 'Internal server error' });
    }
  }

  static async getById(req: Request, res: Response): Promise<void> {
    try {
      const id = +req.params.id;
      const payment = await PaymentService.getById(id);
      
      if (payment) {
        sendFromService({ res, status: 200, result: payment, message: 'Payment found' });
      } else {
        sendError({ res, status: 404, message: 'Payment not found' });
      }
    } catch (error) {
      console.error('Get payment by id error:', error);
      sendError({ res, status: 500, message: 'Internal server error' });
    }
  }

  static async update(req: Request, res: Response): Promise<void> {
    try {
      const id = +req.params.id;
      const updateData: Partial<PaymentData> = {};

      if (req.body.uid) updateData.uid = req.body.uid;
      if (req.body.provider) updateData.provider = req.body.provider;
      if (req.body.revenue !== undefined) updateData.revenue = req.body.revenue;

      const result = await PaymentService.update(id, updateData);
      const status = result.success ? 200 : 404;
      sendFromService({ res, status, result });
    } catch (error) {
      console.error('Update payment error:', error);
      sendError({ res, status: 500, message: 'Internal server error' });
    }
  }

  static async delete(req: Request, res: Response): Promise<void> {
    try {
      const id = +req.params.id;
      const result = await PaymentService.delete(id);
      const status = result.success ? 200 : 404;
      sendFromService({ res, status, result });
    } catch (error) {
      console.error('Delete payment error:', error);
      sendError({ res, status: 500, message: 'Internal server error' });
    }
  }
}
