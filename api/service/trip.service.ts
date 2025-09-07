import { queryAsync } from '../db/connectiondb';

export interface Trip {
  idx: number;
  name: string;
  country: string;
  destinationid: number;
  coverimage: string;
  detail: string;
  price: number;
  duration: number;
}

export class TripService {
  static async getAll(): Promise<Trip[]> {
    try {
      const result: any = await queryAsync('SELECT * FROM trip');
      return result as Trip[];
    } catch (error) {
      throw error;
    }
  }

  static async getById(id: number): Promise<Trip[]> {
    try {
      const [result] = await queryAsync('SELECT * FROM trip WHERE idx = ?', [id]);
      return Array.isArray(result) ? result as Trip[] : [];
    } catch (error) {
      throw error;
    }
  }

  static async search(id?: string, name?: string): Promise<Trip[]> {
    try {
      const [result] = await queryAsync(
        'SELECT * FROM trip WHERE (idx IS NULL OR idx = ?) OR (name IS NULL OR name LIKE ?)',
        [id, '%' + name + '%']
      );
      return Array.isArray(result) ? result as Trip[] : [];
    } catch (error) {
      throw error;
    }
  }

  static async create(trip: Omit<Trip, 'idx'>): Promise<{ affectedRows: number; insertId: number }> {
    try {
      const [result] = await queryAsync(
        'INSERT INTO `trip`(`name`, `country`, `destinationid`, `coverimage`, `detail`, `price`, `duration`) VALUES (?,?,?,?,?,?,?)',
        [trip.name, trip.country, trip.destinationid, trip.coverimage, trip.detail, trip.price, trip.duration]
      );
      return { affectedRows: (result as any).affectedRows, insertId: (result as any).insertId };
    } catch (error) {
      throw error;
    }
  }

  static async update(id: number, trip: Partial<Trip>): Promise<{ affectedRows: number }> {
    try {
      const [originalResult] = await queryAsync('SELECT * FROM trip WHERE idx = ?', [id]);
      if (!Array.isArray(originalResult) || originalResult.length === 0) {
        return { affectedRows: 0 };
      }
      const originalTrip = (originalResult as any[])[0];
      const updatedTrip = { ...originalTrip, ...trip };

      const [result] = await queryAsync(
        'UPDATE `trip` SET `name`=?, `country`=?, `destinationid`=?, `coverimage`=?, `detail`=?, `price`=?, `duration`=? WHERE `idx`=?',
        [updatedTrip.name, updatedTrip.country, updatedTrip.destinationid, updatedTrip.coverimage, updatedTrip.detail, updatedTrip.price, updatedTrip.duration, id]
      );
      return { affectedRows: (result as any).affectedRows };
    } catch (error) {
      throw error;
    }
  }

  static async delete(id: number): Promise<{ affectedRows: number }> {
    try {
      const [result] = await queryAsync('DELETE FROM trip WHERE idx = ?', [id]);
      return { affectedRows: (result as any).affectedRows };
    } catch (error) {
      throw error;
    }
  }
}
