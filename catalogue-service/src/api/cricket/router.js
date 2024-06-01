/* eslint-disable @typescript-eslint/no-unused-vars */
/* eslint-disable @typescript-eslint/no-var-requires */
const express = require('express');
const Cricket = require('./index');

const AuthenticateSession = require('../../middlewares/AuthenticateSession');

const router = express.Router();

const cricket = new Cricket();

router.get('/competitions', cricket.getCompetitions);
router.get('/events', cricket.getEvents);
router.get('/get-catalogue', cricket.getCatalogue);
router.post('/validate-bet-placement', cricket.validateBetPlacement);
router.get('/get-fixture-stream', cricket.getFixtureStream);
router.get('/get-catalogue-stream', cricket.getCatalogueStream);

module.exports = router;
