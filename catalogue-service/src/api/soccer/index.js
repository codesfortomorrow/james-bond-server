/* eslint-disable @typescript-eslint/no-var-requires */
const kafkaTopics = require('../../utils/kafkaTopics');
const validateBet = require('../../utils/validateBet');

class Soccer {

  static fixtureSubscribers = [];
  static marketCatalogueSubscribers = new Object();
  static fixtures = [];
  static competitions = [];
  static events = new Object();
  static marketCatalogues = new Object();
  static OverUnder15Goals = new Object();
  static OverUnder25Goals = new Object();
  static OverUnder35Goals = new Object();
  static matchOddsCatalogues = new Object();


  emitFixtureStream() {
    Soccer.fixtureSubscribers.forEach(subscriber => {
      subscriber.response.write(`data: ${JSON.stringify(Soccer.fixtures)}\n\n`);
    });
  }

  // emitCatalogueStream(eventId) {
  //   if (Soccer.marketCatalogueSubscribers[eventId]) {
  //     Soccer.marketCatalogueSubscribers[eventId].forEach(subscriber => {
  //       if (Soccer.marketCatalogues[eventId]) {
  //         subscriber.response.write(`data: ${JSON.stringify(Soccer.marketCatalogues[eventId])}\n\n`);
  //       } else {
  //         subscriber.response.write(`data: ${JSON.stringify({})}\n\n`);
  //       }
  //     });
  //   }
  // }

  emitCatalogueStream(eventId, type) {
    if (Soccer.marketCatalogueSubscribers[eventId]) {
      Soccer.marketCatalogueSubscribers[eventId].forEach(subscriber => {
        if (Soccer.marketCatalogues[eventId]) {

          if (type) {
            subscriber.response.write(`data: ${JSON.stringify({ [type]: Soccer.marketCatalogues[eventId][type] })}\n\n`);
          } else {
            subscriber.response.write(`data: ${JSON.stringify(Soccer.marketCatalogues[eventId])}\n\n`);
          }

        } else {
          subscriber.response.write(`data: ${JSON.stringify({})}\n\n`);
        }
      });
    }
  }
  consumeKafkaMessage(payload) {
    if (payload.topic === kafkaTopics.SOCCER_FIXTURE_LIST.topic) {
      Soccer.fixtures = JSON.parse(payload.message.value ? payload.message.value.toString() : '[]');
      this.emitFixtureStream();
    }

    if (payload.topic === kafkaTopics.SOCCER_COMPETITION_LIST.topic) {
      Soccer.competitions = JSON.parse(payload.message.value ? payload.message.value.toString() : '[]');

    }

    if (payload.topic === kafkaTopics.SOCCER_EVENT_LIST.topic) {
      const parsedData = JSON.parse(payload.message.value ? payload.message.value.toString() : '{}');

      if (parsedData.competitionId) {
        Soccer.events[parsedData.competitionId] = parsedData.events;

      }
    }

    if (payload.topic === kafkaTopics.SOCCER_MARKET_CATALOGUE.topic) {
      const parsedData = JSON.parse(payload.message.value ? payload.message.value.toString() : '{}');
      // console.log('parsedData', JSON.stringify(parsedData));
      if(!Soccer.marketCatalogues[parsedData.eventId]) {
        Soccer.marketCatalogues[parsedData.eventId] = {};
      }
      // console.log('parsedData.market', parsedData.market);
      if (parsedData.market === 'MATCH_ODDS') {
        // console.log('MatchOdds');

        Soccer.marketCatalogues[parsedData.eventId]['MatchOdds'] = parsedData;
        this.emitCatalogueStream(parsedData.eventId, 'MatchOdds');
        Soccer.matchOddsCatalogues[parsedData.eventId] = parsedData.marketCatalogue;
        // console.log('parsedData.market', parsedData);
      }
      if (parsedData.market === 'Over/Under 1.5 Goals') {
        // console.log('Over/Under 1.5 Goals');
        Soccer.marketCatalogues[parsedData.eventId]['OverUnder15Goals'] = parsedData;
        this.emitCatalogueStream(parsedData.eventId, 'OverUnder15Goals');
        Soccer.OverUnder15Goals[parsedData.eventId] = parsedData.marketCatalogue;

      }

      if (parsedData.market === 'Over/Under 2.5 Goals') {
        // console.log('Over/Under 2.5 Goals');
        Soccer.marketCatalogues[parsedData.eventId]['OverUnder25Goals'] = parsedData;
        this.emitCatalogueStream(parsedData.eventId, 'OverUnder25Goals');
        Soccer.OverUnder25Goals[parsedData.eventId] = parsedData.marketCatalogue
      }
      if (parsedData.market === 'Over/Under 3.5 Goals') {
        Soccer.marketCatalogues[parsedData.eventId]['OverUnder35Goals'] = parsedData;
        this.emitCatalogueStream(parsedData.eventId, 'OverUnder35Goals');
        Soccer.OverUnder35Goals[parsedData.eventId] = parsedData.marketCatalogue;

      }
    }
  }
/**
 * @swagger
 * /soccer/competitions:
 *   get:
 *     summary: Get list of soccer competitions
 *     responses:
 *       200:
 *         description: Successful response
 *         content:
 *           application/json:
 *             schema:
 *               type: array
 *               items:
 *                 type: string
 */

