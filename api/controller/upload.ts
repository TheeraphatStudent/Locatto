import express from 'express';
import { UploadService } from '../service/upload.service';

export class UploadController {
  static async upload(req: express.Request, res: express.Response): Promise<void> {
    try {
      const filename = (req as any).file.filename;
      res.json({ filename });
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
      if (fileInfo.download) {
        res.download(fileInfo.path);
      } else {
        res.sendFile(fileInfo.path);
      }
    } catch (error) {
      console.error('Get file error:', error);
      res.status(404).json({ error: 'File not found' });
    }
  }
}
