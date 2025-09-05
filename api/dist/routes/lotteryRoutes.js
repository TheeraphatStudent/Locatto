"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = require("express");
const LotteryController_1 = require("../controllers/LotteryController");
const express_validator_1 = require("express-validator");
const router = (0, express_1.Router)();
const lotteryController = new LotteryController_1.LotteryController();
const lotteryValidation = [
    (0, express_validator_1.body)('lottery_number').isLength({ min: 1, max: 20 }).withMessage('Lottery number is required and must be less than 20 characters'),
    (0, express_validator_1.body)('period').isLength({ min: 1, max: 50 }).withMessage('Period is required and must be less than 50 characters'),
];
const lotteryUpdateValidation = [
    (0, express_validator_1.body)('lottery_number').optional().isLength({ min: 1, max: 20 }).withMessage('Lottery number must be less than 20 characters'),
    (0, express_validator_1.body)('period').optional().isLength({ min: 1, max: 50 }).withMessage('Period must be less than 50 characters'),
];
router.get('/', lotteryController.getAllLotteries);
router.get('/:id', lotteryController.getLotteryById);
router.post('/', lotteryValidation, lotteryController.createLottery);
router.put('/:id', lotteryUpdateValidation, lotteryController.updateLottery);
router.delete('/:id', lotteryController.deleteLottery);
exports.default = router;
