const express = require('express');
const Tennis = require('./index');

const AuthenticateSession = require('../../middlewares/AuthenticateSession');

const router = express.Router();

const tennis = new Tennis();

router.get('/competitions', AuthenticateSession, tennis.getCompetitions);
router.get('/events', AuthenticateSession, tennis.getEvents);
router.get('/get-catalogue', AuthenticateSession, tennis.getCatalogue);
router.post('/validate-bet-placement', tennis.validateBetPlacement);
router.get('/get-fixture-stream', tennis.getFixtureStream);
router.get('/get-catalogue-stream', tennis.getCatalogueStream);

module.exports = router;
