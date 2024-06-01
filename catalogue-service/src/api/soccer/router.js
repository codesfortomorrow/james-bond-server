const express = require('express');
const Soccer = require('./index');

const AuthenticateSession = require('../../middlewares/AuthenticateSession');

const router = express.Router();

const soccer = new Soccer();

router.get('/competitions',  soccer.getCompetitions);
router.get('/events', soccer.getEvents);
router.get('/get-catalogue',  soccer.getCatalogue);
router.post('/validate-bet-placement', soccer.validateBetPlacement);
router.get('/get-fixture-stream', soccer.getFixtureStream);
router.get('/get-catalogue-stream', soccer.getCatalogueStream);

module.exports = router;
