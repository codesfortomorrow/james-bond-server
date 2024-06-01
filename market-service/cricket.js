/* eslint-disable @typescript-eslint/no-unused-vars */
/* eslint-disable @typescript-eslint/no-var-requires */
/* eslint-disable no-sparse-arrays */

const EventEmitter = require('events');
const { getData } = require('./utils/request');
const kafkaTopics = require('./utils/kafkaTopics');
const { Console, log } = require('console');


class Cricket {
  eventEmitter = new EventEmitter();
  marketEmitter = new EventEmitter();
  competitionEmitter = new EventEmitter();
  fixtureEmitter = new EventEmitter();
  fixtures = [];
  competitions = [];
  eventList = [];
  eventmarket = [];
  events = new Object();
  markets = new Object();
  timelines = new Object();
  sessions = new Object();
  sessionsResultData = new Object();
  eventIntervals = new Object();
  marketIntervals = new Object();
  sessionIntervals = new Object();
  bmIntervals = new Object();
  timelineIntervals = new Object();
  marketResultIntervals = new Object();
  marketSessionsResultDataIntervals = new Object();
  marketSessionsResultIntervals = new Object();
  eventfixtureHolder = {};

  handleShutDownMarketInterval(competitionId, eventId, marketCatalogue) {
    if (marketCatalogue[0]?.status === 'CLOSED') {
      clearInterval(this.marketIntervals[competitionId][eventId]);
      delete this.marketIntervals[competitionId][eventId];

      clearInterval(this.sessionIntervals[competitionId][eventId]);
      delete this.sessionIntervals[competitionId][eventId];

      clearInterval(this.bmIntervals[competitionId][eventId]);
      delete this.bmIntervals[competitionId][eventId];

      clearInterval(this.timelineIntervals[competitionId][eventId]);
      delete this.timelineIntervals[competitionId][eventId];

      clearInterval(this.marketSessionsResultDataIntervals[competitionId][eventId]);
      delete this.marketSessionsResultDataIntervals[competitionId][eventId];
    }
  }

  async fetchTimelineData(competitionId, eventId) {
    try {

      const fetchScoreUrlResponse = await getData(`${process.env.CRICKET_TIMELINE_ENDPOINT}?eventid=${eventId}`);
     
      if (fetchScoreUrlResponse && fetchScoreUrlResponse.length > 0) {
       
      
      // console.log('fatch timeline',JSON.stringify(fetchScoreUrlResponse))
      if (fetchScoreUrlResponse.score !== '') {
        // const response = await getData(fetchScoreUrlResponse);
        //  console.log('response',JSON.stringify(response))
        const response = fetchScoreUrlResponse[0];
        // console.log('response',JSON.stringify(response))
        const events = response.stateOfBall;
        const score =response.score;
        
       
       

           

          

          if (!this.timelines[competitionId]) {
            this.timelines[competitionId] = new Object();
          }
          // console.log('herere evebet',events);
          this.timelines[competitionId][eventId] = {
            recentBalls: events,
            score: score
          };
        

      }}
    } catch (err) {
      console.error(err);
    }
  }
  async fetchSessionResultData(competitionId, eventId) {
    try {
      const sessionsResultData = await getData(`${process.env.CRICKET_SESSION_RESULT_ENDPOINT}?eventId=${eventId}`);

      if (sessionsResultData instanceof Array) {
        if (!this.sessionsResultData[competitionId]) {
          this.sessionsResultData[competitionId] = new Object();
        }

        this.sessionsResultData[competitionId][eventId] = sessionsResultData;
      }
    } catch (err) {
      console.error(err);
    }
  }

