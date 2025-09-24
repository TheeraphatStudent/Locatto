import { conn, queryAsync } from '../db/connectiondb';

export interface RewardData {
  rid?: number;
  tier: string;
  revenue: number;
  winner?: string;
}

export class RewardService {
  static async create(data: RewardData): Promise<{ success: boolean; message: string; reward?: any }> {
    try {
      const [result] = await queryAsync(
        'INSERT INTO reward (tier, revenue, winner) VALUES (?, ?, ?)',
        [data.tier, data.revenue, data.winner || null]
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
        `SELECT *
         FROM reward
         ORDER BY created DESC`
      );
      return Array.isArray(result) ? result : [];
    } catch (error) {
      console.error('Database error:', error);
      throw error;
    }
  }

  static async getAllRewards(): Promise<any[]> {
    try {
      // console.log('>>> USING getAllRewards SQL <<<');
      const [result] = await queryAsync(
        `SELECT *
         FROM reward
         ORDER BY created DESC`
      );
      return Array.isArray(result) ? result : [];
    } catch (error) {
      console.error('Database error in getAllRewards:', error);
      throw error;
    }
  }

  static async getById(rid: number): Promise<any> {
    try {
      const [result] = await queryAsync(
        `SELECT *
         FROM reward
         WHERE rid = ?`,
        [rid]
      );
      return Array.isArray(result) && result.length > 0 ? result[0] : null;
    } catch (error) {
      console.error('Database error:', error);
      throw error;
    }
  }

  static async update(rid: number, data: Partial<RewardData>): Promise<{ success: boolean; message: string }> {
    try {
      const fields = [];
      const values = [];

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
    // console.log('Data:', data);

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

  static async claimReward(uid: number, rid: number): Promise<{ success: boolean; message: string; user?: any; lotteryNumber?: string }> {
    try {
      // 1. หา reward
      const reward = await this.getById(rid);
      if (!reward) {
        return { success: false, message: 'Reward not found' };
      }

      // 2. ตรวจสอบว่าผู้ใช้มีสิทธิ์เคลมหรือไม่ (มีเลขที่ถูกรางวัล)
      // ตรวจสอบจาก purchase ที่มี lottery_number ตรงกับ winner โดยใช้ logic จาก winner endpoint
      const [purchaseResult] = await queryAsync(
        `SELECT p.pid, l.lottery_number FROM purchase p 
       INNER JOIN lottery l ON p.lid = l.lid 
       WHERE p.uid = ?`,
        [uid]
      );

      if (!Array.isArray(purchaseResult) || purchaseResult.length === 0) {
        return { success: false, message: 'No lottery purchases found for this user' };
      }

      // ตรวจสอบว่ามี lottery number ที่ถูกรางวัลหรือไม่
      let hasWinningTicket = false;
      let winningLotteryNumber = '';

      for (const purchase of purchaseResult as any[]) {
        const lotteryNumber = (purchase as any).lottery_number;

        // ตรวจสอบตาม tier เหมือนใน winner endpoint
        if (reward.tier === 'T1' && lotteryNumber === reward.winner) {
          hasWinningTicket = true;
          winningLotteryNumber = lotteryNumber;
          break;
        } else if (reward.tier === 'T2' && lotteryNumber === reward.winner) {
          hasWinningTicket = true;
          winningLotteryNumber = lotteryNumber;
          break;
        } else if (reward.tier === 'T3' && lotteryNumber === reward.winner) {
          hasWinningTicket = true;
          winningLotteryNumber = lotteryNumber;
          break;
        } else if (reward.tier === 'T1L3' && lotteryNumber.endsWith(reward.winner)) {
          hasWinningTicket = true;
          winningLotteryNumber = lotteryNumber;
          break;
        } else if (reward.tier === 'R2' && lotteryNumber.endsWith(reward.winner)) {
          hasWinningTicket = true;
          winningLotteryNumber = lotteryNumber;
          break;
        }
      }

      if (!hasWinningTicket) {
        return { success: false, message: 'You are not eligible to claim this reward - no winning lottery number found' };
      }

      // 3. ตรวจสอบว่าเคลมไปแล้วหรือไม่
      const [claimResult] = await queryAsync('SELECT * FROM winner WHERE uid = ? AND rid = ?', [uid, rid]);
      if (Array.isArray(claimResult) && claimResult.length > 0) {
        return { success: false, message: 'Reward already claimed' };
      }

      // 4. เพิ่มเครดิตเข้า user
      await queryAsync('UPDATE user SET credit = credit + ? WHERE uid = ?', [
        reward.revenue,
        uid,
      ]);

      // // 5. บันทึกการเคลมใน winner table
      // await queryAsync('INSERT INTO winner (uid, rid, payid, amount) VALUES (?, ?, NULL, ?)', 
      //   [uid, rid, reward.revenue]);

      // 6. return user ใหม่
      const [userResult] = await queryAsync('SELECT uid, credit FROM user WHERE uid = ?', [uid]);
      const user = Array.isArray(userResult) && userResult.length > 0 ? userResult[0] : null;

      return { success: true, message: 'Reward claimed successfully', user, lotteryNumber: winningLotteryNumber };
    } catch (error) {
      console.error('Claim reward error:', error);
      return { success: false, message: 'Internal server error' };
    }
  }
}

