import { Repository } from 'typeorm';
import { AppDataSource } from '../config/database';
import { Lottery } from '../models/Lottery';

export class LotteryService {
  private readonly repo: Repository<Lottery>;

  constructor() {
    this.repo = AppDataSource.getRepository(Lottery);
  }

  getAll = () => this.repo.find();

  getById = (id: number) => this.repo.findOneBy({ lid: id });

  create = (data: Partial<Lottery>) => this.repo.save(this.repo.create(data));

  update = async (id: number, data: Partial<Lottery>) => {
    await this.repo.update({ lid: id }, data);
    return this.getById(id);
  };

  remove = async (id: number) => {
    await this.repo.delete({ lid: id });
  };
}


