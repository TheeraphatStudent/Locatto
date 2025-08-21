import { Router } from 'express';
import { RewardController } from '../controllers/RewardController';
import { body } from 'express-validator';

const router = Router();
const rewardController = new RewardController();

const rewardValidation = [
  body('lid').isInt({ min: 1 }).withMessage('Lottery ID is required and must be a positive integer'),
  body('tier').isLength({ min: 1, max: 20 }).withMessage('Tier is required and must be less than 20 characters'),
  body('revenue').isNumeric().withMessage('Revenue is required and must be a number'),
  body('winner').optional().isLength({ max: 100 }).withMessage('Winner name must be less than 100 characters'),
];

const rewardUpdateValidation = [
  body('lid').optional().isInt({ min: 1 }).withMessage('Lottery ID must be a positive integer'),
  body('tier').optional().isLength({ min: 1, max: 20 }).withMessage('Tier must be less than 20 characters'),
  body('revenue').optional().isNumeric().withMessage('Revenue must be a number'),
  body('winner').optional().isLength({ max: 100 }).withMessage('Winner name must be less than 100 characters'),
];

router.get('/', rewardController.getAllRewards);
router.get('/:id', rewardController.getRewardById);
router.post('/', rewardValidation, rewardController.createReward);
router.put('/:id', rewardUpdateValidation, rewardController.updateReward);
router.delete('/:id', rewardController.deleteReward);

export default router;


