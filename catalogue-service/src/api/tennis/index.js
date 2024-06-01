/* eslint-disable @typescript-eslint/no-var-requires */
const kafkaTopics = require('../../utils/kafkaTopics');
const validateBet = require('../../utils/validateBet');

class Tennis {

  static fixtureSubscribers = [];
  static marketCatalogueSubscribers = new Object();
  static fixtures = [];
  static competitions = [];
  static events = new Object();
  static marketCatalogues = new Object();
  static Set1Winner = new Object();
  static Set2Winner = new Object();
  static matchOddsCatalogues = new Object();

  emitFixtureStream() {
    Tennis.fixtureSubscribers.forEach(subscriber => {
      subscriber.response.write(`data: ${JSON.stringify(Tennis.fixtures)}\n\n`);
    });
  }

  emitCatalogueStream(eventId, type) {
    if (Tennis.marketCatalogueSubscribers[eventId]) {
      Tennis.marketCatalogueSubscribers[eventId].forEach(subscriber => {
        if (Tennis.marketCatalogues[eventId]) {

          if (type) {
            subscriber.response.write(`data: ${JSON.stringify({ [type]: Tennis.marketCatalogues[eventId][type] })}\n\n`);
          } else {
            subscriber.response.write(`data: ${JSON.stringify(Tennis.marketCatalogues[eventId])}\n\n`);
          }

        } else {
          subscriber.response.write(`data: ${JSON.stringify({})}\n\n`);
        }
      });
    }
  }

  consumeKafkaMessage(payload) {
    if (payload.topic === kafkaTopics.TENNIS_FIXTURE_LIST.topic) {
      Tennis.fixtures = JSON.parse(payload.message.value ? payload.message.value.toString() : '[]');
      this.emitFixtureStream();
    }

    if (payload.topic === kafkaTopics.TENNIS_COMPETITION_LIST.topic) {
      Tennis.competitions = JSON.parse(payload.message.value ? payload.message.value.toString() : '[]');
    }

    if (payload.topic === kafkaTopics.TENNIS_EVENT_LIST.topic) {
      const parsedData = JSON.parse(payload.message.value ? payload.message.value.toString() : '{}');
      if (parsedData.competitionId) {
        Tennis.events[parsedData.competitionId] = parsedData.events;
      }
    }

    if (payload.topic === kafkaTopics.TENNIS_MARKET_CATALOGUE.topic) {
      const parsedData = JSON.parse(payload.message.value ? payload.message.value.toString() : '{}');
      if(!Tennis.marketCatalogues[parsedData.eventId]) {
        Tennis.marketCatalogues[parsedData.eventId] = {};
      }
      // console.log('parsedData.market', parsedData.market);
      if (parsedData.market === 'MATCH_ODDS') {
        // console.log('MatchOdds');

        Tennis.marketCatalogues[parsedData.eventId]['MatchOdds'] = parsedData;
        this.emitCatalogueStream(parsedData.eventId, 'MatchOdds');
        Tennis.matchOddsCatalogues[parsedData.eventId] = parsedData.marketCatalogue;
      }
      if (parsedData.market === 'Set 1 Winner') {
        // console.log('Set 1 Winner');
        Tennis.marketCatalogues[parsedData.eventId]['Set1Winner'] = parsedData;
        this.emitCatalogueStream(parsedData.eventId, 'Set1Winner');
        Tennis.Set1Winner[parsedData.eventId] = parsedData.marketCatalogue;

      }

      if (parsedData.market === 'Set 2 Winner') {
        // console.log('Set 2 Winner');
        Tennis.marketCatalogues[parsedData.eventId]['Set2Winner'] = parsedData;
        this.emitCatalogueStream(parsedData.eventId, 'Set2Winner');
        Tennis.Set2Winner[parsedData.eventId] = parsedData.marketCatalogue;
      }
     
    }
  }

  getCompetitions(req, res) {
    res.status(200).send(Tennis.competitions);
  }

  getEvents(req, res) {
    const competitionId = req.query.competitionId;

    if (competitionId) {
      res.status(200).send(Tennis.events[competitionId] ? Tennis.events[competitionId] : []);
    } else {
      res.status(400).end();
    }
  }

  getCatalogue(req, res) {
    const eventId = req.query.eventId;

    if (eventId) {
      res.status(200).send(Tennis.marketCatalogues[eventId] ? Tennis.marketCatalogues[eventId] : []);
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

    // const response = validateBet(2, Tennis.marketCatalogues[eventId], req.body);
    if(market==='Set 1 Winner'){
      
      response = validateBet(2, Tennis.Set1Winner[eventId], req.body);
     }
     if(market==='Set 2 Winner'){
     
      response = validateBet(2, Tennis.Set2Winner[eventId], req.body);
     }
     if(market==='MATCH_ODDS'){
    
      response = validateBet(2, Tennis.matchOddsCatalogues[eventId], req.body);
    }

    if (response instanceof Error) {
      res.status(406).send(response.message);
    } else {
      res.status(200).json(response);
    }
  }

  getFixtureStream(req, res) {
    const streamId = Math.random().toString(16).slice(2);

    res.writeHead(200, {
      'Content-Type': 'text/event-stream',
      'Connection': 'keep-alive',
      'Cache-Control': 'no-cache',
      'X-Accel-Buffering': 'no'
    });

    Tennis.fixtureSubscribers = [...Tennis.fixtureSubscribers, { id: streamId, response: res }];
    res.write(`data: ${JSON.stringify(Tennis.fixtures)}\n\n`);

    req.on('close', () => {
      const subscriberIndex = Tennis.fixtureSubscribers.findIndex((subscriber) => subscriber.id == streamId);
      if (subscriberIndex !== -1) {
        Tennis.fixtureSubscribers.splice(subscriberIndex, 1);
      }
    });
  }

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

    if (Tennis.marketCatalogueSubscribers[eventId]) {
      Tennis.marketCatalogueSubscribers[eventId] = [...Tennis.marketCatalogueSubscribers[eventId], { id: streamId, response: res }];
    } else {
      Tennis.marketCatalogueSubscribers[eventId] = [{ id: streamId, response: res }];
    }

    if (Tennis.marketCatalogues[eventId]) {
      res.write(`data: ${JSON.stringify(Tennis.marketCatalogues[eventId])}\n\n`);
    } else {
      res.write(`data: ${JSON.stringify({})}\n\n`);
    }

    req.on('close', () => {
      const subscriberIndex = Tennis.marketCatalogueSubscribers[eventId].findIndex((subscriber) => subscriber.id == streamId);
      if (subscriberIndex !== -1) {
        Tennis.marketCatalogueSubscribers[eventId].splice(subscriberIndex, 1);
      }
    });
  }
}

module.exports = Tennis;
