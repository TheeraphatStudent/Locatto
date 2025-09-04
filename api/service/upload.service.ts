import path from 'path';
import * as fs from 'fs';

export class UploadService {
  static getFile(filename: string, download?: string): { path: string; download: boolean } {
    const filePath = path.join(__dirname, '../uploads', filename);
    if (!fs.existsSync(filePath)) {
      throw new Error('File not found');
    }
    return { path: filePath, download: download === 'true' };
  }
}
