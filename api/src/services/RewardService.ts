import { Repository } from 'typeorm';
import { AppDataSource } from '../config/database';
import { Reward } from '../models/Reward';

export class RewardService {
  private rewardRepository: Repository<Reward>;

  constructor() {
    this.rewardRepository = AppDataSource.getRepository(Reward);
  }

  async getAllRewards(): Promise<Reward[]> {
    return await this.rewardRepository.find({
      relations: ['lottery']
    });
  }

  async getRewardById(id: number): Promise<Reward | null> {
    return await this.rewardRepository.findOne({
      where: { rid: id },
      relations: ['lottery']
    });
  }

  async createReward(rewardData: Partial<Reward>): Promise<Reward> {
    const reward = this.rewardRepository.create(rewardData);
    return await this.rewardRepository.save(reward);
  }

  async updateReward(id: number, rewardData: Partial<Reward>): Promise<Reward | null> {
    await this.rewardRepository.update(id, rewardData);
    return await this.getRewardById(id);
  }

  async deleteReward(id: number): Promise<boolean> {
    const result = await this.rewardRepository.delete(id);
    return result.affected !== 0;
  }

  async getRewardsByLottery(lotteryId: number): Promise<Reward[]> {
    return await this.rewardRepository.find({
      where: { lid: lotteryId },
      relations: ['lottery']
    });
  }
} 