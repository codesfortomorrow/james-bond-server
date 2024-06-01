/* eslint-disable no-undef */
/* eslint-disable @typescript-eslint/no-var-requires */
const { getData } = require('../utils/request');
const kafkaTopics = require('../utils/kafkaTopics');

class AmarAkbarAnthony {

  constructor() {
    this.casino = 'Amar-Akbar-Anthony';
    this.currentMarket = null;
    this.markets = [];
  }

  async casinoHandler(producer) {
    const response = await getData(process.env.AAA_MARKET_ENDPOINT);
    if (response instanceof Error) {
      return;
    }

    if (response.success === true && typeof response.data === 'object') {
      producer.send({
        topic: kafkaTopics.CASINO_AMAR_AKBAR_ANTHONY_CATALOGUE.topic,
        messages: [
          { value: JSON.stringify(response.data) }
        ]
      });

      if (
        response.data.t1 &&
        response.data.t1 instanceof Array &&
        response.data.t1.length &&
        response.data.t1[0].mid !== '0' &&
        this.currentMarket !== response.data.t1[0].mid
      ) {

        if (this.currentMarket) {
          this.markets.push(this.currentMarket);
        }

        this.currentMarket = response.data.t1[0].mid;
      }
    }
  }

  async getCasinoResults(producer) {
    const response = await getData(process.env.AAA_RESULT_ENDPOINT);
    if (response instanceof Error) {
      return;
    }

    if (response.success === true && response.data instanceof Array) {
      this.markets.forEach((mid, index) => {
        for (let i = 0; i < response.data.length; i++) {
          if (response.data[i].mid === mid) {
            this.markets.splice(index, 1);
            s.debug(`Message emit ${kafkaTopics.CASINO_AMAR_AKBAR_ANTHONY_RESULT.topic}: ${JSON.stringify({ marketId: Number(response.data[i].mid), result: Number(response.data[i].result), casino: this.casino })}`);
            producer.send({
              topic: kafkaTopics.CASINO_AMAR_AKBAR_ANTHONY_RESULT.topic,
              messages: [
                { value: JSON.stringify({ marketId: Number(response.data[i].mid), result: Number(response.data[i].result), casino: this.casino }) }
              ]
            });
          }
        }
      });
    }
  }

  async init(producer) {
    this.casinoHandler(producer);
    this.getCasinoResults(producer);

    setInterval(() => this.casinoHandler(producer), 1000);
    setInterval(() => this.getCasinoResults(producer), 3000);
  }
}

module.exports = AmarAkbarAnthony;
