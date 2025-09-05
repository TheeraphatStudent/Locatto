import { Repository } from 'typeorm';
import { AppDataSource } from '../config/database';
import { Purchase } from '../models/Purchase';

export class PurchaseService {
  private readonly repo: Repository<Purchase>;

  constructor() {
    this.repo = AppDataSource.getRepository(Purchase);
  }

  getAll = () => this.repo.find();

  getById = (id: number) => this.repo.findOneBy({ pid: id });

  create = (data: Partial<Purchase>) => this.repo.save(this.repo.create(data));

  update = async (id: number, data: Partial<Purchase>) => {
    await this.repo.update({ pid: id }, data);
    return this.getById(id);
  };

  remove = async (id: number) => {
    await this.repo.delete({ pid: id });
  };
}


