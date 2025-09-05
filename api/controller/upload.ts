import { Request, Response } from 'express';
import { UploadService } from '../service/upload.service';
import * as fs from 'fs';
import * as path from 'path';

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
        res.status(400).json({ error: 'No file uploaded' });
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
        res.json({ message: "file already exists" });
        return;
      }

      fs.renameSync(oldPath, newPath);

      res.json({ filename: newFilename });
    } catch (error) {
      console.error('Upload error:', error);
      res.status(500).json({ error: 'Internal server error' });
    }
  }

  static async getFile(req: Request, res: Response): Promise<void> {
    try {
      const uid = req.params.uid;
      const uploadsDir = path.join(__dirname, '../uploads');
      const files = fs.readdirSync(uploadsDir);
      const filename = files.find(f => f.startsWith(`uid_${uid}`));
      if (!filename) {
        res.status(404).json({ error: 'File not found' });
        return;
      }
      const filePath = path.join(uploadsDir, filename);
      res.sendFile(filePath);
    } catch (error) {
      console.error('Get file error:', error);
      res.status(500).json({ error: 'Internal server error' });
    }
  }

  static async getFileInfo(req: Request, res: Response): Promise<void> {
    try {
      const filename = req.body as string;
      const parsed = UploadController.parseFilename(filename);
      res.json(parsed);
    } catch (error) {
      console.error('Get file info error:', error);
      res.status(404).json({ error: 'File not found' });
    }
  }

  static async deleteFile(req: Request, res: Response): Promise<void> {
    try {
      const uid = req.params.uid;
      const uploadsDir = path.join(__dirname, '../uploads');
      const files = fs.readdirSync(uploadsDir);
      const filename = files.find(f => f.startsWith(`uid_${uid}`));
      if (!filename) {
        res.status(404).json({ error: 'File not found' });
        return;
      }
      const result = UploadService.deleteFile(filename);
      if (result) {
        const parsed = UploadController.parseFilename(filename);
        res.json({ message: 'File deleted successfully', ...parsed });
      } else {
        res.status(404).json({ error: 'File not found' });
      }
    } catch (error) {
      console.error('Delete file error:', error);
      res.status(500).json({ error: 'Internal server error' });
    }
  }

  static async getAllFiles(req: Request, res: Response): Promise<void> {
    try {
      const uploadsDir = path.join(__dirname, '../uploads');
      const files = fs.readdirSync(uploadsDir);
      const parsedFiles = files.map(file => UploadController.parseFilename(file));
      res.json({ files: parsedFiles });
    } catch (error) {
      console.error('Get all files error:', error);
      res.status(500).json({ error: 'Internal server error' });
    }
  }
}
