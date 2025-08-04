import dotenv from 'dotenv';
import { app, AppDataSource } from './app';

dotenv.config();

const PORT = process.env.PORT || 3000;

const startServer = async () => {
  try {
    await AppDataSource.initialize();
    console.log('Database connected successfully');
    
    app.listen(PORT, () => {
      console.log(`Server is running on port ${PORT}`);
      console.log(`Health check: http://localhost:${PORT}/api/health`);
    });
  } catch (error) {
    console.error('Error starting server:', error);
    process.exit(1);
  }
};

startServer(); 