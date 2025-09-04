import express from 'express';
import { AuthController } from '../controller/auth';

const router = express.Router();

router.post('/register', AuthController.register);
router.post('/login', AuthController.login);
router.post('/repass', AuthController.resetPassword);
router.post('/me', AuthController.me)

export { router };
