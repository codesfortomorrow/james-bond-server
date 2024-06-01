/* eslint-disable @typescript-eslint/no-var-requires */
const express = require('express');
const AmarAkbarAnthony = require('./index');

// eslint-disable-next-line @typescript-eslint/no-unused-vars
const AuthenticateSession = require('../../../middlewares/AuthenticateSession');

const router = express.Router();

const amarAkbarAnthony = new AmarAkbarAnthony();

router.get('/get-catalogue-stream', amarAkbarAnthony.getCatalogueStream);

module.exports = router;
