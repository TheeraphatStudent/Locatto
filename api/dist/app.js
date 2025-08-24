"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.AppDataSource = exports.app = void 0;
require("reflect-metadata");
const express_1 = __importDefault(require("express"));
const cors_1 = __importDefault(require("cors"));
const helmet_1 = __importDefault(require("helmet"));
const express_rate_limit_1 = __importDefault(require("express-rate-limit"));
const database_1 = require("./config/database");
Object.defineProperty(exports, "AppDataSource", { enumerable: true, get: function () { return database_1.AppDataSource; } });
const logger_1 = require("./middlewares/logger");
const errorHandler_1 = require("./middlewares/errorHandler");
const customerRoutes_1 = __importDefault(require("./routes/customerRoutes"));
const lotteryRoutes_1 = __importDefault(require("./routes/lotteryRoutes"));
const purchaseRoutes_1 = __importDefault(require("./routes/purchaseRoutes"));
const rewardRoutes_1 = __importDefault(require("./routes/rewardRoutes"));
const app = (0, express_1.default)();
exports.app = app;
const limiter = (0, express_rate_limit_1.default)({
    windowMs: 15 * 60 * 1000,
    max: 100,
    message: {
        error: 'Too many requests from this IP, please try again later.',
    },
});
app.use((0, helmet_1.default)());
app.use((0, cors_1.default)());
app.use(limiter);
app.use(express_1.default.json({ limit: '10mb' }));
app.use(express_1.default.urlencoded({ extended: true }));
app.use(logger_1.logger);
app.get('/api/health', (_req, res) => {
    res.json({
        success: true,
        message: 'API is running',
        timestamp: new Date().toISOString(),
    });
});
app.use('/api/customers', customerRoutes_1.default);
app.use('/api/lotteries', lotteryRoutes_1.default);
app.use('/api/purchases', purchaseRoutes_1.default);
app.use('/api/rewards', rewardRoutes_1.default);
app.use('*', (_req, res) => {
    res.status(404).json({ success: false, message: 'Route not found' });
});
app.use(errorHandler_1.errorHandler);
