import { Request, Response } from 'express';
import { validationResult } from 'express-validator';
import { RewardService } from '../services/RewardService';

export class RewardController {
  private readonly service = new RewardService();

  getAllRewards = async (_req: Request, res: Response) => {
    const items = await this.service.getAll();
    res.json(items);
  };

  getRewardById = async (req: Request, res: Response) => {
    const id = Number(req.params.id);
    const item = await this.service.getById(id);
    if (!item) return res.status(404).json({ success: false, message: 'Reward not found' });
    res.json(item);
  };

  createReward = async (req: Request, res: Response) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) return res.status(400).json({ success: false, errors: errors.array() });
    const created = await this.service.create(req.body);
    res.status(201).json(created);
  };

  updateReward = async (req: Request, res: Response) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) return res.status(400).json({ success: false, errors: errors.array() });
    const id = Number(req.params.id);
    const updated = await this.service.update(id, req.body);
    if (!updated) return res.status(404).json({ success: false, message: 'Reward not found' });
    res.json(updated);
  };

  deleteReward = async (req: Request, res: Response) => {
    const id = Number(req.params.id);
    await this.service.remove(id);
    res.status(204).send();
  };
}


