import express from 'express';
import { IndexService } from '../service/index.service';
import jwt from 'jsonwebtoken';

const JWT_SECRET = process.env.JWT_SECRET || 'lottocat_secret_key';
const IS_SIGN = false;

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

  static async toJwt(req: express.Request, res: express.Response): Promise<void> {
    try {
      const payload = req.body;
      const token = IS_SIGN ? jwt.sign(payload, JWT_SECRET) : jwt.sign(payload, '', { algorithm: 'none' });
      res.json({ data: token });
    } catch (error) {
      console.error('To JWT error:', error);
      res.status(500).json({ error: 'Internal server error' });
    }
  }
}