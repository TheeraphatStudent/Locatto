import { Request, Response } from 'express';
import { UploadService } from '../service/upload.service';
import * as fs from 'fs';
import * as path from 'path';
import { sendError, sendFromService } from '../utils/response.helper';

interface AuthenticatedRequest extends Request {
  uid?: any;
}

export class UploadController {
  static parseFilename(filename: string) {

    const parts = filename.split('&');
    const uid = parts[0].split('_')[1];
    const fname = parts[1].split('_')[1];
    const time = parts[2].split('_')[1];
    const type = filename.split('.').pop();

    return { uid, filename: fname, time, type };
  }

  static async upload(req: AuthenticatedRequest, res: Response): Promise<void> {
    try {
      // console.log(req)

      const file = (req as any).file;
      if (!file) {
        sendError({ res, status: 400, message: 'No file uploaded' });
        return;
      }

      const uid = crypto.randomUUID();
      const originalName = file.originalname;
      const parsed = path.parse(originalName);
      const timestamp = Date.now();
      const newFilename = `uid_${uid}&fname_${parsed.name}&time_${timestamp}${parsed.ext}`;

      const oldPath = file.path;
      const newPath = path.join(path.dirname(oldPath), newFilename);

      if (fs.existsSync(newPath)) {
        sendFromService({ res, status: 200, result: { message: 'file already exists' } });
        return;
      }

      fs.renameSync(oldPath, newPath);

      sendFromService({ res, status: 201, result: { filename: newFilename }, message: 'File uploaded' });
    } catch (error) {
      console.error('Upload error:', error);
      sendError({ res, status: 500, message: 'Internal server error' });
    }
  }

  static async getFile(req: Request, res: Response): Promise<void> {
    try {
      const uid = req.params.uid;
      const uploadsDir = path.join(__dirname, '../uploads');
      const files = fs.readdirSync(uploadsDir);
      const filename = files.find(f => f.startsWith(`uid_${uid}`));
      if (!filename) {
        sendError({ res, status: 404, message: 'File not found' });
        return;
      }
      const filePath = path.join(uploadsDir, filename);
      res.sendFile(filePath);
    } catch (error) {
      console.error('Get file error:', error);
      sendError({ res, status: 500, message: 'Internal server error' });
    }
  }

  static async getFileInfo(req: Request, res: Response): Promise<void> {
    try {
      const filename = req.body as string;
      const parsed = UploadController.parseFilename(filename);
      sendFromService({ res, status: 200, result: parsed, message: 'File info parsed' });
    } catch (error) {
      console.error('Get file info error:', error);
      sendError({ res, status: 404, message: 'File not found' });
    }
  }

  static async deleteFile(req: Request, res: Response): Promise<void> {
    try {
      const uid = req.params.uid;
      const uploadsDir = path.join(__dirname, '../uploads');
      const files = fs.readdirSync(uploadsDir);
      const filename = files.find(f => f.startsWith(`uid_${uid}`));
      if (!filename) {
        sendError({ res, status: 404, message: 'File not found' });
        return;
      }
      const result = UploadService.deleteFile(filename);
      if (result) {
        const parsed = UploadController.parseFilename(filename);
        sendFromService({ res, status: 200, result: { message: 'File deleted successfully', ...parsed } });
      } else {
        sendError({ res, status: 404, message: 'File not found' });
      }
    } catch (error) {
      console.error('Delete file error:', error);
      sendError({ res, status: 500, message: 'Internal server error' });
    }
  }

  static async getAllFiles(req: Request, res: Response): Promise<void> {
    try {
      const uploadsDir = path.join(__dirname, '../uploads');
      const files = fs.readdirSync(uploadsDir);
      const parsedFiles = files.map(file => UploadController.parseFilename(file));
      sendFromService({ res, status: 200, result: { files: parsedFiles }, message: 'Files listed' });
    } catch (error) {
      console.error('Get all files error:', error);
      sendError({ res, status: 500, message: 'Internal server error' });
    }
  }
}
