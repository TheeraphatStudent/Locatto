import express from 'express';
import { Request, Response } from 'express';
import { RewardService, RewardData } from '../service/reward.service';
import { isRoleExst } from '../utils/auth.helper';
import { Tiers } from '../type/reward';

export class RewardController {
  static async create(req: Request, res: Response): Promise<void> {
    try {
      const { lid, tier, revenue, winner } = req.body;

      if (!lid || !tier || revenue === undefined) {
        res.status(400).json({ error: 'lid, tier, and revenue are required' });
        return;
      }

      const result = await RewardService.create({ lid, tier, revenue, winner });

      if (result.success) {
        res.status(201).json({
          message: result.message,
          reward: result.reward
        });
      } else {
        res.status(400).json({ error: result.message });
      }
    } catch (error) {
      console.error('Create reward error:', error);
      res.status(500).json({ error: 'Internal server error' });
    }
  }

  static async getAll(req: Request, res: Response): Promise<void> {
    try {
      if (req.query.id) {
        const id = +req.query.id;
        const reward = await RewardService.getById(id);
        if (reward) {
          res.json(reward);
        } else {
          res.status(404).json({ error: 'Reward not found' });
        }
      } else if (req.query.lid) {
        const lid = +req.query.lid;
        const rewards = await RewardService.getByLotteryId(lid);
        res.json(rewards);
      } else {
        const rewards = await RewardService.getAll();
        res.json(rewards);
      }
    } catch (error) {
      console.error('Get rewards error:', error);
      res.status(500).json({ error: 'Internal server error' });
    }
  }

  static async getById(req: Request, res: Response): Promise<void> {
    try {
      const id = +req.params.id;
      const reward = await RewardService.getById(id);
      
      if (reward) {
        res.json(reward);
      } else {
        res.status(404).json({ error: 'Reward not found' });
      }
    } catch (error) {
      console.error('Get reward by id error:', error);
      res.status(500).json({ error: 'Internal server error' });
    }
  }

  static async update(req: Request, res: Response): Promise<void> {
    try {
      const id = +req.params.id;
      const updateData: Partial<RewardData> = {};

      if (req.body.lid) updateData.lid = req.body.lid;
      if (req.body.tier) updateData.tier = req.body.tier;
      if (req.body.revenue !== undefined) updateData.revenue = req.body.revenue;
      if (req.body.winner !== undefined) updateData.winner = req.body.winner;

      const result = await RewardService.update(id, updateData);

      if (result.success) {
        res.json({ message: result.message });
      } else {
        res.status(404).json({ error: result.message });
      }
    } catch (error) {
      console.error('Update reward error:', error);
      res.status(500).json({ error: 'Internal server error' });
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
    try {
      if (!req.user || !isRoleExst((req.user as any).role, 'admin')) {
        res.status(403).json({ error: 'Admin access required' });
        return;
      }

      const tierData = req.body;

      delete tierData.iat;
      delete tierData.exp;

      if (!tierData || Object.keys(tierData).length === 0) {
        res.status(400).json({ error: 'No tier data provided' });
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
          res.status(400).json({ error: `Invalid revenue value for ${tierKey}: ${revenueValue}` });
          return;
        }

        const result = await RewardService.updateOrCreate({
          tier: tierKey,
          revenue: revenue
        });

        if (!result.success) {
          res.status(500).json({ error: `Failed to manage ${tierKey}: ${result.message}` });
          return;
        }

        results.push(result.reward);
      }

      res.status(200).json({
        message: 'All reward tiers managed successfully',
        rewards: results
      });
    } catch (error) {
      console.error('Manage rewards error:', error);
      res.status(500).json({ error: 'Internal server error' });
    }
  }
}
