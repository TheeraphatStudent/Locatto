import { Repository } from 'typeorm';
import { AppDataSource } from '../config/database';
import { Purchase } from '../models/Purchase';

export class PurchaseService {
  private purchaseRepository: Repository<Purchase>;

  constructor() {
    this.purchaseRepository = AppDataSource.getRepository(Purchase);
  }

  async getAllPurchases(): Promise<Purchase[]> {
    return await this.purchaseRepository.find({
      relations: ['customer', 'lottery']
    });
  }

  async getPurchaseById(id: number): Promise<Purchase | null> {
    return await this.purchaseRepository.findOne({
      where: { pid: id },
      relations: ['customer', 'lottery']
    });
  }

  async createPurchase(purchaseData: Partial<Purchase>): Promise<Purchase> {
    const purchase = this.purchaseRepository.create(purchaseData);
    return await this.purchaseRepository.save(purchase);
  }

  async updatePurchase(id: number, purchaseData: Partial<Purchase>): Promise<Purchase | null> {
    await this.purchaseRepository.update(id, purchaseData);
    return await this.getPurchaseById(id);
  }

  async deletePurchase(id: number): Promise<boolean> {
    const result = await this.purchaseRepository.delete(id);
    return result.affected !== 0;
  }

  async getPurchasesByCustomer(customerId: number): Promise<Purchase[]> {
    return await this.purchaseRepository.find({
      where: { cid: customerId },
      relations: ['customer', 'lottery']
    });
  }

  async getPurchasesByLottery(lotteryId: number): Promise<Purchase[]> {
    return await this.purchaseRepository.find({
      where: { lid: lotteryId },
      relations: ['customer', 'lottery']
    });
  }
} 