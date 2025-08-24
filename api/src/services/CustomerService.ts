import { Repository } from 'typeorm';
import { AppDataSource } from '../config/database';
import { Customer } from '../models/Customer';

export class CustomerService {
  private readonly repo: Repository<Customer>;

  constructor() {
    this.repo = AppDataSource.getRepository(Customer);
  }

  getAll = () => this.repo.find();

  getById = (id: number) => this.repo.findOneBy({ cid: id });

  create = (data: Partial<Customer>) => this.repo.save(this.repo.create(data));

  update = async (id: number, data: Partial<Customer>) => {
    await this.repo.update({ cid: id }, data);
    return this.getById(id);
  };

  remove = async (id: number) => {
    await this.repo.delete({ cid: id });
  };
}


