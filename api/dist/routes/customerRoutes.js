"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = require("express");
const CustomerController_1 = require("../controllers/CustomerController");
const express_validator_1 = require("express-validator");
const router = (0, express_1.Router)();
const customerController = new CustomerController_1.CustomerController();
const customerValidation = [
    (0, express_validator_1.body)('name').isLength({ min: 1, max: 100 }).withMessage('Name is required and must be less than 100 characters'),
    (0, express_validator_1.body)('telno').isLength({ min: 10, max: 15 }).withMessage('Phone number must be between 10-15 characters'),
    (0, express_validator_1.body)('username').isLength({ min: 3, max: 50 }).withMessage('Username must be between 3-50 characters'),
    (0, express_validator_1.body)('password').isLength({ min: 6 }).withMessage('Password must be at least 6 characters'),
    (0, express_validator_1.body)('credit').optional().isNumeric().withMessage('Credit must be a number'),
    (0, express_validator_1.body)('img').optional().isString().isLength({ max: 255 }).withMessage('Image URL must be less than 255 characters'),
];
const customerUpdateValidation = [
    (0, express_validator_1.body)('name').optional().isLength({ min: 1, max: 100 }).withMessage('Name must be less than 100 characters'),
    (0, express_validator_1.body)('telno').optional().isLength({ min: 10, max: 15 }).withMessage('Phone number must be between 10-15 characters'),
    (0, express_validator_1.body)('username').optional().isLength({ min: 3, max: 50 }).withMessage('Username must be between 3-50 characters'),
    (0, express_validator_1.body)('password').optional().isLength({ min: 6 }).withMessage('Password must be at least 6 characters'),
    (0, express_validator_1.body)('credit').optional().isNumeric().withMessage('Credit must be a number'),
    (0, express_validator_1.body)('img').optional().isString().isLength({ max: 255 }).withMessage('Image URL must be less than 255 characters'),
];
router.get('/', customerController.getAllCustomers);
router.get('/:id', customerController.getCustomerById);
router.post('/', customerValidation, customerController.createCustomer);
router.put('/:id', customerUpdateValidation, customerController.updateCustomer);
router.delete('/:id', customerController.deleteCustomer);
exports.default = router;
