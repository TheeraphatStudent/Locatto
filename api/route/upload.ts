import express from 'express';
import path from 'path';
import multer from 'multer';
import { v4 as uuidv4 } from 'uuid';
import * as fs from 'fs';
import { UploadController } from '../controller/upload.controller';

const router = express.Router();

const uploadsDir = path.join(__dirname, "../uploads");
if (!fs.existsSync(uploadsDir)) {
  fs.mkdirSync(uploadsDir, { recursive: true });
}

const storage = multer.diskStorage({
  destination: (_req, _file, cb) => {
    cb(null, uploadsDir);
  },
  filename: (_req, file, cb) => {
    const uniqueSuffix = uuidv4();
    const filename = uniqueSuffix + "." + file.originalname.split(".").pop();
    cb(null, filename);
  },
});

const upload = multer({
  storage,
  limits: {
    fileSize: 67108864,
  },
});

router.post("/", upload.single("file"), UploadController.upload);

router.post("/get", UploadController.getFileInfo);
router.get("/list", UploadController.getAllFiles);

router.get("/:uid", UploadController.getFile);
router.delete("/:uid", UploadController.deleteFile);

export { router };
