/* eslint-disable semi */
/* eslint-disable quotes */
/* eslint-disable no-unused-vars */
const EventEmitter = require('events');
const http = require('http');
const { ObjectId } = require('mongodb');
const axios = require('axios');
const { Session } = require('./lib/cricket');
const { stringify } = require('querystring');
const { log } = require('console');
const moment = require('moment-timezone');
// const { transporter, mailOptions } = require('./nodemailer.config');

const subscribers = [process.env.BASE_API];

async function getData(url) {
  const promise = new Promise((resolve, reject) => {
    http.get(url, (res) => {
      let data = [];

      res.on('data', chunk => data.push(chunk));
      res.on('end', async () => {
        if (res.statusCode === 200) {
          try {
            if (data.length) {
              const response = JSON.parse(Buffer.concat(data));
              if (typeof response === 'object')
                resolve(response);
              else {
                reject(new Error(response));
              }
            } else {
              reject(new Error('Empty response'));
            }
          } catch (e) {
            reject(e);
          }
        } else {
          reject(new Error(res.statusMessage));
        }
      });
    }).on('error', err => {
      reject(err);
    });
  });

  return await promise.catch(err => err);
}

class Cricket {

  constructor(server) {
    this.eventEmitter = new EventEmitter();
    this.marketEmitter = new EventEmitter();
    this.competitionEmitter = new EventEmitter();
    this.competitions = [];
    this.events = new Object();
    this.sessions = new Object();
    this.eventIntervals = new Object();
    this.marketIntervals = new Object();
    this.bmIntervals = new Object();
    this.sessionResultIntervals = new Object();

    // Handler to listen http request
    server.get('/cricket/get-session-result', this.getSessionResult);
    // server.get('/cricket/validate-session', this.validateSession);
    server.get('/cricket/get-unresolved-sessions', this.getUnResolvedSession);
    server.get('/cricket/get-unresolved-eventid', this.getUnResolvedEventSession);
    server.get('/cricket/get-bookmaker-unresolve', this.getUnResolvedBookmaker);
    server.post('/cricket/resolve-session', this.resolveSession);
    server.post('/cricket/resolve-bookmaker', this.resolveBookmaker);
    server.get('/cricket/get-all-bookmaker', this.getALLBookmaker);
    server.post('/cricket/resolve-fancy', this.resolveFancy);
    // server.get('/notify', this.notify);
    server.post('/cricket/check-market', this.checkSession);
  }

  async sendEventToSubscribers(session) {


    const promises = subscribers.map(endpoint => {

      let selectionId;
      if (session.market === 'bookmaker') {
        selectionId = session.runnerName
      } else {
          
          selectionId = session.selectionId;
      }
      const payload = {
        eventId: session.eventId,
        marketId: session.marketId,
        selectionId: selectionId,
        marketName: session.mname,
        result: session.result,
        status :session.status,
        gameType: session.gameType

      };
   
      
      return axios.post(endpoint, payload).catch(err => console.error(err));
    });

    Promise.all(promises).catch(err => console.error(err));
  }
 
  getSessionResult = async (req, res) => {
    const { eventId, marketId, selectionId } = req.query;

    if (!eventId || !marketId || !selectionId) {
      res.status(400).end();
    } else {
      const collection = global.DB.collection('sessions');

      const response = await collection.findOne({ eventId: Number(eventId), marketId: Number(marketId), selectionId: Number(selectionId) }).catch(err => err);

      if (response instanceof Error) {
        res.status(500).send(response.message);
      } else if (response === null) {
        res.status(204).end();
      } else {
        res.status(200).send(response);
      }
    }
  };

  // validateSession = async (req, res) => {
  //   const { eventId, marketId, selectionId } = req.query;

  //   console.debug('Validate Session Query: ', JSON.stringify(req.query));

  //   if (!eventId || !marketId || !selectionId) {
  //     res.status(400).end();
  //   } else {
  //     const collection = global.DB.collection('sessions');

  //     const response = await collection.findOne({ eventId: Number(eventId), marketId: Number(marketId), selectionId: Number(selectionId), status: { $ne: 1 } }).catch(err => err);

  //     if (response instanceof Error) {
  //       res.status(500).send(response.message);
  //     } else if (response === null) {
  //       res.status(204).end();
  //     } else {
  //       res.status(200).send(true);
  //     }
  //   }
  // };

