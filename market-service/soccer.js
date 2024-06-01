/* eslint-disable @typescript-eslint/no-var-requires */
const EventEmitter = require('events');
const kafkaTopics = require('./utils/kafkaTopics');
const { getData } = require('./utils/request');


class Soccer {
  eventEmitter = new EventEmitter();
  marketEmitter = new EventEmitter();
  competitionEmitter = new EventEmitter();
  fixtureEmitter = new EventEmitter();
  fixtures = [];
  competitions = [];
  events = new Object();
  markets = new Object();
  eventIntervals = new Object();
  marketIntervals = new Object();
  bmIntervals = new Object();
  marketResultIntervals = new Object();

  handleShutDownMarketInterval(competitionId, eventId, marketCatalogue) {
    if (marketCatalogue[0]?.status === 'CLOSED') {
      clearInterval(this.marketIntervals[competitionId][eventId]);
      delete this.marketIntervals[competitionId][eventId];

      

    }
  }

  async fixtureHandler(producer) {
    const eventHolder = {};

    const competitions = await getData(`${process.env.SOCCER_COMPETITIONS_ENDPOINT}?id=1`);

    if (competitions instanceof Error ) {
      producer.send({
        topic: kafkaTopics.SOCCER_FIXTURE_LIST.topic,
        messages: [
          { value: JSON.stringify([]) }
        ]
      });

      return;
    }

    await Promise.all(competitions.map(async (c) => {

      const events = await getData(`${process.env.SOCCER_EVENTS_ENDPOINT}?sid=${c.competition.id}&sportid=1`);
      
      if (!events instanceof Error || events.length>0) {
        events.forEach((e) => {
          const currentDate = new Date();
            const eventOpenDate = new Date(e.event.openDate);
            const timeDifference = eventOpenDate.getTime() - currentDate.getTime();
            const daysDifference = timeDifference / (1000 * 3600 * 24);
            
            if (daysDifference <= 4  && daysDifference >= -2 ) {
                eventHolder[e.event.id] = e.event;
                // console.log('days diffr',daysDifference);
            }
        });}
    }));



    for (let key in eventHolder) {
      const marketids = await getData(`${process.env.SOCCER_EVENTS_MARKET}?EventID=${key}&sportid=1`);
      if (marketids instanceof Error || !(marketids instanceof Array) || !Array.isArray(marketids) || marketids.length === 0){
        continue
      }
      

      marketids.filter(e => e.marketName === 'Match Odds').forEach(e => {
 
        
        eventHolder[key]['market_id'] = e.marketId;
        eventHolder[key]['runner'] = e.runners.map(runner => ({
          selectionId: runner.selectionId,
          runnerName: runner.runnerName,
        
      
      }));
      });

      const odds = await getData(`${process.env.SOCCER_MARKET_ENDPOINT}?market_id=${eventHolder[key]['market_id']}&sportid=1`);
      // console.log('inplay',JSON.stringify(odds))

      if (!Array.isArray(odds) || odds instanceof Error || !(odds instanceof Array || odds.length === 0) || !odds[0]) {
        // console.error('No data received for odds',eventHolder[key]['market_id'],eventHolder[key]['runner']);
        continue;
        
    } 
   
      else {
        eventHolder[key]['inplay'] = odds[0].inplay;
        eventHolder[key]['status'] = odds[0].status;
        eventHolder[key]['odds'] = odds[0];
        eventHolder[key]['market'] = 'MATCH_ODDS';
        eventHolder[key]['back1'] = (odds && odds[0] && odds[0]['runners'] && odds[0]['runners'][0] && odds[0]['runners'][0]['ex'] && odds[0]['runners'][0]['ex']['availableToBack'] && odds[0]['runners'][0]['ex']['availableToBack'][0] && odds[0]['runners'][0]['ex']['availableToBack'][0]['price']) ? odds[0]['runners'][0]['ex']['availableToBack'][0]['price'] : null;

        eventHolder[key]['lay1'] = (odds && odds[0] && odds[0]['runners'] && odds[0]['runners'][0] && odds[0]['runners'][0]['ex'] && odds[0]['runners'][0]['ex']['availableToLay'] && odds[0]['runners'][0]['ex']['availableToLay'][0] && odds[0]['runners'][0]['ex']['availableToLay'][0]['price']) ? odds[0]['runners'][0]['ex']['availableToLay'][0]['price'] : null;
        
        eventHolder[key]['back11'] = (odds && odds[0] && odds[0]['runners'] && odds[0]['runners'][1] && odds[0]['runners'][1]['ex'] && odds[0]['runners'][1]['ex']['availableToBack'] && odds[0]['runners'][1]['ex']['availableToBack'][0] && odds[0]['runners'][1]['ex']['availableToBack'][0]['price']) ? odds[0]['runners'][1]['ex']['availableToBack'][0]['price'] : null;
        
        eventHolder[key]['lay11'] = (odds && odds[0] && odds[0]['runners'] && odds[0]['runners'][1] && odds[0]['runners'][1]['ex'] && odds[0]['runners'][1]['ex']['availableToLay'] && odds[0]['runners'][1]['ex']['availableToLay'][0] && odds[0]['runners'][1]['ex']['availableToLay'][0]['price']) ? odds[0]['runners'][1]['ex']['availableToLay'][0]['price'] : null;
        
        eventHolder[key]['back12'] = (odds && odds[0] && odds[0]['runners'] && odds[0]['runners'][2] && odds[0]['runners'][2]['ex'] && odds[0]['runners'][2]['ex']['availableToBack'] && odds[0]['runners'][2]['ex']['availableToBack'][0] && odds[0]['runners'][2]['ex']['availableToBack'][0]['price']) ? odds[0]['runners'][2]['ex']['availableToBack'][0]['price'] : null;
        
        eventHolder[key]['lay12'] = (odds && odds[0] && odds[0]['runners'] && odds[0]['runners'][2] && odds[0]['runners'][2]['ex'] && odds[0]['runners'][2]['ex']['availableToLay'] && odds[0]['runners'][2]['ex']['availableToLay'][0] && odds[0]['runners'][2]['ex']['availableToLay'][0]['price']) ? odds[0]['runners'][2]['ex']['availableToLay'][0]['price'] : null;
        
      }
    }

   

    producer.send({
      topic: kafkaTopics.SOCCER_FIXTURE_LIST.topic,
      messages: [
        { value: JSON.stringify(eventHolder) }
      ]
    });
      //  console.log(JSON.stringify(eventHolder))
    // const response = await getData(process.env.TENNIS_FIXTURES_ENDPOINT);
    // if (response instanceof Error || !(response instanceof Array)) {
    //   producer.send({
    //     topic: kafkaTopics.TENNIS_FIXTURE_LIST.topic,
    //     messages: [
    //       { value: JSON.stringify([]) }
    //     ]
    //   });

    //   return;
    // }

    // producer.send({
    //   topic: kafkaTopics.TENNIS_FIXTURE_LIST.topic,
    //   messages: [
    //     { value: JSON.stringify(response) }
    //   ]
    // });

    // const fixtureById = new Object();

    // response.forEach(fixture => fixtureById[fixture.gameId] = fixture);

    // const prevFixtures = [...this.fixtures];
    // const currFixtures = response.map(f => f.gameId);
    // const newFixtures = response.filter(f => prevFixtures.indexOf(f.gameId) === -1).map(f => f.gameId);

    // this.fixtures = [...prevFixtures.filter(id => currFixtures.indexOf(id) !== -1), ...newFixtures];

    // if (!this.marketIntervals[-1]) {
    //   this.marketIntervals[-1] = {};
    // }

    // for (const [id] of Object.entries(this.marketIntervals[-1])) {
    //   if (currFixtures.indexOf(id) === -1) {
    //     clearInterval(this.marketIntervals[-1][id]);
    //     delete this.marketIntervals[-1][id];
    //   }
    // }

    // if (newFixtures.length) {
    //   this.fixtureEmitter.emit('data', newFixtures.map(id => ({ gameId: id, marketId: fixtureById[id].marketId })));
    // }
  }

