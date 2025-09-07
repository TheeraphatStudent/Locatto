import { conn, queryAsync } from '../db/connectiondb';
import { Tiers } from '../type/reward';
import { generateDerivedTiers, formatTierResult } from '../utils/tier.manager';

export interface LotteryData {
  lid?: number;
  lottery_number: string;
  period: string;
}

export class LotteryService {
  static async create(data: LotteryData): Promise<{ success: boolean; message: string; lottery?: any }> {
    try {
      const [result] = await queryAsync(
        'INSERT INTO lottery (lottery_number, period) VALUES (?, ?)',
        [data.lottery_number, data.period]
      );

      return {
        success: true,
        message: 'Lottery created successfully',
        lottery: { lid: (result as any).insertId, ...data }
      };
    } catch (error: any) {
      console.error('Database error:', error);
      if (error.code === 'ER_DUP_ENTRY') {
        return { success: false, message: 'Lottery number already exists' };
      } else {
        return { success: false, message: 'Internal server error' };
      }
    }
  }

  static async getAll(page: number, size: number): Promise<{ lotteries: any[], total: number }> {
    try {
      const offset = (page - 1) * size;

      const [lotteries] = await queryAsync('SELECT * FROM lottery LIMIT ? OFFSET ?', [size, offset]);
      const [countResult] = await queryAsync('SELECT COUNT(*) as total FROM lottery');

      const total = Array.isArray(countResult) ? (countResult[0] as any).total : 0;

      return {
        lotteries: Array.isArray(lotteries) ? lotteries : [],
        total
      };
    } catch (error) {
      console.error('Database error:', error);
      throw error;
    }
  }

  static async search(query: string, page: number, size: number): Promise<{ lotteries: any[], total: number }> {
    try {
      const offset = (page - 1) * size;
      const searchQuery = `%${query}%`;

      const [lotteries] = await queryAsync(
        'SELECT * FROM lottery WHERE lottery_number LIKE ? ORDER BY created DESC LIMIT ? OFFSET ?',
        [searchQuery, size, offset]
      );
      const [countResult] = await queryAsync(
        'SELECT COUNT(*) as total FROM lottery WHERE lottery_number LIKE ?',
        [searchQuery]
      );

      const total = Array.isArray(countResult) ? (countResult[0] as any).total : 0;

      return {
        lotteries: Array.isArray(lotteries) ? lotteries : [],
        total
      };
    } catch (error) {
      console.error('Database error:', error);
      throw error;
    }
  }

  static async getPurchasedLotteries(): Promise<any[]> {
    try {
      const [result] = await queryAsync(
        `SELECT l.* FROM lottery l 
         INNER JOIN purchase p ON l.lid = p.lid 
         ORDER BY l.created DESC`
      );
      return Array.isArray(result) ? result : [];
    } catch (error) {
      console.error('Database error:', error);
      throw error;
    }
  }

  static async selectRandomWinners(followed: boolean = false): Promise<{ success: boolean; winners?: any; message?: string }> {
    try {
      const lotteryData = followed ? await this.getPurchasedLotteries() : (await this.getAll(1, 1000000)).lotteries;

      if (lotteryData.length < 3) {
        return { success: false, message: 'Not enough lottery entries for random selection' };
      }

      const lotteryNumbers = [...new Set(lotteryData.map((l: any) => l.lottery_number))];

      if (lotteryNumbers.length < 3) {
        return { success: false, message: 'Not enough unique lottery numbers for random selection' };
      }

      const selectedIndices = new Set<number>();
      const winners = [];

      while (selectedIndices.size < 3 && selectedIndices.size < lotteryNumbers.length) {
        const randomIndex = Math.floor(Math.random() * lotteryNumbers.length);
        if (!selectedIndices.has(randomIndex)) {
          selectedIndices.add(randomIndex);
          winners.push(lotteryNumbers[randomIndex]);
        }
      }

      const tier1 = winners[0];
      const tier2 = winners[1];
      const tier3 = winners[2];

      const tier4 = tier1.slice(-3);

      const randomDigits = Math.floor(Math.random() * 90 + 10).toString();
      const tier5 = randomDigits;

      const winnerData = {
        tier1: tier1,
        tier2: tier2,
        tier3: tier3,
        tier4: tier4,
        tier5: tier5
      };

      const derivedTiers = generateDerivedTiers(winnerData);

      winnerData.tier4 = derivedTiers.tier4;
      winnerData.tier5 = derivedTiers.tier5;

      const updatePromises = [
        this.updateRewardTier('T1', winnerData.tier1),
        this.updateRewardTier('T2', winnerData.tier2),
        this.updateRewardTier('T3', winnerData.tier3),
        this.updateRewardTier('T1L3', winnerData.tier4),
        this.updateRewardTier('R2', winnerData.tier5)
      ];

      try {
        await Promise.all(updatePromises);
        return { success: true, winners: formatTierResult(winnerData) };
      } catch (updateError) {
        console.error('Error updating reward tiers:', updateError);
        return { success: false, message: 'Failed to update reward tiers' };
      }
    } catch (error) {
      console.error('Error selecting random winners:', error);
      return { success: false, message: 'Internal server error' };
    }
  }