  getUnResolvedSession = async (req, res) => {
    
    const { search, offset, limit } = req.query;
    

    const collection = global.DB.collection('sessions');

    const escapedSearch = search ? search.replace(/[.*+?^${}()|[\]\\]/g, '\\$&') : '';
const response = await collection.find({ status: { $nin: [0, 1] }, session:{ $regex: escapedSearch, $options: 'i' } }).skip(Number(offset) || 0).limit(Number(limit) || 10).toArray().catch(err => err);

    if (response instanceof Error) {
      res.status(500).send(response.message);
    } else if (response === null) {
      res.status(200).send({ sessions: [], counts: 0 });
    } else {
      const counts = await collection.aggregate([
        { $match: { status: { $nin: [0, 1] } } },
        { $group: { _id: '$status', count: { $sum: 1 } } }
      ]).toArray().catch(err => err);

      if (counts instanceof Error) {
        res.status(500).send(counts.message);
        return;
      }

      res.status(200).send({ sessions: response, counts });
    }
  };



  getUnResolvedEventSession = async (req, res) => {
    
    const { eventId,search, offset, limit } = req.query;
    // console.log(req.query);
    const eventid = parseInt(eventId);
    

    const collection = global.DB.collection('sessions');

    // Escape special characters in the search string
const escapedSearch = search ? search.replace(/[.*+?^${}()|[\]\\]/g, '\\$&') : '';

// Create the regular expression for case-insensitive search


// Use the regular expression in the query
const response = await collection.find({
  eventId: eventid,
  status: { $nin: [0, 1] },
  session: { $regex: escapedSearch, $options: 'i' }
}).skip(Number(offset) || 0).limit(Number(limit) || 10).toArray().catch(err => err);

   

    if (response instanceof Error) {
      res.status(500).send(response.message);
    } else if (response === null) {
      res.status(200).send({ sessions: [], counts: 0 });
    } else {
      const counts = await collection.aggregate([
        { $match: {  eventId:eventid ,status: { $nin: [0, 1] }} },
        { $group: { _id: '$status', count: { $sum: 1 } } }
      ]).toArray().catch(err => err);

      if (counts instanceof Error) {
        res.status(500).send(counts.message);
        return;
      }

      res.status(200).send({ sessions: response, counts });
    }
  };

  getUnResolvedBookmaker = async (req, res) => {
    
    const { eventId,search, offset, limit } = req.query;
    // console.log(req.query);
    const eventid = parseInt(eventId);
    

    const collection = global.DB.collection('bookmakers');

    const escapedSearch = search ? search.replace(/[.*+?^${}()|[\]\\]/g, '\\$&') : '';
    let response;
try {
   response = await collection.find({ 
    eventId: eventid, 
    status: '', 
    eventName: { $regex: new RegExp(escapedSearch, 'i') || '' } 
  }).skip(Number(offset) || 0).limit(Number(limit) || 10).toArray();

  // Process the response here
  console.log(response);
} catch (err) {
  // Handle errors here
  console.error(err);
}

   

    if (response instanceof Error) {
      res.status(500).send(response.message);
    } else if (response === null) {
      res.status(200).send({ sessions: [] });
    } else {
    
      res.status(200).send({ bookmaker: response});
    }
  };

  getALLBookmaker= async (req, res) => {
    
    const { search, offset, limit } = req.query;
    // console.log(req.query);
   
    

    const collection = global.DB.collection('bookmakers');

    const escapedSearch = search ? search.replace(/[.*+?^${}()|[\]\\]/g, '\\$&') : '';

    let response;
try {
  response = await collection.find({ 
    status: '',
    eventName: { $regex: new RegExp(escapedSearch, 'i') || '' } 
  }).skip(Number(offset) || 0).limit(Number(limit) || 10).toArray();

 
 
} catch (err) {
  // Handle errors here
  console.error(err);
}

   

    if (response instanceof Error) {
      res.status(500).send(response.message);
    } else if (response === null) {
      res.status(200).send({ sessions: [] });
    } else {
      const counts = await collection.aggregate([
        { $match: { status: ''} },
        { $group: { _id: '$status', count: { $sum: 1 } } }
      ]).toArray().catch(err => err);

      if (counts instanceof Error) {
        res.status(500).send(counts.message);
        return;
      }

    
      res.status(200).send({ bookmaker: response, counts});
    }
  };
  checkSession = async (req, res) => {
    const { gameType, eventId, selectionId } = req.body;
    console.log('Request:', gameType, eventId, selectionId);
    let market;
    if (gameType === "fancy") {
        market = "fancy1";
    } else {
        market = gameType;
    }

    if (!eventId || !selectionId) {
        res.status(400).send({ error: 'Bad request' });
        return;
    }

    try {
        const collection = global.DB.collection('sessions');
        const response = await collection.findOne({
           eventId: Number(eventId),
           gameType: market,
           selectionId:Number( selectionId)
        });

        // console.log('Response:', response, 'Market:', market, 'SelectionId:', selectionId);

        if (response) {
            res.status(200).send({ message: 'Success' });
        } else {
          res.status(200).send({ message: 'Success' });
        }
    } catch (error) {
        console.error('Error executing database query:', error);
        res.status(500).send({ error: 'Internal server error' });
    }
};





