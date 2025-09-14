import path from 'path';
import * as fs from 'fs';
import { Storage } from '@google-cloud/storage';

export class UploadService {
  private static storage = new Storage();
  private static bucket = this.storage.bucket('lottocat_bucket');
  private static shouldUploadToGCS = process.env.UPLOAD_TO_GCS === 'true';

  static getFile(filename: string, download?: string): { path: string; download: boolean } {
    const uploadsDir = path.join(__dirname, '../uploads');
    const filePath = path.join(uploadsDir, filename);
    
    if (!fs.existsSync(filePath)) {
      throw new Error('File not found');
    }
    
    return { path: filePath, download: download === 'true' };
  }

  static async uploadToGCS(filePath: string, filename: string): Promise<string | null> {
    if (!this.shouldUploadToGCS) {
      console.log('GCS upload disabled for this environment');
      return null;
    }
    
    try {
      const destination = `uploads/${filename}`;
      const [file] = await this.bucket.upload(filePath, {
        destination: destination,
        metadata: {
          cacheControl: 'public, max-age=31536000',
        },
      });

      await file.makePublic();

      return `https://storage.googleapis.com/${this.bucket.name}/uploads/${filename}`;
    } catch (error) {
      console.error('GCS upload error:', error);
      throw new Error('Failed to upload to Google Cloud Storage');
    }
  }

  static deleteFile(filename: string): boolean {
    try {
      const uploadsDir = path.join(__dirname, '../uploads');
      const filePath = path.join(uploadsDir, filename);
      
      if (fs.existsSync(filePath)) {
        fs.unlinkSync(filePath);
        return true;
      }
      return false;
    } catch (error) {
      console.error('Delete file error:', error);
      return false;
    }
  }

  static getFilesByUid(uid: number): string[] {
    try {
      const uploadsDir = path.join(__dirname, '../uploads');
      const files = fs.readdirSync(uploadsDir);
      return files.filter(file => file.startsWith(`uid_${uid}&`));
    } catch (error) {
      console.error('Get files by uid error:', error);
      return [];
    }
  }
}
