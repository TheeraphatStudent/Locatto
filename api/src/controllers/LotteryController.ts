import { Request, Response } from 'express';
import { LotteryService } from '../services/LotteryService';
import { validationResult } from 'express-validator';

export class LotteryController {
  private lotteryService: LotteryService;

  constructor() {
    this.lotteryService = new LotteryService();
  }

  async getAllLotteries(req: Request, res: Response): Promise<void> {
    try {
      const lotteries = await this.lotteryService.getAllLotteries();
      res.json({
        success: true,
        data: lotteries
      });
    } catch (error) {
      res.status(500).json({
        success: false,
        message: 'Error fetching lotteries',
        error: error instanceof Error ? error.message : 'Unknown error'
      });
    }
  }

  async getLotteryById(req: Request, res: Response): Promise<void> {
    try {
      const id = parseInt(req.params.id);
      const lottery = await this.lotteryService.getLotteryById(id);
      
      if (!lottery) {
        res.status(404).json({
          success: false,
          message: 'Lottery not found'
        });
        return;
      }

      res.json({
        success: true,
        data: lottery
      });
    } catch (error) {
      res.status(500).json({
        success: false,
        message: 'Error fetching lottery',
        error: error instanceof Error ? error.message : 'Unknown error'
      });
    }
  }

  async createLottery(req: Request, res: Response): Promise<void> {
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

      const lottery = await this.lotteryService.createLottery(req.body);
      res.status(201).json({
        success: true,
        data: lottery,
        message: 'Lottery created successfully'
      });
    } catch (error) {
      res.status(500).json({
        success: false,
        message: 'Error creating lottery',
        error: error instanceof Error ? error.message : 'Unknown error'
      });
    }
  }

  async updateLottery(req: Request, res: Response): Promise<void> {
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
      const lottery = await this.lotteryService.updateLottery(id, req.body);
      
      if (!lottery) {
        res.status(404).json({
          success: false,
          message: 'Lottery not found'
        });
        return;
      }

      res.json({
        success: true,
        data: lottery,
        message: 'Lottery updated successfully'
      });
    } catch (error) {
      res.status(500).json({
        success: false,
        message: 'Error updating lottery',
        error: error instanceof Error ? error.message : 'Unknown error'
      });
    }
  }

  async deleteLottery(req: Request, res: Response): Promise<void> {
    try {
      const id = parseInt(req.params.id);
      const deleted = await this.lotteryService.deleteLottery(id);
      
      if (!deleted) {
        res.status(404).json({
          success: false,
          message: 'Lottery not found'
        });
        return;
      }

      res.json({
        success: true,
        message: 'Lottery deleted successfully'
      });
    } catch (error) {
      res.status(500).json({
        success: false,
        message: 'Error deleting lottery',
        error: error instanceof Error ? error.message : 'Unknown error'
      });
    }
  }
} 