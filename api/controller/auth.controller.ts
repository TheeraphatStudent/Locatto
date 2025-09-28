import { Request, Response } from 'express';
import { AuthService } from '../service/auth.service';
import * as jwt from 'jsonwebtoken';
import { sendError, sendFromService, sendSuccess } from '../utils/response.helper';

export class AuthController {
  static async register(req: Request, res: Response): Promise<void> {
    try {
      const { fullname, telno, cardId, email, img, username, password, credit } = req.body;

      const result = await AuthService.register({ fullname, telno, cardId, email, img, username, password, credit });
      const status = result.success ? 201 : (result.message === 'User already exists' ? 400 : 500);
      sendFromService({ res, status, result });
    } catch (error) {
      console.error('Register error:', error);
      sendError({ res, status: 500, message: 'Internal server error' });
    }
  }

  // app > route > controller > service > db

  static async login(req: Request, res: Response): Promise<void> {
    try {
      const { username, password } = req.body;

      const result = await AuthService.login({ username, password });
      const status = result.success ? 200 : (result.message === 'Invalid credentials' ? 401 : 500);
      sendFromService({ res, status, result });
    } catch (error) {
      console.error('Login error:', error);
      sendError({ res, status: 500, message: 'Internal server error' });
    }
  }

  static async resetPassword(req: Request, res: Response): Promise<void> {
    try {
      const { username, password, repeatPassword } = req.body;
      if (password !== repeatPassword) {
        sendError({ res, status: 400, message: 'Passwords do not match' });
        return;
      }

      const result = await AuthService.resetPassword({ username, password });
      const status = result.success ? 200 : (result.message === 'User not found' ? 404 : 500);
      sendFromService({ res, status, result });
    } catch (error) {
      console.error('Reset password error:', error);
      sendError({ res, status: 500, message: 'Internal server error' });
    }
  }

  static async me(req: Request, res: Response): Promise<void> {
    try {
      if (!req.user) {
        sendError({ res, status: 401, message: 'User not authenticated' });
        return;
      }

      const user = req.user as any;
      const result = await AuthService.me({ uid: user.uid });
      const status = result.success ? 200 : (result.message === 'User not found' ? 404 : 500);
      sendFromService({ res, status, result });
    } catch (error) {
      console.error('Me error:', error);
      sendError({ res, status: 500, message: 'Internal server error' });
    }
  }

  static async updateMe(req: Request, res: Response): Promise<void> {
    try {
      if (!req.user) {
        sendError({ res, status: 401, message: 'User not authenticated' });
        return;
      }

      const user = req.user as any;
      const { fullname, telno, cardId, email } = req.body;

      const result = await AuthService.updateMe({ uid: user.uid, fullname, telno, cardId, email });
      const status = result.success ? 200 : 500;
      sendFromService({ res, status, result });
    } catch (error) {
      console.error('Update me error:', error);
      sendError({ res, status: 500, message: 'Internal server error' });
    }
  }

  static async logout(req: Request, res: Response): Promise<void> {
    try {
      // console.log("Logout Request Body: ", req.body)

      const { token } = req.body;

      const decoded = jwt.decode(token);
      const { uid } = decoded as any;

      const result = await AuthService.logout({ uid, token });
      const status = result.success ? 200 : 500;
      sendFromService({ res, status, result });
    } catch (error) {
      console.error('Logout error:', error);
      sendError({ res, status: 500, message: 'Internal server error' });
    }
  }
}