  static async updateRewardTier(tierName: Tiers, winnerNumber: string): Promise<void> {
    try {
      await queryAsync(
        'UPDATE reward SET winner = ? WHERE tier = ?',
        [winnerNumber, tierName]
      );
    } catch (error) {
      console.error('Database error updating reward tier:', error);
      throw error;
    }
  }

  static async getById(lid: number): Promise<any> {
    try {
      const [result] = await queryAsync('SELECT * FROM lottery WHERE lid = ?', [lid]);
      return Array.isArray(result) && result.length > 0 ? result[0] : null;
    } catch (error) {
      console.error('Database error:', error);
      throw error;
    }
  }

  static async update(lid: number, data: Partial<LotteryData>): Promise<{ success: boolean; message: string }> {
    try {
      const fields = [];
      const values = [];

      if (data.lottery_number) {
        fields.push('lottery_number = ?');
        values.push(data.lottery_number);
      }
      if (data.period) {
        fields.push('period = ?');
        values.push(data.period);
      }

      if (fields.length === 0) {
        return { success: false, message: 'No fields to update' };
      }

      values.push(lid);

      const [result] = await queryAsync(
        `UPDATE lottery SET ${fields.join(', ')} WHERE lid = ?`,
        values
      );

      if ((result as any).affectedRows === 0) {
        return { success: false, message: 'Lottery not found' };
      }

      return { success: true, message: 'Lottery updated successfully' };
    } catch (error) {
      console.error('Database error:', error);
      return { success: false, message: 'Internal server error' };
    }
  }

  static async generateBulkLotteries(n: number): Promise<{ success: boolean; message: string; lotteries?: any[]; generated?: number }> {
    try {
      if (n <= 0) {
        return { success: false, message: 'Number must be more than 1' };
      }

      const generatedNumbers = new Set<string>();

      while (generatedNumbers.size < n) {
        const randomNum = Math.floor(Math.random() * 1000000);
        const lotteryNumber = randomNum.toString().padStart(6, '0');

        if (!generatedNumbers.has(lotteryNumber)) {
          generatedNumbers.add(lotteryNumber);
        }

        if (generatedNumbers.size >= 999999) {
          break;
        }
      }

      const lotteryNumbers = Array.from(generatedNumbers);
      const values = lotteryNumbers.map(num => [num]);
      const placeholders = lotteryNumbers.map(() => '(?)').join(', ');

      const [result] = await queryAsync(
        `INSERT INTO lottery (lottery_number) VALUES ${placeholders}`,
        lotteryNumbers
      );

      return {
        success: true,
        message: `Successfully generated ${lotteryNumbers.length} unique lottery numbers`,
        lotteries: lotteryNumbers.map((num, index) => ({
          lid: (result as any).insertId + index,
          lottery_number: num
        })),
        generated: lotteryNumbers.length
      };
    } catch (error) {
      console.error('Error generating bulk lotteries:', error);
      return { success: false, message: 'Internal server error' };
    }
  }

  static async delete(lid: number): Promise<{ success: boolean; message: string }> {
    try {
      const [result] = await queryAsync('DELETE FROM lottery WHERE lid = ?', [lid]);

      if ((result as any).affectedRows === 0) {
        return { success: false, message: 'Lottery not found' };
      }

      return { success: true, message: 'Lottery deleted successfully' };
    } catch (error) {
      console.error('Database error:', error);
      return { success: false, message: 'Internal server error' };
    }
  }
}
