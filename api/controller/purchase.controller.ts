import { Request, Response } from 'express';
import { PurchaseService, PurchaseData } from '../service/purchase.service';
import { sendError, sendFromService } from '../utils/response.helper';

export class PurchaseController {
  static async create(req: Request, res: Response): Promise<void> {
    try {
      const { uid, lid, lot_amount, payid } = req.body;

      if (!uid || !lid || !lot_amount || !payid) {
        sendError({ res, status: 400, message: 'uid, lid, lot_amount, and payid are required' });
        return;
      }

      const result = await PurchaseService.create({ uid, lid, lot_amount, payid });
      const status = result.success ? 201 : 400;
      sendFromService({ res, status, result });
    } catch (error) {
      console.error('Create purchase error:', error);
      sendError({ res, status: 500, message: 'Internal server error' });
    }
  }

  static async getAll(req: Request, res: Response): Promise<void> {
    try {
      if (req.query.id) {
        const id = +req.query.id;
        const purchase = await PurchaseService.getById(id);
        if (purchase) {
          sendFromService({ res, status: 200, result: purchase, message: 'Purchase found' });
        } else {
          sendError({ res, status: 404, message: 'Purchase not found' });
        }
      } else if (req.query.uid) {
        const uid = +req.query.uid;
        const purchases = await PurchaseService.getByUserId(uid);
        sendFromService({ res, status: 200, result: purchases, message: 'Purchases fetched' });
      } else {
        const purchases = await PurchaseService.getAll();
        sendFromService({ res, status: 200, result: purchases, message: 'Purchases fetched' });
      }
    } catch (error) {
      console.error('Get purchases error:', error);
      sendError({ res, status: 500, message: 'Internal server error' });
    }
  }

  static async getById(req: Request, res: Response): Promise<void> {
    try {
      const id = +req.params.id;
      if (isNaN(id)) {
        sendError({ res, status: 400, message: 'Invalid id' });
        return;
      }
      const purchase = await PurchaseService.getById(id);
      
      if (purchase) {
        sendFromService({ res, status: 200, result: purchase, message: 'Purchase found' });
      } else {
        sendError({ res, status: 404, message: 'Purchase not found' });
      }
    } catch (error) {
      console.error('Get purchase by id error:', error);
      sendError({ res, status: 500, message: 'Internal server error' });
    }
  }

  static async update(req: Request, res: Response): Promise<void> {
    try {
      const id = +req.params.id;
      const updateData: Partial<PurchaseData> = {};

      if (req.body.uid) updateData.uid = req.body.uid;
      if (req.body.lid) updateData.lid = req.body.lid;
      if (req.body.lot_amount) updateData.lot_amount = req.body.lot_amount;
      if (req.body.payid) updateData.payid = req.body.payid;

      const result = await PurchaseService.update(id, updateData);
      const status = result.success ? 200 : 404;
      sendFromService({ res, status, result });
    } catch (error) {
      console.error('Update purchase error:', error);
      sendError({ res, status: 500, message: 'Internal server error' });
    }
  }

  static async delete(req: Request, res: Response): Promise<void> {
    try {
      const id = +req.params.id;
      const result = await PurchaseService.delete(id);
      const status = result.success ? 200 : 404;
      sendFromService({ res, status, result });
    } catch (error) {
      console.error('Delete purchase error:', error);
      sendError({ res, status: 500, message: 'Internal server error' });
    }
  }

  static async getByUserWithStatus(req: Request, res: Response): Promise<void> {
    try {
      const uid = req.user.uid;
      const page = +(req.query.page as string) || 1;
      const size = +(req.query.size as string) || 10;

      const result = await PurchaseService.getByUserWithStatus(uid, page, size);

      sendFromService({ res, status: 200, result, message: 'Purchases with status fetched' });
    } catch (error) {
      console.error('Get purchases with status error:', error);
      sendError({ res, status: 500, message: 'Internal server error' });
    }
  }
}
