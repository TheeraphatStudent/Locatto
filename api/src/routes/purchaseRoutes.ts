import { Router } from 'express';
import { PurchaseController } from '../controllers/PurchaseController';
import { body } from 'express-validator';

const router = Router();
const purchaseController = new PurchaseController();

const purchaseValidation = [
  body('cid').isInt({ min: 1 }).withMessage('Customer ID is required and must be a positive integer'),
  body('lid').isInt({ min: 1 }).withMessage('Lottery ID is required and must be a positive integer'),
];

const purchaseUpdateValidation = [
  body('cid').optional().isInt({ min: 1 }).withMessage('Customer ID must be a positive integer'),
  body('lid').optional().isInt({ min: 1 }).withMessage('Lottery ID must be a positive integer'),
];

router.get('/', purchaseController.getAllPurchases);
router.get('/:id', purchaseController.getPurchaseById);
router.post('/', purchaseValidation, purchaseController.createPurchase);
router.put('/:id', purchaseUpdateValidation, purchaseController.updatePurchase);
router.delete('/:id', purchaseController.deletePurchase);

export default router;


