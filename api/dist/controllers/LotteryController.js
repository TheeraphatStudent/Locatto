"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.LotteryController = void 0;
const express_validator_1 = require("express-validator");
const LotteryService_1 = require("../services/LotteryService");
class LotteryController {
    constructor() {
        this.service = new LotteryService_1.LotteryService();
        this.getAllLotteries = async (_req, res) => {
            const items = await this.service.getAll();
            res.json(items);
        };
        this.getLotteryById = async (req, res) => {
            const id = Number(req.params.id);
            const item = await this.service.getById(id);
            if (!item)
                return res.status(404).json({ success: false, message: 'Lottery not found' });
            res.json(item);
        };
        this.createLottery = async (req, res) => {
            const errors = (0, express_validator_1.validationResult)(req);
            if (!errors.isEmpty())
                return res.status(400).json({ success: false, errors: errors.array() });
            const created = await this.service.create(req.body);
            res.status(201).json(created);
        };
        this.updateLottery = async (req, res) => {
            const errors = (0, express_validator_1.validationResult)(req);
            if (!errors.isEmpty())
                return res.status(400).json({ success: false, errors: errors.array() });
            const id = Number(req.params.id);
            const updated = await this.service.update(id, req.body);
            if (!updated)
                return res.status(404).json({ success: false, message: 'Lottery not found' });
            res.json(updated);
        };
        this.deleteLottery = async (req, res) => {
            const id = Number(req.params.id);
            await this.service.remove(id);
            res.status(204).send();
        };
    }
}
exports.LotteryController = LotteryController;
