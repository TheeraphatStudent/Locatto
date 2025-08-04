import 'reflect-metadata';
import express from 'express';
import cors from 'cors';
import helmet from 'helmet';
import rateLimit from 'express-rate-limit';
import { AppDataSource } from './config/database';
import { logger } from './middlewares/logger';
import { errorHandler } from './middlewares/errorHandler';

import customerRoutes from './routes/customerRoutes';
import lotteryRoutes from './routes/lotteryRoutes';
import purchaseRoutes from './routes/purchaseRoutes';
import rewardRoutes from './routes/rewardRoutes';

const app = express();

const limiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 100,
  message: {
    error: 'Too many requests from this IP, please try again later.'
  }
});

app.use(helmet());
app.use(cors());
app.use(limiter);
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true }));
app.use(logger);

app.get('/api/health', (req, res) => {
  res.json({
    success: true,
    message: 'API is running',
    timestamp: new Date().toISOString()
  });
});

app.use('/api/customers', customerRoutes);
app.use('/api/lotteries', lotteryRoutes);
app.use('/api/purchases', purchaseRoutes);
app.use('/api/rewards', rewardRoutes);

app.use('*', (req, res) => {
  res.status(404).json({
    success: false,
    message: 'Route not found'
  });
});

app.use(errorHandler);

export { app, AppDataSource }; 
 