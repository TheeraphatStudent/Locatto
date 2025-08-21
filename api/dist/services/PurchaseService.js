"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.PurchaseService = void 0;
const database_1 = require("../config/database");
const Purchase_1 = require("../models/Purchase");
class PurchaseService {
    constructor() {
        this.getAll = () => this.repo.find();
        this.getById = (id) => this.repo.findOneBy({ pid: id });
        this.create = (data) => this.repo.save(this.repo.create(data));
        this.update = async (id, data) => {
            await this.repo.update({ pid: id }, data);
            return this.getById(id);
        };
        this.remove = async (id) => {
            await this.repo.delete({ pid: id });
        };
        this.repo = database_1.AppDataSource.getRepository(Purchase_1.Purchase);
    }
}
exports.PurchaseService = PurchaseService;
