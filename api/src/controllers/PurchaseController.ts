import { Request, Response } from 'express';
import { validationResult } from 'express-validator';
import { PurchaseService } from '../services/PurchaseService';

export class PurchaseController {
  private readonly service = new PurchaseService();

  getAllPurchases = async (_req: Request, res: Response) => {
    const items = await this.service.getAll();
    res.json(items);
  };

  getPurchaseById = async (req: Request, res: Response) => {
    const id = Number(req.params.id);
    const item = await this.service.getById(id);
    if (!item) return res.status(404).json({ success: false, message: 'Purchase not found' });
    res.json(item);
  };

  createPurchase = async (req: Request, res: Response) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) return res.status(400).json({ success: false, errors: errors.array() });
    const created = await this.service.create(req.body);
    res.status(201).json(created);
  };

  updatePurchase = async (req: Request, res: Response) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) return res.status(400).json({ success: false, errors: errors.array() });
    const id = Number(req.params.id);
    const updated = await this.service.update(id, req.body);
    if (!updated) return res.status(404).json({ success: false, message: 'Purchase not found' });
    res.json(updated);
  };

  deletePurchase = async (req: Request, res: Response) => {
    const id = Number(req.params.id);
    await this.service.remove(id);
    res.status(204).send();
  };
}