  resolveSession = async (req, res) => {
    const { _id, result,status } = req.body;
    const indiaTime = moment().tz('Asia/Kolkata');

// Format the date and time as required
const startTime = indiaTime.format('YYYY-MM-DD HH:mm:ss');
// console.log('reus',result,_id);
    if (_id && result) {
      console.log('reus',result,_id);
      const collection = global.DB.collection('sessions');

      const response = await collection.findOneAndUpdate(
        { _id: ObjectId(_id) },
        {
          $set: { status: 1, result:result ,startTime}
        },
        {
          returnDocument: 'after'
        }
      ).catch(err => err);
     console.log(response,'respp')
      if (response instanceof Error) {
        res.status(500).send(response.message);
        return;
      }

      this.sendEventToSubscribers(response.value);
      res.status(200).send({ message: 'Success' });
    } else {
      res.status(400).send({ error: 'Bad request' });
    }
  };
  resolveBookmaker  = async (req, res) => {
    const { _id,status } = req.body;

    if (_id && status) {
      const collection = global.DB.collection('bookmakers');

      const response = await collection.findOneAndUpdate(
        { _id: ObjectId(_id) },
        {
          $set: { status }
        },
        {
          returnDocument: 'after'
        }
      ).catch(err => err);
     
      if (response instanceof Error) {
        res.status(500).send(response.message);
        return;
      }
    // console.log('resp',response.value)
      this.sendEventToSubscribers(response.value);
      res.status(200).send({ message: 'Success' });
    } else {
      res.status(400).send({ error: 'Bad request' });
    }
  };


  resolveFancy= async (req, res) => {
    const { _id, result} = req.body;

    if (_id && result) {
      const collection = global.DB.collection('sessions');

      const response = await collection.findOneAndUpdate(
        { _id: ObjectId(_id) },
        {
          $set: { status: 1, result }
        },
        {
          returnDocument: 'after'
        }
      ).catch(err => err);
         console.log('resp',response.value)
      if (response instanceof Error) {
        res.status(500).send(response.message);
        return;
      }

      this.sendEventToSubscribers(response.value);
      res.status(200).send({ message: 'Success' });
    } else {
      res.status(400).send({ error: 'Bad request' });
    }
  };
  // notify = async (req, res) => {
  //   const collection = global.DB.collection('sessions');

  //   const response = await collection.aggregate([
  //     { $match: { status: { $nin: [0, 1] } } },
  //     { $group: { _id: '$status', count: { $sum: 1 } } }
  //   ]).toArray().catch(err => err);

  //   if (response instanceof Error) {
  //     res.status(500).send(response.message);
  //     return;
  //   }

  //   const statistics = {
  //     '-1': 0,
  //     '-2': 0,
  //     '-3': 0,
  //     '-4': 0,
  //   };

  //   let total = 0;

  //   response.forEach(element => {
  //     total += element.count;
  //     statistics[element._id] = element.count;
  //   });

  //   const subject = 'Notification! Statistics of awaiting session to get resolved';
  //   const mailBody = `Hey! Here is the current statistics of awaiting session to get resolved quickly.<br/>
  //     - NOT_AVAILABLE     : ${statistics['-1']} <br/> 
  //     - NOT_HANDLED       : ${statistics['-2']} <br/>    
  //     - NOT_PROCESSABLE   : ${statistics['-3']} <br/>
  //     - UNEXPECTED_RESULT : ${statistics['-4']} <br/>
  //     <br/>
  //     - TOTAL : ${total} <br/>
  //     <br/>
  //     Please go the admin panel and resolve all these awaiting sessions. <br/>
  //     <br/>
  //     Thanks
  //   `;

