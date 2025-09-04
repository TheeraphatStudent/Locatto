import { queryAsync } from '../db/connectiondb';
import mysql from 'mysql';

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
      const formattedSql = mysql.format('SELECT * FROM trip WHERE idx = ?', [id]);
      const result: any = await queryAsync(formattedSql);
      return result as Trip[];
    } catch (error) {
      throw error;
    }
  }

  static async search(id?: string, name?: string): Promise<Trip[]> {
    try {
      const formattedSql = mysql.format(
        'SELECT * FROM trip WHERE (idx IS NULL OR idx = ?) OR (name IS NULL OR name LIKE ?)',
        [id, '%' + name + '%']
      );
      const result: any = await queryAsync(formattedSql);
      return result as Trip[];
    } catch (error) {
      throw error;
    }
  }

  static async create(trip: Omit<Trip, 'idx'>): Promise<{ affectedRows: number; insertId: number }> {
    try {
      const sql = 'INSERT INTO `trip`(`name`, `country`, `destinationid`, `coverimage`, `detail`, `price`, `duration`) VALUES (?,?,?,?,?,?,?)';
      const values = [trip.name, trip.country, trip.destinationid, trip.coverimage, trip.detail, trip.price, trip.duration];
      const formattedSql = mysql.format(sql, values);
      const result: any = await queryAsync(formattedSql);
      return { affectedRows: result.affectedRows, insertId: result.insertId };
    } catch (error) {
      throw error;
    }
  }

  static async update(id: number, trip: Partial<Trip>): Promise<{ affectedRows: number }> {
    try {
      const formattedSqlSelect = mysql.format('SELECT * FROM trip WHERE idx = ?', [id]);
      const originalResult: any = await queryAsync(formattedSqlSelect);
      if (originalResult.length === 0) {
        return { affectedRows: 0 };
      }
      const originalTrip = originalResult[0];
      const updatedTrip = { ...originalTrip, ...trip };

      const sql = 'UPDATE `trip` SET `name`=?, `country`=?, `destinationid`=?, `coverimage`=?, `detail`=?, `price`=?, `duration`=? WHERE `idx`=?';
      const values = [updatedTrip.name, updatedTrip.country, updatedTrip.destinationid, updatedTrip.coverimage, updatedTrip.detail, updatedTrip.price, updatedTrip.duration, id];
      const formattedSql = mysql.format(sql, values);
      const result: any = await queryAsync(formattedSql);
      return { affectedRows: result.affectedRows };
    } catch (error) {
      throw error;
    }
  }

  static async delete(id: number): Promise<{ affectedRows: number }> {
    try {
      const formattedSql = mysql.format('DELETE FROM trip WHERE idx = ?', [id]);
      const result: any = await queryAsync(formattedSql);
      return { affectedRows: result.affectedRows };
    } catch (error) {
      throw error;
    }
  }
}
