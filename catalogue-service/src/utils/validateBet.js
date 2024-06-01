/* eslint-disable @typescript-eslint/no-unused-vars */
function validateCricketBet(marketCatalogue, { market, gameType, selectionId, betOn, price, percent }) {
 
  if (marketCatalogue  && marketCatalogue.catalogue instanceof Array) {
    
    const sidMap = marketCatalogue.sidMap;

    if (gameType === 'fancy'||gameType === 'session') {
      const fancyMarket = marketCatalogue.catalogue.filter(m => m.market === gameType && m.market === market);
     
      if (fancyMarket.length) {
        const marketData = fancyMarket[0].runners;
       
        

        for (let i = 0; i < marketData.length; i++) {
          if (Number(marketData[i].SelectionId) === Number(selectionId)) {
          
            if (marketData[i].GameStatus !== '') {
              return new Error('Oops! Bet not allowed due to market suspense');
            }

            if (betOn === 'BACK') {
              console.debug('Market:', market, 'Bet On:', betOn, 'Market Bhav:', Number(marketData[i]?.BackPrice1), 'Bet Bhav:', Number(price), 'Market Percent:', Number(marketData[i]?.BackSize1), 'Bet Percent:', Number(percent));
            } else {
              console.debug('Market:', market, 'Bet On:', betOn, 'Market Bhav:', Number(marketData[i]?.LayPrice1), 'Bet Bhav:', Number(price), 'Market Percent:', Number(marketData[i]?.LaySize1), 'Bet Percent:', Number(percent));
            }

            if (
              betOn === 'BACK' && (Number(marketData[i]?.BackPrice1) !== Number(price) || Number(marketData[i]?.BackSize1) !== Number(percent)) ||
              betOn === 'LAY' && (Number(marketData[i]?.LayPrice1) !== Number(price) || Number(marketData[i]?.LaySize1) !== Number(percent))
            ) {
              return new Error('Oops! Bet not allowed due to market change');
            } else {
              return { price: betOn === 'BACK' ? Number(marketData[i]?.BackPrice1) : Number(marketData[i]?.LayPrice1) };
            }
          }
        }
      }
    } else {
      
      const oddsMarkets = marketCatalogue.catalogue.filter(m => m.market === gameType && m.market === market);
    
        let  runners;
      if (oddsMarkets[0]) {
        if(gameType==='bookmaker'){
           runners = oddsMarkets[0].runners[0].runners;
             
         }
      
         if(gameType==='Match Odds'){
          runners = oddsMarkets[0].runners;
         }
        
        for (const runner of runners) {
          if (Number(runner.selectionId) === Number(selectionId)) {
            const status = runner.status;
            if (status !== 'ACTIVE') {
              return new Error('Oops! Bet not allowed due to market suspense');
            }
  
            if (betOn === 'BACK') {
              console.debug('Market:', market, 'Bet On:', betOn, 'Market Bhav:', Number(runner?.ex?.availableToBack[0]?.price), 'Bet Bhav:', Number(price));
            } else {
              console.debug('Market:', market, 'Bet On:', betOn, 'Market Bhav:', Number(runner?.ex?.availableToLay[0]?.price), 'Bet Bhav:', Number(price));
            }
  
            if (
              betOn === 'BACK' && ((Number(runner?.ex?.availableToBack[0]?.price) - Number(price) < 0) || (Number(runner?.ex?.availableToBack[0]?.price) - Number(price) > 3)) ||
              betOn === 'LAY' && ((Number(price) - Number(runner?.ex?.availableToLay[0]?.price) < 0 || (Number(price) - Number(runner?.ex?.availableToLay[0]?.price) > 3)))
            ) {
              return new Error('Oops! Bet not allowed due to market change');
            } else {
              return { price: betOn === 'BACK' ? Number(runner?.ex?.availableToBack[0]?.price) : Number(runner?.ex?.availableToLay[0]?.price) };
            }
          }
        }
      }
    }
  }

  return new Error('Oops! Market not available');
}

