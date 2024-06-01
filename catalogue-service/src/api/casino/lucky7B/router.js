const express = require('express');
const Lucky7B = require('./index');

const AuthenticateSession = require('../../../middlewares/AuthenticateSession');

const router = express.Router();

const lucky7B = new Lucky7B();

router.get('/get-catalogue-stream', lucky7B.getCatalogueStream);

module.exports = router;
