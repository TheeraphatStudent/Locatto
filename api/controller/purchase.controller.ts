import express from 'express';
import { PurchaseService, PurchaseData } from '../service/purchase.service';

export class PurchaseController {
  static async create(req: express.Request, res: express.Response): Promise<void> {
    try {
      const { uid, lid, lot_amount, payid } = req.body;

      if (!uid || !lid || !lot_amount || !payid) {
        res.status(400).json({ error: 'uid, lid, lot_amount, and payid are required' });
        return;
      }

      const result = await PurchaseService.create({ uid, lid, lot_amount, payid });

      if (result.success) {
        res.status(201).json({
          message: result.message,
          purchase: result.purchase
        });
      } else {
        res.status(400).json({ error: result.message });
      }
    } catch (error) {
      console.error('Create purchase error:', error);
      res.status(500).json({ error: 'Internal server error' });
    }
  }

  static async getAll(req: express.Request, res: express.Response): Promise<void> {
    try {
      if (req.query.id) {
        const id = +req.query.id;
        const purchase = await PurchaseService.getById(id);
        if (purchase) {
          res.json(purchase);
        } else {
          res.status(404).json({ error: 'Purchase not found' });
        }
      } else if (req.query.uid) {
        const uid = +req.query.uid;
        const purchases = await PurchaseService.getByUserId(uid);
        res.json(purchases);
      } else {
        const purchases = await PurchaseService.getAll();
        res.json(purchases);
      }
    } catch (error) {
      console.error('Get purchases error:', error);
      res.status(500).json({ error: 'Internal server error' });
    }
  }

  static async getById(req: express.Request, res: express.Response): Promise<void> {
    try {
      const id = +req.params.id;
      const purchase = await PurchaseService.getById(id);
      
      if (purchase) {
        res.json(purchase);
      } else {
        res.status(404).json({ error: 'Purchase not found' });
      }
    } catch (error) {
      console.error('Get purchase by id error:', error);
      res.status(500).json({ error: 'Internal server error' });
    }
  }

  static async update(req: express.Request, res: express.Response): Promise<void> {
    try {
      const id = +req.params.id;
      const updateData: Partial<PurchaseData> = {};

      if (req.body.uid) updateData.uid = req.body.uid;
      if (req.body.lid) updateData.lid = req.body.lid;
      if (req.body.lot_amount) updateData.lot_amount = req.body.lot_amount;
      if (req.body.payid) updateData.payid = req.body.payid;

      const result = await PurchaseService.update(id, updateData);

      if (result.success) {
        res.json({ message: result.message });
      } else {
        res.status(404).json({ error: result.message });
      }
    } catch (error) {
      console.error('Update purchase error:', error);
      res.status(500).json({ error: 'Internal server error' });
    }
  }

  static async delete(req: express.Request, res: express.Response): Promise<void> {
    try {
      const id = +req.params.id;
      const result = await PurchaseService.delete(id);

      if (result.success) {
        res.json({ message: result.message });
      } else {
        res.status(404).json({ error: result.message });
      }
    } catch (error) {
      console.error('Delete purchase error:', error);
      res.status(500).json({ error: 'Internal server error' });
    }
  }
}
