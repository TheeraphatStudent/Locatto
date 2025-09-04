import express from 'express';
import { IndexController } from '../controller/index';

const router = express.Router();

router.get('/', IndexController.getIndex);
router.post('/tojwt', IndexController.toJwt);

export { router };
