import { Repository } from 'typeorm';
import { AppDataSource } from '../config/database';
import { Reward } from '../models/Reward';

export class RewardService {
  private readonly repo: Repository<Reward>;

  constructor() {
    this.repo = AppDataSource.getRepository(Reward);
  }

  getAll = () => this.repo.find();

  getById = (id: number) => this.repo.findOneBy({ rid: id });

  create = (data: Partial<Reward>) => this.repo.save(this.repo.create(data));

  update = async (id: number, data: Partial<Reward>) => {
    await this.repo.update({ rid: id }, data);
    return this.getById(id);
  };

  remove = async (id: number) => {
    await this.repo.delete({ rid: id });
  };
}


