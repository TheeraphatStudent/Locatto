import { conn, queryAsync } from '../db/connectiondb';

export interface PurchaseData {
  pid?: number;
  uid: number;
  lid: number;
  lot_amount: number;
  payid: number;
}

export class PurchaseService {
  static async create(data: PurchaseData): Promise<{ success: boolean; message: string; purchase?: any }> {
    try {
      const [result] = await queryAsync(
        'INSERT INTO purchase (uid, lid, lot_amount, payid) VALUES (?, ?, ?, ?)',
        [data.uid, data.lid, data.lot_amount, data.payid]
      );

      return {
        success: true,
        message: 'Purchase created successfully',
        purchase: { pid: (result as any).insertId, ...data }
      };
    } catch (error) {
      console.error('Database error:', error);
      return { success: false, message: 'Internal server error' };
    }
  }

  static async getAll(): Promise<any[]> {
    try {
      const [result] = await queryAsync(
        `SELECT p.*, u.name as user_name, l.lottery_number, pay.tier as payment_tier 
         FROM purchase p 
         LEFT JOIN user u ON p.uid = u.uid 
         LEFT JOIN lottery l ON p.lid = l.lid 
         LEFT JOIN payment pay ON p.payid = pay.payid 
         ORDER BY p.created DESC`
      );
      return Array.isArray(result) ? result : [];
    } catch (error) {
      console.error('Database error:', error);
      throw error;
    }
  }

  static async getById(pid: number): Promise<any> {
    try {
      const [result] = await queryAsync(
        `SELECT p.*, u.name as user_name, l.lottery_number, pay.tier as payment_tier 
         FROM purchase p 
         LEFT JOIN user u ON p.uid = u.uid 
         LEFT JOIN lottery l ON p.lid = l.lid 
         LEFT JOIN payment pay ON p.payid = pay.payid 
         WHERE p.pid = ?`,
        [pid]
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
        `SELECT p.*, l.lottery_number, pay.tier as payment_tier 
         FROM purchase p 
         LEFT JOIN lottery l ON p.lid = l.lid 
         LEFT JOIN payment pay ON p.payid = pay.payid 
         WHERE p.uid = ? 
         ORDER BY p.created DESC`,
        [uid]
      );
      return Array.isArray(result) ? result : [];
    } catch (error) {
      console.error('Database error:', error);
      throw error;
    }
  }

  static async update(pid: number, data: Partial<PurchaseData>): Promise<{ success: boolean; message: string }> {
    try {
      const fields = [];
      const values = [];

      if (data.uid) {
        fields.push('uid = ?');
        values.push(data.uid);
      }
      if (data.lid) {
        fields.push('lid = ?');
        values.push(data.lid);
      }
      if (data.lot_amount) {
        fields.push('lot_amount = ?');
        values.push(data.lot_amount);
      }
      if (data.payid) {
        fields.push('payid = ?');
        values.push(data.payid);
      }

      if (fields.length === 0) {
        return { success: false, message: 'No fields to update' };
      }

      values.push(pid);

      const [result] = await queryAsync(
        `UPDATE purchase SET ${fields.join(', ')} WHERE pid = ?`,
        values
      );

      if ((result as any).affectedRows === 0) {
        return { success: false, message: 'Purchase not found' };
      }

      return { success: true, message: 'Purchase updated successfully' };
    } catch (error) {
      console.error('Database error:', error);
      return { success: false, message: 'Internal server error' };
    }
  }

  static async delete(pid: number): Promise<{ success: boolean; message: string }> {
    try {
      const [result] = await queryAsync('DELETE FROM purchase WHERE pid = ?', [pid]);

      if ((result as any).affectedRows === 0) {
        return { success: false, message: 'Purchase not found' };
      }

      return { success: true, message: 'Purchase deleted successfully' };
    } catch (error) {
      console.error('Database error:', error);
      return { success: false, message: 'Internal server error' };
    }
  }
}
