import { Router } from 'express';
import { LotteryController } from '../controllers/LotteryController';
import { body } from 'express-validator';

const router = Router();
const lotteryController = new LotteryController();

const lotteryValidation = [
  body('lottery_number').isLength({ min: 1, max: 20 }).withMessage('Lottery number is required and must be less than 20 characters'),
  body('period').isLength({ min: 1, max: 50 }).withMessage('Period is required and must be less than 50 characters')
];

const lotteryUpdateValidation = [
  body('lottery_number').optional().isLength({ min: 1, max: 20 }).withMessage('Lottery number must be less than 20 characters'),
  body('period').optional().isLength({ min: 1, max: 50 }).withMessage('Period must be less than 50 characters')
];

router.get('/', lotteryController.getAllLotteries.bind(lotteryController));
router.get('/:id', lotteryController.getLotteryById.bind(lotteryController));
router.post('/', lotteryValidation, lotteryController.createLottery.bind(lotteryController));
router.put('/:id', lotteryUpdateValidation, lotteryController.updateLottery.bind(lotteryController));
router.delete('/:id', lotteryController.deleteLottery.bind(lotteryController));

export default router; 