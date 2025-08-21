"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.RewardService = void 0;
const database_1 = require("../config/database");
const Reward_1 = require("../models/Reward");
class RewardService {
    constructor() {
        this.getAll = () => this.repo.find();
        this.getById = (id) => this.repo.findOneBy({ rid: id });
        this.create = (data) => this.repo.save(this.repo.create(data));
        this.update = async (id, data) => {
            await this.repo.update({ rid: id }, data);
            return this.getById(id);
        };
        this.remove = async (id) => {
            await this.repo.delete({ rid: id });
        };
        this.repo = database_1.AppDataSource.getRepository(Reward_1.Reward);
    }
}
exports.RewardService = RewardService;
