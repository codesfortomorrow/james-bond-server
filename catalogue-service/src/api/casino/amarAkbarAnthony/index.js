const kafkaTopics = require('../../../utils/kafkaTopics');

class AmarAkbarAnthony {

  static subscribers = [];
  static marketCatalogue = new Object();

  emitCatalogueStream() {
    AmarAkbarAnthony.subscribers.forEach(subscriber => {
      subscriber.response.write(`data: ${JSON.stringify(AmarAkbarAnthony.marketCatalogue)}\n\n`);
    });
  }

  consumeKafkaMessage(payload) {
    if (payload.topic === kafkaTopics.CASINO_AMAR_AKBAR_ANTHONY_CATALOGUE.topic) {
      AmarAkbarAnthony.marketCatalogue = JSON.parse(payload.message.value ? payload.message.value.toString() : '{}');
      this.emitCatalogueStream();
    }
  }

  getCatalogueStream(req, res) {
    const streamId = Math.random().toString(16).slice(2);

    res.writeHead(200, {
      'Content-Type': 'text/event-stream',
      'Connection': 'keep-alive',
      'Cache-Control': 'no-cache',
      'X-Accel-Buffering': 'no'
    });

    AmarAkbarAnthony.subscribers = [...AmarAkbarAnthony.subscribers, { id: streamId, response: res }];

    res.write(`data: ${JSON.stringify(AmarAkbarAnthony.marketCatalogue)}\n\n`);

    req.on('close', () => {
      const subscriberIndex = AmarAkbarAnthony.subscribers.findIndex((subscriber) => subscriber.id == streamId);
      if (subscriberIndex !== -1) {
        AmarAkbarAnthony.subscribers.splice(subscriberIndex, 1);
      }
    });
  }
}

module.exports = AmarAkbarAnthony;
