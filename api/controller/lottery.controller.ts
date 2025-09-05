import { Request, Response } from 'express';
import { LotteryService, LotteryData } from '../service/lottery.service';
import { isRoleExst } from '../utils/auth.helper';

export class LotteryController {
  static async create(req: Request, res: Response): Promise<void> {
    try {
      // console.log("Request Body: ", req.body)
      // console.log("Request User: ", req.user)

      const { n } = req.body;

      if (!req.user || !isRoleExst((req.user as any).role, 'admin')) {
        res.status(403).json({ error: 'Admin access required' });
        return;
      }

      if (!n || typeof n !== 'number') {
        res.status(400).json({ error: 'n parameter is required and must be a number' });
        return;
      }

      const result = await LotteryService.generateBulkLotteries(n);

      if (result.success) {
        res.status(201).json({
          message: result.message,
          lotteries: result.lotteries,
          generated: result.generated
        });
      } else {
        res.status(400).json({ error: result.message });
      }
    } catch (error) {
      console.error('Create lottery error:', error);
      res.status(500).json({ error: 'Internal server error' });
    }
  }

  static async getAll(req: Request, res: Response): Promise<void> {
    try {
      if (req.query.id) {
        const id = +req.query.id;
        const lottery = await LotteryService.getById(id);
        if (lottery) {
          res.json(lottery);
        } else {
          res.status(404).json({ error: 'Lottery not found' });
        }
      } else {
        const lotteries = await LotteryService.getAll();
        res.json(lotteries);
      }
    } catch (error) {
      console.error('Get lotteries error:', error);
      res.status(500).json({ error: 'Internal server error' });
    }
  }

  static async getById(req: Request, res: Response): Promise<void> {
    try {
      const id = +req.params.id;
      const lottery = await LotteryService.getById(id);
      
      if (lottery) {
        res.json(lottery);
      } else {
        res.status(404).json({ error: 'Lottery not found' });
      }
    } catch (error) {
      console.error('Get lottery by id error:', error);
      res.status(500).json({ error: 'Internal server error' });
    }
  }

  static async update(req: Request, res: Response): Promise<void> {
    try {
      const id = +req.params.id;
      const updateData: Partial<LotteryData> = {};

      if (req.body.lottery_number) updateData.lottery_number = req.body.lottery_number;
      if (req.body.period) updateData.period = req.body.period;

      const result = await LotteryService.update(id, updateData);

      if (result.success) {
        res.json({ message: result.message });
      } else {
        res.status(404).json({ error: result.message });
      }
    } catch (error) {
      console.error('Update lottery error:', error);
      res.status(500).json({ error: 'Internal server error' });
    }
  }

  static async delete(req: Request, res: Response): Promise<void> {
    try {
      const id = +req.params.id;
      const result = await LotteryService.delete(id);

      if (result.success) {
        res.json({ message: result.message });
      } else {
        res.status(404).json({ error: result.message });
      }
    } catch (error) {
      console.error('Delete lottery error:', error);
      res.status(500).json({ error: 'Internal server error' });
    }
  }

  static async selectRandomWinnersFollowed(req: Request, res: Response): Promise<void> {
    try {
      if (!req.user || !isRoleExst((req.user as any).role, 'admin')) {
        res.status(403).json({ error: 'Admin access required' });
        return;
      }

      const result = await LotteryService.selectRandomWinners(true);

      if (result.success) {
        res.json({
          message: 'Random winners selected successfully (followed)',
          // winners: result.winners
        });
      } else {
        res.status(400).json({ error: result.message });
      }
    } catch (error) {
      console.error('Select random winners followed error:', error);
      res.status(500).json({ error: 'Internal server error' });
    }
  }

  static async selectRandomWinnersUnfollowed(req: Request, res: Response): Promise<void> {
    try {
      if (!req.user || !isRoleExst((req.user as any).role, 'admin')) {
        res.status(403).json({ error: 'Admin access required' });
        return;
      }

      const result = await LotteryService.selectRandomWinners(false);

      if (result.success) {
        res.json({
          message: 'Random winners selected successfully (unfollowed)',
          // winners: result.winners
        });
      } else {
        res.status(400).json({ error: result.message });
      }
    } catch (error) {
      console.error('Select random winners unfollowed error:', error);
      res.status(500).json({ error: 'Internal server error' });
    }
  }
}
