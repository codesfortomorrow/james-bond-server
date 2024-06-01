const cricket = {
  CRICKET_COMPETITION_LIST: {
    topic: 'cricket-competition-list',
    fromBeginning: false
  },
  CRICKET_EVENT_LIST: {
    topic: 'cricket-event-list',
    fromBeginning: false
  },
  CRICKET_FIXTURE_LIST: {
    topic: 'cricket-fixture-list',
    fromBeginning: false
  },
  CRICKET_MARKET_CATALOGUE: {
    topic: 'cricket-market-catalogue',
    fromBeginning: false
  }
};

const soccer = {
  SOCCER_COMPETITION_LIST: {
    topic: 'soccer-competition-list',
    fromBeginning: false
  },
  SOCCER_EVENT_LIST: {
    topic: 'soccer-event-list',
    fromBeginning: false
  },
  SOCCER_FIXTURE_LIST: {
    topic: 'soccer-fixture-list',
    fromBeginning: false
  },
  SOCCER_MARKET_CATALOGUE: {
    topic: 'soccer-market-catalogue',
    fromBeginning: false
  }
};

const tennis = {
  TENNIS_COMPETITION_LIST: {
    topic: 'tennis-competition-list',
    fromBeginning: false
  },
  TENNIS_EVENT_LIST: {
    topic: 'tennis-event-list',
    fromBeginning: false
  },
  TENNIS_FIXTURE_LIST: {
    topic: 'tennis-fixture-list',
    fromBeginning: false
  },
  TENNIS_MARKET_CATALOGUE: {
    topic: 'tennis-market-catalogue',
    fromBeginning: false
  }
};

const casino = {
  /* Teen Patti 20 */
  CASINO_TEEN_PATTI_20_CATALOGUE: {
    topic: 'casino-teenpatti20-catalogue',
    fromBeginning: false
  },

  /* Lucky 7B */
  CASINO_LUCKY_7B_CATALOGUE: {
    topic: 'casino-lucky7b-catalogue',
    fromBeginning: false
  },

  /* Amar Akbar Anthony */
  CASINO_AMAR_AKBAR_ANTHONY_CATALOGUE: {
    topic: 'casino-aaa-catalogue',
    fromBeginning: false
  }
};

module.exports = {
  ...cricket,
  ...tennis,
  ...soccer,
  ...casino
};
