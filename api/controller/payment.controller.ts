import express from 'express';
import { PaymentService, PaymentData } from '../service/payment.service';

export class PaymentController {
  static async create(req: express.Request, res: express.Response): Promise<void> {
    try {
      const { uid, tier, revenue } = req.body;

      if (!uid || !tier || revenue === undefined) {
        res.status(400).json({ error: 'uid, tier, and revenue are required' });
        return;
      }

      const result = await PaymentService.create({ uid, tier, revenue });

      if (result.success) {
        res.status(201).json({
          message: result.message,
          payment: result.payment
        });
      } else {
        res.status(400).json({ error: result.message });
      }
    } catch (error) {
      console.error('Create payment error:', error);
      res.status(500).json({ error: 'Internal server error' });
    }
  }

  static async getAll(req: express.Request, res: express.Response): Promise<void> {
    try {
      if (req.query.id) {
        const id = +req.query.id;
        const payment = await PaymentService.getById(id);
        if (payment) {
          res.json(payment);
        } else {
          res.status(404).json({ error: 'Payment not found' });
        }
      } else if (req.query.uid) {
        const uid = +req.query.uid;
        const payments = await PaymentService.getByUserId(uid);
        res.json(payments);
      } else {
        const payments = await PaymentService.getAll();
        res.json(payments);
      }
    } catch (error) {
      console.error('Get payments error:', error);
      res.status(500).json({ error: 'Internal server error' });
    }
  }

  static async getById(req: express.Request, res: express.Response): Promise<void> {
    try {
      const id = +req.params.id;
      const payment = await PaymentService.getById(id);
      
      if (payment) {
        res.json(payment);
      } else {
        res.status(404).json({ error: 'Payment not found' });
      }
    } catch (error) {
      console.error('Get payment by id error:', error);
      res.status(500).json({ error: 'Internal server error' });
    }
  }

  static async update(req: express.Request, res: express.Response): Promise<void> {
    try {
      const id = +req.params.id;
      const updateData: Partial<PaymentData> = {};

      if (req.body.uid) updateData.uid = req.body.uid;
      if (req.body.tier) updateData.tier = req.body.tier;
      if (req.body.revenue !== undefined) updateData.revenue = req.body.revenue;

      const result = await PaymentService.update(id, updateData);

      if (result.success) {
        res.json({ message: result.message });
      } else {
        res.status(404).json({ error: result.message });
      }
    } catch (error) {
      console.error('Update payment error:', error);
      res.status(500).json({ error: 'Internal server error' });
    }
  }

  static async delete(req: express.Request, res: express.Response): Promise<void> {
    try {
      const id = +req.params.id;
      const result = await PaymentService.delete(id);

      if (result.success) {
        res.json({ message: result.message });
      } else {
        res.status(404).json({ error: result.message });
      }
    } catch (error) {
      console.error('Delete payment error:', error);
      res.status(500).json({ error: 'Internal server error' });
    }
  }
}
