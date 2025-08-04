import { DataSource } from 'typeorm';
import { Customer } from '../models/Customer';
import { Purchase } from '../models/Purchase';
import { Lottery } from '../models/Lottery';
import { Reward } from '../models/Reward';

export const AppDataSource = new DataSource({
  type: 'mysql',
  host: process.env.DB_HOST || 'localhost',
  port: parseInt(process.env.DB_PORT || '3306'),
  username: process.env.DB_USERNAME || 'root',
  password: process.env.DB_PASSWORD || 'rootpassword',
  database: process.env.DB_DATABASE || 'locatto',
  synchronize: false,
  logging: process.env.NODE_ENV === 'development',
  entities: [Customer, Purchase, Lottery, Reward],
  migrations: ['src/migrations/*.ts'],
  subscribers: ['src/subscribers/*.ts'],
}); 