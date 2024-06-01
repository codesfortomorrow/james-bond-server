require('./betdb.config');
require('./db.config');


import express, { Application } from 'express';
import cors from 'cors';
import RequestHandler from './api';
import path from 'path';

const app: Application = express();

app.use(express.json());

app.use(express.urlencoded({ extended: false }));
app.use(express.static(path.join(__dirname,'../','uploads')));

// const whitelist = ['http://localhost:3001', 'http://localhost:3000','http://staging.bigdaddybook.com','staging-admin.bigdadddybook.com','http://staging.shiv11.com','http://staging-admin.bigdaddybook.com'];
const domain = process.env.DOMAIN;

const origins = domain
  ? [
      new RegExp(`^http[s]{0,1}://${domain}$`),
      new RegExp(`^http[s]{0,1}://[a-z-]+.${domain}$`),
    
      new RegExp('^http[s]{0,1}://localhost(:[0-9]+)?$')
    ]
  : [new RegExp('^http[s]{0,1}://localhost(:[0-9]+)?$')];
const corsOptions = {
  origin: origins,
  credentials: true,
};



app.use(cors(corsOptions));

RequestHandler(app);

app.listen(process.env.HTTP_PORT || '', () => {
  console.log(
    `🚀️ User service running on port ${process.env.HTTP_PORT || ''}`
  );
});
