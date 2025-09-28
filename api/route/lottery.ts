import { Router } from 'express';
import { LotteryController } from '../controller/lottery.controller';

const router = Router();

// Create lottery
router.post('/', LotteryController.create);

/*
5 Number of reward

Tier 1 (random 6 digit),
Tier 2 (random 6 digit),
Tier 3 (random 6 digit),
Tier 4 (Last 3 (digit of Tier 1))
Tier 5 (Last 2 (Random 2 digit))

*/

// /random/reward/followed - all lottery was purchase
router.get('/random/reward/followed', LotteryController.selectRandomWinnersFollowed);

// /random/reward/unfollowed - all lottery
router.get('/random/reward/unfollowed', LotteryController.selectRandomWinnersUnfollowed);

router.get('/', LotteryController.getAll);
router.get('/:id', LotteryController.getById);

router.post('/search', LotteryController.search);

router.put('/:id', LotteryController.update);

router.delete('/:id', LotteryController.delete);

export { router };
