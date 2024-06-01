const express = require('express');
const TeenPatti20 = require('./index');

const AuthenticateSession = require('../../../middlewares/AuthenticateSession');

const router = express.Router();

const teenPatti20 = new TeenPatti20();

router.get('/get-catalogue-stream', teenPatti20.getCatalogueStream);

module.exports = router;