  async fixtureHandler(producer, competition) {
    const eventHolder = {};
    // console.log('comptition',competition)
    const competitions = await getData(`${process.env.SOCCER_COMPETITIONS_ENDPOINT}?id=4`);


    if (competitions instanceof Error || !(competitions instanceof Array)) {
      producer.send({
        topic: kafkaTopics.CRICKET_FIXTURE_LIST.topic,
        messages: [
          { value: JSON.stringify([]) }
        ]
      });

      return;
    }

    await Promise.all(competitions.map(async (c) => {
      const events = await getData(`${process.env.CRICKET_EVENTS_ENDPOINT}?sid=${c.competition.id}&sportid=4`);
      if (!events instanceof Error || events.length > 0) {
        events.forEach((e) => {
          const currentDate = new Date();
          const eventOpenDate = new Date(e.event.openDate);
          const timeDifference = eventOpenDate.getTime() - currentDate.getTime();
          const daysDifference = timeDifference / (1000 * 3600 * 24);

          if (daysDifference <= 4 && daysDifference >= -5) {
            eventHolder[e.event.id] = e.event;
          }
        });
      }
    }));

    // console.log('evnt',eventHolder)

    for (let key in eventHolder) {

      const marketids = await getData(`${process.env.CRICKET_EVENTS_MARKET}?EventID=${key}&sportid=4`);
      // console.log('evnt',JSON.stringify(marketids),key,`${process.env.CRICKET_EVENTS_MARKET}?EventID=${key}&sportid=4`)

      if (marketids == null || marketids.length <= 0 || !Array.isArray(marketids) || marketids.length === 0)
        continue;

      marketids.filter(e => e.marketName === 'Match Odds').forEach(e => {
      
        eventHolder[key]['runner'] = e.runners.map(runner => ({
          selectionId: runner.selectionId,
          runnerName: runner.runnerName,

        }));
        eventHolder[key]['market_id'] = e.marketId;
      
      });
      // console.log('evnt',JSON.stringify(marketids))
      const session = await getData(`${process.env.CRICKET_MARKET_SESSION_ENDPOINT}?eventid=${key}&sportid=4`);
      if (session == null && session.length < 0 && !Array.isArray(session) && session.length == 0) {
        continue;
       
      }

      session.filter(e => e.gtype === 'session').forEach(e => {
        eventHolder[key]['session'] = e;

      });


     
      const odds = await getData(`${process.env.CRICKET_MARKET_ENDPOINT}?market_id=${eventHolder[key]['market_id']}&sportid=4`);
    //  if (eventHolder[key]['market_id'] === "1.229453913"){
      // console.log('evnt',JSON.stringify(odds),`${process.env.CRICKET_MARKET_ENDPOINT}?market_id=${eventHolder[key]['market_id']}&sportid=4`)
    //  }
      if (!Array.isArray(odds) || odds instanceof Error || !(odds instanceof Array || odds.length === 0) || !odds[0]) {
        console.error('No data received for odds cricket',eventHolder[key]['market_id']);
        continue;
      }
    
      else {
        eventHolder[key]['inplay'] = odds[0].inplay;
        eventHolder[key]['status'] = odds[0].status;
        eventHolder[key]['odds'] = odds[0];
        eventHolder[key]['market'] = 'Match Odds';

        eventHolder[key]['back1'] = (odds && odds[0] && odds[0]['runners'] && odds[0]['runners'][0] && odds[0]['runners'][0]['ex'] && odds[0]['runners'][0]['ex']['availableToBack'] && odds[0]['runners'][0]['ex']['availableToBack'][0] && odds[0]['runners'][0]['ex']['availableToBack'][0]['price']) ? odds[0]['runners'][0]['ex']['availableToBack'][0]['price'] : null;

        eventHolder[key]['lay1'] = (odds && odds[0] && odds[0]['runners'] && odds[0]['runners'][0] && odds[0]['runners'][0]['ex'] && odds[0]['runners'][0]['ex']['availableToLay'] && odds[0]['runners'][0]['ex']['availableToLay'][0] && odds[0]['runners'][0]['ex']['availableToLay'][0]['price']) ? odds[0]['runners'][0]['ex']['availableToLay'][0]['price'] : null;
        
        eventHolder[key]['back11'] = (odds && odds[0] && odds[0]['runners'] && odds[0]['runners'][1] && odds[0]['runners'][1]['ex'] && odds[0]['runners'][1]['ex']['availableToBack'] && odds[0]['runners'][1]['ex']['availableToBack'][0] && odds[0]['runners'][1]['ex']['availableToBack'][0]['price']) ? odds[0]['runners'][1]['ex']['availableToBack'][0]['price'] : null;
        
        eventHolder[key]['lay11'] = (odds && odds[0] && odds[0]['runners'] && odds[0]['runners'][1] && odds[0]['runners'][1]['ex'] && odds[0]['runners'][1]['ex']['availableToLay'] && odds[0]['runners'][1]['ex']['availableToLay'][0] && odds[0]['runners'][1]['ex']['availableToLay'][0]['price']) ? odds[0]['runners'][1]['ex']['availableToLay'][0]['price'] : null;
        
        eventHolder[key]['back12'] = (odds && odds[0] && odds[0]['runners'] && odds[0]['runners'][2] && odds[0]['runners'][2]['ex'] && odds[0]['runners'][2]['ex']['availableToBack'] && odds[0]['runners'][2]['ex']['availableToBack'][0] && odds[0]['runners'][2]['ex']['availableToBack'][0]['price']) ? odds[0]['runners'][2]['ex']['availableToBack'][0]['price'] : null;
        
        eventHolder[key]['lay12'] = (odds && odds[0] && odds[0]['runners'] && odds[0]['runners'][2] && odds[0]['runners'][2]['ex'] && odds[0]['runners'][2]['ex']['availableToLay'] && odds[0]['runners'][2]['ex']['availableToLay'][0] && odds[0]['runners'][2]['ex']['availableToLay'][0]['price']) ? odds[0]['runners'][2]['ex']['availableToLay'][0]['price'] : null;
        
      }
      // console.log("sdddddd",JSON.stringify(eventHolder))
    }

    producer.send({
      topic: kafkaTopics.CRICKET_FIXTURE_LIST.topic,
      messages: [
        { value: JSON.stringify(eventHolder) }
      ]
    });
    //  console.log(JSON.stringify(eventHolder),'qqqqqqqqqqqq')

    const fixtureById = new Object();
    
    Object.values(eventHolder).forEach(fixture => {
    
      fixtureById[fixture.id] = fixture;
    });
    
    const prevFixtures = [...this.fixtures];
    const currFixtures = Object.keys(fixtureById);
    const newFixtures = currFixtures.filter(id => !prevFixtures.includes(id));
    
    this.fixtures = [...prevFixtures.filter(id => currFixtures.includes(id)), ...newFixtures];
    
    if (!this.marketIntervals[-1]) {
      this.marketIntervals[-1] = {};
    }
    
    if (!this.sessionIntervals[-1]) {
      this.sessionIntervals[-1] = {};
    }
    
    if (!this.bmIntervals[-1]) {
      this.bmIntervals[-1] = {};
    }
    
    if (!this.timelineIntervals[-1]) {
      this.timelineIntervals[-1] = {};
    }
    
    for (const [id] of Object.entries(this.marketIntervals[-1])) {
      if (!currFixtures.includes(id)) {
        clearInterval(this.marketIntervals[-1][id]);
        delete this.marketIntervals[-1][id];
      }
    }
    
    for (const [id] of Object.entries(this.sessionIntervals[-1])) {
      if (!currFixtures.includes(id)) {
        clearInterval(this.sessionIntervals[-1][id]);
        delete this.sessionIntervals[-1][id];
      }
    }
    
    for (const [id] of Object.entries(this.bmIntervals[-1])) {
      if (!currFixtures.includes(id)) {
        clearInterval(this.bmIntervals[-1][id]);
        delete this.bmIntervals[-1][id];
      }
    }
    
    for (const [id] of Object.entries(this.timelineIntervals[-1])) {
      if (!currFixtures.includes(id)) {
        clearInterval(this.timelineIntervals[-1][id]);
        delete this.timelineIntervals[-1][id];
      }
    }
    
    // if (newFixtures.length) {
    //   this.fixtureEmitter.emit('data', newFixtures.map(id => ({ gameId: id, marketId: fixtureById[id].marketId })));
    // }
    
  }