  //   transporter.sendMail(mailOptions(process.env.NOTIFY_EMAIL, subject, mailBody), (err) => {
  //     if (err) {
  //       console.error(err);
  //       res.status(500).send(err.message);
  //     } else {
  //       res.status(200).end();
  //     }
  //   });
  // };

  async updateMarketStartTime(marketId, startTime) {
    const collection = global.DB.collection('sessions');

    const queryResponse = await collection.updateMany(
      { marketId: Number(marketId) },
      {
        $set: { startTime }
      }
    ).catch(err => err);

    if (queryResponse instanceof Error) {
      console.error(queryResponse);
    }
  }

  handleShutDownMarketInterval(competitionId, eventId, marketCatalogue) {
    if (
      marketCatalogue &&
      marketCatalogue instanceof Array &&
      marketCatalogue.length > 0 &&
      marketCatalogue[0].status === 'CLOSED'
  ) 
    
   {
      clearInterval(this.marketIntervals[competitionId][eventId]);
      delete this.marketIntervals[competitionId][eventId];

      clearInterval(this.bmIntervals[competitionId][eventId]);
      delete this.bmIntervals[competitionId][eventId];
    }

  }

  async competitionHandler() {

    const response = await getData(`${process.env.CRICKET_COMPETITIONS_ENDPOINT}?id=4`);
    
    if (response instanceof Error) {
      return;
    }

    const competitions = response;
  

    if (competitions instanceof Array) {
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
  }
  async eventHandler( competitionId) {
    const _response = await getData(`${process.env.CRICKET_EVENTS_ENDPOINT}?sid=${competitionId}&sportid=4`);
   



    if (_response instanceof Error || !(_response instanceof Array)) {

    

      return;
    }

    _response.forEach(async (r) => {
      let _eventId = r.event.id;
     
      const response = await getData(`${process.env.CRICKET_EVENTS_MARKET}?EventID=${_eventId}`);
    
      if (response instanceof Error || !(response instanceof Array) || !Array.isArray(response) || response.length === 0){
        return;
      }
     
      const eventById = new Object();


      response.filter(e => e.marketName === 'Match Odds').forEach(e => { e.event = r.event; eventById[_eventId] = e; });


      const events = Object.values(eventById);
     

      if (events instanceof Array) {
        if (!this.events[competitionId]) {
          this.events[competitionId] = [];
        }
  
        events.forEach(e => eventById[e.event.id] = e);
        events.forEach(e => this.updateMarketStartTime(e.marketId, e.marketStartTime));
  
        const prevEvents = [...this.events[competitionId]];
        const currEvents = events.map(e => e.event.id);
        const newEvents = events.filter(e => prevEvents.indexOf(e.event.id) === -1).map(e => e.event.id);
  
        this.events[competitionId] = [...prevEvents.filter(e => currEvents.indexOf(e) !== -1), ...newEvents];
  
        if (!this.marketIntervals[competitionId]) {
          this.marketIntervals[competitionId] = new Object();
        }
        if (!this.bmIntervals[competitionId]) {
          this.bmIntervals[competitionId] = new Object();
        }
  
        const marketIntervals = this.marketIntervals[competitionId];
        const bmIntervals = this.bmIntervals[competitionId];
  
        for (const [eventId] of Object.entries(marketIntervals)) {
          if (currEvents.indexOf(eventId) === -1) {
            clearInterval(marketIntervals[eventId]);
            delete marketIntervals[eventId];
            clearInterval(bmIntervals[eventId]);
            delete bmIntervals[eventId];
          }
        }
        
        if (newEvents.length) {
          this.eventEmitter.emit('data', competitionId, newEvents.map(id => ({ eventId: id, marketId: eventById[id].marketId, marketStartTime: eventById[id].marketStartTime,event:eventById[id].event })));
        }
      }
    });

  }

  async marketHandler(competitionId, eventId, marketId, starttime) {
    const response = await getData(`${process.env.CRICKET_MARKET_ENDPOINT}?eventid=${eventId}`);
    

     if (response instanceof Error || !(response instanceof Array)) {
     
       return;
      
    }

   
    const marketCatalogue = response;
    

    this.handleShutDownMarketInterval(competitionId, eventId, marketCatalogue);

    if (!this.sessions[competitionId]) {
      this.sessions[competitionId] = new Object();
    }

    if (!this.sessions[competitionId][eventId]) {
      this.sessions[competitionId][eventId] = [];
    }

    let sessions = [];
   
    const fancyMarkets = marketCatalogue.filter(entry =>
      !entry.RunnerName.includes('.') &&
      !entry.RunnerName.includes('1st Inn 0 to 20 overs Total 2 runs') &&
      !entry.RunnerName.includes('1st Inn 0 to 20 overs Total 1 runs') &&
      !entry.RunnerName.toLowerCase().includes('run bhav') &&
      !entry.RunnerName.toLowerCase().includes('over 1') &&
      (
          entry.RunnerName.toLowerCase().includes('win the toss') ||
          entry.RunnerName.toLowerCase().includes('lunch fav') ||
          entry.RunnerName.toLowerCase().includes('hatrick') ||
          entry.RunnerName.toLowerCase().includes('maiden') ||
          entry.RunnerName.toLowerCase().includes('run') ||
          entry.RunnerName.toLowerCase().includes('1st wkt caught out') ||
          entry.RunnerName.toLowerCase().includes('wkt runs') ||
          entry.RunnerName.toLowerCase().includes('fall of 1st wkt') ||
          entry.RunnerName.toLowerCase().includes('1st Wkt lost to') ||
          entry.RunnerName.toLowerCase().includes('total match') ||
          entry.RunnerName.toLowerCase().includes('only 19 over run') ||
          entry.RunnerName.includes('over run') ||
          entry.RunnerName.toLowerCase().includes('How many balls face') ||
          entry.RunnerName.toLowerCase().includes('1st inn 0') ||
          entry.gtype ==='session'


      )
  );
  
  // console.log('market', JSON.stringify(fancyMarkets));
  
   
   
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
      const collection = global.DB.collection('sessions');

      const session = new Session(Number(eventId));
     
     
      newSessions.map(async (SelectionId) => {
        const doc = {
          competitionId: Number(competitionId),
          eventId: Number(eventId),
          marketId: Number(marketId),
          selectionId: Number(SelectionId),
          session: sessionByID[SelectionId].RunnerName,
          gameType: sessionByID[SelectionId].gtype
        };
        

        const response = await collection.findOne(doc).catch(err => err);

        if (response instanceof Error) {
          console.error(response);
          return;
        } else if (response === null) {
          doc.status = -2;
          // if (session.isSessionProcessable(doc.session)) {
          //   doc.status = 0;
          // } else {
          //   console.warn(`Handler not found for session "${doc.session}"`);
          //   doc.status = -2;
          // }
          // console.log('doccc',doc);
          const queryResponse = await collection.insertOne({
            ...doc,
            mname: sessionByID[SelectionId].mname,
            startTime: starttime,
            result: null
          }).catch(err => err);
          // console.log('db response ',queryResponse);

          if (queryResponse instanceof Error) {
            console.error(queryResponse);
            return;
          }
        }
      });
    }
  }

