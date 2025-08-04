import { Entity, PrimaryGeneratedColumn, Column, OneToMany, CreateDateColumn, UpdateDateColumn } from 'typeorm';
import { Purchase } from './Purchase';
import { Reward } from './Reward';

@Entity('lotteries')
export class Lottery {
  @PrimaryGeneratedColumn()
  lid: number;

  @Column({ length: 20, unique: true })
  lottery_number: string;

  @Column({ length: 50 })
  period: string;

  @CreateDateColumn()
  created: Date;

  @UpdateDateColumn()
  updated: Date;

  @OneToMany(() => Purchase, purchase => purchase.lottery)
  purchases: Purchase[];

  @OneToMany(() => Reward, reward => reward.lottery)
  rewards: Reward[];
} 