  async competitionHandler(producer) {

    const response = await getData(`${process.env.SOCCER_COMPETITIONS_ENDPOINT}?id=4`);
    let competitions;
    // console.log('respose',response);

    if (response instanceof Error || !Array.isArray(response) || response.length === 0) {
      // sleep 
      await new Promise(resolve => setTimeout(resolve, 5000));
      return await this.competitionHandler(producer);

    } else {
      competitions = response;
      this.competitions = response;
    }

    producer.send({
      topic: kafkaTopics.CRICKET_COMPETITION_LIST.topic,
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
          delete this.sessionIntervals[competitionId];
          delete this.marketIntervals[competitionId];
          delete this.bmIntervals[competitionId];
          delete this.markets[competitionId];
          delete this.sessions[competitionId];
        }

        if (this.marketSessionsResultDataIntervals[competitionId]) {
          for (const [, interval] of Object.entries(this.marketSessionsResultDataIntervals[competitionId])) {
            clearInterval(interval);
          }
          delete this.marketSessionsResultDataIntervals[competitionId];
          delete this.sessionsResultData[competitionId];
        }

        if (this.timelineIntervals[competitionId]) {
          for (const [, interval] of Object.entries(this.timelineIntervals[competitionId])) {
            clearInterval(interval);
          }
          delete this.timelineIntervals[competitionId];
          delete this.timelines[competitionId];
        }

        clearInterval(this.eventIntervals[competitionId]);
        delete this.eventIntervals[competitionId];
        delete this.events[competitionId];
      }
    }

