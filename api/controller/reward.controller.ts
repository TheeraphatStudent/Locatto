import { Request, Response } from 'express';
import { RewardService, RewardData } from '../service/reward.service';

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
    try {
      const id = +req.params.id;
      const result = await RewardService.delete(id);

      if (result.success) {
        res.json({ message: result.message });
      } else {
        res.status(404).json({ error: result.message });
      }
    } catch (error) {
      console.error('Delete reward error:', error);
      res.status(500).json({ error: 'Internal server error' });
    }
  }

  static async manageRewards(req: Request, res: Response): Promise<void> {
    try {
      // Check if user is admin
      if (!req.user || (req.user as any).role !== 'admin') {
        res.status(403).json({ error: 'Admin access required' });
        return;
      }

      const { tier1, tier2, tier3, tier4, tier5 } = req.body;

      if (tier1 === undefined || tier2 === undefined || tier3 === undefined || 
          tier4 === undefined || tier5 === undefined) {
        res.status(400).json({ error: 'All tier fields (tier1, tier2, tier3, tier4, tier5) are required' });
        return;
      }

      const tiers = [
        { name: 'Tier 1', value: tier1 },
        { name: 'Tier 2', value: tier2 },
        { name: 'Tier 3', value: tier3 },
        { name: 'Last 3 digit of Tier 1', value: tier4 },
        { name: 'Last 2 digit (Random 2 digit)', value: tier5 }
      ];

      const results = [];

      for (const tier of tiers) {
        const revenue = tier.value === '' ? 0 : parseFloat(tier.value);
        
        if (isNaN(revenue)) {
          res.status(400).json({ error: `Invalid revenue value for ${tier.name}: ${tier.value}` });
          return;
        }

        const result = await RewardService.create({
          lid: null,
          tier: tier.name,
          revenue: revenue
        });

        if (!result.success) {
          res.status(500).json({ error: `Failed to create ${tier.name}: ${result.message}` });
          return;
        }

        results.push(result.reward);
      }

      res.status(201).json({
        message: 'All reward tiers managed successfully',
        rewards: results
      });
    } catch (error) {
      console.error('Manage rewards error:', error);
      res.status(500).json({ error: 'Internal server error' });
    }
  }
}
