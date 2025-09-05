import express from 'express';
import { LotteryService, LotteryData } from '../service/lottery.service';

export class LotteryController {
  static async create(req: express.Request, res: express.Response): Promise<void> {
    try {
      const { lottery_number, period } = req.body;

      if (!lottery_number || !period) {
        res.status(400).json({ error: 'lottery_number and period are required' });
        return;
      }

      const result = await LotteryService.create({ lottery_number, period });

      if (result.success) {
        res.status(201).json({
          message: result.message,
          lottery: result.lottery
        });
      } else {
        res.status(400).json({ error: result.message });
      }
    } catch (error) {
      console.error('Create lottery error:', error);
      res.status(500).json({ error: 'Internal server error' });
    }
  }

  static async getAll(req: express.Request, res: express.Response): Promise<void> {
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

  static async getById(req: express.Request, res: express.Response): Promise<void> {
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

  static async update(req: express.Request, res: express.Response): Promise<void> {
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

  static async delete(req: express.Request, res: express.Response): Promise<void> {
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

  static async selectRandomWinnersFollowed(req: express.Request, res: express.Response): Promise<void> {
    try {
      const result = await LotteryService.selectRandomWinners(true);

      if (result.success) {
        res.json({
          message: 'Random winners selected successfully (followed)',
          winners: result.winners
        });
      } else {
        res.status(400).json({ error: result.message });
      }
    } catch (error) {
      console.error('Select random winners followed error:', error);
      res.status(500).json({ error: 'Internal server error' });
    }
  }

  static async selectRandomWinnersUnfollowed(req: express.Request, res: express.Response): Promise<void> {
    try {
      const result = await LotteryService.selectRandomWinners(false);

      if (result.success) {
        res.json({
          message: 'Random winners selected successfully (unfollowed)',
          winners: result.winners
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
