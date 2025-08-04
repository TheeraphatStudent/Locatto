import { Request, Response } from 'express';
import { RewardService } from '../services/RewardService';
import { validationResult } from 'express-validator';

export class RewardController {
  private rewardService: RewardService;

  constructor() {
    this.rewardService = new RewardService();
  }

  async getAllRewards(req: Request, res: Response): Promise<void> {
    try {
      const rewards = await this.rewardService.getAllRewards();
      res.json({
        success: true,
        data: rewards
      });
    } catch (error) {
      res.status(500).json({
        success: false,
        message: 'Error fetching rewards',
        error: error instanceof Error ? error.message : 'Unknown error'
      });
    }
  }

  async getRewardById(req: Request, res: Response): Promise<void> {
    try {
      const id = parseInt(req.params.id);
      const reward = await this.rewardService.getRewardById(id);
      
      if (!reward) {
        res.status(404).json({
          success: false,
          message: 'Reward not found'
        });
        return;
      }

      res.json({
        success: true,
        data: reward
      });
    } catch (error) {
      res.status(500).json({
        success: false,
        message: 'Error fetching reward',
        error: error instanceof Error ? error.message : 'Unknown error'
      });
    }
  }

  async createReward(req: Request, res: Response): Promise<void> {
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

      const reward = await this.rewardService.createReward(req.body);
      res.status(201).json({
        success: true,
        data: reward,
        message: 'Reward created successfully'
      });
    } catch (error) {
      res.status(500).json({
        success: false,
        message: 'Error creating reward',
        error: error instanceof Error ? error.message : 'Unknown error'
      });
    }
  }

  async updateReward(req: Request, res: Response): Promise<void> {
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
      const reward = await this.rewardService.updateReward(id, req.body);
      
      if (!reward) {
        res.status(404).json({
          success: false,
          message: 'Reward not found'
        });
        return;
      }

      res.json({
        success: true,
        data: reward,
        message: 'Reward updated successfully'
      });
    } catch (error) {
      res.status(500).json({
        success: false,
        message: 'Error updating reward',
        error: error instanceof Error ? error.message : 'Unknown error'
      });
    }
  }

  async deleteReward(req: Request, res: Response): Promise<void> {
    try {
      const id = parseInt(req.params.id);
      const deleted = await this.rewardService.deleteReward(id);
      
      if (!deleted) {
        res.status(404).json({
          success: false,
          message: 'Reward not found'
        });
        return;
      }

      res.json({
        success: true,
        message: 'Reward deleted successfully'
      });
    } catch (error) {
      res.status(500).json({
        success: false,
        message: 'Error deleting reward',
        error: error instanceof Error ? error.message : 'Unknown error'
      });
    }
  }
} 