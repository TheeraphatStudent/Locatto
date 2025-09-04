import express from 'express';
import { IndexService } from '../service/index.service';

export class IndexController {
  static async getIndex(req: express.Request, res: express.Response): Promise<void> {
    try {
      const message = IndexService.getMessage();
      res.send(message);
    } catch (error) {
      console.error('Get index error:', error);
      res.status(500).json({ error: 'Internal server error' });
    }
  }
}