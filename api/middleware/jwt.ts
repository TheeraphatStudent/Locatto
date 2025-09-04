import jwt from 'jsonwebtoken';
import { Request, Response, NextFunction } from 'express';

const JWT_SECRET = process.env.JWT_SECRET || 'lottocat_secret_key';
const IS_SIGN = process.env.IS_SIGN === 'true';

interface AuthenticatedRequest extends Request {
  decodedPayload?: any;
  uid?: any;
}

const handleRequestDecoding = (req: AuthenticatedRequest): void => {
  const decoded = IS_SIGN ? jwt.verify(req.body.data, JWT_SECRET) : jwt.decode(req.body.data);
  req.decodedPayload = decoded;
  req.body = decoded;
};

const handleResponseEncoding = (res: Response): void => {
  const originalJson = res.json;
  res.json = function(data: any) {
    const encodedResponse = IS_SIGN ? jwt.sign(data, JWT_SECRET) : jwt.sign(data, '', { algorithm: 'none' });
    return originalJson.call(this, { data: encodedResponse });
  };
};

const isContain = (content: string) => {
  const reject = ['tojwt', '/auth/login', '/auth/register', '/auth/repass', '/upload'];

  return reject.some((item) => content.includes(item));
} 

export const jwtMiddleware = (req: AuthenticatedRequest, res: Response, next: NextFunction): void => {
  // console.log("Request Path: ", req.path)
  // console.log(isContain(req.path))
  
  if (isContain(req.path)) {
    next();
    return;
  }

  const authHeader = req.headers.authorization;
  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    res.status(401).json({ error: 'Authorization header missing or invalid' });
    return;
  }

  try {
    const token = authHeader.split('Bearer ')[1];

    const decoded = IS_SIGN ? jwt.verify(token, JWT_SECRET) : jwt.decode(token);
    if (decoded && typeof decoded === 'object') {
      req.decodedPayload = decoded;
      req.uid = (decoded as any).uid;
    }
    req.body = { data: decoded };

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
  } catch (error) {
    console.error('JWT middleware error:', error);
    res.status(401).json({ error: 'Invalid token' });
  }
};
