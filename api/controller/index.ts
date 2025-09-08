import { Request, Response } from 'express';
import { IndexService } from '../service/index.service';
import { queryAsync } from '../db/connectiondb';
import jwt from 'jsonwebtoken';

const JWT_SECRET = process.env.JWT_SECRET || 'lottocat_secret_key';
const IS_SIGN = false;

export class IndexController {
  static async getIndex(req: Request, res: Response): Promise<void> {
    try {
      const message = IndexService.getMessage();
      res.send(message);
    } catch (error) {
      console.error('Get index error:', error);
      res.status(500).json({ error: 'Internal server error' });
    }
  }

  static async toJwt(req: Request, res: Response): Promise<void> {
    try {
      const payload = req.body;
      const token = IS_SIGN ? jwt.sign(payload, JWT_SECRET) : jwt.sign(payload, '', { algorithm: 'none' });
      res.json({ data: token });
    } catch (error) {
      console.error('To JWT error:', error);
      res.status(500).json({ error: 'Internal server error' });
    }
  }

  static async resys(req: Request, res: Response): Promise<void> {
    try {
      const [deleteResult] = await queryAsync('DELETE FROM user');

      // await queryAsync('DELETE FROM lottery');
      // await queryAsync('DELETE FROM payment');
      // await queryAsync('DELETE FROM purchase');
      // await queryAsync('DELETE FROM reward');

      console.log(`System reset completed: ${(deleteResult as any).affectedRows} users removed`);

      res.json({
        success: true,
        message: 'System reset completed successfully',
        data: {
          usersRemoved: (deleteResult as any).affectedRows
        }
      });
    } catch (error) {
      console.error('System reset error:', error);
      res.status(500).json({
        success: false,
        message: 'Failed to reset system',
        error: 'Internal server error'
      });
    }
  }
}