  async competitionHandler(producer) {
    const response = await getData(`${process.env.SOCCER_COMPETITIONS_ENDPOINT}?id=1`);
    if (response instanceof Error) {
      producer.send({
        topic: kafkaTopics.SOCCER_COMPETITION_LIST.topic,
        messages: [
          { value: JSON.stringify([]) }
        ]
      });
    }
    const competitions = response;
   

    producer.send({
      topic: kafkaTopics.SOCCER_COMPETITION_LIST.topic,
      messages: [
        { value: JSON.stringify(competitions) }
      ]
    });

    const prevCompetitions = [...this.competitions];
    const currCompetitions = competitions.map(c => c.competition.id);
    const newCompetitions = competitions.filter(c => prevCompetitions.indexOf(c.competition.id) === -1).map(c => c.competition.id);

    this.competitions = [...prevCompetitions.filter(c => currCompetitions.indexOf(c) !== -1), ...newCompetitions];

    for (const [competitionId] of Object.entries(this.eventIntervals)) {
      if (currCompetitions.indexOf(competitionId) === -1) {
        if (this.marketIntervals[competitionId]) {
          for (const [, interval] of Object.entries(this.marketIntervals[competitionId])) {
            clearInterval(interval);
          }
        }
        clearInterval(this.eventIntervals[competitionId]);
        delete this.eventIntervals[competitionId];
        delete this.marketIntervals[competitionId];
        delete this.bmIntervals[competitionId];
      }
    }

    if (newCompetitions.length) {
      this.competitionEmitter.emit('data', newCompetitions);
    }
  }

