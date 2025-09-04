import express from 'express';
import { IndexController } from '../controller/index';

const router = express.Router();

router.get('/', IndexController.getIndex);

export { router };
