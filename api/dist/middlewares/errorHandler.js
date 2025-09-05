"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.errorHandler = void 0;
// eslint-disable-next-line @typescript-eslint/no-explicit-any
const errorHandler = (err, _req, res, _next) => {
    // eslint-disable-next-line no-console
    console.error(err);
    const statusCode = err?.statusCode ?? 500;
    res.status(statusCode).json({
        success: false,
        message: err?.message ?? 'Internal server error',
    });
};
exports.errorHandler = errorHandler;
