"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.CustomerService = void 0;
const database_1 = require("../config/database");
const Customer_1 = require("../models/Customer");
class CustomerService {
    constructor() {
        this.getAll = () => this.repo.find();
        this.getById = (id) => this.repo.findOneBy({ cid: id });
        this.create = (data) => this.repo.save(this.repo.create(data));
        this.update = async (id, data) => {
            await this.repo.update({ cid: id }, data);
            return this.getById(id);
        };
        this.remove = async (id) => {
            await this.repo.delete({ cid: id });
        };
        this.repo = database_1.AppDataSource.getRepository(Customer_1.Customer);
    }
}
exports.CustomerService = CustomerService;