  async eventHandler(producer, competitionId) {
    const response = await getData(`${process.env.SOCCER_EVENTS_ENDPOINT}?sid=${competitionId}&sportid=1`);

    if (response instanceof Error) {
      producer.send({
        topic: kafkaTopics.SOCCER_EVENT_LIST.topic,
        messages: [
          { value: JSON.stringify({ competitionId, events: [] }) }
        ]
      });

      return;
    }

    const events = response;

    producer.send({
      topic: kafkaTopics.SOCCER_EVENT_LIST.topic,
      messages: [
        { value: JSON.stringify({ competitionId, events }) }
      ]
    });

    if (!this.events[competitionId]) {
      this.events[competitionId] = [];
    }

    const eventById = new Object();

    events.forEach(e => eventById[e.event.id] = e);

    const prevEvents = [...this.events[competitionId]];
    const currEvents = events.map(e => e.event.id);
    const newEvents = events.filter(e => prevEvents.indexOf(e.event.id) === -1).map(e => e.event.id);

    this.events[competitionId] = [...prevEvents.filter(e => currEvents.indexOf(e) !== -1), ...newEvents];

    if (!this.marketIntervals[competitionId]) {
      this.marketIntervals[competitionId] = new Object();
    }

    const marketIntervals = this.marketIntervals[competitionId];

    for (const [eventId] of Object.entries(marketIntervals)) {
      if (currEvents.indexOf(eventId) === -1) {
        clearInterval(marketIntervals[eventId]);
        delete marketIntervals[eventId];
      }
    }
    // console.log('newwww',JSON.stringify(eventById));
    if (newEvents.length) {
      this.eventEmitter.emit('data', competitionId, newEvents.map(id => ({
        eventId: id,


        competitionId,
        event: eventById[id].event.name
      })));
    }
  }

  async marketHandler(producer, competitionId, eventId, event) {
    // console.log('eventId',event);
    const response = await getData(`${process.env.SOCCER_EVENTS_MARKET}?EventID=${eventId}&sportid=1`);
    // console.log('eventId',event,JSON.stringify(response));
    if (response instanceof Error || !(response instanceof Array) || !Array.isArray(response) || response.length === 0) {
      producer.send({
        topic: kafkaTopics.SOCCER_MARKET_CATALOGUE.topic,
        messages: [
          {
            value: JSON.stringify({ eventId, marketCatalogue: [] })
          }
        ]
      });
      return;
    }

    const filteredMarkets = response.filter(market =>
     market.marketName === 'Over/Under 2.5 Goals' ||
     market.marketName === 'Over/Under 3.5 Goals' ||
      market.marketName === 'Match Odds' ||
      market.marketName === 'Over/Under 1.5 Goals'
    );


    // console.log('newwww',JSON.stringify(filteredMarkets));
    const marketIds = {};

    for (const market of filteredMarkets) {
      const runners = market.runners.reduce((runnersObj, runner) => {
        runnersObj[runner.selectionId] = runner.runnerName;
        return runnersObj;
      }, {});

      marketIds[market.marketId] = { market: market.marketName, runners };
    }
    // console.log('runners',marketIds);
    // const marketIds = filteredMarkets.map(market => market.marketId);

    // console.log('newwww',JSON.stringify(filteredMarkets));

    for (const marketId in marketIds) {
      if (Object.hasOwnProperty.call(marketIds, marketId)) {
        const response = await getData(`${process.env.SOCCER_MARKET_ENDPOINT}?market_id=${marketId}&sportid=1`);

        if (response instanceof Error || !(response instanceof Array) || !Array.isArray(response) || response.length === 0) {

          continue;
        }
        if (!this.markets[competitionId]) {
          this.markets[competitionId] = new Object();
        }

        if (!this.markets[competitionId][eventId]) {
          this.markets[competitionId][eventId] = [];
        }

        const marketCatalogue = response;
        const { market: marketName, runners } = marketIds[marketId];
        if (marketName === 'Match Odds') {
          producer.send({

            topic: kafkaTopics.SOCCER_MARKET_CATALOGUE.topic,
            messages: [
              {
                value: JSON.stringify({
                  eventId,
                  market: 'MATCH_ODDS',
                  marketCatalogue: marketCatalogue.map(m => ({
                    ...m,

                    event,
                    eventId,
                    runners: m.runners.map(r => ({ ...r, runnerName: runners[r.selectionId] })),
                    market: 'MATCH_ODDS',

                    gameType: 'match'
                  }))
                })
              }
            ]
          });
        }
        // console.log('newwww',JSON.stringify(marketCatalogue));
        else {
          // console.log('newwww222222222',JSON.stringify(marketCatalogue));

          producer.send({

            topic: kafkaTopics.SOCCER_MARKET_CATALOGUE.topic,
            messages: [
              {
                value: JSON.stringify({
                  eventId,
                  market: marketName,
                  marketCatalogue: marketCatalogue.map(m => ({
                    ...m,

                    event,
                    eventId: eventId,
                    runners: m.runners.map(r => ({ ...r, runnerName: runners[r.selectionId] })),
                    market: marketName,
                    gameType: marketName
                  }))
                })
              }
            ]
          });
        }

        // console.log('cheack data',competitionId,eventId,marketCatalogue);
        this.handleShutDownMarketInterval(competitionId, eventId, marketCatalogue);

        const prevMarkets = [...this.markets[competitionId][eventId]];
        const currMarkets = marketCatalogue.map(m => m.marketId);
        const newMarkets = marketCatalogue.filter(m => prevMarkets.indexOf(m.marketId) === -1).map(m => m.marketId);

        this.markets[competitionId][eventId] = [...prevMarkets.filter(m => currMarkets.indexOf(m) !== -1), ...newMarkets];

        if (newMarkets.length) {
          this.marketEmitter.emit('data', eventId, newMarkets);
        }
      }
    }
  }



