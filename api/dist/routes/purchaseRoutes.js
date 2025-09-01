"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = require("express");
const PurchaseController_1 = require("../controllers/PurchaseController");
const express_validator_1 = require("express-validator");
const router = (0, express_1.Router)();
const purchaseController = new PurchaseController_1.PurchaseController();
const purchaseValidation = [
    (0, express_validator_1.body)('cid').isInt({ min: 1 }).withMessage('Customer ID is required and must be a positive integer'),
    (0, express_validator_1.body)('lid').isInt({ min: 1 }).withMessage('Lottery ID is required and must be a positive integer'),
];
const purchaseUpdateValidation = [
    (0, express_validator_1.body)('cid').optional().isInt({ min: 1 }).withMessage('Customer ID must be a positive integer'),
    (0, express_validator_1.body)('lid').optional().isInt({ min: 1 }).withMessage('Lottery ID must be a positive integer'),
];
router.get('/', purchaseController.getAllPurchases);
router.get('/:id', purchaseController.getPurchaseById);
router.post('/', purchaseValidation, purchaseController.createPurchase);
router.put('/:id', purchaseUpdateValidation, purchaseController.updatePurchase);
router.delete('/:id', purchaseController.deletePurchase);
exports.default = router;
