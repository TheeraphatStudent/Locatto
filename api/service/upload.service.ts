import path from 'path';
import * as fs from 'fs';
import { Storage } from '@google-cloud/storage';
import { v4 as uuidv4 } from 'uuid';
import multer from 'multer';
import MulterGoogleCloudStorage from 'multer-google-storage';

export class UploadService {
  private static storage = new Storage();
  private static bucket = this.storage.bucket('lottocat_bucket');
  private static shouldUploadToGCS = process.env.UPLOAD_TO_GCS === 'true';

  static getMulterConfig(): { upload: multer.Multer; storage: any } {
    const shouldUploadToGCS = process.env.UPLOAD_TO_GCS === 'true';

    if (shouldUploadToGCS) {
      return this.getGCSMulterConfig();
    } else {
      return this.getLocalMulterConfig();
    }
  }

  private static getGCSMulterConfig(): { upload: multer.Multer; storage: any } {
    const storage = new MulterGoogleCloudStorage({
      bucket: 'lottocat_bucket',
      projectId: process.env.GOOGLE_CLOUD_PROJECT,
      keyFilename: process.env.GOOGLE_APPLICATION_CREDENTIALS,
      filename: (_req: any, file: Express.Multer.File, cb: (error: Error | null, filename: string) => void) => {
        const uniqueSuffix = uuidv4();
        const filename = uniqueSuffix + '.' + file.originalname.split('.').pop();
        cb(null, `uploads/${filename}`);
      },
      metadata: {
        cacheControl: 'public, max-age=31536000',
      },
    });

    const upload = multer({
      storage,
      limits: {
        fileSize: 67108864,
      },
    });

    return { upload, storage };
  }

  private static getLocalMulterConfig(): { upload: multer.Multer; storage: any } {
    const uploadsDir = path.join(__dirname, '../uploads');
    if (!fs.existsSync(uploadsDir)) {
      fs.mkdirSync(uploadsDir, { recursive: true });
    }

    const storage = multer.diskStorage({
      destination: (_req, _file, cb) => {
        cb(null, uploadsDir);
      },
      filename: (_req, file, cb) => {
        const uniqueSuffix = uuidv4();
        const filename = uniqueSuffix + '.' + file.originalname.split('.').pop();
        cb(null, filename);
      },
    });

    const upload = multer({
      storage,
      limits: {
        fileSize: 67108864,
      },
    });

    return { upload, storage };
  }

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

  static async handleFileUpload(file: Express.Multer.File): Promise<{ filename: string; gcsUrl?: string; localPath?: string }> {
    if (this.shouldUploadToGCS) {
      return this.uploadFileToGCS(file);
    } else {
      return this.uploadFileLocally(file);
    }
  }

  private static async uploadFileToGCS(file: Express.Multer.File): Promise<{ filename: string; gcsUrl: string }> {
    try {
      const uniqueSuffix = uuidv4();
      const filename = uniqueSuffix + '.' + file.originalname.split('.').pop();
      const destination = `uploads/${filename}`;

      let uploadOptions: any = {
        destination: destination,
        metadata: {
          cacheControl: 'public, max-age=31536000',
        },
      };

      const [uploadedFile] = await this.bucket.upload(file.path, uploadOptions);

      await uploadedFile.makePublic();

      const gcsUrl = `https://storage.googleapis.com/${this.bucket.name}/uploads/${filename}`;

      return {
        filename: filename,
        gcsUrl: gcsUrl
      };
    } catch (error) {
      console.error('Direct GCS upload error:', error);
      throw new Error('Failed to upload file to Google Cloud Storage');
    }
  }

  private static async uploadFileLocally(file: Express.Multer.File): Promise<{ filename: string; localPath: string }> {
    try {
      const uploadsDir = path.join(__dirname, '../uploads');
      if (!fs.existsSync(uploadsDir)) {
        fs.mkdirSync(uploadsDir, { recursive: true });
      }

      const uniqueSuffix = uuidv4();
      const filename = uniqueSuffix + '.' + file.originalname.split('.').pop();
      const filePath = path.join(uploadsDir, filename);

      if (file.path) {
        fs.renameSync(file.path, filePath);
      } else if (file.buffer) {
        fs.writeFileSync(filePath, file.buffer);
      }

      return {
        filename: filename,
        localPath: filePath
      };
    } catch (error) {
      console.error('Local upload error:', error);
      throw new Error('Failed to upload file locally');
    }
  }
}
