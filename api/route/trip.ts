import express from 'express';
import { TripController } from '../controller/trip';

const router = express.Router();

router.get("/", TripController.getAll);
router.get("/:id", TripController.getById);
router.get("/search/fields", TripController.search);
router.post("/newdata", TripController.create);
router.put("/:id", TripController.update);
router.delete("/:id", TripController.delete);

export { router };
