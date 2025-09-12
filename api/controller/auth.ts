import { Request, Response } from 'express';
import { AuthService } from '../service/auth.service';
import * as jwt from 'jsonwebtoken';
import { sendSuccess, sendError } from '../utils/response.helper';

export class AuthController {
  static async register(req: Request, res: Response): Promise<void> {
    try {
      const { fullname, telno, cardId, email, img, username, password, credit } = req.body;

      const result = await AuthService.register({ fullname, telno, cardId, email, img, username, password, credit });

      if (result.success) {
        sendSuccess(res, result.message, { userId: result.userId }, 201);
      } else {
        sendError(res, result.message, null, result.message === 'User already exists' ? 400 : 500);
      }
    } catch (error) {
      console.error('Register error:', error);
      sendError(res, 'Internal server error', null, 500);
    }
  }

  static async login(req: Request, res: Response): Promise<void> {
    try {
      const { username, password } = req.body;

      const result = await AuthService.login({ username, password });

      if (result.success) {
        // res.json({
        //   message: result.message,
        //   data: {
        //     token: result.token,
        //     user: result.user
        //   }
        // });
        sendSuccess(res, result.message, { token: result.token, user: result.user }, 200);
      } else {
        sendError(res, result.message, null, result.message === 'Invalid credentials' ? 401 : 500);
      }
    } catch (error) {
      console.error('Login error:', error);
      sendError(res, 'Internal server error', null, 500);
    }
  }

  static async resetPassword(req: Request, res: Response): Promise<void> {
    try {
      const { username, password, repeatPassword } = req.body;
      if (password !== repeatPassword) {
        sendError(res, 'Passwords do not match', null, 400);
        return;
      }

      const result = await AuthService.resetPassword({ username, password });

      if (result.success) {
        sendSuccess(res, result.message, null, 200);
      } else {
        sendError(res, result.message, null, result.message === 'User not found' ? 404 : 500);
      }
    } catch (error) {
      console.error('Reset password error:', error);
      sendError(res, 'Internal server error', null, 500);
    }
  }

  static async me(req: Request, res: Response): Promise<void> {
    try {
      if (!req.user) {
        sendError(res, 'User not authenticated', null, 401);
        return;
      }

      const user = req.user as any;
      const result = await AuthService.me({ uid: user.uid });

      if (result.success) {
        sendSuccess(res, result.message, { user: result.user }, 200);
      } else {
        sendError(res, result.message, null, result.message === 'User not found' ? 404 : 500);
      }
    } catch (error) {
      console.error('Me error:', error);
      sendError(res, 'Internal server error', null, 500);
    }
  }

  static async logout(req: Request, res: Response): Promise<void> {
    try {
      // console.log("Logout Request Body: ", req.body)

      const { token } = req.body;

      const decoded = jwt.decode(token);
      const { uid } = decoded as any;

      const result = await AuthService.logout({ uid, token });

      if (result.success) {
        sendSuccess(res, result.message, null, 200);
      } else {
        sendError(res, result.message, null, 500);
      }
    } catch (error) {
      console.error('Logout error:', error);
      sendError(res, 'Internal server error', null, 500);
    }
  }
}
