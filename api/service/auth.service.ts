import bcrypt from 'bcrypt';
import jwt from 'jsonwebtoken';
import { conn } from '../db/connectiondb';
import { LoginRequest, RegisterRequest } from '../type/auth';

const JWT_SECRET = process.env.JWT_SECRET || 'lottocat_secret_key';

export class AuthService {
  static async register(userData: RegisterRequest): Promise<{ success: boolean; message: string; userId?: number }> {
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

  static async login(credentials: LoginRequest): Promise<{
    success: boolean;
    message: string;
    token?: string;
    user?: any;
  }> {
    return new Promise((resolve) => {
      conn.query(
        'SELECT uid, name, telno, email, password, credit, role FROM user WHERE username = ?',
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
                role: user.role,
                name: user.name
              },
              JWT_SECRET,
              { expiresIn: '7d' }
            ) : jwt.sign(
              {
                uid: user.uid,
                role: user.role,
                name: user.name
              },
              '',
              { algorithm: 'none', expiresIn: '7d' }
            );

            // console.log('Updating token for uid:', user.uid);
            conn.query(
              'UPDATE user SET token = ? WHERE uid = ?',
              [token, user.uid],
              (updateErr: any) => {
                if (updateErr) {
                  console.error('Database error:', updateErr);
                  resolve({ success: false, message: 'Internal server error' });
                  return;
                }
                console.log('Token updated successfully');

                resolve({
                  success: true,
                  message: 'Login successful',
                  token,
                  user: {
                    uid: user.uid,
                    name: user.name,
                    telno: user.telno,
                    email: user.email,
                    credit: user.credit,
                    role: user.role
                  }
                });
              }
            );
          } catch (error) {
            console.error('Login error:', error);
            resolve({ success: false, message: 'Internal server error' });
          }
        }
      );
    });
  }

  static async resetPassword(data: LoginRequest): Promise<{ success: boolean; message: string }> {
    // console.log("Reset Password Data: ", data)

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

  static async me(data: { uid: number }): Promise<{ success: boolean; message: string; user?: any }> {
    return new Promise((resolve) => {
      conn.query(
        'SELECT name, telno, email, credit, role FROM user WHERE uid = ?',
        [data.uid],
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

  static async logout(data: { uid: number, token: string }): Promise<{ success: boolean; message: string }> {
    // console.log("Logout Data: ", data)

    return new Promise((resolve) => {
      conn.query(
        'UPDATE user SET token = "" WHERE uid = ? AND token = ?',
        [data.uid, data.token],
        (err: any, result: any) => {
          if (err) {
            console.error('Database error:', err);
            resolve({ success: false, message: 'Internal server error' });
            return;
          }
          // console.log('Logout query result:', result);
          // console.log('Rows affected:', result.affectedRows);

          if (result.affectedRows === 0) {
            resolve({ success: false, message: 'User not found' });
            return;
          }

          resolve({ success: true, message: 'Logged out successfully' });
        }
      );
    });
  }
}
