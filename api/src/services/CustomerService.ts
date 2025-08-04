import { Repository } from 'typeorm';
import { AppDataSource } from '../config/database';
import { Customer } from '../models/Customer';
import bcrypt from 'bcryptjs';

export class CustomerService {
  private customerRepository: Repository<Customer>;

  constructor() {
    this.customerRepository = AppDataSource.getRepository(Customer);
  }

  async getAllCustomers(): Promise<Customer[]> {
    return await this.customerRepository.find({
      relations: ['purchases']
    });
  }

  async getCustomerById(id: number): Promise<Customer | null> {
    return await this.customerRepository.findOne({
      where: { cid: id },
      relations: ['purchases']
    });
  }

  async createCustomer(customerData: Partial<Customer>): Promise<Customer> {
    if (customerData.password) {
      customerData.password = await bcrypt.hash(customerData.password, 10);
    }
    
    const customer = this.customerRepository.create(customerData);
    return await this.customerRepository.save(customer);
  }

  async updateCustomer(id: number, customerData: Partial<Customer>): Promise<Customer | null> {
    if (customerData.password) {
      customerData.password = await bcrypt.hash(customerData.password, 10);
    }

    await this.customerRepository.update(id, customerData);
    return await this.getCustomerById(id);
  }

  async deleteCustomer(id: number): Promise<boolean> {
    const result = await this.customerRepository.delete(id);
    return result.affected !== 0;
  }

  async getCustomerByUsername(username: string): Promise<Customer | null> {
    return await this.customerRepository.findOne({
      where: { username }
    });
  }
} 