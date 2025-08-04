import { Entity, PrimaryGeneratedColumn, Column, ManyToOne, JoinColumn, CreateDateColumn, UpdateDateColumn } from 'typeorm';
import { Lottery } from './Lottery';

@Entity('rewards')
export class Reward {
  @PrimaryGeneratedColumn()
  rid: number;

  @Column()
  lid: number;

  @Column({ length: 20 })
  tier: string;

  @Column('decimal', { precision: 12, scale: 2 })
  revenue: number;

  @Column({ length: 100, nullable: true })
  winner: string;

  @CreateDateColumn()
  created: Date;

  @UpdateDateColumn()
  updated: Date;

  @ManyToOne(() => Lottery, lottery => lottery.rewards, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'lid' })
  lottery: Lottery;
} 