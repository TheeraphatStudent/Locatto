import bcrypt from 'bcrypt';
import jwt from 'jsonwebtoken';
import { conn } from '../db/connectiondb';

const JWT_SECRET = process.env.JWT_SECRET || 'lottocat_secret_key';

export class AuthService {
  static async register(userData: {
    fullname: string;
    telno: string;
    cardId: string;
    email: string;
    img: string;
    username: string;
    password: string;
    credit?: number;
  }): Promise<{ success: boolean; message: string; userId?: number }> {
    return new Promise((resolve) => {
      conn.query(
        'SELECT uid FROM user WHERE username = ? OR email = ?',
        [userData.username, userData.email],
        async (err: any, result: any[]) => {
          if (err) {
            console.error('Database error:', err);
            resolve({ success: false, message: 'Internal server error' });
            return;
          }

          if (result.length > 0) {
            resolve({ success: false, message: 'User already exists' });
            return;
          }

          try {
            const hashedPassword = await bcrypt.hash(userData.password, 10);

            conn.query(
              'INSERT INTO user (name, telno, card_id, email, img, username, password, credit) VALUES (?, ?, ?, ?, ?, ?, ?, ?)',
              [userData.fullname, userData.telno, userData.cardId, userData.email, userData.img, userData.username, hashedPassword, userData.credit || 0],
              (err: any, result: any) => {
                if (err) {
                  console.error('Database error:', err);
                  resolve({ success: false, message: 'Internal server error' });
                  return;
                }

                resolve({
                  success: true,
                  message: 'User registered successfully',
                  userId: result.insertId
                });
              }
            );
          } catch (error) {
            console.error('Hash error:', error);
            resolve({ success: false, message: 'Internal server error' });
          }
        }
      );
    });
  }

  static async login(credentials: { username: string; password: string }): Promise<{
    success: boolean;
    message: string;
    token?: string;
    user?: any;
  }> {
    return new Promise((resolve) => {
      conn.query(
        'SELECT uid, name, telno, email, password, credit FROM user WHERE username = ?',
        [credentials.username],
        async (err: any, result: any[]) => {
          if (err) {
            console.error('Database error:', err);
            resolve({ success: false, message: 'Internal server error' });
            return;
          }

          if (result.length === 0) {
            resolve({ success: false, message: 'Invalid credentials' });
            return;
          }

          const user = result[0];

          try {
            const isValidPassword = await bcrypt.compare(credentials.password, user.password);
            if (!isValidPassword) {
              resolve({ success: false, message: 'Invalid credentials' });
              return;
            }

            const IS_SIGN = process.env.IS_SIGN === 'true';
            const token = IS_SIGN ? jwt.sign(
              {
                uid: user.uid,
                username: user.username,
                name: user.name
              },
              JWT_SECRET,
              { expiresIn: '7d' }
            ) : jwt.sign(
              {
                uid: user.uid,
                username: user.username,
                name: user.name
              },
              '',
              { algorithm: 'none', expiresIn: '7d' }
            );

            resolve({
              success: true,
              message: 'Login successful',
              token,
              user: {
                uid: user.uid,
                name: user.name,
                telno: user.telno,
                email: user.email,
                credit: user.credit
              }
            });
          } catch (error) {
            console.error('Login error:', error);
            resolve({ success: false, message: 'Internal server error' });
          }
        }
      );
    });
  }

  static async resetPassword(data: { username: string; password: string }): Promise<{ success: boolean; message: string }> {
    return new Promise((resolve) => {
      conn.query(
        'SELECT uid FROM user WHERE username = ?',
        [data.username],
        async (err: any, result: any[]) => {
          if (err) {
            console.error('Database error:', err);
            resolve({ success: false, message: 'Internal server error' });
            return;
          }

          if (result.length === 0) {
            resolve({ success: false, message: 'User not found' });
            return;
          }

          try {
            const hashedPassword = await bcrypt.hash(data.password, 10);

            conn.query(
              'UPDATE user SET password = ? WHERE username = ?',
              [hashedPassword, data.username],
              (err: any, result: any) => {
                if (err) {
                  console.error('Database error:', err);
                  resolve({ success: false, message: 'Internal server error' });
                  return;
                }

                resolve({ success: true, message: 'Password reset successful' });
              }
            );
          } catch (error) {
            console.error('Hash error:', error);
            resolve({ success: false, message: 'Internal server error' });
          }
        }
      );
    });
  }

  static async me(data: { username: string }): Promise<{ success: boolean; message: string; user?: any }> {
    return new Promise((resolve) => {
      conn.query(
        'SELECT uid, name, telno, email, password, credit FROM user WHERE username = ?',
        [data.username],
        (err: any, result: any[]) => {
          if (err) {
            console.error('Database error:', err);
            resolve({ success: false, message: 'Internal server error' });
            return;
          }

          if (result.length === 0) {
            resolve({ success: false, message: 'User not found' });
            return;
          }

          resolve({ success: true, message: 'User found', user: result[0] });
        }
      );
    });
  }

  static async logout(data: { username: string }): Promise<{ success: boolean; message: string }> {
    return new Promise((resolve) => {
      conn.query(
        'UPDATE user SET token = NULL WHERE username = ?',
        [data.username],
        (err: any, result: any) => {
          if (err) {
            console.error('Database error:', err);
            resolve({ success: false, message: 'Internal server error' });
            return;
          }

          resolve({ success: true, message: 'Logged out successfully' });
        }
      );
    });
  }
}
