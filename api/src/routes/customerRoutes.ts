import { Router } from 'express';
import { CustomerController } from '../controllers/CustomerController';
import { body } from 'express-validator';

const router = Router();
const customerController = new CustomerController();

const customerValidation = [
  body('name').isLength({ min: 1, max: 100 }).withMessage('Name is required and must be less than 100 characters'),
  body('telno').isLength({ min: 10, max: 15 }).withMessage('Phone number must be between 10-15 characters'),
  body('username').isLength({ min: 3, max: 50 }).withMessage('Username must be between 3-50 characters'),
  body('password').isLength({ min: 6 }).withMessage('Password must be at least 6 characters'),
  body('credit').optional().isNumeric().withMessage('Credit must be a number')
];

const customerUpdateValidation = [
  body('name').optional().isLength({ min: 1, max: 100 }).withMessage('Name must be less than 100 characters'),
  body('telno').optional().isLength({ min: 10, max: 15 }).withMessage('Phone number must be between 10-15 characters'),
  body('username').optional().isLength({ min: 3, max: 50 }).withMessage('Username must be between 3-50 characters'),
  body('password').optional().isLength({ min: 6 }).withMessage('Password must be at least 6 characters'),
  body('credit').optional().isNumeric().withMessage('Credit must be a number')
];

router.get('/', customerController.getAllCustomers.bind(customerController));
router.get('/:id', customerController.getCustomerById.bind(customerController));
router.post('/', customerValidation, customerController.createCustomer.bind(customerController));
router.put('/:id', customerUpdateValidation, customerController.updateCustomer.bind(customerController));
router.delete('/:id', customerController.deleteCustomer.bind(customerController));

export default router; 