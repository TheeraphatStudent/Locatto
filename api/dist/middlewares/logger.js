"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.logger = void 0;
const logger = (req, res, next) => {
    const start = Date.now();
    res.on('finish', () => {
        const durationMs = Date.now() - start;
        console.log(`${req.method} ${req.originalUrl} ${res.statusCode} - ${durationMs}ms`);
    });
    next();
};
exports.logger = logger;
