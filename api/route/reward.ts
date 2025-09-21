import { Router } from 'express';
import { RewardController } from '../controller/reward.controller';

const router = Router();

router.post('/', RewardController.create);

/*
5 Number of reward, Reward Revenue = 0 (default)
Tier 1: 0,
Tier 2: 0,
Tier 3: 0,
Last 3 digit of Tier 1: 0,
Last 2 digit (Random 2 digit): 0
*/

// /manage
router.post('/manage', RewardController.manageRewards);

router.get('/', RewardController.getAll);
router.get('/:id', RewardController.getById);

router.put('/:id', RewardController.update);
router.delete('/:id', RewardController.delete);

router.post('/winner/:lottery_number', RewardController.winner);

export { router };
