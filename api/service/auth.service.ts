import bcrypt from 'bcrypt';
import jwt from 'jsonwebtoken';
import { conn, queryAsync } from '../db/connectiondb';
import { LoginRequest, RegisterRequest } from '../type/auth';

const JWT_SECRET = process.env.JWT_SECRET || 'lottocat_secret_key';

export class AuthService {
  static async register(userData: RegisterRequest): Promise<{ success: boolean; message: string; userId?: number }> {
    try {
      const [existingUsers] = await queryAsync(
        'SELECT uid FROM user WHERE username = ? OR email = ?',
        [userData.username, userData.email]
      );

      if (Array.isArray(existingUsers) && existingUsers.length > 0) {
        return { success: false, message: 'User already exists' };
      }

      const hashedPassword = await bcrypt.hash(userData.password, 10);

      const emailLower = userData.email.toLowerCase();
      const role = emailLower.includes('admin') ? 'admin' : 'user';

      console.log(`User email: ${userData.email}, Lowercase: ${emailLower}, Assigned role: ${role}`);

      const [result] = await queryAsync(
        'INSERT INTO user (name, telno, card_id, email, img, username, password, credit, role) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)',
        [
          userData.fullname, 
          userData.telno, 
          userData.cardId, 
          userData.email, 
          userData.img, 
          userData.username, 
          hashedPassword, 
          userData.credit || 0, 
          role
        ]
      );

      return {
        success: true,
        message: 'User registered successfully',
        userId: (result as any).insertId
      };
    } catch (error) {
      console.error('Database error:', error);
      return { success: false, message: 'Internal server error' };
    }
  }

  static async login(credentials: LoginRequest): Promise<{
    success: boolean;
    message: string;
    token?: string;
    user?: any;
  }> {
    try {
      const [users] = await queryAsync(
        'SELECT uid, name, password, credit, role FROM user WHERE email = ? OR username = ?',
        [credentials.username, credentials.username]
      );

      if (!Array.isArray(users) || users.length === 0) {
        return { success: false, message: 'Invalid credentials' };
      }

      const user = (users as any[])[0];

      const isValidPassword = await bcrypt.compare(credentials.password, user.password);
      
      if (!isValidPassword) {
        return { success: false, message: 'Invalid credentials' };
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

      await queryAsync(
        'UPDATE user SET token = ? WHERE uid = ?',
        [token, user.uid]
      );

      console.log('Token updated successfully');

      return {
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
      };
    } catch (error) {
      console.error('Login error:', error);
      return { success: false, message: 'Internal server error' };
    }
  }

  static async resetPassword(data: LoginRequest): Promise<{ success: boolean; message: string }> {
    try {
      console.log("Reset password data:", data);

      const [users] = await queryAsync(
        'SELECT uid FROM user WHERE username = ?',
        [data.username]
      );

      console.log("Users found:", users);

      if (!Array.isArray(users) || users.length === 0) {
        return { success: false, message: 'User not found' };
      }

      const hashedPassword = await bcrypt.hash(data.password, 10);

      await queryAsync(
        'UPDATE user SET password = ? WHERE username = ?',
        [hashedPassword, data.username]
      );

      console.log('Password reset successful for user:', data.username);

      return { success: true, message: 'Password reset successful' };
    } catch (error) {
      console.error('Reset password error:', error);
      return { success: false, message: 'Internal server error' };
    }
  }

  static async me(data: { uid: number }): Promise<{ success: boolean; message: string; user?: any }> {
    try {
      const [users] = await queryAsync(
        'SELECT name, telno, email, credit, role FROM user WHERE uid = ?',
        [data.uid]
      );

      if (!Array.isArray(users) || users.length === 0) {
        return { success: false, message: 'User not found' };
      }

      return { success: true, message: 'User found', user: (users as any[])[0] };
    } catch (error) {
      console.error('Database error:', error);
      return { success: false, message: 'Internal server error' };
    }
  }

  static async validateUserToken(data: { uid: number; token: string }): Promise<{ success: boolean; message: string; user?: any }> {
    try {
      console.log("Data: ", data)

      const [users] = await queryAsync(
        'SELECT uid, name, telno, email, credit, role FROM user WHERE uid = ? AND token = ?',
        [data.uid, data.token]
      );

      console.log("Users: ", users)

      if (!Array.isArray(users) || users.length === 0) {
        return { success: false, message: 'User not found or token mismatch' };
      }

      return {
        success: true,
        message: 'User and token validated',
        user: (users as any[])[0]
      };
    } catch (error) {
      console.error('Database error:', error);
      return { success: false, message: 'Internal server error' };
    }
  }

  static async logout(data: { uid: number, token: string }): Promise<{ success: boolean; message: string }> {
    try {
      const [result] = await queryAsync(
        'UPDATE user SET token = "" WHERE uid = ? AND token = ?',
        [data.uid, data.token]
      );

      if ((result as any).affectedRows === 0) {
        return { success: false, message: 'User not found' };
      }

      return { success: true, message: 'Logged out successfully' };
    } catch (error) {
      console.error('Database error:', error);
      return { success: false, message: 'Internal server error' };
    }
  }
}
