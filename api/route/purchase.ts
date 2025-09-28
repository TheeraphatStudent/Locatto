import { Router } from 'express';
import { PurchaseController } from '../controller/purchase.controller';

const router = Router();

router.post('/', PurchaseController.create);

router.get('/', PurchaseController.getAll);
router.get('/me', PurchaseController.getByUserWithStatus);
router.get('/:id', PurchaseController.getById);

router.put('/:id', PurchaseController.update);
router.delete('/:id', PurchaseController.delete);

export { router };
