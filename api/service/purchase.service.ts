import { conn } from '../db/connectiondb';

export interface PurchaseData {
  pid?: number;
  uid: number;
  lid: number;
  lot_amount: number;
  payid: number;
}

export class PurchaseService {
  static async create(data: PurchaseData): Promise<{ success: boolean; message: string; purchase?: any }> {
    return new Promise((resolve) => {
      conn.query(
        'INSERT INTO purchase (uid, lid, lot_amount, payid) VALUES (?, ?, ?, ?)',
        [data.uid, data.lid, data.lot_amount, data.payid],
        (err: any, result: any) => {
          if (err) {
            console.error('Database error:', err);
            resolve({ success: false, message: 'Internal server error' });
            return;
          }

          resolve({
            success: true,
            message: 'Purchase created successfully',
            purchase: { pid: result.insertId, ...data }
          });
        }
      );
    });
  }

  static async getAll(): Promise<any[]> {
    return new Promise((resolve, reject) => {
      conn.query(
        `SELECT p.*, u.name as user_name, l.lottery_number, pay.tier as payment_tier 
         FROM purchase p 
         LEFT JOIN user u ON p.uid = u.uid 
         LEFT JOIN lottery l ON p.lid = l.lid 
         LEFT JOIN payment pay ON p.payid = pay.payid 
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

  static async getById(pid: number): Promise<any> {
    return new Promise((resolve, reject) => {
      conn.query(
        `SELECT p.*, u.name as user_name, l.lottery_number, pay.tier as payment_tier 
         FROM purchase p 
         LEFT JOIN user u ON p.uid = u.uid 
         LEFT JOIN lottery l ON p.lid = l.lid 
         LEFT JOIN payment pay ON p.payid = pay.payid 
         WHERE p.pid = ?`,
        [pid],
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
        `SELECT p.*, l.lottery_number, pay.tier as payment_tier 
         FROM purchase p 
         LEFT JOIN lottery l ON p.lid = l.lid 
         LEFT JOIN payment pay ON p.payid = pay.payid 
         WHERE p.uid = ? 
         ORDER BY p.created DESC`,
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

  static async update(pid: number, data: Partial<PurchaseData>): Promise<{ success: boolean; message: string }> {
    return new Promise((resolve) => {
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
        resolve({ success: false, message: 'No fields to update' });
        return;
      }

      values.push(pid);

      conn.query(
        `UPDATE purchase SET ${fields.join(', ')} WHERE pid = ?`,
        values,
        (err: any, result: any) => {
          if (err) {
            console.error('Database error:', err);
            resolve({ success: false, message: 'Internal server error' });
            return;
          }

          if (result.affectedRows === 0) {
            resolve({ success: false, message: 'Purchase not found' });
            return;
          }

          resolve({ success: true, message: 'Purchase updated successfully' });
        }
      );
    });
  }

  static async delete(pid: number): Promise<{ success: boolean; message: string }> {
    return new Promise((resolve) => {
      conn.query(
        'DELETE FROM purchase WHERE pid = ?',
        [pid],
        (err: any, result: any) => {
          if (err) {
            console.error('Database error:', err);
            resolve({ success: false, message: 'Internal server error' });
            return;
          }

          if (result.affectedRows === 0) {
            resolve({ success: false, message: 'Purchase not found' });
            return;
          }

          resolve({ success: true, message: 'Purchase deleted successfully' });
        }
      );
    });
  }
}
