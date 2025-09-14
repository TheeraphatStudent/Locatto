import express from 'express';
import { UploadController } from '../controller/upload.controller';
import { UploadService } from '../service/upload.service';

const router = express.Router();

const { upload } = UploadService.getMulterConfig();

router.post('/', upload.single('file'), UploadController.uploadFile);

router.post('/get', UploadController.getFileInfo);
router.get('/list', UploadController.getAllFiles);

router.get('/:uid', UploadController.getFile);
router.delete('/:uid', UploadController.deleteFile);

export { router };
