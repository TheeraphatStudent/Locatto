import { Request, Response } from 'express';
import { LotteryService, LotteryData } from '../service/lottery.service';
import { isRoleExst } from '../utils/auth.helper';
import { sendError, sendFromService } from '../utils/response.helper';

export class LotteryController {
  static async create(req: Request, res: Response): Promise<void> {
    try {
      // console.log("Request Body: ", req.body)

      const { n } = req.body;

      if (!req.user || !isRoleExst((req.user as any).role, 'admin')) {
        sendError({ res, status: 403, message: 'Admin access required', data: null as any });
        return;
      }

      if (!n || typeof n !== 'number') {
        sendError({ res, status: 400, message: 'n parameter is required and must be a number', data: null as any });
        return;
      }

      const result = await LotteryService.generateBulkLotteries(n);

      const status = result.success ? 201 : 400;
      sendFromService({ res, status, result });
    } catch (error) {
      console.error('Create lottery error:', error);
      sendError({ res, status: 500, message: 'Internal server error' });
    }
  }

  static async getAll(req: Request, res: Response): Promise<void> {
    try {
      // console.log('Calling getAllRewards');

      const page = parseInt(req.query.page as string) || 1;
      const size = parseInt(req.query.size as string) || 10;

      const { lotteries, total } = await LotteryService.getAll(page, size);
      sendFromService({
        res,
        status: 200,
        result: {
          data: lotteries,
          totalPages: Math.ceil(total / size),
          currentPage: page
        },
        message: 'Lotteries fetched successfully'
      });
    } catch (error) {
      console.error('Get lotteries error:', error);
      sendError({ res, status: 500, message: 'Internal server error' });
    }
  }

  static async search(req: Request, res: Response): Promise<void> {
    try {
      const { search } = req.body;
      const page = parseInt(req.query.page as string) || 1;
      const size = parseInt(req.query.size as string) || 10;

      if (!search) {
        sendError({ res, status: 400, message: 'Search query is required' });
        return;
      }

      const { lotteries, total } = await LotteryService.search(search, page, size);
      sendFromService({
        res,
        status: 200,
        result: {
          data: lotteries,
          totalPages: Math.ceil(total / size),
          currentPage: page
        },
        message: 'Search completed'
      });
    } catch (error) {
      console.error('Search lotteries error:', error);
      sendError({ res, status: 500, message: 'Internal server error' });
    }
  }

  static async getById(req: Request, res: Response): Promise<void> {
    try {
      // console.log('Calling getById with ID:', req.params.id);

      const id = +req.params.id;
      const lottery = await LotteryService.getById(id);
      
      if (lottery) {
        sendFromService({ res, status: 200, result: lottery, message: 'Lottery found' });
      } else {
        sendError({ res, status: 404, message: 'Lottery not found' });
      }
    } catch (error) {
      console.error('Get lottery by id error:', error);
      sendError({ res, status: 500, message: 'Internal server error' });
    }
  }

  static async update(req: Request, res: Response): Promise<void> {
    try {
      const id = +req.params.id;
      const updateData: Partial<LotteryData> = {};

      if (req.body.lottery_number) updateData.lottery_number = req.body.lottery_number;

      const result = await LotteryService.update(id, updateData);
      const status = result.success ? 200 : 404;
      sendFromService({ res, status, result });
    } catch (error) {
      console.error('Update lottery error:', error);
      sendError({ res, status: 500, message: 'Internal server error' });
    }
  }

  static async delete(req: Request, res: Response): Promise<void> {
    try {
      const id = +req.params.id;
      const result = await LotteryService.delete(id);
      const status = result.success ? 200 : 404;
      sendFromService({ res, status, result });
    } catch (error) {
      console.error('Delete lottery error:', error);
      sendError({ res, status: 500, message: 'Internal server error' });
    }
  }

  static async selectRandomWinnersFollowed(req: Request, res: Response): Promise<void> {
    try {
      if (!req.user || !isRoleExst((req.user as any).role, 'admin')) {
        sendError({ res, status: 403, message: 'Admin access required' });
        return;
      }

      const result = await LotteryService.selectRandomWinners(true);
      const status = result.success ? 200 : 400;
      sendFromService({ res, status, result: result.success ? { ...result, message: 'Random winners selected successfully (followed)' } : result });
    } catch (error) {
      console.error('Select random winners followed error:', error);
      sendError({ res, status: 500, message: 'Internal server error' });
    }
  }

  static async selectRandomWinnersUnfollowed(req: Request, res: Response): Promise<void> {
    try {
      if (!req.user || !isRoleExst((req.user as any).role, 'admin')) {
        sendError({ res, status: 403, message: 'Admin access required' });
        return;
      }

      const result = await LotteryService.selectRandomWinners(false);
      const status = result.success ? 200 : 400;
      sendFromService({ res, status, result: result.success ? { ...result, message: 'Random winners selected successfully (unfollowed)' } : result });
    } catch (error) {
      console.error('Select random winners unfollowed error:', error);
      sendError({ res, status: 500, message: 'Internal server error' });
    }
  }
}
