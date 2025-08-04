import { Request, Response } from 'express';
import { CustomerService } from '../services/CustomerService';
import { validationResult } from 'express-validator';

export class CustomerController {
  private customerService: CustomerService;

  constructor() {
    this.customerService = new CustomerService();
  }

  async getAllCustomers(req: Request, res: Response): Promise<void> {
    try {
      const customers = await this.customerService.getAllCustomers();
      res.json({
        success: true,
        data: customers
      });
    } catch (error) {
      res.status(500).json({
        success: false,
        message: 'Error fetching customers',
        error: error instanceof Error ? error.message : 'Unknown error'
      });
    }
  }

  async getCustomerById(req: Request, res: Response): Promise<void> {
    try {
      const id = parseInt(req.params.id);
      const customer = await this.customerService.getCustomerById(id);
      
      if (!customer) {
        res.status(404).json({
          success: false,
          message: 'Customer not found'
        });
        return;
      }

      res.json({
        success: true,
        data: customer
      });
    } catch (error) {
      res.status(500).json({
        success: false,
        message: 'Error fetching customer',
        error: error instanceof Error ? error.message : 'Unknown error'
      });
    }
  }

  async createCustomer(req: Request, res: Response): Promise<void> {
    try {
      const errors = validationResult(req);
      if (!errors.isEmpty()) {
        res.status(400).json({
          success: false,
          message: 'Validation errors',
          errors: errors.array()
        });
        return;
      }

      const customer = await this.customerService.createCustomer(req.body);
      res.status(201).json({
        success: true,
        data: customer,
        message: 'Customer created successfully'
      });
    } catch (error) {
      res.status(500).json({
        success: false,
        message: 'Error creating customer',
        error: error instanceof Error ? error.message : 'Unknown error'
      });
    }
  }

  async updateCustomer(req: Request, res: Response): Promise<void> {
    try {
      const errors = validationResult(req);
      if (!errors.isEmpty()) {
        res.status(400).json({
          success: false,
          message: 'Validation errors',
          errors: errors.array()
        });
        return;
      }

      const id = parseInt(req.params.id);
      const customer = await this.customerService.updateCustomer(id, req.body);
      
      if (!customer) {
        res.status(404).json({
          success: false,
          message: 'Customer not found'
        });
        return;
      }

      res.json({
        success: true,
        data: customer,
        message: 'Customer updated successfully'
      });
    } catch (error) {
      res.status(500).json({
        success: false,
        message: 'Error updating customer',
        error: error instanceof Error ? error.message : 'Unknown error'
      });
    }
  }

  async deleteCustomer(req: Request, res: Response): Promise<void> {
    try {
      const id = parseInt(req.params.id);
      const deleted = await this.customerService.deleteCustomer(id);
      
      if (!deleted) {
        res.status(404).json({
          success: false,
          message: 'Customer not found'
        });
        return;
      }

      res.json({
        success: true,
        message: 'Customer deleted successfully'
      });
    } catch (error) {
      res.status(500).json({
        success: false,
        message: 'Error deleting customer',
        error: error instanceof Error ? error.message : 'Unknown error'
      });
    }
  }
} 