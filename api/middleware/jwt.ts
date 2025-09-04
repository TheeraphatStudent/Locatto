import jwt from 'jsonwebtoken';
import { Request, Response, NextFunction } from 'express';

const JWT_SECRET = process.env.JWT_SECRET || 'lottocat_secret_key';

interface AuthenticatedRequest extends Request {
  decodedPayload?: any;
}

const handleRequestDecoding = (req: AuthenticatedRequest): void => {
  const decoded = jwt.verify(req.body.data, JWT_SECRET);
  req.decodedPayload = decoded;
  req.body = decoded;
};

const handleResponseEncoding = (res: Response): void => {
  const originalJson = res.json;
  res.json = function(data: any) {
    const encodedResponse = jwt.sign(data, JWT_SECRET);
    return originalJson.call(this, { data: encodedResponse });
  };
};

export const jwtMiddleware = (req: AuthenticatedRequest, res: Response, next: NextFunction): void => {
  if (req.body && req.body.data) {
    try {
      handleRequestDecoding(req);
      handleResponseEncoding(res);
      next();
    } catch (error) {
      console.error('JWT middleware error:', error);
      res.status(401).json({ error: 'Invalid token' });
    }
  } else {
    next();
  }
};
