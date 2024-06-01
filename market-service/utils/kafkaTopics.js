const cricket = {
  CRICKET_COMPETITION_LIST: {
    topic: 'cricket-competition-list',
    numPartitions: 2
  },
  CRICKET_EVENT_LIST: {
    topic: 'cricket-event-list',
    numPartitions: 2
  },
  CRICKET_FIXTURE_LIST: {
    topic: 'cricket-fixture-list',
    numPartitions: 2
  },
  CRICKET_MARKET_CATALOGUE: {
    topic: 'cricket-market-catalogue',
    numPartitions: 2
  },
  CRICKET_MARKET_RESULT: {
    topic: 'cricket-market-result',
    numPartitions: 2
  }
};

const soccer = {
  SOCCER_COMPETITION_LIST: {
    topic: 'soccer-competition-list',
    numPartitions: 2
  },
  SOCCER_EVENT_LIST: {
    topic: 'soccer-event-list',
    numPartitions: 2
  },
  SOCCER_FIXTURE_LIST: {
    topic: 'soccer-fixture-list',
    numPartitions: 2
  },
  SOCCER_MARKET_CATALOGUE: {
    topic: 'soccer-market-catalogue',
    numPartitions: 2
  },
  SOCCER_MARKET_RESULT: {
    topic: 'soccer-market-result',
    numPartitions: 2
  }
};

const tennis = {
  TENNIS_COMPETITION_LIST: {
    topic: 'tennis-competition-list',
    numPartitions: 2
  },
  TENNIS_EVENT_LIST: {
    topic: 'tennis-event-list',
    numPartitions: 2
  },
  TENNIS_FIXTURE_LIST: {
    topic: 'tennis-fixture-list',
    numPartitions: 2
  },
  TENNIS_MARKET_CATALOGUE: {
    topic: 'tennis-market-catalogue',
    numPartitions: 2
  },
  TENNIS_MARKET_RESULT: {
    topic: 'tennis-market-result',
    numPartitions: 2
  }
};

const casino = {
  /* Teen Patti 20 */
  CASINO_TEEN_PATTI_20_CATALOGUE: {
    topic: 'casino-teenpatti20-catalogue',
    numPartitions: 2
  },
  CASINO_TEEN_PATTI_20_RESULT: {
    topic: 'casino-teenpatti20-result',
    numPartitions: 2
  },

  /* Lucky 7B */
  CASINO_LUCKY_7B_CATALOGUE: {
    topic: 'casino-lucky7b-catalogue',
    numPartitions: 2
  },
  CASINO_LUCKY_7B_RESULT: {
    topic: 'casino-lucky7b-result',
    numPartitions: 2
  },

  /* Amar Akbar Anthony */
  CASINO_AMAR_AKBAR_ANTHONY_CATALOGUE: {
    topic: 'casino-aaa-catalogue',
    numPartitions: 2
  },
  CASINO_AMAR_AKBAR_ANTHONY_RESULT: {
    topic: 'casino-aaa-result',
    numPartitions: 2
  }
};

module.exports = {
  ...cricket,
  ...tennis,
  ...soccer,
  ...casino
};