    if (newCompetitions.length) {
      this.competitionEmitter.emit('data', newCompetitions);
    }
  }

  async eventHandler(producer, competitionId) {


    const _response = await getData(`${process.env.CRICKET_EVENTS_ENDPOINT}?sid=${competitionId}&sportid=4`);


    if (_response instanceof Error || !Array.isArray(_response) || _response.length === 0) {

      // producer.send({
      //     topic: kafkaTopics.CRICKET_EVENT_LIST.topic,
      //     messages: [
      //         { value: JSON.stringify({ competitionId, events: [] }) }
      //     ]
      // });

      await new Promise(resolve => setTimeout(resolve, 5000));
      return await this.eventHandler(producer, competitionId);
    }
    // _response.forEach((e) => { this.eventfixtureHolder[e.event.id] = e.event; });
    this.eventList = _response;
    let events = [];
    const eventById = new Object();
    const allEvents = [];
    // _response.forEach(async (r) => {
    //     let _eventId = r.event.id;

    //     const response = await getData(`${process.env.CRICKET_EVENTS_MARKET}?EventID=${_eventId}&sportid=4`);

    //     if (response instanceof Error || !Array.isArray(response)||response.length===0){
    //       producer.send({
    //         topic: kafkaTopics.CRICKET_EVENT_LIST.topic,
    //         messages: [
    //             { value: JSON.stringify({ competitionId, events: this.eventmarket }) }
    //         ]
    //     });
    //     }

    //     if (Array.isArray(response) && response.length > 0) {
    //         response.filter(e => e.marketName === 'Match Odds').forEach(e => {
    //             e.event = r.event;
    //             eventById[_eventId] = e;
    //             this.eventfixtureHolder[r.event.id] = matchOdds.marketId;
    //             if (!allEvents.some(ev => ev.marketId === e.marketId)) {
    //               allEvents.push(e); 
    //           }
    //         });
    //         events = Object.values(eventById);
    //         this.eventmarket=allEvents;

    //     }


    // })
    // producer.send({
    //     topic: kafkaTopics.CRICKET_EVENT_LIST.topic,
    //     messages: [
    //         { value: JSON.stringify({ competitionId, events: allEvents }) }
    //     ]
    // });
    for (const r of _response) {
      const _eventId = r.event.id;

      try {
        const response = await getData(`${process.env.CRICKET_EVENTS_MARKET}?EventID=${_eventId}&sportid=4`);

        if (response instanceof Error || !Array.isArray(response) || response.length === 0) {
          producer.send({
            topic: kafkaTopics.CRICKET_EVENT_LIST.topic,
            messages: [
              { value: JSON.stringify({ competitionId, events: this.eventmarket }) }
            ]
          });
        }

        if (Array.isArray(response) && response.length > 0) {
          response.filter(e => e.marketName === 'Match Odds' || e.marketName === 'Winner').forEach(e => {
            e.event = r.event;
            eventById[_eventId] = e;

            if (!allEvents.some(ev => ev.marketId === e.marketId)) {
              allEvents.push(e);
            }
          });
          events = Object.values(eventById);
          this.eventmarket = allEvents;

        };
      } catch (error) {
        // Handle error
        console.error('Error fetching market data:', error);
      }
    }


    producer.send({
      topic: kafkaTopics.CRICKET_EVENT_LIST.topic,
      messages: [
        { value: JSON.stringify({ competitionId, events: allEvents }) }
      ]
    });

    if (!this.events[competitionId]) {
      this.events[competitionId] = [];
    }

    const prevEvents = [...this.events[competitionId]];
    const currEvents = events.map(e => e.event.id);
    const newEvents = events.filter(e => prevEvents.indexOf(e.event.id) === -1).map(e => e.event.id);

    this.events[competitionId] = [...prevEvents.filter(e => currEvents.indexOf(e) !== -1), ...newEvents];

    if (!this.marketIntervals[competitionId]) {
      this.marketIntervals[competitionId] = new Object();
    }

    if (!this.sessionIntervals[competitionId]) {
      this.sessionIntervals[competitionId] = new Object();
    }

    if (!this.bmIntervals[competitionId]) {
      this.bmIntervals[competitionId] = new Object();
    }

    if (!this.marketSessionsResultDataIntervals[competitionId]) {
      this.marketSessionsResultDataIntervals[competitionId] = new Object();
    }

    if (!this.timelineIntervals[competitionId]) {
      this.timelineIntervals[competitionId] = new Object();
    }

    const marketIntervals = this.marketIntervals[competitionId];

    const sessionIntervals = this.sessionIntervals[competitionId];
    const bmIntervals = this.sessionIntervals[competitionId];

    for (const [eventId] of Object.entries(marketIntervals)) {

      if (currEvents.indexOf(eventId) === -1) {
        clearInterval(marketIntervals[eventId]);
        delete marketIntervals[eventId];

        clearInterval(sessionIntervals[eventId]);
        delete sessionIntervals[eventId];
        clearInterval(bmIntervals[eventId]);
        delete bmIntervals[eventId];
        (this.markets[competitionId] && this.markets[competitionId][eventId]) ? delete this.markets[competitionId][eventId] : '';
        (this.sessions[competitionId]) && this.sessions[competitionId][eventId] ? delete this.sessions[competitionId][eventId] : '';

      }
    }

    const marketSessionsResultDataIntervals = this.marketSessionsResultDataIntervals[competitionId];

    for (const [eventId] of Object.entries(marketSessionsResultDataIntervals)) {
      if (currEvents.indexOf(eventId) === -1) {
        clearInterval(marketSessionsResultDataIntervals[eventId]);
        delete marketSessionsResultDataIntervals[eventId];
        delete this.sessionsResultData[competitionId][eventId];
      }
    }

    const timelineIntervals = this.timelineIntervals[competitionId];

    for (const [eventId] of Object.entries(timelineIntervals)) {
      if (currEvents.indexOf(eventId) === -1) {
        clearInterval(timelineIntervals[eventId]);
        delete timelineIntervals[eventId];
        delete this.timelines[competitionId][eventId];
      }
    }

    if (newEvents.length) {
      this.eventEmitter.emit('data', competitionId, newEvents.map(id => ({ eventId: id, marketId: eventById[id].marketId, sidMap: eventById[id].runners.reduce((obj, cur) => ({ ...obj, [cur.selectionId]: cur.runnerName }), {}) })));
    }
  };



  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  async marketHandler(producer, competitionId, eventId, marketId, sidMap, _e) {

    const response = await getData(`${process.env.CRICKET_MARKET_ENDPOINT}?market_id=${marketId}&sportid=4`);


    //  console.log("sidddmap",sidMap)
    if (response instanceof Error || !(response instanceof Array) || response.length === 0) {

      producer.send({
        topic: kafkaTopics.CRICKET_MARKET_CATALOGUE.topic,
        messages: [
          {
            value: JSON.stringify({ eventId, marketCatalogue: { eventId, marketId, sidMap, catalogue: []} })
          }
        ]
      });
      return;
    }
    const marketCatalogue = response;
    // const whitelistMarkets = ['match', 'match1', 'match2', 'fancy1', , 'odds'];

    // const marketCatalogue = response.filter(m => { return whitelistMarkets.includes(m.gtype) || whitelistMarkets.includes(m.markettype.toLowerCase()); });
    //   function addRunnerNames(marketCatalogue, runnerNames) {
    //     for (const markets of marketCatalogue) {
    //     markets.market= 'Match Odds';
    //         for (const runnerN of markets.runners) {
    //             const runner = runnerNames[runnerN.selectionId];
    //             if (runner) {
    //                 runnerN.runnerName = runner;
    //             }
    //         }
    //     }
    // }

    // addRunnerNames(marketCatalogue,sidMap);

    // console.log(JSON.stringify(marketCatalogue),"res22222pose");

    if (!this.markets[competitionId]) {
      this.markets[competitionId] = new Object();
    }

    if (!this.markets[competitionId][eventId]) {
      this.markets[competitionId][eventId] = [];
    }

    if (!this.timelines[competitionId]) {
      this.timelines[competitionId] = new Object();
    }

    if (!this.timelines[competitionId][eventId]) {
      this.timelines[competitionId][eventId] = new Object();
    }

    if (!this.sessionsResultData[competitionId]) {
      this.sessionsResultData[competitionId] = new Object();
    }

    if (!this.sessionsResultData[competitionId][eventId]) {
      this.sessionsResultData[competitionId][eventId] = new Object();
    }

    producer.send({
      topic: kafkaTopics.CRICKET_MARKET_CATALOGUE.topic,
      messages: [
        {
          value: JSON.stringify({
            eventId, market: 'Match Odds', marketCatalogue: {
              eventId, marketId, market: 'Match Odds', sidMap, catalogue: marketCatalogue.map(m => ({
                ...m,

                eventid: eventId,
                runners: m.runners.map(r => ({ ...r, runnerName: sidMap[r.selectionId] })),
                market: 'Match Odds'
              })), 
            }
          })
        }
      ]
    });

    this.handleShutDownMarketInterval(competitionId, eventId, marketCatalogue);


    const marketByID = new Object();

    marketCatalogue.forEach(market => marketByID[market.marketId] = market);

    const prevMarkets = [...this.markets[competitionId][eventId]];
    const currMarkets = marketCatalogue.map(m => m.marketId);
    const newMarkets = marketCatalogue.filter(m => prevMarkets.indexOf(m.marketId) === -1).map(m => m.marketId);


    this.markets[competitionId][eventId] = [...prevMarkets.filter(m => currMarkets.indexOf(m) !== -1), ...newMarkets];

    if (newMarkets.length) {
      this.marketEmitter.emit('markets', eventId, marketId, newMarkets);
    }

    // // Handle fancy1 Market Result 
    // if (!this.sessions[competitionId]) {
    //   this.sessions[competitionId] = new Object();
    // }

    // if (!this.sessions[competitionId][eventId]) {
    //   this.sessions[competitionId][eventId] = [];
    // }

    // let sessions = [];

    // const fancyMarkets = marketCatalogue.filter(m => m.gtype === 'fancy1');

    // if (fancyMarkets.length === 1) {
    //   sessions = [...fancyMarkets[0].section.map(i => ({ ...i, mname: fancyMarkets[0].mname }))];
    // } else if (fancyMarkets.length >= 2) {
    //   const _fancyMarkets = fancyMarkets.map(m => ({ ...m, section: m.section.map(i => ({ ...i, mname: m.mname })) }));
    //   console.log("fghdghdfhdgfhgdfhgdhgfhdgfhgdfh...............", _fancyMarkets);
    //   _fancyMarkets.forEach(m => sessions.push(...m.section));
    // }

    // const prevSessions = [...this.sessions[competitionId][eventId]];
    // const currSessions = sessions.map(s => s.sid);
    // const newSessions = currSessions.filter(s => prevSessions.indexOf(s) === -1);

    // this.sessions[competitionId][eventId] = [...prevSessions.filter(s => currSessions.indexOf(s) !== -1), ...newSessions];

    // const sessionByID = new Object();

    // sessions.forEach(session => sessionByID[session.sid] = session);

    // if (newSessions.length) {
    //   this.marketEmitter.emit('sessions', competitionId, eventId, marketId, newSessions.map(i => ({ sid: i, mname: sessionByID[i].mname, gtype: 'fancy1' })));
    // }
  }
  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  async bmHandler(producer, competitionId, eventId, marketId, sidMap, e) {

    const response = await getData(`${process.env.CRICKET_MARKET_BMLIST_ENDPOINT}?EventID=${eventId}&sportid=4`);
    // console.log("resp",JSON.stringify(response));
    const bookmakerdata = {};

    if (response instanceof Error || !(response instanceof Array)) {
      producer.send({
        topic: kafkaTopics.CRICKET_MARKET_CATALOGUE.topic,
        messages: [
          {
            value: JSON.stringify({ eventId, marketCatalogue: { eventId, marketId, sidMap, catalogue: [] } })
          }
        ]
      });
      return;
    }


    const bookmakerMarketIDs = response.filter(m => { return m.marketName.toLowerCase() === 'bookmaker'; });
    let bmMarketOdds = [];
    for (let bmMarkets of bookmakerMarketIDs) {

      const responseRunners = await getData(`${process.env.CRICKET_MARKET_BMLIST_RUNNERS_ENDPOINT}?MarketID=${bmMarkets.marketId}&sportid=4`);
  //  console.log("resp",JSON.stringify(responseRunners),bmMarkets.marketId);
      if (responseRunners instanceof Error || !(responseRunners instanceof Array)) {
        continue;
      }
      bmMarketOdds.push(responseRunners);
    }
    // console.log("resp",JSON.stringify(bmMarketOdds));
    const bmCatalogue = bmMarketOdds.flatMap(array => array);

    if (!this.sessionsResultData[competitionId]) {
      this.sessionsResultData[competitionId] = new Object();
    }

    if (!this.sessionsResultData[competitionId][eventId]) {
      this.sessionsResultData[competitionId][eventId] = new Object();
    }


    let marketCatalogue = { eventId, market: 'bookmaker', marketId, sidMap: {}, catalogue: [{ eventid: eventId, marketId: `${eventId}_bm`, market: 'bookmaker', runners: bmCatalogue }]};

    producer.send({
      topic: kafkaTopics.CRICKET_MARKET_CATALOGUE.topic,
      messages: [
        {
          value: JSON.stringify({ eventId, marketCatalogue })
        }
      ]
    });

    this.handleShutDownMarketInterval(competitionId, eventId, marketCatalogue);
  }
  async sessionHandler(producer, competitionId, eventId, marketId) {

    const response = await getData(`${process.env.CRICKET_MARKET_SESSION_ENDPOINT}?eventid=${eventId}&sportid=4`);

    if (response instanceof Error || !(response instanceof Array)|| response.length === 0) {
      producer.send({
        topic: kafkaTopics.CRICKET_MARKET_CATALOGUE.topic,
        messages: [
          {
            value: JSON.stringify({ eventId, marketCatalogue: { eventId, marketId, sidMap: {}, catalogue: [], } })
          }
        ]
      });

      return;
    }


    const whitelistMarkets = ['fancy1', 'session'];
    // const marketCatalogue = response.filter(m => { return whitelistMarkets.includes(m.gtype) || whitelistMarkets.includes(m.markettype.toLowerCase()); });
    const marketCatalogue = response.filter(m => { return whitelistMarkets.includes(m.gtype); });
    const fancyDataCatalogue = response.filter(item => item.gtype == 'fancy1');
    const sessionDataCatalogue = response.filter(item => item.gtype === 'session');



    if (!this.markets[competitionId]) {
      this.markets[competitionId] = new Object();
    }

    if (!this.markets[competitionId][eventId]) {
      this.markets[competitionId][eventId] = [];
    }

    if (!this.timelines[competitionId]) {
      this.timelines[competitionId] = new Object();
    }

    if (!this.timelines[competitionId][eventId]) {
      this.timelines[competitionId][eventId] = new Object();
    }

    if (!this.sessionsResultData[competitionId]) {
      this.sessionsResultData[competitionId] = new Object();
    }

    if (!this.sessionsResultData[competitionId][eventId]) {
      this.sessionsResultData[competitionId][eventId] = new Object();
    }

    producer.send({
      topic: kafkaTopics.CRICKET_MARKET_CATALOGUE.topic,
      messages: [
        {
          value: JSON.stringify({ eventId, market: 'fancy', marketCatalogue: { eventId, marketId, market: 'fancy', sidMap: {}, catalogue: [{ eventid: eventId, marketId: `${eventId}_fancy`, market: 'fancy', runners: fancyDataCatalogue }] } })
        }
      ]
    });
    producer.send({
      topic: kafkaTopics.CRICKET_MARKET_CATALOGUE.topic,
      messages: [
        {
          value: JSON.stringify({ eventId, market: 'session', marketCatalogue: { eventId, marketId, market: 'session', sidMap: {}, catalogue: [{ eventid: eventId, marketId: `${eventId}_session`, market: 'session', runners: sessionDataCatalogue }]} })
        }
      ]
    });

    this.handleShutDownMarketInterval(competitionId, eventId, fancyDataCatalogue);
    this.handleShutDownMarketInterval(competitionId, eventId, sessionDataCatalogue);



    // const marketByID = new Object();

    // marketCatalogue.forEach(market => marketByID[market.SelectionId] = market);

    // const prevMarkets = [...this.markets[competitionId][eventId]];
    // const currMarkets = marketCatalogue.filter(m => (m.gtype !== 'fancy1'||m.gtype !== 'session')).map(m => m.SelectionId);
    // const newMarkets = marketCatalogue.filter(m => prevMarkets.indexOf(m.mid) === -1 && m.gtype !== 'fancy1').map(m => m.mid);

    // this.markets[competitionId][eventId] = [...prevMarkets.filter(m => currMarkets.indexOf(m) !== -1), ...newMarkets];

    // if (newMarkets.length) {
    //   this.marketEmitter.emit('markets', eventId, marketId, newMarkets.map(m => ({ mname: marketByID[m].mname, gtype: marketByID[m].gtype })));
    // }

    // Handle fancy1 Market Result 
    if (!this.sessions[competitionId]) {
      this.sessions[competitionId] = new Object();
    }

    if (!this.sessions[competitionId][eventId]) {
      this.sessions[competitionId][eventId] = [];
    }

    let sessions = [];

    const fancyMarkets = marketCatalogue.filter(m => m.gtype === 'fancy1' || m.gtype === 'session');
    
   
    if (fancyMarkets.length === 1 && fancyMarkets[0].section) {
      sessions = [...fancyMarkets[0].section.map(i => ({ ...i, mname: fancyMarkets[0].RunnerName }))];
    } else if (fancyMarkets.length >= 2) {

      // const _fancyMarkets = fancyMarkets.map(m => {console.log('m',m);({ ...m, section: m.map(i => ({ ...i, mname: m.RunnerName })) })});
      // console.log("fghdghdfhdgfhgdfhgdhgfhdgfhgdfh...............", fancyMarkets);
      fancyMarkets.forEach(m => sessions.push({ ...m, mname: m.RunnerName }));
    }

    const prevSessions = [...this.sessions[competitionId][eventId]];
    const currSessions = sessions.map(s => s.SelectionId);
    const newSessions = currSessions.filter(s => prevSessions.indexOf(s) === -1);

    this.sessions[competitionId][eventId] = [...prevSessions.filter(s => currSessions.indexOf(s) !== -1), ...newSessions];

    const sessionByID = new Object();

    sessions.forEach(session => sessionByID[session.SelectionId] = session);
    

    if (newSessions.length) {
    
      this.marketEmitter.emit('sessions', competitionId, eventId, marketId, newSessions.map(i => ({ sid: i, mname: sessionByID[i].mname, gtype: 'fancy1' })));
    }
  }
  //     updateObj2WithSimilarityThreshold(obj1, obj2,eventId, similarityThreshold = 0.8) {
  //     // Convert obj1 to a Map for faster lookup
  //     const runnerMap = new Map();
  //     obj1.forEach(market => {
  //         market.runners.forEach(runner => {
  //             const normalizedRunnerName = normalizeRunnerName(runner.runnerName);
  //             runnerMap.set(normalizedRunnerName, runner.selectionId);
  //         });
  //     });

  //     // Update obj2 based on obj1 with similarity threshold
  //     obj2.forEach(market => {
  //         market.runners.forEach(runner => {
  //             const obj2RunnerName = normalizeRunnerName(runner.runnerName);
  //             let bestMatch = { similarity: 0, selectionId: undefined };

  //             obj1.forEach(obj1Market => {
  //                 obj1Market.runners.forEach(obj1Runner => {
  //                     const obj1RunnerName = normalizeRunnerName(obj1Runner.runnerName);
  //                     const similarity = jaccardSimilarity(obj1RunnerName, obj2RunnerName);
  //                     if (similarity >= similarityThreshold && similarity > bestMatch.similarity) {
  //                         bestMatch = { similarity, selectionId: obj1Runner.selectionId };
  //                     }
  //                 });
  //             });

  //             if (bestMatch.selectionId !== undefined) {
  //                 runner.selectionId = bestMatch.selectionId;
  //             } else {
  //                 console.log(`No matching runner found for ${runner.runnerName} in obj1`);
  //             }
  //             obj2.forEach(m => {

  //               if (m.status === 'CLOSED') {


  //                 m.runners.forEach(r => {
  //                   producer.send({
  //                     topic: kafkaTopics.CRICKET_MARKET_RESULT.topic,
  //                     messages: [
  //                       { value: JSON.stringify({ gameId: 4, eventId: Number(eventId), marketId: String(m.marketId), selectionId: Number(r.selectionId), market: 'bookmaker', gameType: 'bookmaker', status: r.status }) }
  //                     ]
  //                   });

  //                 });
  //               }})


  //         });
  //     });
  // };

  async init(producer) {
    //this.fixtureHandler(producer);
    this.competitionHandler(producer);



    // setInterval(() => this.fixtureHandler(producer,this.competitions,this.eventList,this.eventmarket), 15000);
    setInterval(() => this.competitionHandler(producer), 24 * 60 * 60 * 1000);
    this.fixtureHandler(producer, this.competitions);
    setInterval(() => this.fixtureHandler(producer, this.competitions), 5000);


    // this.fixtureEmitter.on('data', (fixtures) => {
    //   fixtures.forEach(fixture => {
    //     if (!this.marketIntervals[-1][fixture.gameId]) {
    //       this.marketHandler(producer, -1, fixture.gameId, fixture.marketId);
    //       this.marketIntervals[-1][fixture.gameId] = setInterval(() => this.marketHandler(producer, -1, fixture.gameId, fixture.marketId), 5000);
    //     }

    //     if (!this.timelineIntervals[-1][fixture.gameId]) {
    //       this.fetchTimelineData(-1, fixture.gameId);
    //       this.timelineIntervals[-1][fixture.gameId] = setInterval(() => this.fetchTimelineData(-1, fixture.gameId), 5000);
    //     }
    //   });
    // });

    this.competitionEmitter.on('data', (competitions) => {

      competitions.forEach(c => {
        if (!this.eventIntervals[c]) {

          this.eventHandler(producer, c);
          this.eventIntervals[c] = setInterval(() => this.eventHandler(producer, c), 12 * 60 * 60 * 1000);
        }
      });
    });

    this.eventEmitter.on('data', (competitionId, events) => {
      events.forEach(e => {
        if (!this.marketIntervals[competitionId][e.eventId]) {
          if (e.eventId === '33042707') {
            console.log('faulty event', JSON.stringify(e));
          }
          this.marketHandler(producer, competitionId, e.eventId, e.marketId, e.sidMap);
          this.marketIntervals[competitionId][e.eventId] = setInterval(() => this.marketHandler(producer, competitionId, e.eventId, e.marketId, e.sidMap, e), 5000);
        }

        if (!this.sessionIntervals[competitionId][e.eventId]) {
          this.sessionHandler(producer, competitionId, e.eventId, e.marketId);
          this.sessionIntervals[competitionId][e.eventId] = setInterval(() => this.sessionHandler(producer, competitionId, e.eventId, e.marketId), 4000);
        }
        if (!this.bmIntervals[competitionId][e.eventId]) {
          this.bmHandler(producer, competitionId, e.eventId, e.marketId);
          this.bmIntervals[competitionId][e.eventId] = setInterval(() => this.bmHandler(producer, competitionId, e.eventId, e.marketId), 5000);
        }


        // if (!this.timelineIntervals[competitionId][e.eventId]) {
        //   this.fetchTimelineData(competitionId, e.eventId);
        //   this.timelineIntervals[competitionId][e.eventId] = setInterval(() => this.fetchTimelineData(competitionId, e.eventId), 5000);
        // }

        // if (!this.marketSessionsResultDataIntervals[competitionId][e.eventId]) {
        //   this.fetchSessionResultData(competitionId, e.eventId);
        //   this.marketSessionsResultDataIntervals[competitionId][e.eventId] = setInterval(() => this.fetchSessionResultData(competitionId, e.eventId), 10000);
        // }
      });
    });



    this.marketEmitter.on('markets', (eventId, marketId, markets) => {

      if (!this.marketResultIntervals[marketId]) {

    //     function normalizeRunnerName(name) {
    //       return name.toLowerCase().trim();
    //     }

    //     function jaccardSimilarity(str1, str2) {
    //       const set1 = new Set(str1.split(''));
    //       const set2 = new Set(str2.split(''));
    //       const intersection = new Set([...set1].filter(char => set2.has(char)));
    //       const union = new Set([...set1, ...set2]);
    //       return intersection.size / union.size;
    //     }
    //     function updateObj2WithSimilarityThreshold(obj1, obj2, eventId, similarityThreshold = 0.8) {
    //       // Convert obj1 to a Map for faster lookup
          
    //       const runnerMap = new Map();
    //       obj1.forEach(market => {
    //         market.runners.forEach(runner => {
    //           const normalizedRunnerName = normalizeRunnerName(runner.runnerName);
    //           runnerMap.set(normalizedRunnerName, runner.selectionId);
    //         });
    //       });
    //       console.log('bookmake obj1',JSON.stringify(obj1));
    // console.log('bookmake',JSON.stringify(obj2));
    //       // Update obj2 based on obj1 with similarity threshold
    //       obj2.forEach(market => {
    //         market.runners.forEach(runner => {
    //           const obj2RunnerName = normalizeRunnerName(runner.runnerName);
    //           let bestMatch = { similarity: 0, selectionId: undefined };

    //           obj1.forEach(obj1Market => {
    //             obj1Market.runners.forEach(obj1Runner => {
    //               const obj1RunnerName = normalizeRunnerName(obj1Runner.runnerName);
    //               const similarity = jaccardSimilarity(obj1RunnerName, obj2RunnerName);
    //               if (similarity >= similarityThreshold && similarity > bestMatch.similarity) {
    //                 bestMatch = { similarity, selectionId: obj1Runner.selectionId };
    //               }
    //             });
    //           });

    //           if (bestMatch.selectionId !== undefined) {
    //             console.log(`Updating selectionId for ${runner.runnerName} in obj2: ${runner.selectionId} -> ${bestMatch.selectionId}`);
    //             runner.selectionId = bestMatch.selectionId;
    //           } else {
    //             console.log(`No matching runner found for ${runner.runnerName} in obj1`);
    //           }



    //         });
    //       });
    //       obj2.forEach(m => {

    //         if (m.status === 'CLOSED') {


    //           m.runners.forEach(r => {
    //             console.log('marketid', m.marketId, "evenId", eventId, "selctionid", r.selectionId, r.status)
    //             m.runners.forEach(r => {
    //               producer.send({
    //                 topic: kafkaTopics.CRICKET_MARKET_RESULT.topic,
    //                 messages: [
    //                   { value: JSON.stringify({ gameId: 4, eventId: Number(eventId), marketId: String(m.marketId), selectionId: Number(r.selectionId), market: 'bookmaker', gameType: 'bookmaker', status: r.status }) }
    //                 ]
    //               });

    //             });



    //           });
    //         }
    //       })
    //     };



        const interval = setInterval(async () => {
          const result = await getData(`${process.env.CRICKET_RESULT_ENDPOINT}?market_id=${marketId}&sportid=4`);
          // console.log('reslut', result);

          if (result instanceof Error) return;

          if (result instanceof Array) {
            // const response = await getData(`${process.env.CRICKET_MARKET_BMLIST_ENDPOINT}?EventID=${eventId}&sportid=4`);
            // if (response instanceof Error) return;
            //  console.log('response bm',JSON.stringify(response))
            // const bookmakerdata = {};
            result.forEach(m => {
              // console.log('cheacking m', m)
              if (m.status === 'CLOSED') {


                m.runners.forEach(r => {
                  producer.send({
                    topic: kafkaTopics.CRICKET_MARKET_RESULT.topic,
                    messages: [
                      { value: JSON.stringify({ gameId: 4, eventId: Number(eventId), marketId: String(marketId), selectionId: String(r.selectionId), market: m.marketName, gameType: m.marketName, status: r.status }) }
                    ]
                  });

                  producer.send({
                    topic: kafkaTopics.CRICKET_MARKET_RESULT.topic,
                    messages: [
                      { value: JSON.stringify({ gameId: 4, eventId: Number(eventId), marketId: String(m.marketId), selectionId: String(r.runnerName), market:'bookmaker', gameType:'bookmaker', status: r.status }) }
                    ]
                  });




                });


                // updateObj2WithSimilarityThreshold(response,result, eventId);
            
                clearInterval(this.marketResultIntervals[marketId]);
                delete this.marketResultIntervals[marketId];
              }
            });

          }
        }, 20000);

        this.marketResultIntervals[marketId] = interval;
      }
    });

    // this.marketEmitter.on('sessions', (competitionId, eventId, marketId, sessions) => {
    //   if (!this.marketSessionsResultIntervals[eventId]) {
    //     this.marketSessionsResultIntervals[eventId] = {};
    //   }
    //   sessions.forEach(session => {
    //     if (!this.marketSessionsResultIntervals[eventId][session.sid]) {
    //       const interval = setInterval(async () => {
    //         console.log('sesssion',);

    //         if (this.sessionsResultData[competitionId] && this.sessionsResultData[competitionId][eventId]) {
    //           const sessionsResultData = this.sessionsResultData[competitionId][eventId];

    //           let currentSessionResult = null;


    //           for (const resultData of sessionsResultData) {
    //             if (resultData.sid == session.sid) {
    //               currentSessionResult = resultData;
    //               break;
    //             }
    //           }

    //           if (currentSessionResult && currentSessionResult.result !== '...' && !isNaN(Number(currentSessionResult.result))) {
    //             console.debug(`Message emit ${kafkaTopics.CRICKET_MARKET_RESULT.topic}: ${JSON.stringify({ gameId: 4, eventId: Number(eventId), marketId: Number(marketId), selectionId: Number(session.sid), market: session.mname, gameType: session.gtype, result: Number(currentSessionResult.result) })}`);
    //             producer.send({
    //               topic: kafkaTopics.CRICKET_MARKET_RESULT.topic,
    //               messages: [
    //                 { value: JSON.stringify({ gameId: 4, eventId: Number(eventId), marketId: Number(marketId), selectionId: Number(session.sid), market: session.mname, gameType: session.gtype, result: Number(currentSessionResult.result) }) }
    //               ]
    //             });

    //             clearInterval(this.marketSessionsResultIntervals[eventId][session.sid]);
    //             delete this.marketSessionsResultIntervals[eventId][session.sid];
    //           }
    //         }
    //       }, 20000);

    //       this.marketSessionsResultIntervals[eventId][session.sid] = interval;
    //     }
    //   });
    // });
  }
}

module.exports = Cricket;
