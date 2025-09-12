import { Request, Response } from 'express';
import { LotteryService, LotteryData } from '../service/lottery.service';
import { isRoleExst } from '../utils/auth.helper';
import { sendSuccess, sendError } from '../utils/response.helper';

export class LotteryController {
  static async create(req: Request, res: Response): Promise<void> {
    try {
      // console.log("Request Body: ", req.body)
      // console.log("Request User: ", req.user)

      const { n } = req.body;

      if (!req.user || !isRoleExst((req.user as any).role, 'admin')) {
        sendError(res, 'Admin access required', null, 403);
        return;
      }

      if (!n || typeof n !== 'number') {
        sendError(res, 'n parameter is required and must be a number', null, 400);
        return;
      }

      const result = await LotteryService.generateBulkLotteries(n);

      if (result.success) {
        sendSuccess(res, result.message, {
          lotteries: result.lotteries,
          generated: result.generated
        }, 201);
      } else {
        sendError(res, result.message, null, 400);
      }
    } catch (error) {
      console.error('Create lottery error:', error);
      sendError(res, 'Internal server error', null, 500);
    }
  }

  static async getAll(req: Request, res: Response): Promise<void> {
    try {
      const page = parseInt(req.query.page as string) || 1;
      const size = parseInt(req.query.size as string) || 10;

      const { lotteries, total } = await LotteryService.getAll(page, size);
      sendSuccess(res, 'Lotteries retrieved successfully', {
        data: lotteries,
        totalPages: Math.ceil(total / size),
        currentPage: page,
      }, 200);
    } catch (error) {
      console.error('Get lotteries error:', error);
      sendError(res, 'Internal server error', null, 500);
    }
  }

  static async search(req: Request, res: Response): Promise<void> {
    try {
      const { search } = req.body;
      const page = parseInt(req.query.page as string) || 1;
      const size = parseInt(req.query.size as string) || 10;

      if (!search) {
        sendError(res, 'Search query is required', null, 400);
        return;
      }

      const { lotteries, total } = await LotteryService.search(search, page, size);
      sendSuccess(res, 'Lotteries searched successfully', {
        data: lotteries,
        totalPages: Math.ceil(total / size),
        currentPage: page,
      }, 200);
    } catch (error) {
      console.error('Search lotteries error:', error);
      sendError(res, 'Internal server error', null, 500);
    }
  }

  static async getById(req: Request, res: Response): Promise<void> {
    try {
      const id = +req.params.id;
      const lottery = await LotteryService.getById(id);
      
      if (lottery) {
        sendSuccess(res, 'Lottery found', lottery, 200);
      } else {
        sendError(res, 'Lottery not found', null, 404);
      }
    } catch (error) {
      console.error('Get lottery by id error:', error);
      sendError(res, 'Internal server error', null, 500);
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
        sendSuccess(res, result.message, null, 200);
      } else {
        sendError(res, result.message, null, 404);
      }
    } catch (error) {
      console.error('Update lottery error:', error);
      sendError(res, 'Internal server error', null, 500);
    }
  }

  static async delete(req: Request, res: Response): Promise<void> {
    try {
      const id = +req.params.id;
      const result = await LotteryService.delete(id);

      if (result.success) {
        sendSuccess(res, result.message, null, 200);
      } else {
        sendError(res, result.message, null, 404);
      }
    } catch (error) {
      console.error('Delete lottery error:', error);
      sendError(res, 'Internal server error', null, 500);
    }
  }

  static async selectRandomWinnersFollowed(req: Request, res: Response): Promise<void> {
    try {
      if (!req.user || !isRoleExst((req.user as any).role, 'admin')) {
        sendError(res, 'Admin access required', null, 403);
        return;
      }

      const result = await LotteryService.selectRandomWinners(true);

      if (result.success) {
        sendSuccess(res, 'Random winners selected successfully (followed)', null, 200);
      } else {
        sendError(res, result.message, null, 400);
      }
    } catch (error) {
      console.error('Select random winners followed error:', error);
      sendError(res, 'Internal server error', null, 500);
    }
  }

  static async selectRandomWinnersUnfollowed(req: Request, res: Response): Promise<void> {
    try {
      if (!req.user || !isRoleExst((req.user as any).role, 'admin')) {
        sendError(res, 'Admin access required', null, 403);
        return;
      }

      const result = await LotteryService.selectRandomWinners(false);

      if (result.success) {
        sendSuccess(res, 'Random winners selected successfully (unfollowed)', null, 200);
      } else {
        sendError(res, result.message || 'Failed to select winners', null, 400);
      }
    } catch (error) {
      console.error('Select random winners unfollowed error:', error);
      sendError(res, 'Internal server error', null, 500);
    }
  }
}
