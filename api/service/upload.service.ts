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
    const options: any = {
      bucket: 'lottocat_bucket',
      projectId: process.env.GOOGLE_CLOUD_PROJECT,
      filename: (_req: any, file: Express.Multer.File, cb: (error: Error | null, filename: string) => void) => {
        const uniqueSuffix = uuidv4();
        const filename = uniqueSuffix + '.' + file.originalname.split('.').pop();
        cb(null, filename);
      },
    };

    if (process.env.GOOGLE_APPLICATION_CREDENTIALS) {
      options.keyFilename = process.env.GOOGLE_APPLICATION_CREDENTIALS;
    }

    const storage = new MulterGoogleCloudStorage(options);

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
      // Generate unique filename
      const uniqueSuffix = uuidv4();
      const fileExtension = file.originalname.split('.').pop() || '';
      const filename = `${uniqueSuffix}.${fileExtension}`;
      const destination = `uploads/${filename}`;

      console.log(`Uploading file to GCS: ${filename} (${file.size} bytes)`);

      const uploadOptions = {
        destination: destination,
        metadata: {
          cacheControl: 'public, max-age=31536000',
          contentType: file.mimetype,
          metadata: {
            originalName: file.originalname,
            uploadTimestamp: new Date().toISOString(),
          },
        },
        public: true,
        validation: 'md5',
      };

      let uploadedFile;
      if (file.buffer && file.buffer.length > 0) {
        console.log('Uploading from buffer using file.save() method');

        const fileRef = this.bucket.file(destination);
        await fileRef.save(file.buffer, {
          metadata: uploadOptions.metadata,
          public: true,
          validation: 'md5',
        });
        uploadedFile = fileRef;

      } else if (file.path && fs.existsSync(file.path)) {
        // Upload from file path (recommended for disk-stored files)
        console.log(`Uploading from file path: ${file.path}`);

        const [uploaded] = await this.bucket.upload(file.path, uploadOptions);
        uploadedFile = uploaded;

      } else {
        throw new Error('No valid file data or path available for upload');
      }

      // Ensure file is publicly accessible
      if (!uploadOptions.public) {
        await uploadedFile.makePublic();
      }

      // Generate public URL
      const gcsUrl = `https://storage.googleapis.com/${this.bucket.name}/${destination}`;

      console.log(`✅ File uploaded successfully to GCS: ${gcsUrl}`);

      return {
        filename: filename,
        gcsUrl: gcsUrl
      };

    } catch (error) {
      const err = error as any;

      if (err.code === 403) {
        throw new Error('Access denied to Google Cloud Storage. Check authentication and permissions.');
      } else if (err.code === 404) {
        throw new Error('Bucket not found. Verify bucket name and project configuration.');
      } else if (err.code === 429) {
        throw new Error('Rate limit exceeded. Please retry after a moment.');
      } else {
        throw new Error(`Failed to upload file to Google Cloud Storage: ${err.message || 'Unknown error'}`);
      }
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
