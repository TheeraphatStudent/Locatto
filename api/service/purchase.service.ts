import { conn, queryAsync } from '../db/connectiondb';

export interface PurchaseData {
  pid?: number;
  uid: number;
  lid: number;
  lot_amount: number;
  payid: number;
}

export class PurchaseService {
  static async create(data: PurchaseData): Promise<{ success: boolean; message: string; purchase?: any, user?: any }> {
    try {
      const [user_credit] = await queryAsync(
        'SELECT credit FROM user where uid = ?',
        [data.uid]
      )

      console.log("User credit: ", user_credit)

      const [payment_revenue] = await queryAsync(
        'SELECT revenue FROM payment WHERE payid = ?',
        [data.payid]
      )

      console.log("Payment revenue: ", payment_revenue);

      const userCredit = parseInt(((user_credit as any) as any)[0].credit ?? "0")
      const paymentRevenue = parseInt(((payment_revenue as any) as any)[0].revenue ?? "80")

      if (userCredit < paymentRevenue) {
        return { success: false, message: 'Insufficient credit' };
      }

      const [result] = await queryAsync(
        'INSERT INTO purchase (uid, lid, lot_amount, payid) VALUES (?, ?, ?, ?)',
        [data.uid, data.lid, data.lot_amount, data.payid]
      );

      const updatedCredit = userCredit - paymentRevenue;

      await queryAsync(
        'UPDATE user SET credit = ? WHERE uid = ?',
        [updatedCredit, data.uid]
      )

      return {
        success: true,
        message: 'Purchase created successfully',
        purchase: { pid: (result as any).insertId, uid: data.uid, lid: data.lid, lot_amount: data.lot_amount, payid: data.payid },
        user: { uid: data.uid, credit: updatedCredit }
      };
    } catch (error) {
      console.error('Database error:', error);
      return { success: false, message: 'Internal server error' };
    }
  }

  static async getAll(): Promise<any[]> {
    try {
      const [result] = await queryAsync(
        `SELECT p.*, u.name as user_name, l.lottery_number
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
        `SELECT p.*, u.name as user_name, l.lottery_number
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
        `SELECT p.*, l.lottery_number
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

  static async getByUserWithStatus(uid: number, page: number, size: number): Promise<{ purchases: any[], total: number }> {
    try {
      const offset = (page - 1) * size;

      const purchases = (await queryAsync(
        `SELECT p.created, l.* FROM purchase p LEFT JOIN lottery l ON p.lid = l.lid WHERE p.uid = ? ORDER BY p.created DESC LIMIT ? OFFSET ?`,
        [uid, size, offset]
      ))[0] as any[];

      const [countResult] = await queryAsync('SELECT COUNT(*) as total FROM purchase WHERE uid = ?', [uid]);
      const total = Array.isArray(countResult) ? (countResult[0] as any).total : 0;

      const rewards = (await queryAsync('SELECT * FROM reward'))[0] as any[];
      const [userClaims] = await queryAsync('SELECT rid FROM winner WHERE uid = ?', [uid]);
      const claimedRids = new Set(Array.isArray(userClaims) ? userClaims.map((c: any) => c.rid) : []);

      const result = purchases.map((purchase: any) => {
        let status = 'pending';
        let rewardId = null;
        let prize = '-';

        const hasWinner = rewards.some((r: any) => r.winner != null);
        if (hasWinner) {
          const winningReward = rewards.find((r: any) => {
            if (r.winner == null) return false;
            if (r.tier === 'T1L3' && purchase.lottery_number.endsWith(r.winner)) return true;
            if (r.tier === 'R2' && purchase.lottery_number.endsWith(r.winner)) return true;
            return false;
          });
          if (winningReward) {
            rewardId = winningReward.rid;
            prize = winningReward.revenue.toString();
            if (claimedRids.has(winningReward.rid)) {
              status = 'claimed';
            } else {
              status = 'win';
            }
          } else {
            status = 'fail';
          }
        }
        return {
          created: purchase.created,
          status,
          rewardId,
          prize,
          lot_info: { ...purchase }
        };
      });

      return { purchases: result, total };
    } catch (error) {
      console.error('Database error:', error);
      throw error;
    }
  }
}