  async bmHandler(competitionId, eventId, marketId, event) {

    const eventName = event.name;

    const bookmakerMarketIDs = await getData(`${process.env.CRICKET_MARKET_BMLIST_ENDPOINT}?EventID=${eventId}&sportid=4`);
    if (bookmakerMarketIDs instanceof Error || !(bookmakerMarketIDs instanceof Array)|| bookmakerMarketIDs.length === 0) {
      // console.log('hererer',response)
      return;
    }
    const response = bookmakerMarketIDs.filter(m => { return m.marketName.toLowerCase() === 'bookmaker'; });
    const collection = global.DB.collection('bookmakers');
    for (const runner of response[0].runners) {
      // console.log('Current runner:', runner);
  
      const selectionId = runner.selectionId;
      const runnerName = runner.runnerName;
  
      // console.log('Selection ID:', selectionId);
      // console.log('Runner Name:', runnerName);
  
        const doc = {
            competitionId: Number(competitionId),
            eventId: Number(eventId),
            marketId: Number(marketId),
            selectionId: Number(selectionId),
            runnerName: runnerName,
            eventName: eventName,
            gameid: 4,
            gameType: 'bookmaker',
            market: 'bookmaker',
            status :''
        };

        // Check if the document already exists
        const existingDoc = await collection.findOne({
            competitionId: doc.competitionId,
            eventId: doc.eventId,
            marketId: doc.marketId,
            selectionId: doc.selectionId,
            eventName: doc.eventName,
            gameid: doc.gameid,
            gameType: doc.gameType,
            market: doc.market
        }).catch(err => err);
        // console.log('extttt',existingDoc);
        if (existingDoc instanceof Error) {
           
            continue;
        } else if (existingDoc === null) {
           
            const queryResponse = await collection.insertOne(doc).catch(err => err);
            // console.log('queryResponse',queryResponse);
            if (queryResponse instanceof Error) {
                console.error(queryResponse);
                continue;
            }
        }
    }
}