  getCompetitions(req, res) {
    res.status(200).send(Soccer.competitions);
  }
/**
 * @swagger
 * /soccer/events:
 *   get:
 *     summary: Get soccer events for a specific competition
 *     parameters:
 *       - in: query
 *         name: competitionId
 *         required: true
 *         schema:
 *           type: string
 *     responses:
 *       200:
 *         description: Successful response
 *         content:
 *           application/json:
 *             schema:
 *               type: array
 *               items:
 *                 type: object
 */

  getEvents(req, res) {
    const competitionId = req.query.competitionId;

    if (competitionId) {
      res.status(200).send(Soccer.events[competitionId] ? Soccer.events[competitionId] : []);
    } else {
      res.status(400).end();
    }
  }


  getCatalogue(req, res) {
    const eventId = req.query.eventId;

    if (eventId) {
     
      res.status(200).send(Soccer.marketCatalogues[eventId] ? Soccer.marketCatalogues[eventId] : []);
    } else {
      res.status(400).end();
    }
  }

  validateBetPlacement(req, res) {
    let response;
    const { eventId, market, gameType, selectionId, betOn, price, percent } = req.body;

    if (!eventId || !market || !gameType || !selectionId || !price || !betOn || !percent) {
      res.status(400).end();
      return;
    }


    if(market==='Over/Under 1.5 Goals'){
    
      response = validateBet(1, Soccer.OverUnder15Goals[eventId], req.body);
     }
     
     if(market==='Over/Under 2.5 Goals'){
      
       response = validateBet(1, Soccer.OverUnder25Goals[eventId], req.body);
      }
      if(market==='Over/Under 3.5 Goals'){
      
       response = validateBet(1, Soccer.OverUnder35Goals[eventId], req.body);
      }
      if(market==='MATCH_ODDS'){
    //  console.log('matchodds ',eventId, market, gameType, selectionId, betOn, price, percent)
       response = validateBet(1, Soccer.matchOddsCatalogues[eventId], req.body);
     }

    if (response instanceof Error) {
      res.status(406).send(response.message);
    } else {
      res.status(200).json(response);
    }
  }
/**
 * @swagger
 * /soccer/get-fixture-stream:
 *   get:
 *     summary: Get fixture stream for soccer events
 *     responses:
 *       200:
 *         description: Successful response
 *         content:
 *           text/event-stream:
 *             schema:
 *               type: string
 */

  getFixtureStream(req, res) {
    const streamId = Math.random().toString(16).slice(2);
    // console.log('Hello World soccer', new Date().getTime());

    res.writeHead(200, {
      'Content-Type': 'text/event-stream',
      'Connection': 'keep-alive',
      'Cache-Control': 'no-cache',
      'X-Accel-Buffering': 'no'
    });

    Soccer.fixtureSubscribers = [...Soccer.fixtureSubscribers, { id: streamId, response: res }];
    res.write(`data: ${JSON.stringify(Soccer.fixtures)}\n\n`);

    req.on('close', () => {
      const subscriberIndex = Soccer.fixtureSubscribers.findIndex((subscriber) => subscriber.id == streamId);
      if (subscriberIndex !== -1) {
        Soccer.fixtureSubscribers.splice(subscriberIndex, 1);
      }
    });
  }
/**
 * @swagger
 * /soccer/get-catalogue-stream:
 *   get:
 *     summary: Get catalogue stream for a specific soccer event
 *     parameters:
 *       - in: query
 *         name: eventId
 *         required: true
 *         schema:
 *           type: string
 *     responses:
 *       200:
 *         description: Successful response
 *         content:
 *           text/event-stream:
 *             schema:
 *               type: string
 */
  getCatalogueStream(req, res) {
    const streamId = Math.random().toString(16).slice(2);
    const eventId = req.query.eventId;

    if (!eventId) {
      res.status(400).end();
      return;
    }

    res.writeHead(200, {
      'Content-Type': 'text/event-stream',
      'Connection': 'keep-alive',
      'Cache-Control': 'no-cache',
      'X-Accel-Buffering': 'no'
    });

    if (Soccer.marketCatalogueSubscribers[eventId]) {
      Soccer.marketCatalogueSubscribers[eventId] = [...Soccer.marketCatalogueSubscribers[eventId], { id: streamId, response: res }];
    } else {
      Soccer.marketCatalogueSubscribers[eventId] = [{ id: streamId, response: res }];
    }

    if (Soccer.marketCatalogues[eventId]) {
      res.write(`data: ${JSON.stringify(Soccer.marketCatalogues[eventId])}\n\n`);
    } else {
      res.write(`data: ${JSON.stringify({})}\n\n`);
    }

    req.on('close', () => {
      const subscriberIndex = Soccer.marketCatalogueSubscribers[eventId].findIndex((subscriber) => subscriber.id == streamId);
      if (subscriberIndex !== -1) {
        Soccer.marketCatalogueSubscribers[eventId].splice(subscriberIndex, 1);
      }
    });
  }
}

module.exports = Soccer;