/* eslint-disable @typescript-eslint/no-unused-vars */
/* eslint-disable @typescript-eslint/no-var-requires */
/* eslint-disable quotes */
const { json } = require('express');
const kafkaTopics = require('../../utils/kafkaTopics');
const validateBet = require('../../utils/validateBet');

class Cricket {

  static fixtureSubscribers = [];
  static marketCatalogueSubscribers = new Object();
  static fixtures = [];
  static competitions = [];
  static events = new Object();
  static marketCatalogues = {};
  static bmCatalogues = new Object();
  static fancyCatalogues = new Object();
  static sessionCatalogues = new Object();
  static matchOddsCatalogues = new Object();

  emitFixtureStream() {
    Cricket.fixtureSubscribers.forEach(subscriber => {
      subscriber.response.write(`data: ${JSON.stringify(Cricket.fixtures)}\n\n`);
    });
  }

  emitCatalogueStream(eventId, type) {
    if (Cricket.marketCatalogueSubscribers[eventId]) {
      Cricket.marketCatalogueSubscribers[eventId].forEach(subscriber => {
        if (Cricket.marketCatalogues[eventId]) {

           if(type) {
              subscriber.response.write(`data: ${JSON.stringify({[type]: Cricket.marketCatalogues[eventId][type]})}\n\n`);
           } else {
             subscriber.response.write(`data: ${JSON.stringify(Cricket.marketCatalogues[eventId])}\n\n`);
           }

        } else {
          subscriber.response.write(`data: ${JSON.stringify({})}\n\n`);
        }
      });
    }
  }

  consumeKafkaMessage(payload) {
    if (payload.topic === kafkaTopics.CRICKET_FIXTURE_LIST.topic) {
      Cricket.fixtures = JSON.parse(payload.message.value ? payload.message.value.toString() : '[]');
      this.emitFixtureStream();
    }

    if (payload.topic === kafkaTopics.CRICKET_COMPETITION_LIST.topic) {
      Cricket.competitions = JSON.parse(payload.message.value ? payload.message.value.toString() : '[]');
    }

    if (payload.topic === kafkaTopics.CRICKET_EVENT_LIST.topic) {
      const parsedData = JSON.parse(payload.message.value ? payload.message.value.toString() : '{}');
      if (parsedData.competitionId) {
        Cricket.events[parsedData.competitionId] = parsedData.events;
      }
    }

    if (payload.topic === kafkaTopics.CRICKET_MARKET_CATALOGUE.topic) {
      const parsedData = JSON.parse(payload.message.value ? payload.message.value.toString() : '{}');
  
      
      // if (parsedData.eventId) {
      //   Cricket.marketCatalogues[parsedData.eventId] = parsedData.marketCatalogue;
      //   this.emitCatalogueStream(parsedData.eventId, 'matchOdds');
      // }
      if(!Cricket.marketCatalogues[parsedData.eventId]) {
        Cricket.marketCatalogues[parsedData.eventId] = {};
      }

      if(parsedData.marketCatalogue.market === 'Match Odds'){
        
        Cricket.marketCatalogues[parsedData.eventId]['MatchOdds']=parsedData.marketCatalogue;
       
        this.emitCatalogueStream(parsedData.eventId, 'MatchOdds');
        Cricket.matchOddsCatalogues[parsedData.eventId]=parsedData.marketCatalogue;
      }
      if(parsedData.marketCatalogue.market === 'bookmaker'){
        
        Cricket.marketCatalogues[parsedData.eventId]['bookmaker']=parsedData.marketCatalogue;
        this.emitCatalogueStream(parsedData.eventId, 'bookmaker');
        Cricket.bmCatalogues[parsedData.eventId] = parsedData.marketCatalogue;
        
      }
      if(parsedData.marketCatalogue.market=== 'fancy'){
        Cricket.marketCatalogues[parsedData.eventId]['fancy']=parsedData.marketCatalogue;
        this.emitCatalogueStream(parsedData.eventId, 'fancy');
        Cricket.fancyCatalogues[parsedData.eventId] = parsedData.marketCatalogue;
      }
      if(parsedData.marketCatalogue.market=== 'session'){
        Cricket.marketCatalogues[parsedData.eventId]['session']=parsedData.marketCatalogue;
        this.emitCatalogueStream(parsedData.eventId, 'session');
        Cricket.sessionCatalogues[parsedData.eventId] = parsedData.marketCatalogue;
        
      }
     
    }
  }
  

