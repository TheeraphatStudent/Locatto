import { conn, queryAsync } from '../db/connectiondb';

export interface RewardData {
  rid?: number;
  lid: number | null;
  tier: string;
  revenue: number;
  winner?: string;
}

export class RewardService {
  static async create(data: RewardData): Promise<{ success: boolean; message: string; reward?: any }> {
    try {
      const [result] = await queryAsync(
        'INSERT INTO reward (lid, tier, revenue, winner) VALUES (?, ?, ?, ?)',
        [data.lid, data.tier, data.revenue, data.winner || null]
      );

      return {
        success: true,
        message: 'Reward created successfully',
        reward: { rid: (result as any).insertId, ...data }
      };
    } catch (error) {
      console.error('Database error:', error);
      return { success: false, message: 'Internal server error' };
    }
  }

  static async getAll(): Promise<any[]> {
    try {
      const [result] = await queryAsync(
        `SELECT r.*, l.lottery_number
         FROM reward r
         LEFT JOIN lottery l ON r.lid = l.lid
         ORDER BY r.created DESC`
      );
      return Array.isArray(result) ? result : [];
    } catch (error) {
      console.error('Database error:', error);
      throw error;
    }
  }

  static async getById(rid: number): Promise<any> {
    try {
      const [result] = await queryAsync(
        `SELECT r.*, l.lottery_number
         FROM reward r
         LEFT JOIN lottery l ON r.lid = l.lid
         WHERE r.rid = ?`,
        [rid]
      );
      return Array.isArray(result) && result.length > 0 ? result[0] : null;
    } catch (error) {
      console.error('Database error:', error);
      throw error;
    }
  }

  static async getByLotteryId(lid: number): Promise<any[]> {
    try {
      const [result] = await queryAsync(
        `SELECT r.*, l.lottery_number
         FROM reward r
         LEFT JOIN lottery l ON r.lid = l.lid
         WHERE r.lid = ?
         ORDER BY r.created DESC`,
        [lid]
      );
      return Array.isArray(result) ? result : [];
    } catch (error) {
      console.error('Database error:', error);
      throw error;
    }
  }

  static async update(rid: number, data: Partial<RewardData>): Promise<{ success: boolean; message: string }> {
    try {
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
        return { success: false, message: 'No fields to update' };
      }

      values.push(rid);

      const [result] = await queryAsync(
        `UPDATE reward SET ${fields.join(', ')} WHERE rid = ?`,
        values
      );

      if ((result as any).affectedRows === 0) {
        return { success: false, message: 'Reward not found' };
      }

      return { success: true, message: 'Reward updated successfully' };
    } catch (error) {
      console.error('Database error:', error);
      return { success: false, message: 'Internal server error' };
    }
  }

  static async updateOrCreate(data: { tier: string; revenue: number }): Promise<{ success: boolean; message: string; reward?: any }> {
    try {
      const existingReward = await this.getByTier(data.tier);

      if (existingReward) {
        const updateResult = await this.update(existingReward.rid, {
          revenue: data.revenue
        });

        if (updateResult.success) {
          const updatedReward = await this.getById(existingReward.rid);
          return {
            success: true,
            message: `Reward tier ${data.tier} updated successfully`,
            reward: updatedReward
          };
        } else {
          return updateResult;
        }
      } else {
        const createResult = await this.create({
          lid: null,
          tier: data.tier,
          revenue: data.revenue
        });
        return createResult;
      }
    } catch (error) {
      console.error('UpdateOrCreate reward error:', error);
      return { success: false, message: 'Internal server error' };
    }
  }

  static async getByTier(tier: string): Promise<any> {
    try {
      const [result] = await queryAsync('SELECT * FROM reward WHERE tier = ?', [tier]);
      return Array.isArray(result) && result.length > 0 ? result[0] : null;
    } catch (error) {
      console.error('Database error:', error);
      throw error;
    }
  }
}