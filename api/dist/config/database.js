"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.AppDataSource = void 0;
const typeorm_1 = require("typeorm");
const Customer_1 = require("../models/Customer");
const Purchase_1 = require("../models/Purchase");
const Lottery_1 = require("../models/Lottery");
const Reward_1 = require("../models/Reward");
exports.AppDataSource = new typeorm_1.DataSource({
    type: 'mysql',
    host: process.env.DB_HOST || 'localhost',
    port: parseInt(process.env.DB_PORT || '3306'),
    username: process.env.DB_USERNAME || 'root',
    password: process.env.DB_PASSWORD || 'rootpassword',
    database: process.env.DB_DATABASE || 'locatto',
    synchronize: false,
    logging: process.env.NODE_ENV === 'development',
    entities: [Customer_1.Customer, Purchase_1.Purchase, Lottery_1.Lottery, Reward_1.Reward],
    migrations: ['src/migrations/*.ts'],
    subscribers: ['src/subscribers/*.ts'],
});
