"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.LotteryService = void 0;
const database_1 = require("../config/database");
const Lottery_1 = require("../models/Lottery");
class LotteryService {
    constructor() {
        this.getAll = () => this.repo.find();
        this.getById = (id) => this.repo.findOneBy({ lid: id });
        this.create = (data) => this.repo.save(this.repo.create(data));
        this.update = async (id, data) => {
            await this.repo.update({ lid: id }, data);
            return this.getById(id);
        };
        this.remove = async (id) => {
            await this.repo.delete({ lid: id });
        };
        this.repo = database_1.AppDataSource.getRepository(Lottery_1.Lottery);
    }
}
exports.LotteryService = LotteryService;
