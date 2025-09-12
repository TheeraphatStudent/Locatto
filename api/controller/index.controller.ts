import { Request, Response } from 'express';
import { IndexService } from '../service/index.service';
import { queryAsync } from '../db/connectiondb';
import jwt from 'jsonwebtoken';
import { sendError, sendFromService } from '../utils/response.helper';

const JWT_SECRET = process.env.JWT_SECRET || 'lottocat_secret_key';
const IS_SIGN = false;

export class IndexController {
  static async getIndex(req: Request, res: Response): Promise<void> {
    try {
      const message = IndexService.getMessage();
      sendFromService({ res, status: 200, result: { message } });
    } catch (error) {
      console.error('Get index error:', error);
      sendError({ res, status: 500, message: 'Internal server error' });
    }
  }

  static async toJwt(req: Request, res: Response): Promise<void> {
    try {
      const payload = req.body;
      const token = IS_SIGN ? jwt.sign(payload, JWT_SECRET) : jwt.sign(payload, '', { algorithm: 'none' });
      sendFromService({ res, status: 200, result: { token }, message: 'Token generated' });
    } catch (error) {
      console.error('To JWT error:', error);
      sendError({ res, status: 500, message: 'Internal server error' });
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

      const result = {
        success: true,
        message: 'System reset completed successfully',
        usersRemoved: (deleteResult as any).affectedRows
      };
      sendFromService({ res, status: 200, result });
    } catch (error) {
      console.error('System reset error:', error);
      sendError({ res, status: 500, message: 'Failed to reset system' });
    }
  }
}