import { Request, Response } from 'express';
import { PurchaseService } from '../services/PurchaseService';
import { validationResult } from 'express-validator';

export class PurchaseController {
  private purchaseService: PurchaseService;

  constructor() {
    this.purchaseService = new PurchaseService();
  }

  async getAllPurchases(req: Request, res: Response): Promise<void> {
    try {
      const purchases = await this.purchaseService.getAllPurchases();
      res.json({
        success: true,
        data: purchases
      });
    } catch (error) {
      res.status(500).json({
        success: false,
        message: 'Error fetching purchases',
        error: error instanceof Error ? error.message : 'Unknown error'
      });
    }
  }

  async getPurchaseById(req: Request, res: Response): Promise<void> {
    try {
      const id = parseInt(req.params.id);
      const purchase = await this.purchaseService.getPurchaseById(id);
      
      if (!purchase) {
        res.status(404).json({
          success: false,
          message: 'Purchase not found'
        });
        return;
      }

      res.json({
        success: true,
        data: purchase
      });
    } catch (error) {
      res.status(500).json({
        success: false,
        message: 'Error fetching purchase',
        error: error instanceof Error ? error.message : 'Unknown error'
      });
    }
  }

  async createPurchase(req: Request, res: Response): Promise<void> {
    try {
      const errors = validationResult(req);
      if (!errors.isEmpty()) {
        res.status(400).json({
          success: false,
          message: 'Validation errors',
          errors: errors.array()
        });
        return;
      }

      const purchase = await this.purchaseService.createPurchase(req.body);
      res.status(201).json({
        success: true,
        data: purchase,
        message: 'Purchase created successfully'
      });
    } catch (error) {
      res.status(500).json({
        success: false,
        message: 'Error creating purchase',
        error: error instanceof Error ? error.message : 'Unknown error'
      });
    }
  }

  async updatePurchase(req: Request, res: Response): Promise<void> {
    try {
      const errors = validationResult(req);
      if (!errors.isEmpty()) {
        res.status(400).json({
          success: false,
          message: 'Validation errors',
          errors: errors.array()
        });
        return;
      }

      const id = parseInt(req.params.id);
      const purchase = await this.purchaseService.updatePurchase(id, req.body);
      
      if (!purchase) {
        res.status(404).json({
          success: false,
          message: 'Purchase not found'
        });
        return;
      }

      res.json({
        success: true,
        data: purchase,
        message: 'Purchase updated successfully'
      });
    } catch (error) {
      res.status(500).json({
        success: false,
        message: 'Error updating purchase',
        error: error instanceof Error ? error.message : 'Unknown error'
      });
    }
  }

  async deletePurchase(req: Request, res: Response): Promise<void> {
    try {
      const id = parseInt(req.params.id);
      const deleted = await this.purchaseService.deletePurchase(id);
      
      if (!deleted) {
        res.status(404).json({
          success: false,
          message: 'Purchase not found'
        });
        return;
      }

      res.json({
        success: true,
        message: 'Purchase deleted successfully'
      });
    } catch (error) {
      res.status(500).json({
        success: false,
        message: 'Error deleting purchase',
        error: error instanceof Error ? error.message : 'Unknown error'
      });
    }
  }
} 