import path from 'path';
import * as fs from 'fs';

export class UploadService {
  static getFile(filename: string, download?: string): { path: string; download: boolean } {
    const uploadsDir = path.join(__dirname, '../uploads');
    const filePath = path.join(uploadsDir, filename);
    
    if (!fs.existsSync(filePath)) {
      throw new Error('File not found');
    }
    
    return { path: filePath, download: download === 'true' };
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
