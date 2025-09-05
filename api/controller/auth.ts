import { Request, Response } from 'express';
import { AuthService } from '../service/auth.service';
import * as jwt from 'jsonwebtoken';

export class AuthController {
  static async register(req: Request, res: Response): Promise<void> {
    try {
      const { fullname, telno, cardId, email, img, username, password, credit } = req.body;

      const result = await AuthService.register({ fullname, telno, cardId, email, img, username, password, credit });

      if (result.success) {
        res.json({
          message: result.message,
          userId: result.userId
        });
      } else {
        res.status(result.message === 'User already exists' ? 400 : 500).json({ error: result.message });
      }
    } catch (error) {
      console.error('Register error:', error);
      res.status(500).json({ error: 'Internal server error' });
    }
  }

  static async login(req: Request, res: Response): Promise<void> {
    try {
      const { username, password } = req.body;

      const result = await AuthService.login({ username, password });

      if (result.success) {
        res.json({
          message: result.message,
          token: result.token,
          user: result.user
        });
      } else {
        res.status(result.message === 'Invalid credentials' ? 401 : 500).json({ error: result.message });
      }
    } catch (error) {
      console.error('Login error:', error);
      res.status(500).json({ error: 'Internal server error' });
    }
  }

  static async resetPassword(req: Request, res: Response): Promise<void> {
    try {
      const { username, password, repeatPassword } = req.body;
      if (password !== repeatPassword) {
        res.status(400).json({ error: 'Passwords do not match' });
        return;
      }

      const result = await AuthService.resetPassword({ username, password });

      if (result.success) {
        res.json({ message: result.message });
      } else {
        res.status(result.message === 'User not found' ? 404 : 500).json({ error: result.message });
      }
    } catch (error) {
      console.error('Reset password error:', error);
      res.status(500).json({ error: 'Internal server error' });
    }
  }

  static async me(req: Request, res: Response): Promise<void> {
    try {
      const { username } = req.body;

      const result = await AuthService.me({ username });

      if (result.success) {
        res.json({
          message: result.message,
          user: result.user
        });
      } else {
        res.status(result.message === 'User not found' ? 404 : 500).json({ error: result.message });
      }
    } catch (error) {
      console.error('Me error:', error);
      res.status(500).json({ error: 'Internal server error' });
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
        res.json({
          message: result.message
        });
      } else {
        res.status(500).json({ error: result.message });
      }
    } catch (error) {
      console.error('Logout error:', error);
      res.status(500).json({ error: 'Internal server error' });
    }
  }
}
