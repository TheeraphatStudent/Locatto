import express from 'express';
import { IndexController } from '../controller/index.controller';

const router = express.Router();

router.get('/', IndexController.getIndex);
router.post('/tojwt', IndexController.toJwt);
router.post('/resys', IndexController.resys);

export { router };
