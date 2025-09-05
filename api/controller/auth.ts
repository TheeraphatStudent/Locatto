import express from 'express';
import { AuthService } from '../service/auth.service';

export class AuthController {
  static async register(req: express.Request, res: express.Response): Promise<void> {
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

  static async login(req: express.Request, res: express.Response): Promise<void> {
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

  static async resetPassword(req: express.Request, res: express.Response): Promise<void> {
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

  static async me(req: express.Request, res: express.Response): Promise<void> {
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

  static async logout(req: express.Request, res: express.Response): Promise<void> {
    try {
      const { username } = req.body;

      const result = await AuthService.logout({username});

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
