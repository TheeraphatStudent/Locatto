import { Entity, PrimaryGeneratedColumn, Column, OneToMany, CreateDateColumn, UpdateDateColumn } from 'typeorm';
import { Purchase } from './Purchase';

@Entity('customers')
export class Customer {
  @PrimaryGeneratedColumn()
  cid!: number;

  @Column('varchar', { length: 100 })
  name!: string;

  @Column('varchar', { length: 15 })
  telno!: string;

  @Column('varchar', { length: 255, nullable: true })
  img!: string | null;

  @Column('varchar', { length: 50, unique: true })
  username!: string;

  @Column('varchar', { length: 255 })
  password!: string;

  @Column('decimal', { precision: 10, scale: 2, default: 0 })
  credit!: number;

  @CreateDateColumn()
  created!: Date;

  @UpdateDateColumn()
  updated!: Date;

  @OneToMany(() => Purchase, (purchase: Purchase) => purchase.customer)
  purchases!: Purchase[];
}


