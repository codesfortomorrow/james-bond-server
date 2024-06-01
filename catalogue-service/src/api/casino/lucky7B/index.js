const kafkaTopics = require('../../../utils/kafkaTopics');

class Lucky7B {

  static subscribers = [];
  static marketCatalogue = new Object();

  emitCatalogueStream() {
    Lucky7B.subscribers.forEach(subscriber => {
      subscriber.response.write(`data: ${JSON.stringify(Lucky7B.marketCatalogue)}\n\n`);
    });
  }

  consumeKafkaMessage(payload) {
    if (payload.topic === kafkaTopics.CASINO_LUCKY_7B_CATALOGUE.topic) {
      Lucky7B.marketCatalogue = JSON.parse(payload.message.value ? payload.message.value.toString() : '{}');
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

    Lucky7B.subscribers = [...Lucky7B.subscribers, { id: streamId, response: res }];

    res.write(`data: ${JSON.stringify(Lucky7B.marketCatalogue)}\n\n`);

    req.on('close', () => {
      const subscriberIndex = Lucky7B.subscribers.findIndex((subscriber) => subscriber.id == streamId);
      if (subscriberIndex !== -1) {
        Lucky7B.subscribers.splice(subscriberIndex, 1);
      }
    });
  }
}

module.exports = Lucky7B;
