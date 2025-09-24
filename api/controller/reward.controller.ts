import express from 'express';
import { Request, Response } from 'express';
import { RewardService, RewardData } from '../service/reward.service';
import { isRoleExst } from '../utils/auth.helper';
import { Tiers } from '../type/reward';
import { sendError, sendFromService } from '../utils/response.helper';

export class RewardController {
  static async create(req: Request, res: Response): Promise<void> {
    try {
      const { tier, revenue, winner } = req.body;

      if (!tier || revenue === undefined) {
        sendError({ res, status: 400, message: 'tier and revenue are required' });
        return;
      }

      const result = await RewardService.create({ tier, revenue, winner });
      const status = result.success ? 201 : 400;
      sendFromService({ res, status, result });
    } catch (error) {
      console.error('Create reward error:', error);
      sendError({ res, status: 500, message: 'Internal server error' });
    }
  }

  static async getAll(req: Request, res: Response): Promise<void> {
    
    try {
      if (req.query.id) {
        const id = +req.query.id;
        const reward = await RewardService.getById(id);
        if (reward) {
          sendFromService({ res, status: 200, result: reward, message: 'Reward found' });
        } else {
          sendError({ res, status: 404, message: 'Reward not found' });
        }
      } else {
        // console.log('Calling getAllRewards');
        const rewards = await RewardService.getAll();
        sendFromService({ res, status: 200, result: rewards, message: 'Rewards fetched' });
      }
    } catch (error) {
      console.error('Get rewards error:', error);
      sendError({ res, status: 500, message: 'Internal server error' });
    }
  }

  static async getAllRewards(req: Request, res: Response): Promise<void> {
    try {
      const rewards = await RewardService.getAllRewards();
      sendFromService({ res, status: 200, result: rewards });
    } catch (error) {
      console.error('Get all rewards error:', error);
      sendError({ res, status: 500, message: 'Internal server error' });
    }
  }

  static async getById(req: Request, res: Response): Promise<void> {
    try {
      // console.log('Calling getById with ID:', req.params.id);
      const id = parseInt(req.params.id, 10);
      if (isNaN(id)) {
        sendError({ res, status: 400, message: 'Invalid reward ID' });
        return;
      }
      const reward = await RewardService.getById(id);
      
      if (reward) {
        sendFromService({ res, status: 200, result: reward, message: 'Reward found' });
      } else {
        sendError({ res, status: 404, message: 'Reward not found' });
      }
    } catch (error) {
      console.error('Get reward by id error:', error);
      sendError({ res, status: 500, message: 'Internal server error' });
    }
  }

  static async update(req: Request, res: Response): Promise<void> {
    try {
      const id = +req.params.id;
      const updateData: Partial<RewardData> = {};

      if (req.body.tier) updateData.tier = req.body.tier;
      if (req.body.revenue !== undefined) updateData.revenue = req.body.revenue;
      if (req.body.winner !== undefined) updateData.winner = req.body.winner;

      const result = await RewardService.update(id, updateData);
      const status = result.success ? 200 : 404;
      sendFromService({ res, status, result });
    } catch (error) {
      console.error('Update reward error:', error);
      sendError({ res, status: 500, message: 'Internal server error' });
    }
  }

  static async delete(req: Request, res: Response): Promise<void> {
    // try {
    //   const id = +req.params.id;
    //   const result = await RewardService.delete(id);

    //   if (result.success) {
    //     res.json({ message: result.message });
    //   } else {
    //     res.status(404).json({ error: result.message });
    //   }
    // } catch (error) {
    //   console.error('Delete reward error:', error);
    //   res.status(500).json({ error: 'Internal server error' });
    // }
  }

  static async manageRewards(req: Request, res: Response): Promise<void> {
    // console.log('Test:', req.body);
    try {
      // console.log('xxxxDDDD:', req.body); // ตรวจสอบค่าของ req.body
      if (!req.user || !isRoleExst((req.user as any).role, 'admin')) {
        sendError({ res, status: 403, message: 'Admin access required' });
        return;
      }

      const tierData = req.body;

      delete tierData.iat;
      delete tierData.exp;

      if (!tierData || Object.keys(tierData).length === 0) {
        // console.log('tierData received:', tierData);
        sendError({ res, status: 400, message: 'No tier data provided' });
        return;
      }

      const tierMapping: { [key: string]: string } = {
        '1': 'T1',
        '2': 'T2',
        '3': 'T3',
        '4': 'T1L3',
        '5': 'R2'
      };

      const mappedTierData: { [key: string]: any } = {};

      for (const [key, value] of Object.entries(tierData)) {
        const tierName = tierMapping[key] || key;
        mappedTierData[tierName] = value;
      }

      const results = [];

      for (const [tierKey, revenueValue] of Object.entries(mappedTierData)) {
        const revenue = revenueValue === '' ? 0 : parseFloat(revenueValue as string);

        if (isNaN(revenue)) {
          sendError({ res, status: 400, message: `Invalid revenue value for ${tierKey}: ${revenueValue}` });
          return;
        }

        const result = await RewardService.updateOrCreate({
          tier: tierKey,
          revenue: revenue
        });

        if (!result.success) {
          sendError({ res, status: 500, message: `Failed to manage ${tierKey}: ${result.message}` });
          return;
        }

        results.push(result.reward);
      }

      sendFromService({ res, status: 200, result: { rewards: results }, message: 'All reward tiers managed successfully' });
    } catch (error) {
      console.error('Manage rewards error:', error);
      sendError({ res, status: 500, message: 'Internal server error' });
    }
  }

  static async claim(req: Request, res: Response): Promise<void> {
    try {
      // console.log("Request: ", req.body)

      const uid = req.user?.uid; 
      const { rid } = req.body;

      if (!uid || !rid) {
        res.status(400).json({ success: false, message: 'Missing uid or rid' });
        return;
      }

      const result = await RewardService.claimReward(uid, rid);
      res.status(result.success ? 200 : 400).json(result);
    } catch (error) {
      console.error('Claim reward controller error:', error);
      res.status(500).json({ success: false, message: 'Internal server error' });
    }
  }
}