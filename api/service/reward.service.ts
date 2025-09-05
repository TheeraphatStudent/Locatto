import { conn } from '../db/connectiondb';

export interface RewardData {
  rid?: number;
  lid: number | null;
  tier: string;
  revenue: number;
  winner?: string;
}

export class RewardService {
  static async create(data: RewardData): Promise<{ success: boolean; message: string; reward?: any }> {
    return new Promise((resolve) => {
      conn.query(
        'INSERT INTO reward (lid, tier, revenue, winner) VALUES (?, ?, ?, ?)',
        [data.lid, data.tier, data.revenue, data.winner || null],
        (err: any, result: any) => {
          if (err) {
            console.error('Database error:', err);
            resolve({ success: false, message: 'Internal server error' });
            return;
          }

          resolve({
            success: true,
            message: 'Reward created successfully',
            reward: { rid: result.insertId, ...data }
          });
        }
      );
    });
  }

  static async getAll(): Promise<any[]> {
    return new Promise((resolve, reject) => {
      conn.query(
        `SELECT r.*, l.lottery_number
         FROM reward r
         LEFT JOIN lottery l ON r.lid = l.lid
         ORDER BY r.created DESC`,
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

  static async getById(rid: number): Promise<any> {
    return new Promise((resolve, reject) => {
      conn.query(
        `SELECT r.*, l.lottery_number
         FROM reward r
         LEFT JOIN lottery l ON r.lid = l.lid
         WHERE r.rid = ?`,
        [rid],
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

  static async getByLotteryId(lid: number): Promise<any[]> {
    return new Promise((resolve, reject) => {
      conn.query(
        `SELECT r.*, l.lottery_number
         FROM reward r
         LEFT JOIN lottery l ON r.lid = l.lid
         WHERE r.lid = ?
         ORDER BY r.created DESC`,
        [lid],
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

  static async update(rid: number, data: Partial<RewardData>): Promise<{ success: boolean; message: string }> {
    return new Promise((resolve) => {
      const fields = [];
      const values = [];

      if (data.lid) {
        fields.push('lid = ?');
        values.push(data.lid);
      }
      if (data.tier) {
        fields.push('tier = ?');
        values.push(data.tier);
      }
      if (data.revenue !== undefined) {
        fields.push('revenue = ?');
        values.push(data.revenue);
      }
      if (data.winner !== undefined) {
        fields.push('winner = ?');
        values.push(data.winner);
      }

      if (fields.length === 0) {
        resolve({ success: false, message: 'No fields to update' });
        return;
      }

      values.push(rid);

      conn.query(
        `UPDATE reward SET ${fields.join(', ')} WHERE rid = ?`,
        values,
        (err: any, result: any) => {
          if (err) {
            console.error('Database error:', err);
            resolve({ success: false, message: 'Internal server error' });
            return;
          }

          if (result.affectedRows === 0) {
            resolve({ success: false, message: 'Reward not found' });
            return;
          }

          resolve({ success: true, message: 'Reward updated successfully' });
        }
      );
    });
  }

  static async updateOrCreate(data: { tier: string; revenue: number }): Promise<{ success: boolean; message: string; reward?: any }> {
    return new Promise(async (resolve) => {
      try {
        const existingReward = await this.getByTier(data.tier);

        if (existingReward) {
          const updateResult = await this.update(existingReward.rid, {
            revenue: data.revenue
          });

          if (updateResult.success) {
            const updatedReward = await this.getById(existingReward.rid);
            resolve({
              success: true,
              message: `Reward tier ${data.tier} updated successfully`,
              reward: updatedReward
            });
          } else {
            resolve(updateResult);
          }
        } else {
          const createResult = await this.create({
            lid: null,
            tier: data.tier,
            revenue: data.revenue
          });
          resolve(createResult);
        }
      } catch (error) {
        console.error('UpdateOrCreate reward error:', error);
        resolve({ success: false, message: 'Internal server error' });
      }
    });
  }

  static async getByTier(tier: string): Promise<any> {
    return new Promise((resolve, reject) => {
      conn.query(
        'SELECT * FROM reward WHERE tier = ?',
        [tier],
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
}