  async sessionResultHandler(_session) {
    try {
      const session = new Session(_session.eventId);
      const response = await session.getSessionResult(_session.session);

      if (response instanceof Error) {
        console.warn(`Getting Error while processing "${_session.session}"`);
        console.error(response);
      } else if (response) {
        console.debug(`Response for session "${_session.session}" :`, response);

        if (response.status === 'CLOSED' || response.status === 'NOT_PROCESSABLE' || response.status === 'NOT_AVAILABLE') {
          const fields = {};

          switch (response.status) {
            case 'CLOSED':
              if (response.data !== null && response.data !== undefined && !isNaN(Number(response.data))) {
                fields.result = Number(response.data);
                fields.status = 1;
              } else {
                fields.status = -4;
                fields.error = `Unexpected response : ${typeof response.data === 'object' ? JSON.stringify(response.data) : response.data}`;
              }
              break;
            case 'NOT_PROCESSABLE':
              fields.status = -3;
              fields.error = response.message;
              break;
            case 'NOT_AVAILABLE':
              fields.status = -1;
              fields.error = response.message;
              break;
            default:
              break;
          }

          const collection = global.DB.collection('sessions');

          const queryResponse = await collection.updateOne(
            { _id: _session._id },
            {
              $set: fields
            }
          ).catch(err => err);

          if (queryResponse instanceof Error) {
            console.error(queryResponse);
            return;
          }

          console.debug(`Session "${_session.session}" resolved with "${response.status}" status...`);

          clearInterval(this.sessionResultIntervals[_session.competitionId][_session.eventId][_session._id]);
          delete this.sessionResultIntervals[_session.competitionId][_session.eventId][_session._id];
        }
      }
    } catch (err) {
      console.error(err);
    }
  }

  async bindSessionHandler(session) {
    if (!this.sessionResultIntervals[session.competitionId]) {
      this.sessionResultIntervals[session.competitionId] = {};
    }

    if (!this.sessionResultIntervals[session.competitionId][session.eventId]) {
      this.sessionResultIntervals[session.competitionId][session.eventId] = {};
    }

    if (!this.sessionResultIntervals[session.competitionId][session.eventId][session._id]) {
      this.sessionResultHandler(session);
      this.sessionResultIntervals[session.competitionId][session.eventId][session._id] = setInterval(() => this.sessionResultHandler(session), 30000);
    }
  }

  async initScheduledSessions() {
    const collection = global.DB.collection('sessions');
    const response = await collection.find({ status: 0, startTime: { $lte: new Date().toISOString() } }).toArray().catch(err => err);

    response.forEach(session => {
      this.bindSessionHandler(session);
    });
  }

  async init() {

    this.competitionEmitter.on('data', (competitions) => {
      competitions.forEach(competitionId => {
        if (!this.eventIntervals[competitionId]) {
          this.eventHandler(competitionId);
          this.eventIntervals[competitionId] = setInterval(() => this.eventHandler(competitionId), 1000*60*60*12);
        }
      });
    });

    this.eventEmitter.on('data', (competitionId, events) => {
      // console.log('events ,',events)
      if (!this.marketIntervals[competitionId]) {
        this.marketIntervals[competitionId] = new Object();
      }

      events.forEach(e => {
       
      
        if (!this.marketIntervals[competitionId][e.eventId]) {
          // if (!this.bmIntervals[competitionId][e.eventId]) {
          // this.bmHandler(competitionId, e.eventId,e.marketId,e.event);
          // this.bmIntervals[competitionId][e.eventId] =  setInterval(() => this.bmHandler(competitionId, e.eventId, e.marketId,e.event), 10000);
          // }
          this.marketHandler(competitionId, e.eventId, e.marketId, e.marketStartTime);
          this.marketIntervals[competitionId][e.eventId] = setInterval(() => this.marketHandler(competitionId, e.eventId, e.marketId, e.marketStartTime), 4000);
        }
      });
    });

    // this.initScheduledSessions();
    // this.competitionHandler();

    // setInterval(() => this.competitionHandler(), 24*60*60*1000);
    // setInterval(() => this.initScheduledSessions(), 300000);
  }
}

module.exports = Cricket;
