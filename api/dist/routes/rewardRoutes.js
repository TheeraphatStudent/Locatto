"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = require("express");
const RewardController_1 = require("../controllers/RewardController");
const express_validator_1 = require("express-validator");
const router = (0, express_1.Router)();
const rewardController = new RewardController_1.RewardController();
const rewardValidation = [
    (0, express_validator_1.body)('lid').isInt({ min: 1 }).withMessage('Lottery ID is required and must be a positive integer'),
    (0, express_validator_1.body)('tier').isLength({ min: 1, max: 20 }).withMessage('Tier is required and must be less than 20 characters'),
    (0, express_validator_1.body)('revenue').isNumeric().withMessage('Revenue is required and must be a number'),
    (0, express_validator_1.body)('winner').optional().isLength({ max: 100 }).withMessage('Winner name must be less than 100 characters'),
];
const rewardUpdateValidation = [
    (0, express_validator_1.body)('lid').optional().isInt({ min: 1 }).withMessage('Lottery ID must be a positive integer'),
    (0, express_validator_1.body)('tier').optional().isLength({ min: 1, max: 20 }).withMessage('Tier must be less than 20 characters'),
    (0, express_validator_1.body)('revenue').optional().isNumeric().withMessage('Revenue must be a number'),
    (0, express_validator_1.body)('winner').optional().isLength({ max: 100 }).withMessage('Winner name must be less than 100 characters'),
];
router.get('/', rewardController.getAllRewards);
router.get('/:id', rewardController.getRewardById);
router.post('/', rewardValidation, rewardController.createReward);
router.put('/:id', rewardUpdateValidation, rewardController.updateReward);
router.delete('/:id', rewardController.deleteReward);
exports.default = router;
