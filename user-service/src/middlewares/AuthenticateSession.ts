import { Request, Response, NextFunction } from 'express';
import jwt, { JwtPayload, Secret } from 'jsonwebtoken';
import { isLockedUser } from '../utils/validators';
import { JwtAuthPayload } from '../types';

const AuthenticateSession = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
	const bearerHeader = req.headers['authorization'];
	if (typeof bearerHeader !== 'undefined') {
		const bearer = bearerHeader.split(' ');
		const bearerToken = bearer[1];

		try {
			// console.log(bearerToken,'token');
			const payload = jwt.verify(bearerToken, process.env.JWT_TOKEN_SECRET as Secret) as JwtPayload;
			const tokenData = { ...payload as JwtAuthPayload };
			if (Date.now() >= tokenData.exp * 1000) {
				// console.log('hererere token expired4');
                res.status(403).json({ message: 'Token expired' });
                return;
            }

			if (await isLockedUser(tokenData._uid)) {
				// console.log('hererere token expired3');
				res.sendStatus(403);
			} else {
				req[req.method === 'GET' ? 'query' : 'body'] = { ...req[req.method === 'GET' ? 'query' : 'body'], ...tokenData };
				
				
				next();
			}
		} catch (err) {
			// console.log('hererere token expired2',err);
			res.sendStatus(403);
			return;
		}
	} else {
		// console.log('hererere token expired1');
		res.sendStatus(403);
		return;
	}
};

export default AuthenticateSession;
