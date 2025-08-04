import { Repository } from 'typeorm';
import { AppDataSource } from '../config/database';
import { Lottery } from '../models/Lottery';

export class LotteryService {
  private lotteryRepository: Repository<Lottery>;

  constructor() {
    this.lotteryRepository = AppDataSource.getRepository(Lottery);
  }

  async getAllLotteries(): Promise<Lottery[]> {
    return await this.lotteryRepository.find({
      relations: ['purchases', 'rewards']
    });
  }

  async getLotteryById(id: number): Promise<Lottery | null> {
    return await this.lotteryRepository.findOne({
      where: { lid: id },
      relations: ['purchases', 'rewards']
    });
  }

  async createLottery(lotteryData: Partial<Lottery>): Promise<Lottery> {
    const lottery = this.lotteryRepository.create(lotteryData);
    return await this.lotteryRepository.save(lottery);
  }

  async updateLottery(id: number, lotteryData: Partial<Lottery>): Promise<Lottery | null> {
    await this.lotteryRepository.update(id, lotteryData);
    return await this.getLotteryById(id);
  }

  async deleteLottery(id: number): Promise<boolean> {
    const result = await this.lotteryRepository.delete(id);
    return result.affected !== 0;
  }

  async getLotteryByNumber(lottery_number: string): Promise<Lottery | null> {
    return await this.lotteryRepository.findOne({
      where: { lottery_number }
    });
  }
} 