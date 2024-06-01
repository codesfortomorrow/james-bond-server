/* eslint-disable quotes */
import multer from 'multer';
// import { v4 as uuidv4 } from 'uuid';
import crypto from 'crypto';
import path from 'path';


const publicFolderPath = path.join(__dirname, "../", "uploads");
console.log('publicFolderPath' , publicFolderPath);

const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, publicFolderPath);
  },
  filename: (req, file, cb) => {
    const hash = crypto.createHash('md5').update(file.originalname + Date.now() + Math.floor((Math.random() + 1) * 100000)).digest('hex');

    if (!file.originalname.includes('.')) {
      cb(null, hash);
    } else {
      const regExpMatchArray = file.originalname.match(/[a-z0-9]+$/);
      if (regExpMatchArray) {
        cb(null, hash + '.' + regExpMatchArray[0]);
      } else {
        cb(null, hash);
      }
    }
  }
});

export default multer({ storage: storage, limits: { fileSize: 200000000 } });