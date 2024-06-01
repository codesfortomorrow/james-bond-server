/* eslint-disable @typescript-eslint/no-unused-vars */
/* eslint-disable @typescript-eslint/no-var-requires */
const express = require('express');
const cors = require('cors');
const { Kafka } = require('kafkajs');
const { getData } = require('./utils/request');

const Cricket = require('./cricket');
const Soccer = require('./soccer');
const Tennis = require('./tennis');

const TeenPatti20 = require('./casino/teenPatti20');
const Lucky7B = require('./casino/lucky7B');
const AmarAkbarAnthony = require('./casino/amarAkbarAnthony');
// const DBConnection = require('./db.config');
const DBConnection =require("./db.config")

const kafkaTopics = require('./utils/kafkaTopics');

const kafka = new Kafka({
  clientId: 'market-service',
  brokers: ['kafka:9092']
});

const admin = kafka.admin();
const producer = kafka.producer();

async function kafkaProducerInit() {
  const exit = (err) => {
    console.error(err);
    process.exit(1);
  };

  const promises = [
    producer.connect().catch(exit),
    admin.connect().catch(exit)
  ];

  await Promise.all(promises);
  await admin.createTopics({ topics: Object.values(kafkaTopics) }).catch((err) => console.error(err));
}

function initializeHTTPServer() {
  const server = express();

  server.use(cors());
  server.use(express.json());

  server.post('/session-resolve-event', (req, res) => {
    console.log("req",req.body);
    const { eventId, marketId, selectionId, marketName, result,gameType,status} = req.body;
    console.log("req",req.body);

    
    if(gameType==='bookmaker'){
      producer.send({
        topic: kafkaTopics.CRICKET_MARKET_RESULT.topic,
        messages: [
          { value: JSON.stringify({ gameId: 4, eventId: Number(eventId), marketId: String(marketId), selectionId: String(selectionId), market: gameType, gameType: gameType,status:status }) }
        ]
      });
    }
    else if(gameType==='fancy1'){
      producer.send({
        topic: kafkaTopics.CRICKET_MARKET_RESULT.topic,
        messages: [
          { value: JSON.stringify({ gameId: 4, eventId: Number(eventId), marketId: String(marketId), selectionId: String(selectionId), market: marketName, gameType:'fancy',status:result }) }
        ]
      });
    }
    else{
    producer.send({
      topic: kafkaTopics.CRICKET_MARKET_RESULT.topic,
      messages: [
        { value: JSON.stringify({ gameId: 4, eventId: Number(eventId), marketId: String(marketId), selectionId: String(selectionId), market: marketName, gameType: gameType, result: Number(result) }) }
      ]
    });}

    res.status(200).end();
  });
 
 
  server.get('/get-cricket-market-data', async (req, res) => {
    const { eventId } = req.query;
    const response = await getData(`${process.env.CRICKET_MARKET_ENDPOINT}?eventId=${eventId}`);
    res.send(response);
  });

  //////////////////// this for bypass market result service //////////////////////////
  server.post("/result-panel-manual", async (req, res) => {
    try {
        console.log("result-pannel-manual", req.body);
        const {selectionId, result, matchId, gtype } = req.body;
let status;
        if (gtype === "fancy1" || gtype === "fancy") {
            if(result==1){
          status = 'WINNER';
        }
        if(result==0){
          status = 'LOSER';
        }
        if (result==-1)
          {
            status = "REMOVED"
          }
            await producer.send({
                topic: kafkaTopics.CRICKET_MARKET_RESULT.topic,
                messages: [
                    {
                        value: JSON.stringify({
                            gameId: 4,
                            eventId: Number(matchId),
                            selectionId: String(selectionId),
                            status: status,
                            market: 'fancy',
                            gameType: 'fancy',
                        }),
                    },
                ],
            });
        } else {
            await producer.send({
                topic: kafkaTopics.CRICKET_MARKET_RESULT.topic,
                messages: [
                    {
                        value: JSON.stringify({
                            gameId: 4,
                            eventId: Number(matchId),
                            selectionId: String(selectionId),
                            result: Number(result),
                            market: 'session',
                            gameType: 'session',
                        }),
                    },
                ],
            });
        }

        res.status(200).send({
            message: "ok",
            error: false,
            code: 200,
        });
    } catch (error) {
        console.error("Error processing request:", error);
        res.status(500).send({
            message: "Internal server error",
            error: true,
            code: 500,
        });
    }
});


  server.listen(process.env.HTTP_PORT || 8004, async () => {
    console.log(`🚀️ Market service running on port ${process.env.HTTP_PORT || 8004}`);
  });
}
const watchMarkets = async () => {
 // Markets
 new Cricket().init(producer);
 new Soccer().init(producer);
 new Tennis().init(producer);
};
const run = async () => {
  await kafkaProducerInit();
  DBConnection(() => watchMarkets());
  

  // Casino
  // new TeenPatti20().init(producer);
  // new Lucky7B().init(producer);
  // new AmarAkbarAnthony().init(producer);

  initializeHTTPServer();
};

try {
  run();
} catch (e) {
  console.error(e);
}

process.on('uncaughtException', err => {
  console.error('There was an uncaught error', err);
});
