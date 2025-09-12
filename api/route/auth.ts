import express from 'express';
import { AuthController } from '../controller/auth.controller';

const router = express.Router();

router.post('/register', AuthController.register);
router.post('/login', AuthController.login);
router.post('/repass', AuthController.resetPassword);
router.post('/logout', AuthController.logout);

router.get('/me', AuthController.me);

export { router };
