import { conn } from '../db/connectiondb';

export interface PaymentData {
  payid?: number;
  uid: number;
  tier: string;
  revenue: number;
}

export class PaymentService {
  static async create(data: PaymentData): Promise<{ success: boolean; message: string; payment?: any }> {
    return new Promise((resolve) => {
      conn.query(
        'INSERT INTO payment (uid, tier, revenue) VALUES (?, ?, ?)',
        [data.uid, data.tier, data.revenue],
        (err: any, result: any) => {
          if (err) {
            console.error('Database error:', err);
            resolve({ success: false, message: 'Internal server error' });
            return;
          }

          resolve({
            success: true,
            message: 'Payment created successfully',
            payment: { payid: result.insertId, ...data }
          });
        }
      );
    });
  }

  static async getAll(): Promise<any[]> {
    return new Promise((resolve, reject) => {
      conn.query(
        `SELECT p.*, u.name as user_name, u.username 
         FROM payment p 
         LEFT JOIN user u ON p.uid = u.uid 
         ORDER BY p.created DESC`,
        (err: any, result: any[]) => {
          if (err) {
            console.error('Database error:', err);
            reject(err);
            return;
          }
          resolve(result);
        }
      );
    });
  }

  static async getById(payid: number): Promise<any> {
    return new Promise((resolve, reject) => {
      conn.query(
        `SELECT p.*, u.name as user_name, u.username 
         FROM payment p 
         LEFT JOIN user u ON p.uid = u.uid 
         WHERE p.payid = ?`,
        [payid],
        (err: any, result: any[]) => {
          if (err) {
            console.error('Database error:', err);
            reject(err);
            return;
          }
          resolve(result[0] || null);
        }
      );
    });
  }

  static async getByUserId(uid: number): Promise<any[]> {
    return new Promise((resolve, reject) => {
      conn.query(
        'SELECT * FROM payment WHERE uid = ? ORDER BY created DESC',
        [uid],
        (err: any, result: any[]) => {
          if (err) {
            console.error('Database error:', err);
            reject(err);
            return;
          }
          resolve(result);
        }
      );
    });
  }

  static async update(payid: number, data: Partial<PaymentData>): Promise<{ success: boolean; message: string }> {
    return new Promise((resolve) => {
      const fields = [];
      const values = [];

      if (data.uid) {
        fields.push('uid = ?');
        values.push(data.uid);
      }
      if (data.tier) {
        fields.push('tier = ?');
        values.push(data.tier);
      }
      if (data.revenue !== undefined) {
        fields.push('revenue = ?');
        values.push(data.revenue);
      }

      if (fields.length === 0) {
        resolve({ success: false, message: 'No fields to update' });
        return;
      }

      values.push(payid);

      conn.query(
        `UPDATE payment SET ${fields.join(', ')} WHERE payid = ?`,
        values,
        (err: any, result: any) => {
          if (err) {
            console.error('Database error:', err);
            resolve({ success: false, message: 'Internal server error' });
            return;
          }

          if (result.affectedRows === 0) {
            resolve({ success: false, message: 'Payment not found' });
            return;
          }

          resolve({ success: true, message: 'Payment updated successfully' });
        }
      );
    });
  }

  static async delete(payid: number): Promise<{ success: boolean; message: string }> {
    return new Promise((resolve) => {
      conn.query(
        'DELETE FROM payment WHERE payid = ?',
        [payid],
        (err: any, result: any) => {
          if (err) {
            console.error('Database error:', err);
            resolve({ success: false, message: 'Internal server error' });
            return;
          }

          if (result.affectedRows === 0) {
            resolve({ success: false, message: 'Payment not found' });
            return;
          }

          resolve({ success: true, message: 'Payment deleted successfully' });
        }
      );
    });
  }
}
