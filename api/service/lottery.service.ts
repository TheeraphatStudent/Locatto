import { conn } from '../db/connectiondb';

export interface LotteryData {
  lid?: number;
  lottery_number: string;
  period: string;
}

export class LotteryService {
  static async create(data: LotteryData): Promise<{ success: boolean; message: string; lottery?: any }> {
    return new Promise((resolve) => {
      conn.query(
        'INSERT INTO lottery (lottery_number, period) VALUES (?, ?)',
        [data.lottery_number, data.period],
        (err: any, result: any) => {
          if (err) {
            console.error('Database error:', err);
            if (err.code === 'ER_DUP_ENTRY') {
              resolve({ success: false, message: 'Lottery number already exists' });
            } else {
              resolve({ success: false, message: 'Internal server error' });
            }
            return;
          }

          resolve({
            success: true,
            message: 'Lottery created successfully',
            lottery: { lid: result.insertId, ...data }
          });
        }
      );
    });
  }

  static async getAll(): Promise<any[]> {
    return new Promise((resolve, reject) => {
      conn.query(
        'SELECT * FROM lottery ORDER BY created DESC',
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

  static async getPurchasedLotteries(): Promise<any[]> {
    return new Promise((resolve, reject) => {
      conn.query(
        `SELECT l.* FROM lottery l 
         INNER JOIN purchase p ON l.lid = p.lid 
         ORDER BY l.created DESC`,
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

  static async selectRandomWinners(followed: boolean = false): Promise<{ success: boolean; winners?: any; message?: string }> {
    return new Promise(async (resolve) => {
      try {
        const lotteries = followed ? await this.getPurchasedLotteries() : await this.getAll();
        
        if (lotteries.length < 3) {
          resolve({ success: false, message: 'Not enough lottery entries for random selection' });
          return;
        }

        const lotteryNumbers = [...new Set(lotteries.map(l => l.lottery_number))];
        
        if (lotteryNumbers.length < 3) {
          resolve({ success: false, message: 'Not enough unique lottery numbers for random selection' });
          return;
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

        const result = {
          tier1: tier1,
          tier2: tier2,
          tier3: tier3,
          tier4: tier4,
          tier5: tier5
        };

        resolve({ success: true, winners: result });
      } catch (error) {
        console.error('Error selecting random winners:', error);
        resolve({ success: false, message: 'Internal server error' });
      }
    });
  }

  static async getById(lid: number): Promise<any> {
    return new Promise((resolve, reject) => {
      conn.query(
        'SELECT * FROM lottery WHERE lid = ?',
        [lid],
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

  static async update(lid: number, data: Partial<LotteryData>): Promise<{ success: boolean; message: string }> {
    return new Promise((resolve) => {
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
        resolve({ success: false, message: 'No fields to update' });
        return;
      }

      values.push(lid);

      conn.query(
        `UPDATE lottery SET ${fields.join(', ')} WHERE lid = ?`,
        values,
        (err: any, result: any) => {
          if (err) {
            console.error('Database error:', err);
            resolve({ success: false, message: 'Internal server error' });
            return;
          }

          if (result.affectedRows === 0) {
            resolve({ success: false, message: 'Lottery not found' });
            return;
          }

          resolve({ success: true, message: 'Lottery updated successfully' });
        }
      );
    });
  }

  static async delete(lid: number): Promise<{ success: boolean; message: string }> {
    return new Promise((resolve) => {
      conn.query(
        'DELETE FROM lottery WHERE lid = ?',
        [lid],
        (err: any, result: any) => {
          if (err) {
            console.error('Database error:', err);
            resolve({ success: false, message: 'Internal server error' });
            return;
          }

          if (result.affectedRows === 0) {
            resolve({ success: false, message: 'Lottery not found' });
            return;
          }

          resolve({ success: true, message: 'Lottery deleted successfully' });
        }
      );
    });
  }
}
