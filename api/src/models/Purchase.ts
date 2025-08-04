import { Entity, PrimaryGeneratedColumn, Column, ManyToOne, JoinColumn, CreateDateColumn, UpdateDateColumn } from 'typeorm';
import { Customer } from './Customer';
import { Lottery } from './Lottery';

@Entity('purchases')
export class Purchase {
  @PrimaryGeneratedColumn()
  pid: number;

  @Column()
  cid: number;

  @Column()
  lid: number;

  @CreateDateColumn()
  created: Date;

  @UpdateDateColumn()
  updated: Date;

  @ManyToOne(() => Customer, customer => customer.purchases, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'cid' })
  customer: Customer;

  @ManyToOne(() => Lottery, lottery => lottery.purchases, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'lid' })
  lottery: Lottery;
} 