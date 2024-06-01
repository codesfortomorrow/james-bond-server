require('dotenv').config();

const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
const DBConnection = require('./db.config');
const Cricket = require('./cricket');

const server = express();

server.use(cors());
server.use(bodyParser.json());

const watchMarkets = async () => {
  new Cricket(server).init();
};

server.listen(process.env.PORT || 8005, () => {
  DBConnection(() => watchMarkets());
  console.log(`🚀️ Service running on port ${process.env.PORT || 8005}`);
});