  getCompetitions(req, res) {
    res.status(200).send(Cricket.competitions);
  }

  getEvents(req, res) {
    const competitionId = req.query.competitionId;

    if (competitionId) {
      res.status(200).send(Cricket.events[competitionId] ? Cricket.events[competitionId] : []);
    } else {
      res.status(400).end();
    }
  }

  getCatalogue(req, res) {
    const eventId = req.query.eventId;

    if (eventId) {
      res.status(200).send(Cricket.marketCatalogues[eventId] ? Cricket.marketCatalogues[eventId] : []);
    } else {
      res.status(400).end();
    }
  }

  validateBetPlacement(req, res) {
    let response;
    const { eventId, market, gameType, selectionId, betOn, price, percent } = req.body;
    console.log('req.iiiiiiibody',req.body);

    if (!eventId || !market || !gameType || !selectionId || !price || !betOn || !percent) {
      res.status(400).end();
      return;
    }

    if(gameType==='bookmaker'){
    
     response = validateBet(4, Cricket.bmCatalogues[eventId], req.body);
    }
    
    if(gameType==='fancy'){
     
      response = validateBet(4, Cricket.fancyCatalogues[eventId], req.body);
     }
     if(gameType==='session'){
     
      response = validateBet(4, Cricket.sessionCatalogues[eventId], req.body);
     }
     if(gameType==='Match Odds'){
    
      response = validateBet(4, Cricket.matchOddsCatalogues[eventId], req.body);
    }
     
  

    if (response instanceof Error) {
      res.status(406).send(response.message);
    } else {
      res.status(200).json(response);
    }
  }

  getFixtureStream(req, res) {
    // console.log('Hello World cricket', new Date().getTime());
    const streamId = Math.random().toString(16).slice(2);

    res.writeHead(200, {
      'Content-Type': 'text/event-stream',
      'Connection': 'keep-alive',
      'Cache-Control': 'no-cache',
      'X-Accel-Buffering': 'no'
    });

    Cricket.fixtureSubscribers = [...Cricket.fixtureSubscribers, { id: streamId, response: res }];

    res.write(`data: ${JSON.stringify(Cricket.fixtures)}\n\n`);

    req.on('close', () => {
      const subscriberIndex = Cricket.fixtureSubscribers.findIndex((subscriber) => subscriber.id == streamId);
      if (subscriberIndex !== -1) {
        Cricket.fixtureSubscribers.splice(subscriberIndex, 1);
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

    if (Cricket.marketCatalogueSubscribers[eventId]) {
      Cricket.marketCatalogueSubscribers[eventId] = [...Cricket.marketCatalogueSubscribers[eventId], { id: streamId, response: res }];
    } else {
      Cricket.marketCatalogueSubscribers[eventId] = [{ id: streamId, response: res }];
    }

    if (Cricket.marketCatalogues[eventId]) {
      res.write(`data: ${JSON.stringify(Cricket.marketCatalogues[eventId])}\n\n`);
    } else {
      res.write(`data: ${JSON.stringify({})}\n\n`);
    }

    req.on('close', () => {
      const subscriberIndex = Cricket.marketCatalogueSubscribers[eventId].findIndex((subscriber) => subscriber.id == streamId);
      if (subscriberIndex !== -1) {
        Cricket.marketCatalogueSubscribers[eventId].splice(subscriberIndex, 1);
      }
    });
  }
}

module.exports = Cricket;
