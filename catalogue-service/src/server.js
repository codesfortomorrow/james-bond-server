/* eslint-disable @typescript-eslint/no-var-requires */
const express = require('express');
const cors = require('cors');
const { Kafka } = require('kafkajs');
const kafkaTopics = require('./utils/kafkaTopics');
const RequestHandler = require('./api');
const Cricket = require('./api/cricket');
const Soccer = require('./api/soccer');
const Tennis = require('./api/tennis');
const TeenPatti20 = require('./api/casino/teenPatti20');
const Lucky7B = require('./api/casino/lucky7B');
const AmarAkbarAnthony = require('./api/casino/amarAkbarAnthony');
const swaggerUi = require('swagger-ui-express');
// const swaggerSpec = require('./swaggerDefinition');

const kafka = new Kafka({
  clientId: process.env.KAFKA_CLIENT_ID,
  brokers: ['kafka:9092']
});

const consumer = kafka.consumer({ groupId: process.env.KAFKA_GROUP_ID });

async function kafkaConsumerInit() {
  const exit = (err) => {
    console.error(err);
    process.exit(1);
  };

  await consumer.connect().catch(exit);

  const promises = [];
  const topics = Object.values(kafkaTopics);

  for (let i = 0; i < topics.length; i++) {
    promises.push(consumer.subscribe(topics[i]).catch(exit));
  }

  await Promise.all(promises);

  consumer.run({
    eachMessage: async (payload) => {
      new Cricket().consumeKafkaMessage(payload);
      new Soccer().consumeKafkaMessage(payload);
      new Tennis().consumeKafkaMessage(payload);
      // new TeenPatti20().consumeKafkaMessage(payload);
      // new Lucky7B().consumeKafkaMessage(payload);
      // new AmarAkbarAnthony().consumeKafkaMessage(payload);
    }
  }).catch(exit);
}

const app = express();


app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
RequestHandler(app);
// app.use('/api/catalogue/api-docs', swaggerUi.serve, swaggerUi.setup(swaggerSpec));


app.listen(process.env.HTTP_PORT, async () => {
  await kafkaConsumerInit();
  console.log(`🚀️ Catalogue service running on port ${process.env.HTTP_PORT}`);
});
