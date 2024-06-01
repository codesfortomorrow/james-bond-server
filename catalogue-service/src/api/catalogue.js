/* eslint-disable @typescript-eslint/no-var-requires */
const express = require('express');
const cricket = require('./cricket/router');
const soccer = require('./soccer/router');
const tennis = require('./tennis/router');
const casino = require('./casino');

const router = express.Router();

router.use('/cricket', cricket);
router.use('/soccer', soccer);
router.use('/tennis', tennis);
router.use('/casino', casino);

module.exports = router;
