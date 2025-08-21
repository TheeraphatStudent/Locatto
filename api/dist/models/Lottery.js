"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.Lottery = void 0;
const typeorm_1 = require("typeorm");
const Purchase_1 = require("./Purchase");
const Reward_1 = require("./Reward");
let Lottery = class Lottery {
};
exports.Lottery = Lottery;
__decorate([
    (0, typeorm_1.PrimaryGeneratedColumn)(),
    __metadata("design:type", Number)
], Lottery.prototype, "lid", void 0);
__decorate([
    (0, typeorm_1.Column)('varchar', { length: 20, unique: true }),
    __metadata("design:type", String)
], Lottery.prototype, "lottery_number", void 0);
__decorate([
    (0, typeorm_1.Column)('varchar', { length: 50 }),
    __metadata("design:type", String)
], Lottery.prototype, "period", void 0);
__decorate([
    (0, typeorm_1.CreateDateColumn)(),
    __metadata("design:type", Date)
], Lottery.prototype, "created", void 0);
__decorate([
    (0, typeorm_1.UpdateDateColumn)(),
    __metadata("design:type", Date)
], Lottery.prototype, "updated", void 0);
__decorate([
    (0, typeorm_1.OneToMany)(() => Purchase_1.Purchase, purchase => purchase.lottery),
    __metadata("design:type", Array)
], Lottery.prototype, "purchases", void 0);
__decorate([
    (0, typeorm_1.OneToMany)(() => Reward_1.Reward, reward => reward.lottery),
    __metadata("design:type", Array)
], Lottery.prototype, "rewards", void 0);
exports.Lottery = Lottery = __decorate([
    (0, typeorm_1.Entity)('lotteries')
], Lottery);
