import jwt from 'jsonwebtoken';
import { Request, Response, NextFunction } from 'express';
import { AuthService } from '../service/auth.service';

const JWT_SECRET = process.env.JWT_SECRET || 'lottocat_secret_key';
const IS_SIGN = process.env.IS_SIGN === 'true';

const handleRequestDecoding = (req: any): void => {
  try {
    console.group("Request");
    console.log("Body: ", req.body)

    let decoded = jwt.decode(req.body.data);

    console.log("Decoded: ", decoded)
    console.groupEnd();

    req.body = decoded;
  } catch (error) {
    req.body = {};
  }
};

const handleResponseEncoding = (res: Response): void => {
  const originalJson = res.json;
  res.json = function(data: any) {
    const encodedResponse = IS_SIGN ? jwt.sign(data, JWT_SECRET) : jwt.sign(data, '', { algorithm: 'none' });
    return originalJson.call(this, { data: encodedResponse });
  };
};

const isContain = (content: string) => {
  const reject = [
    '/tojwt', 
    '/auth/login', 
    '/auth/logout', 
    '/auth/register', 
    // '/auth/repass', 
    '/upload'
  ];

  return reject.some((item) => content.includes(item));
} 

export const jwtMiddleware = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
  // console.log("Request Body: ", req.body)
  // console.log("Request Data: ", req.data)
  // console.log("File: ", req)

  // Check if file 
  
  if (isContain(req.path)) {
    if ((!req.path.includes('/upload')) && (!req.path.includes('/tojwt'))) {
      handleRequestDecoding(req);
    }

    if (!req.path.includes('/tojwt')) {
      handleResponseEncoding(res);
    }

    next();
    return;
  }

  const authHeader = req.headers.authorization;

  // console.log("Auth header: ", authHeader)

  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    res.status(401).json({ error: 'Authorization header missing or invalid' });
    return;
  }

  try {
    const token = authHeader.split('Bearer ')[1];
    const tokenDecoded = IS_SIGN ? jwt.verify(token, JWT_SECRET) : jwt.decode(token);

    console.log("Token decoded: ", tokenDecoded)

    if (tokenDecoded && typeof tokenDecoded === 'object' && 'uid' in tokenDecoded) {

      const userCheck = await AuthService.validateUserToken({
        uid: tokenDecoded.uid as number,
        token: token
      });

      if (!userCheck.success) {
        console.log('Token validation failed: ', userCheck.message);
        res.status(401).json({ error: userCheck.message });
        return;
      }

      req.user = {
        ...tokenDecoded,
        ...userCheck.user
      };
    }

    handleRequestDecoding(req);
    handleResponseEncoding(res);
    next();
  } catch (error) {
    console.error('JWT middleware error:', error);
    res.status(401).json({ error: 'Invalid token' });
  }
};
