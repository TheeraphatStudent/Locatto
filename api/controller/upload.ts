import express from 'express';
import { UploadService } from '../service/upload.service';
import * as fs from 'fs';
import * as path from 'path';

interface AuthenticatedRequest extends express.Request {
  uid?: any;
}

export class UploadController {
  static async upload(req: AuthenticatedRequest, res: express.Response): Promise<void> {
    try {
      // console.log(req)

      const file = (req as any).file;
      if (!file) {
        res.status(400).json({ error: 'No file uploaded' });
        return;
      }

      const uid = self.crypto.randomUUID();
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

  static async getFile(req: express.Request, res: express.Response): Promise<void> {
    try {
      const filename = req.params.filename;
      const download = req.query.download as string;
      const fileInfo = UploadService.getFile(filename, download);
      if (download === 'true') {
        res.download(fileInfo.path);
      } else {
        res.sendFile(fileInfo.path);
      }
    } catch (error) {
      console.error('Get file error:', error);
      res.status(404).json({ error: 'File not found' });
    }
  }

  static async deleteFile(req: express.Request, res: express.Response): Promise<void> {
    try {
      const filename = req.params.filename;
      const result = UploadService.deleteFile(filename);
      if (result) {
        res.json({ message: 'File deleted successfully' });
      } else {
        res.status(404).json({ error: 'File not found' });
      }
    } catch (error) {
      console.error('Delete file error:', error);
      res.status(500).json({ error: 'Internal server error' });
    }
  }

  static async getFilesByUid(req: AuthenticatedRequest, res: express.Response): Promise<void> {
    try {
      const uid = req.uid;
      const files = UploadService.getFilesByUid(uid);
      res.json({ files });
    } catch (error) {
      console.error('Get files by uid error:', error);
      res.status(500).json({ error: 'Internal server error' });
    }
  }
}
