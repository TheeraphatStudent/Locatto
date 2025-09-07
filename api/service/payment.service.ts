import { conn, queryAsync } from '../db/connectiondb';

export interface PaymentData {
  payid?: number;
  uid: number;
  tier: string;
  revenue: number;
}

export class PaymentService {
  static async create(data: PaymentData): Promise<{ success: boolean; message: string; payment?: any }> {
    try {
      const [result] = await queryAsync(
        'INSERT INTO payment (uid, tier, revenue) VALUES (?, ?, ?)',
        [data.uid, data.tier, data.revenue]
      );

      return {
        success: true,
        message: 'Payment created successfully',
        payment: { payid: (result as any).insertId, ...data }
      };
    } catch (error) {
      console.error('Database error:', error);
      return { success: false, message: 'Internal server error' };
    }
  }

  static async getAll(): Promise<any[]> {
    try {
      const [result] = await queryAsync(
        `SELECT p.*, u.name as user_name, u.username 
         FROM payment p 
         LEFT JOIN user u ON p.uid = u.uid 
         ORDER BY p.created DESC`
      );
      return Array.isArray(result) ? result : [];
    } catch (error) {
      console.error('Database error:', error);
      throw error;
    }
  }

  static async getById(payid: number): Promise<any> {
    try {
      const [result] = await queryAsync(
        `SELECT p.*, u.name as user_name, u.username 
         FROM payment p 
         LEFT JOIN user u ON p.uid = u.uid 
         WHERE p.payid = ?`,
        [payid]
      );
      return Array.isArray(result) && result.length > 0 ? result[0] : null;
    } catch (error) {
      console.error('Database error:', error);
      throw error;
    }
  }

  static async getByUserId(uid: number): Promise<any[]> {
    try {
      const [result] = await queryAsync(
        'SELECT * FROM payment WHERE uid = ? ORDER BY created DESC',
        [uid]
      );
      return Array.isArray(result) ? result : [];
    } catch (error) {
      console.error('Database error:', error);
      throw error;
    }
  }

  static async update(payid: number, data: Partial<PaymentData>): Promise<{ success: boolean; message: string }> {
    try {
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
        return { success: false, message: 'No fields to update' };
      }

      values.push(payid);

      const [result] = await queryAsync(
        `UPDATE payment SET ${fields.join(', ')} WHERE payid = ?`,
        values
      );

      if ((result as any).affectedRows === 0) {
        return { success: false, message: 'Payment not found' };
      }

      return { success: true, message: 'Payment updated successfully' };
    } catch (error) {
      console.error('Database error:', error);
      return { success: false, message: 'Internal server error' };
    }
  }

  static async delete(payid: number): Promise<{ success: boolean; message: string }> {
    try {
      const [result] = await queryAsync('DELETE FROM payment WHERE payid = ?', [payid]);

      if ((result as any).affectedRows === 0) {
        return { success: false, message: 'Payment not found' };
      }

      return { success: true, message: 'Payment deleted successfully' };
    } catch (error) {
      console.error('Database error:', error);
      return { success: false, message: 'Internal server error' };
    }
  }
}