function validateSoccerBet(marketCatalogue, { market, gameType, selectionId, betOn, price }) {
  // console.log('market',JSON.stringify(marketCatalogue),gameType,market)
  if (marketCatalogue  && marketCatalogue.length > 0) {
    
    const oddsMarkets = marketCatalogue.filter(m => m.gameType === gameType && m.market === market);
    // console.log('oddsMarkets.length',oddsMarkets.length)
    if (oddsMarkets.length) {
      // console.log('oddsMarkets[0].runners',oddsMarkets[0].runners)
      const runners = oddsMarkets[0].runners;

      for (const runner of runners) {
        if (Number(runner.selectionId) === Number(selectionId)) {
          const status = runner.status;
          if (status !== 'ACTIVE') {
            return new Error('Oops! Bet not allowed due to market suspense');
          }

          if (betOn === 'BACK') {
            console.debug('Market:', market, 'Bet On:', betOn, 'Market Bhav:', Number(runner?.ex?.availableToBack[0]?.price), 'Bet Bhav:', Number(price));
          } else {
            console.debug('Market:', market, 'Bet On:', betOn, 'Market Bhav:', Number(runner?.ex?.availableToLay[0]?.price), 'Bet Bhav:', Number(price));
          }

          if (
            betOn === 'BACK' && ((Number(runner?.ex?.availableToBack[0]?.price) - Number(price) < 0) || (Number(runner?.ex?.availableToBack[0]?.price) - Number(price) > 3)) ||
            betOn === 'LAY' && ((Number(price) - Number(runner?.ex?.availableToLay[0]?.price) < 0 || (Number(price) - Number(runner?.ex?.availableToLay[0]?.price) > 3)))
          ) {
            return new Error('Oops! Bet not allowed due to market change');
          } else {
            return { price: betOn === 'BACK' ? Number(runner?.ex?.availableToBack[0]?.price) : Number(runner?.ex?.availableToLay[0]?.price) };
          }
        }
      }
    }
  }

  return new Error('Oops! Market not available');
}

function validateTennisBet(marketCatalogue, { market, gameType, selectionId, betOn, price }) {
  if (marketCatalogue instanceof Array) {
    const oddsMarkets = marketCatalogue.filter(m => m.gameType === gameType && m.market === market);

    if (oddsMarkets.length) {
      const runners = oddsMarkets[0].runners;

      for (const runner of runners) {
        if (Number(runner.selectionId) === Number(selectionId)) {
          const status = runner.status;
          if (status !== 'ACTIVE') {
            return new Error('Oops! Bet not allowed due to market suspense');
          }

          if (betOn === 'BACK') {
            console.debug('Market:', market, 'Bet On:', betOn, 'Market Bhav:', Number(runner?.ex?.availableToBack[0]?.price), 'Bet Bhav:', Number(price));
          } else {
            console.debug('Market:', market, 'Bet On:', betOn, 'Market Bhav:', Number(runner?.ex?.availableToLay[0]?.price), 'Bet Bhav:', Number(price));
          }

          if (
            betOn === 'BACK' && ((Number(runner?.ex?.availableToBack[0]?.price) - Number(price) < 0) || (Number(runner?.ex?.availableToBack[0]?.price) - Number(price) > 3)) ||
            betOn === 'LAY' && ((Number(price) - Number(runner?.ex?.availableToLay[0]?.price) < 0 || (Number(price) - Number(runner?.ex?.availableToLay[0]?.price) > 3)))
          ) {
            return new Error('Oops! Bet not allowed due to market change');
          } else {
            return { price: betOn === 'BACK' ? Number(runner?.ex?.availableToBack[0]?.price) : Number(runner?.ex?.availableToLay[0]?.price) };
          }
        }
      }
    }
  }

  return new Error('Oops! Market not available');
}

module.exports = (sport, marketCatalogue, { market, gameType, selectionId, betOn, price, percent }) => {
  switch (sport) {
    case 1:
      return validateSoccerBet(marketCatalogue, { market, gameType, selectionId, betOn, price });
    case 2:
      return validateTennisBet(marketCatalogue, { market, gameType, selectionId, betOn, price });
    case 4:
      return validateCricketBet(marketCatalogue, { market, gameType, selectionId, betOn, price, percent });
    default:
      return new Error('Unknown sport');
  }
};
