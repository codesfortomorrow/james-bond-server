import { Application } from 'express';
import userRouter from './userRouter';

/**
 * RequestHandler extends app to handle routes using specific express router
 * 
 * @param app Application
 * @returns void
 */
const RequestHandler = (app: Application): void => {
	app.use('/', userRouter);
};

export default RequestHandler;
