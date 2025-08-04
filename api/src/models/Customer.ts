import { Entity, PrimaryGeneratedColumn, Column, OneToMany, CreateDateColumn, UpdateDateColumn } from 'typeorm';
import { Purchase } from './Purchase';

@Entity('customers')
export class Customer {
  @PrimaryGeneratedColumn()
  cid: number;

  @Column({ length: 100 })
  name: string;

  @Column({ length: 15 })
  telno: string;

  @Column({ length: 255, nullable: true })
  img: string;

  @Column({ length: 50, unique: true })
  username: string;

  @Column({ length: 255 })
  password: string;

  @Column('decimal', { precision: 10, scale: 2, default: 0 })
  credit: number;

  @CreateDateColumn()
  created: Date;

  @UpdateDateColumn()
  updated: Date;

  @OneToMany(() => Purchase, purchase => purchase.customer)
  purchases: Purchase[];
} 