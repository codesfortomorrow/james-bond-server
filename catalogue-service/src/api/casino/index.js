const express = require('express');
const teenPatti20 = require('./teenPatti20/router');
const lucky7B = require('./lucky7B/router');
const amarAkbarAnthony = require('./amarAkbarAnthony/router');

const router = express.Router();

router.use('/teenpatti20', teenPatti20);
router.use('/lucky7b', lucky7B);
router.use('/amar-akbar-anthony', amarAkbarAnthony);

module.exports = router;