  async init(producer) {
   
    this.competitionHandler(producer);
    this.fixtureHandler(producer);
    setInterval(() => this.fixtureHandler(producer), 15000);
    setInterval(() => this.competitionHandler(producer), 300000);

    // this.fixtureEmitter.on('data', (fixtures) => {
    //   fixtures.forEach(fixture => {
    //     if (!this.marketIntervals[-1][fixture.gameId]) {
    //       this.marketHandler(producer, -1, fixture.gameId, fixture.marketId);
    //       this.marketIntervals[-1][fixture.gameId] = setInterval(() => this.marketHandler(producer, -1, fixture.gameId, fixture.marketId), 5000);
    //     }
    //   });
    // });

    this.competitionEmitter.on('data', (competitions) => {
      competitions.forEach(c => {
        if (!this.eventIntervals[c]) {
          this.eventHandler(producer, c);
          this.eventIntervals[c] = setInterval(() => this.eventHandler(producer, c), 300000);
        }
      });
    });

    this.eventEmitter.on('data', (competitionId, events) => {
      events.forEach(e => {
        if (!this.marketIntervals[competitionId][e.eventId]) {
          this.marketHandler(producer, competitionId, e.eventId, e.event);
          this.marketIntervals[competitionId][e] = setInterval(() => this.marketHandler(producer, competitionId, e.eventId, e.event), 5000);
        }
        // if (!this.bmIntervals[competitionId][e.eventId]) {
        //   this.bmHandler(producer, competitionId, e.eventId, e.marketId);
        //   this.bmIntervals[competitionId][e.eventId] = setInterval(() => this.bmHandler(producer, competitionId, e.eventId, e.marketId), 5000);
        // }
      });
    });

    this.marketEmitter.on('data', (eventId, markets) => {
      markets.map(market => {
        if (!this.marketResultIntervals[market]) {
          const interval = setInterval(async () => {
            const result = await getData(`${process.env.SOCCER_RESULT_ENDPOINT}?market_id=${market}&sportid=1`);
            // console.log('resultsoccer',JSON.stringify(result));
            if (result instanceof Error) {
              return;
            }
            if (result instanceof Array) {
              result.map(m => {
                if (m.status === 'CLOSED') {
                  m.runners.map(r => {
                    // console.debug(`Message emit ${kafkaTopics.SOCCER_MARKET_RESULT.topic}: ${JSON.stringify({ gameId: 1, eventId: Number(eventId), marketId: Number(m.marketId), selectionId: String(r.selectionId), market: 'MATCH_ODDS', gameType: 'match', status: r.status })}`);

                    if (m.marketName === 'Match Odds') {
                      producer.send({
                        topic: kafkaTopics.SOCCER_MARKET_RESULT.topic,
                        messages: [
                          { value: JSON.stringify({ gameId: 1, eventId: Number(eventId), marketId: String(m.marketId), selectionId: String(r.selectionId), market: 'MATCH_ODDS', gameType: 'match', status: r.status }) }
                        ]
                      });
                    }
                    else {
                      producer.send({
                        topic: kafkaTopics.CRICKET_MARKET_RESULT.topic,
                        messages: [
                          { value: JSON.stringify({ gameId: 1, eventId: Number(eventId), marketId: String(m.marketId), selectionId: String(r.selectionId), market: m.marketName, gameType: m.marketName, status: r.status }) }
                        ]
                      });
                    }
                  });

                  clearInterval(this.marketResultIntervals[market]);
                  delete this.marketResultIntervals[market];
                }
              });
            }
          }, 20000);

          this.marketResultIntervals[market] = interval;
        }
      });
    });
  }
}

module.exports = Soccer;
