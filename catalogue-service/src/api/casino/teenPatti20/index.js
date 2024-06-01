const kafkaTopics = require('../../../utils/kafkaTopics');

class TeenPatti20 {

  static subscribers = [];
  static marketCatalogue = new Object();

  emitCatalogueStream() {
    TeenPatti20.subscribers.forEach(subscriber => {
      subscriber.response.write(`data: ${JSON.stringify(TeenPatti20.marketCatalogue)}\n\n`);
    });
  }

  consumeKafkaMessage(payload) {
    if (payload.topic === kafkaTopics.CASINO_TEEN_PATTI_20_CATALOGUE.topic) {
      TeenPatti20.marketCatalogue = JSON.parse(payload.message.value ? payload.message.value.toString() : '{}');
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

    TeenPatti20.subscribers = [...TeenPatti20.subscribers, { id: streamId, response: res }];

    res.write(`data: ${JSON.stringify(TeenPatti20.marketCatalogue)}\n\n`);

    req.on('close', () => {
      const subscriberIndex = TeenPatti20.subscribers.findIndex((subscriber) => subscriber.id == streamId);
      if (subscriberIndex !== -1) {
        TeenPatti20.subscribers.splice(subscriberIndex, 1);
      }
    });
  }
}

module.exports = TeenPatti20;
