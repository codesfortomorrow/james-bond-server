const axios = require('axios');

class Session {

  constructor(eventId) {
    this.eventId = eventId;
    this.status = {
      NA: 'NOT_AVAILABLE',
      NH: 'NOT_HANDLED',
      NP: 'NOT_PROCESSABLE',
      IP: 'IN_PLAY',
      CL: 'CLOSED'
    };
  }

  getTeamShortName(teamName) {
    const parts = teamName.split(' ');
    if (parts.length === 1) {
      return parts[0].slice(0, 3).toUpperCase();
    } else {
      return parts.map(s => s.slice(0, 1)).join('').toUpperCase();
    }
  }

  getRun(str) {
    if (!isNaN(Number(str))) {
      return Number(str);
    } else {
      const run = str.match(/\d/);
      if (run) {
        return Number(run[0]);
      } else {
        return 0;
      }
    }
  }

  isBall(str) {
    if (!isNaN(Number(str))) {
      return 1;
    } else {
      if (/^\dw|n$/i.test(str)) {
        return 0;
      } else {
        return 1;
      }
    }
  }

  isPlayerNameMatched(playerName, timelinePlayerName) {
    if (playerName.toLowerCase() === timelinePlayerName.toLowerCase()) {
      return true;
    }

    const timelinePlayerNameParts = timelinePlayerName.split(' ').filter(i => i.length);

    if (timelinePlayerNameParts.length > 1) {
      let timelinePlayerModifiedName = '';

      for (let i = 0; i < timelinePlayerNameParts.length - 1; i++) {
        timelinePlayerModifiedName += timelinePlayerNameParts[i].slice(0, 1);
        timelinePlayerModifiedName += ' ';
      }

      timelinePlayerModifiedName += timelinePlayerNameParts[timelinePlayerNameParts.length - 1];

      if (playerName.toLowerCase() === timelinePlayerModifiedName.toLowerCase()) {
        return true;
      }
    }

    return false;
  }

  isTeamNameMatched(session, teamName) {
    const teamShortName = this.getTeamShortName(teamName);
    if (session.indexOf(teamShortName) !== -1) {
      return true;
    }

    if (teamShortName.indexOf('T') === 0 && session.indexOf(teamShortName.slice(1)) !== -1) {
      return true;
    }

    return false;
  }

  getWicketDescription(fallOfwickets, wicket) {
    while (wicket <= fallOfwickets.length) {
      if (fallOfwickets[Number(wicket) - 1].match(/\d+\/\d+/g)) {
        return fallOfwickets[Number(wicket) - 1];
      } else {
        wicket++;
      }
    }
  }

  filterSessionString(session) {
    session = session.replace(/(\s*[.])$/g, '');
    session = session.replace(/(\s+\d)$/g, '');
    session = session.replace(/\s*adv(\s+\d+)?$/g, '');
    session = session.replace(/\s+bhav/g, ' ');
    session = session.replace(/\(\s*[A-Z]+\s+vs\s+[A-Z]+\s*\)/g, '');
    return session;
  }

  sendResponse(status, data, message) {
    return {
      status,
      data: data || data == 0 ? data : null,
      message: message ? message : null
    };
  }

  getSessionHandler(_session) {
    switch (true) {
      case /^(match\s+\d+[a-z]+\s+over\s+(?:run|runs))(\s+bhav)?(\s*\(\s*[a-z]+\s+vs\s+[a-z]+\s*\))?(\s*adv)?(\s*[.])?$/i.test(_session):
        return this.getMatchNthOverRun.name;
      case /^(total\s+match\s+fifties)(\s+bhav)?(\s*\(\s*[a-z]+\s+vs\s+[a-z]+\s*\))?(\s*adv)?(\s*[.])?$/i.test(_session):
        return this.getMatchTotalFifties.name;
      case /^(total\s+match\s+bowled)(\s+bhav)?(\s*\(\s*[a-z]+\s+vs\s+[a-z]+\s*\))?(\s*adv)?(\s*[.])?$/i.test(_session):
        return this.getMatchTotalBowledWkt.name;
      case /^(total\s+match\s+caught\s+outs)(\s+bhav)?(\s*\(\s*[a-z]+\s+vs\s+[a-z]+\s*\))?(\s*adv)?(\s*[.])?$/i.test(_session):
        return this.getMatchTotalCaughtWkt.name;
      case /^(total\s+match\s+lbw)(\s+bhav)?(\s*\(\s*[a-z]+\s+vs\s+[a-z]+\s*\))?(\s*adv)?(\s*[.])?$/i.test(_session):
        return this.getMatchTotalLBWWkt.name;
      case /^(total\s+match\s+extras)(\s+bhav)?(\s*\(\s*[a-z]+\s+vs\s+[a-z]+\s*\))?(\s*adv)?(\s*[.])?$/i.test(_session):
        return this.getMatchTotalExtras.name;
      case /^(total\s+match\s+wides)(\s+bhav)?(\s*\(\s*[a-z]+\s+vs\s+[a-z]+\s*\))?(\s*adv)?(\s*[.])?$/i.test(_session):
        return this.getMatchTotalWides.name;
      case /^(total\s+match\s+wkts)(\s+bhav)?(\s*\(\s*[a-z]+\s+vs\s+[a-z]+\s*\))?(\s*adv)?(\s*[.])?$/i.test(_session):
        return this.getMatchTotalWkts.name;
      case /^(total\s+match\s+(?:fours|boundaries))(\s+bhav)?(\s*\(\s*[a-z]+\s+vs\s+[a-z]+\s*\))?(\s*adv)?(\s*[.])?$/i.test(_session):
        return this.getMatchTotalBoundaries.name;
      case /^(total\s+match\s+sixes)(\s+bhav)?(\s*\(\s*[a-z]+\s+vs\s+[a-z]+\s*\))?(\s*adv)?(\s*[.])?$/i.test(_session):
        return this.getMatchTotalSixes.name;
      case /^(highest\s+scoring\s+over\s+in\s+match)(\s+bhav)?(\s*\(\s*[a-z]+\s+vs\s+[a-z]+\s*\))?(\s*adv)?(\s*[.])?$/i.test(_session):
        return this.getMatchHighestScoringOver.name;
      case /^(top\s+batsman\s+(?:run|runs)\s+in\s+match)(\s+bhav)?(\s*\(\s*[a-z]+\s+vs\s+[a-z]+\s*\))?(\s*adv)?(\s*[.])?$/i.test(_session):
        return this.getMatchTopBatsmanRuns.name;
      case /^(\d+\s+wkt\s+or\s+more\s+by\s+bowler\s+in\s+match)(\s+bhav)?(\s*\(\s*[a-z]+\s+vs\s+[a-z]+\s*\))?(\s*adv)?(\s*[.])?$/i.test(_session):
        return this.getMatchTopBowlerWkts.name;
      case /^(\d+[a-z]+\s+(?:inning|innings)\s+(?:run|runs))(\s+bhav)?(?:\s+[a-z]+|\s+[a-z]+\s*\(\s*[a-z]+\s+vs\s+[a-z]+\s*\))?(\s*adv)?(\s*[.])?$/i.test(_session):
        return this.getMatchInningRuns.name;
      case /^((only\s+)?(?:\d+[.]\d|\d+)\s+over\s+(?:run|runs))(\s+bhav)?(?:\s+[a-z]+|\s+[a-z]+\s*\(\s*[a-z]+\s+vs\s+[a-z]+\s*\))(\s*adv)?(\s+\d+)?(\s*[.])?$/i.test(_session):
        return this.getTeamOverRun.name;
      case /^(\d+\s+run)(\s+bhav)?(?:\s+[a-z]+|\s+[a-z]+\s*\(\s*[a-z]+\s+vs\s+[a-z]+\s*\))(\s*adv)?(\s+\d+)?(\s*[.])?$/i.test(_session):
        return this.getTeamRun.name;
      case /^(fall\s+of\s+\d+[a-z]+\s+wkt)(\s+(?:run|runs))?(\s+bhav)?(?:\s+[a-z]+|\s+[a-z]+\s*\(\s*[a-z]+\s+vs\s+[a-z]+\s*\))(\s*adv)?(\s+\d+)?(\s*[.])?$/i.test(_session):
        return this.getTeamNthWktRun.name;
      case /^(\d+[.]\d\s+ball\s+(?:run|runs))(\s+bhav)?(?:\s+[a-z]+|\s+[a-z]+\s*\(\s*[a-z]+\s+vs\s+[a-z]+\s*\))(\s*adv)?(\s+\d+)?(\s*[.])?$/i.test(_session):
        return this.getTeamNthBallRun.name;
      case /^(\d+[a-z]+\s+wkt\s+pship\s+boundaries)(\s+bhav)?(?:\s+[a-z]+|\s+[a-z]+\s*\(\s*[a-z]+\s+vs\s+[a-z]+\s*\))(\s*adv)?(\s+\d+)?(\s*[.])?$/i.test(_session):
        return this.getTeamNthWktBoundaries.name;
      case /^([a-z\s,.'-]+\s+(?:run|runs))(\s+bhav)?(\s+[a-z]+)?(\s*\(\s*[a-z]+\s+vs\s+[a-z]+\s*\))?(\s*adv)?(\s+\d+)?(\s*[.])?$/i.test(_session):
        return this.getPlayerRun.name;
      case /^(how\s+many\s+balls\s+face\s+by\s+[a-z\s,.'-]+)(\s+bhav)?(\s+[a-z]+)?(\s*\(\s*[a-z]+\s+vs\s+[a-z]+\s*\))?(\s*adv)?(\s+\d+)?(\s*[.])?$/i.test(_session):
        return this.getPlayerFacedBallsCount.name;
      case /^([a-z\s,.'-]+\s+boundaries)(\s+bhav)?(\s+[a-z]+)?(\s*\(\s*[a-z]+\s+vs\s+[a-z]+\s*\))?(\s*adv)?(\s+\d+)?(\s*[.])?$/i.test(_session):
        return this.getPlayerBoundaries.name;
      default:
        return null;
    }
  }

  isSessionProcessable(_session) {
    if (this.getSessionHandler(_session)) {
      return true;
    } else {
      return false;
    }
  }

  async getSessionResult(_session) {
    try {
      const handler = this.getSessionHandler(_session);

      if (handler) {
        return (this[handler])(_session);
      } else {
        return null;
      }
    } catch (err) {
      return err;
    }
  }

  async fetchTimelineData() {
    try {
      const fetchScoreUrlResponse = await axios.get(`${process.env.CRICKET_TIMELINE_ENDPOINT}/${this.eventId}`);

      if (fetchScoreUrlResponse.status === 200 && fetchScoreUrlResponse.data.score !== '') {
        const response = await axios.get(fetchScoreUrlResponse.data.score);

        if (response.status === 200) {
          if (
            response.data.doc instanceof Array &&
            response.data.doc[0] &&
            response.data.doc[0].data &&
            response.data.doc[0].data.response_code === 'OK'
          ) {
            return response.data.doc[0].data.score;
          } else {
            return null;
          }
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (err) {
      console.error(err);
      return err;
    }
  }

  // Handler to resolve session
  // - Match x over run
  async getMatchNthOverRun(session) {
    try {
      const timelineData = await this.fetchTimelineData(this.eventId);
      if (timelineData instanceof Error || !timelineData) {
        return null;
      }

      session = this.filterSessionString(session);
      session = session.trim();

      const [targetOver] = session.match(/^(?:\d+[.]\d)|\d+/g);

      if (!targetOver) {
        return this.sendResponse(this.status.NP, null, 'Invalid session over');
      }

      const currentOver = timelineData.innings[0].overs;

      if (targetOver <= currentOver) {
        const overSummaries = timelineData.ballByBallSummaries;
        const eachBallRun = overSummaries[targetOver - 1]['firstInnings'].split(',');
        const totalBalls = eachBallRun.length;
        const maxOverBallsToTraverse = 6;

        let score = 0;
        let counterOfBall = 0;

        for (let k = 0; k < totalBalls; k++) {
          if (counterOfBall <= maxOverBallsToTraverse) {
            const element = eachBallRun[k];

            score += this.getRun(element);
            counterOfBall += this.isBall(element);
          }
        }
        return this.sendResponse(this.status.CL, score);
      } else if (timelineData.matchStatus === 4 || timelineData.innings[0].conclusion !== 'In Progress') {
        return this.sendResponse(this.status.CL, timelineData.innings[0].runs);
      } else {
        return this.sendResponse(this.status.IP);
      }
    } catch (err) {
      return err;
    }
  }

  // Handler to resolve session
  // - Total match Fifties
  async getMatchTotalFifties() {
    try {
      const timelineData = await this.fetchTimelineData(this.eventId);
      if (timelineData instanceof Error || !timelineData) {
        return null;
      }

      if (timelineData.matchStatus !== 4) {
        return this.sendResponse(this.status.IP);
      }

      let totalFifties = 0;

      for (let i = 0; i < timelineData.innings.length; i++) {
        for (let k = 0; k < timelineData.innings[i].batsmen.length; k++) {
          const playerRuns = timelineData.innings[i].batsmen[k].runs;
          if (playerRuns >= 50) {
            totalFifties++;
          }
        }
      }

      return this.sendResponse(this.status.CL, totalFifties);
    } catch (err) {
      return err;
    }
  }

  // Handler to resolve session
  // - Total match bowled
  async getMatchTotalBowledWkt() {
    try {
      const timelineData = await this.fetchTimelineData(this.eventId);
      if (timelineData instanceof Error || !timelineData) {
        return null;
      }

      if (timelineData.matchStatus !== 4) {
        return this.sendResponse(this.status.IP);
      }

      let totalBowled = 0;

      for (let i = 0; i < timelineData.innings.length; i++) {
        const batsmenList = timelineData.innings[i].batsmen;
        for (let k = 0; k < batsmenList.length; k++) {
          if (!batsmenList[k].didNotBat && batsmenList[k].description === 'Bowled') {
            totalBowled++;
          }
        }
      }

      return this.sendResponse(this.status.CL, totalBowled);
    } catch (err) {
      return err;
    }
  }

  // Handler to resolve session
  // - Total match caught outs
  async getMatchTotalCaughtWkt() {
    try {
      const timelineData = await this.fetchTimelineData(this.eventId);
      if (timelineData instanceof Error || !timelineData) {
        return null;
      }

      if (timelineData.matchStatus !== 4) {
        return this.sendResponse(this.status.IP);
      }

      let totalCaught = 0;

      for (let i = 0; i < timelineData.innings.length; i++) {
        const batsmenList = timelineData.innings[i].batsmen;
        for (let k = 0; k < batsmenList.length; k++) {
          if (!batsmenList[k].didNotBat && batsmenList[k].description && batsmenList[k].description.indexOf('Catch') !== -1) {
            totalCaught++;
          }
        }
      }

      return this.sendResponse(this.status.CL, totalCaught);
    } catch (err) {
      return err;
    }
  }

  // Handler to resolve session
  // - Total match LBW
  async getMatchTotalLBWWkt() {
    try {
      const timelineData = await this.fetchTimelineData(this.eventId);
      if (timelineData instanceof Error || !timelineData) {
        return null;
      }

      if (timelineData.matchStatus !== 4) {
        return this.sendResponse(this.status.IP);
      }

      let totalLBW = 0;

      for (let i = 0; i < timelineData.innings.length; i++) {
        const batsmenList = timelineData.innings[i].batsmen;
        for (let k = 0; k < batsmenList.length; k++) {
          if (!batsmenList[k].didNotBat && batsmenList[k].description === 'LBW') {
            totalLBW++;
          }
        }
      }

      return this.sendResponse(this.status.CL, totalLBW);
    } catch (err) {
      return err;
    }
  }

  // Handler to resolve session
  // - Total match extras
  async getMatchTotalExtras() {
    try {
      const timelineData = await this.fetchTimelineData(this.eventId);
      if (timelineData instanceof Error || !timelineData) {
        return null;
      }

      if (timelineData.matchStatus !== 4) {
        return this.sendResponse(this.status.IP);
      }

      let totalExtras = 0;

      for (let i = 0; i < timelineData.innings.length; i++) {
        Object.values(timelineData.innings[i].extrasSummary).forEach(i => {
          totalExtras += i;
        });
      }

      return this.sendResponse(this.status.CL, totalExtras);
    } catch (err) {
      return err;
    }
  }

  // Handler to resolve session
  // - Total match wides
  async getMatchTotalWides() {
    try {
      const timelineData = await this.fetchTimelineData(this.eventId);
      if (timelineData instanceof Error || !timelineData) {
        return null;
      }

      if (timelineData.matchStatus !== 4) {
        return this.sendResponse(this.status.IP);
      }

      let totalWides = 0;

      for (let i = 0; i < timelineData.innings.length; i++) {
        totalWides += timelineData.innings[i].extrasSummary.wides;
      }

      return this.sendResponse(this.status.CL, totalWides);
    } catch (err) {
      return err;
    }
  }

  // Handler to resolve session
  // - Total match wkts
  async getMatchTotalWkts() {
    try {
      const timelineData = await this.fetchTimelineData(this.eventId);
      if (timelineData instanceof Error || !timelineData) {
        return null;
      }

      if (timelineData.matchStatus !== 4) {
        return this.sendResponse(this.status.IP);
      }

      let totalWickets = 0;

      for (let i = 0; i < timelineData.innings.length; i++) {
        totalWickets += timelineData.innings[i].wickets;
      }

      return this.sendResponse(this.status.CL, totalWickets);
    } catch (err) {
      return err;
    }
  }

  // Handler to resolve session
  // - Total match boundaries
  async getMatchTotalBoundaries() {
    try {
      const timelineData = await this.fetchTimelineData(this.eventId);
      if (timelineData instanceof Error || !timelineData) {
        return null;
      }

      if (timelineData.matchStatus !== 4) {
        return this.sendResponse(this.status.IP);
      }

      let totalBoundaries = 0;

      for (let i = 0; i < timelineData.innings.length; i++) {
        const batsmenList = timelineData.innings[i].batsmen;
        for (let k = 0; k < batsmenList.length; k++) {
          totalBoundaries += batsmenList[k].fours;
        }
      }

      return this.sendResponse(this.status.CL, totalBoundaries);
    } catch (err) {
      return err;
    }
  }

  // Handler to resolve session
  // - Total match sixes
  async getMatchTotalSixes() {
    try {
      const timelineData = await this.fetchTimelineData(this.eventId);
      if (timelineData instanceof Error || !timelineData) {
        return null;
      }

      if (timelineData.matchStatus !== 4) {
        return this.sendResponse(this.status.IP);
      }

      let totalSixes = 0;

      for (let i = 0; i < timelineData.innings.length; i++) {
        const batsmenList = timelineData.innings[i].batsmen;
        for (let k = 0; k < batsmenList.length; k++) {
          totalSixes += batsmenList[k].sixes;
        }
      }

      return this.sendResponse(this.status.CL, totalSixes);
    } catch (err) {
      return err;
    }
  }

  // Handler to resolve session
  // - Highest scoring over in match
  async getMatchHighestScoringOver() {
    try {
      const timelineData = await this.fetchTimelineData(this.eventId);
      if (timelineData instanceof Error || !timelineData) {
        return null;
      }

      if (timelineData.matchStatus !== 4) {
        return this.sendResponse(this.status.IP);
      }

      const lastInning = timelineData.currentInningsNumber;
      const overSummaries = timelineData.ballByBallSummaries;
      const inningOptions = ['firstInnings', 'secondInnings', 'thirdInnings', 'fourthInnings'];

      let highestScoringOver = 0;
      let maxRunsInOver = 0;

      for (let i = 0; i < lastInning; i++) {
        const inning = inningOptions[i];
        const lastOver = timelineData.innings[i].overs;

        for (let j = 0; j < lastOver; j++) {
          const eachBallRun = overSummaries[j][inning].split(',');
          const totalBalls = eachBallRun.length;
          const maxOverBallsToTraverse = 6;

          let counterOfBall = 0;
          let overScore = 0;

          for (let k = 0; k < totalBalls; k++) {
            if (counterOfBall <= maxOverBallsToTraverse) {
              const element = eachBallRun[k];

              overScore += this.getRun(element);
              counterOfBall += this.isBall(element);
            }
          }

          if (overScore > maxRunsInOver) {
            maxRunsInOver = overScore;
            highestScoringOver = j + 1;
          }
        }
      }
      return this.sendResponse(this.status.CL, highestScoringOver);
    } catch (err) {
      return err;
    }
  }

  // Handler to resolve session
  // - Top batsman runs in match
  async getMatchTopBatsmanRuns() {
    try {
      const timelineData = await this.fetchTimelineData(this.eventId);
      if (timelineData instanceof Error || !timelineData) {
        return null;
      }

      if (timelineData.matchStatus !== 4) {
        return this.sendResponse(this.status.IP);
      }

      let playerHighestRuns = 0;

      for (let i = 0; i < timelineData.innings.length; i++) {
        const batsmenList = timelineData.innings[i].batsmen;
        for (let k = 0; k < batsmenList.length; k++) {
          if (batsmenList[k].runs > playerHighestRuns) {
            playerHighestRuns = batsmenList[k].runs;
          }
        }
      }

      return this.sendResponse(this.status.CL, playerHighestRuns);
    } catch (err) {
      return err;
    }
  }

  // Handler to resolve session
  // - 2 wkt or more by bowler in match
  async getMatchTopBowlerWkts() {
    try {
      const timelineData = await this.fetchTimelineData(this.eventId);
      if (timelineData instanceof Error || !timelineData) {
        return null;
      }

      if (timelineData.matchStatus !== 4) {
        return this.sendResponse(this.status.IP);
      }

      let bowlerHighestWkts = 0;

      for (let i = 0; i < timelineData.innings.length; i++) {
        const bowlers = timelineData.innings[i].bowlers;
        for (let k = 0; k < bowlers.length; k++) {
          if (bowlers[k].wickets > bowlerHighestWkts) {
            bowlerHighestWkts = bowlers[k].wickets;
          }
        }
      }

      return this.sendResponse(this.status.CL, bowlerHighestWkts);
    } catch (err) {
      return err;
    }
  }

  // Handler to resolve session
  // - x inning run
  async getMatchInningRuns(session) {
    const timelineData = await this.fetchTimelineData(this.eventId);
    if (timelineData instanceof Error || !timelineData) {
      return null;
    }

    session = this.filterSessionString(session);
    session = session.trim();

    const [targetInning] = session.match(/\d+/g);

    if (!targetInning) {
      return this.sendResponse(this.status.NP, null, 'Invalid session inning');
    }

    const currentInning = timelineData.currentInningsNumber;

    if (timelineData.matchStatus === 4 || timelineData.innings[currentInning - 1].conclusion !== 'In Progress') {
      return this.sendResponse(this.status.CL, timelineData.innings[currentInning - 1].runs);
    }

    return this.sendResponse(this.status.IP);
  }

  // Handler to resolve session
  // - x run XXX
  async getTeamRun(session) {
    try {
      const timelineData = await this.fetchTimelineData(this.eventId);
      if (timelineData instanceof Error || !timelineData) {
        return null;
      }

      const targetInning = session.match(/\d$/g) ? Number(session.match(/\d$/g)[0]) : 0;

      if (isNaN(targetInning) || (targetInning !== 0 && targetInning !== 2)) {
        return this.sendResponse(this.status.NP, null, 'Invalid session inning');
      }

      session = this.filterSessionString(session);
      session = session.trim();

      const [targetRun] = session.match(/\d+/g);

      if (!targetRun) {
        return this.sendResponse(this.status.NP, null, 'Invalid session run');
      }

      const currentInning = timelineData.currentInningsNumber;

      for (let i = targetInning; i < currentInning; i++) {
        const teamName = timelineData.innings[i].teamName;

        if (this.isTeamNameMatched(session, teamName)) {
          if (timelineData.matchStatus === 4 || timelineData.innings[i].conclusion !== 'In Progress') {
            return this.sendResponse(this.status.CL, timelineData.innings[i].runs);
          } else {
            return this.sendResponse(this.status.IP);
          }
        }
      }

      if ((targetInning === 0 && currentInning < 2) || (targetInning === 2 && currentInning < 4)) {
        return this.sendResponse(this.status.IP);
      } else {
        return this.sendResponse(this.status.NP, null, 'Team name not found');
      }
    } catch (err) {
      return err;
    }
  }

  // Handler to resolve session
  // - Only x over run XXX
  // - x over run XXX
  // - x.x over run XXX
  async getTeamOverRun(session) {
    try {
      const timelineData = await this.fetchTimelineData(this.eventId);
      if (timelineData instanceof Error || !timelineData) {
        return null;
      }

      let isOverOnly = false;

      if (session.match(/^(only\s+)/gi)) {
        isOverOnly = true;
      }

      const targetInning = session.match(/\d$/g) ? Number(session.match(/\d$/g)[0]) : 0;

      if (isNaN(targetInning) || (targetInning !== 0 && targetInning !== 2)) {
        return this.sendResponse(this.status.NP, null, 'Invalid session inning');
      }

      session = this.filterSessionString(session);
      session = session.replace(/^(only\s+)/gi, '');
      session = session.trim();

      const [targetOver] = session.match(/^(?:\d+[.]\d)|\d+/g);

      if (!targetOver) {
        return this.sendResponse(this.status.NP, null, 'Invalid session over');
      }

      const [over, balls] = targetOver.split('.');

      if (isNaN(Number(over)) || (balls && isNaN(Number(balls)))) {
        return this.sendResponse(this.status.NP, null, 'Invalid session over');
      }

      const currentInning = timelineData.currentInningsNumber;
      const inningOptions = ['firstInnings', 'secondInnings', 'thirdInnings', 'fourthInnings'];

      for (let i = targetInning; i < currentInning; i++) {
        const teamName = timelineData.innings[i].teamName;
        const overSummaries = timelineData.ballByBallSummaries;
        const inning = inningOptions[i];
        const currentOver = timelineData.innings[i].overs;

        if (this.isTeamNameMatched(session, teamName)) {
          if (targetOver <= currentOver) {
            let score = 0;

            if (isOverOnly) {
              const eachBallRun = overSummaries[balls ? over : over - 1][inning].split(',');
              const totalBalls = eachBallRun.length;
              const maxOverBallsToTraverse = balls ? Number(balls) : 6;

              let counterOfBall = 0;

              for (let k = 0; k < totalBalls; k++) {
                if (counterOfBall <= maxOverBallsToTraverse) {
                  const element = eachBallRun[k];

                  score += this.getRun(element);
                  counterOfBall += this.isBall(element);
                }
              }
            } else {
              for (let j = 0; j < targetOver; j++) {
                const eachBallRun = overSummaries[j][inning].split(',');
                const totalBalls = eachBallRun.length;
                const maxOverBallsToTraverse = j + 1 > targetOver && balls ? Number(balls) : 6;

                let counterOfBall = 0;

                for (let k = 0; k < totalBalls; k++) {
                  if (counterOfBall <= maxOverBallsToTraverse) {
                    const element = eachBallRun[k];

                    score += this.getRun(element);
                    counterOfBall += this.isBall(element);
                  }
                }
              }
            }
            return this.sendResponse(this.status.CL, score);
          } else if (timelineData.matchStatus === 4 || timelineData.innings[i].conclusion !== 'In Progress') {
            return this.sendResponse(this.status.CL, timelineData.innings[i].runs);
          } else {
            return this.sendResponse(this.status.IP);
          }
        }
      }

      if ((targetInning === 0 && currentInning < 2) || (targetInning === 2 && currentInning < 4)) {
        return this.sendResponse(this.status.IP);
      } else {
        return this.sendResponse(this.status.NP, null, 'Team name not found');
      }
    } catch (err) {
      return err;
    }
  }

  // Handler to resolve session
  // - Fall of x wkt XXX
  async getTeamNthWktRun(session) {
    try {
      const timelineData = await this.fetchTimelineData(this.eventId);
      if (timelineData instanceof Error || !timelineData) {
        return null;
      }

      const targetInning = session.match(/\d$/g) ? Number(session.match(/\d$/g)[0]) : 0;

      if (isNaN(targetInning) || (targetInning !== 0 && targetInning !== 2)) {
        return this.sendResponse(this.status.NP, null, 'Invalid session inning');
      }

      session = this.filterSessionString(session);
      session = session.trim();

      const [targetWicket] = session.match(/\d+/g);

      if (!targetWicket || isNaN(Number(targetWicket)) || Number(targetWicket) > 10) {
        return this.sendResponse(this.status.NP, null, 'Invalid session wicket');
      }

      const currentInning = timelineData.currentInningsNumber;

      for (let i = targetInning; i < currentInning; i++) {
        const teamName = timelineData.innings[i].teamName;

        if (this.isTeamNameMatched(session, teamName)) {
          let currentWickets = timelineData.innings[i].wickets;

          if (targetWicket <= currentWickets) {
            const fallOfwickets = timelineData.innings[i].fallOfwickets.split(', ').filter(i => i.length);
            const wicketDescription = this.getWicketDescription(fallOfwickets, targetWicket);

            const [teamScoreOnWicket] = wicketDescription.match(/\d+\/\d+/g);
            const [teamRun] = teamScoreOnWicket.split('/');

            return this.sendResponse(this.status.CL, teamRun);
          } else {
            return this.sendResponse(this.status.IP);
          }
        }
      }

      if ((targetInning === 0 && currentInning < 2) || (targetInning === 2 && currentInning < 4)) {
        return this.sendResponse(this.status.IP);
      } else {
        return this.sendResponse(this.status.NP, null, 'Team name not found');
      }
    } catch (err) {
      return err;
    }
  }

  // Handler to resolve session
  // - x.x ball run XXX
  async getTeamNthBallRun(session) {
    try {
      const timelineData = await this.fetchTimelineData(this.eventId);
      if (timelineData instanceof Error || !timelineData) {
        return null;
      }

      const targetInning = session.match(/\d$/g) ? Number(session.match(/\d$/g)[0]) : 0;

      if (isNaN(targetInning) || (targetInning !== 0 && targetInning !== 2)) {
        return this.sendResponse(this.status.NP, null, 'Invalid session inning');
      }

      session = this.filterSessionString(session);
      session = session.trim();

      const [targetOver] = session.match(/^\d+[.]\d/g);

      if (!targetOver) {
        return this.sendResponse(this.status.NP, null, 'Invalid session ball');
      }

      const [over, ball] = targetOver.split('.');

      if (isNaN(Number(over)) || isNaN(Number(ball))) {
        return this.sendResponse(this.status.NP, null, 'Invalid session ball');
      }

      const currentInning = timelineData.currentInningsNumber;
      const inningOptions = ['firstInnings', 'secondInnings', 'thirdInnings', 'fourthInnings'];

      for (let i = targetInning; i < currentInning; i++) {
        const teamName = timelineData.innings[i].teamName;
        const overSummaries = timelineData.ballByBallSummaries;
        const inning = inningOptions[i];
        const currentOver = timelineData.innings[i].overs;

        if (this.isTeamNameMatched(session, teamName)) {
          if (targetOver <= currentOver) {
            const eachBallRun = overSummaries[over][inning].split(',');
            const totalBalls = eachBallRun.length;

            let score = 0;
            let counterOfBall = 0;

            for (let k = 0; k < totalBalls; k++) {
              const element = eachBallRun[k];
              counterOfBall += this.isBall(element);
              if (counterOfBall === Number(ball)) {
                score += this.getRun(element);
                break;
              }
            }
            return this.sendResponse(this.status.CL, score);
          } else {
            return this.sendResponse(this.status.IP);
          }
        }
      }

      if ((targetInning === 0 && currentInning < 2) || (targetInning === 2 && currentInning < 4)) {
        return this.sendResponse(this.status.IP);
      } else {
        return this.sendResponse(this.status.NP, null, 'Team name not found');
      }
    } catch (err) {
      return err;
    }
  }

  // Handler to resolve session
  // - x wkt pship boundaries XXX
  async getTeamNthWktBoundaries(session) {
    try {
      const timelineData = await this.fetchTimelineData(this.eventId);
      if (timelineData instanceof Error || !timelineData) {
        return null;
      }

      const targetInning = session.match(/\d$/g) ? Number(session.match(/\d$/g)[0]) : 0;

      if (isNaN(targetInning) || (targetInning !== 0 && targetInning !== 2)) {
        return this.sendResponse(this.status.NP, null, 'Invalid session inning');
      }

      session = this.filterSessionString(session);
      session = session.trim();

      const [targetWicket] = session.match(/^\d+/g);

      if (!targetWicket || isNaN(Number(targetWicket)) || Number(targetWicket) > 10) {
        return this.sendResponse(this.status.NP, null, 'Invalid session wicket');
      }

      const currentInning = timelineData.currentInningsNumber;
      const inningOptions = ['firstInnings', 'secondInnings', 'thirdInnings', 'fourthInnings'];
      const overSummaries = timelineData.ballByBallSummaries;

      for (let i = targetInning; i < currentInning; i++) {
        const teamName = timelineData.innings[i].teamName;
        const inning = inningOptions[i];

        if (this.isTeamNameMatched(session, teamName)) {
          const currentWickets = timelineData.innings[i].wickets;

          if (Number(targetWicket) <= currentWickets) {
            const fallOfwickets = timelineData.innings[i].fallOfwickets.split(', ').filter(i => i.length);

            const prevWicketDescription = targetWicket > 1 ? this.getWicketDescription(fallOfwickets, targetWicket - 1) : null;
            const targetWicketDescription = this.getWicketDescription(fallOfwickets, targetWicket);

            const [prevWicketOver, prevWicketBall] = targetWicket > 1 ? prevWicketDescription.match(/\d+[.]\d+/g)[0].split('.') : [0, 0];
            const [targetWicketOver, targetWicketBall] = targetWicketDescription.match(/\d+[.]\d+/g)[0].split('.');

            let totalBoundaries = 0;

            for (let j = prevWicketOver; j <= targetWicketOver; j++) {
              const eachBallRun = overSummaries[j][inning].split(',');
              const totalBalls = eachBallRun.length;

              let counterOfBall = 0;

              for (let k = 0; k < totalBalls; k++) {
                if (j === prevWicketOver && k < prevWicketBall) {
                  continue;
                }

                if (j === targetWicketOver && k > targetWicketBall) {
                  continue;
                }

                if (counterOfBall <= 6) {
                  const element = eachBallRun[k];
                  if (this.getRun(element) === 4) {
                    totalBoundaries++;
                  }
                  counterOfBall += this.isBall(element);
                }
              }
            }
            return this.sendResponse(this.status.CL, totalBoundaries);
          } else {
            return this.sendResponse(this.status.IP);
          }
        }
      }

      if ((targetInning === 0 && currentInning < 2) || (targetInning === 2 && currentInning < 4)) {
        return this.sendResponse(this.status.IP);
      } else {
        return this.sendResponse(this.status.NP, null, 'Team name not found');
      }
    } catch (err) {
      return err;
    }
  }

  // Handler to resolve session
  // - {Player Name} run
  async getPlayerRun(session) {
    try {
      const timelineData = await this.fetchTimelineData(this.eventId);
      if (timelineData instanceof Error || !timelineData) {
        return null;
      }

      const targetInning = session.match(/\d$/g) ? Number(session.match(/\d$/g)[0]) : 0;

      if (isNaN(targetInning) || (targetInning !== 0 && targetInning !== 2)) {
        return this.sendResponse(this.status.NP, null, 'Invalid session inning');
      }

      session = this.filterSessionString(session);
      session = session.trim();

      const playerName = session.match(/^([a-z\s,.'-]+\s+run)/gi)[0].split(' run')[0];

      const currentInning = timelineData.currentInningsNumber;

      for (let i = targetInning; i < currentInning; i++) {
        const batsmenList = timelineData.innings[i].batsmen;
        for (let k = 0; k < batsmenList.length; k++) {
          if (this.isPlayerNameMatched(playerName.trim(), batsmenList[k].batsmanName.trim())) {
            if (
              (!batsmenList[k].didNotBat && !batsmenList[k].active) ||
              (timelineData.matchStatus === 4 || timelineData.innings[i].conclusion !== 'In Progress')
            ) {
              return this.sendResponse(this.status.CL, batsmenList[k].runs);
            } else {
              return this.sendResponse(this.status.IP);
            }
          }
        }
      }

      if ((targetInning === 0 && currentInning < 2) || (targetInning === 2 && currentInning < 4)) {
        return this.sendResponse(this.status.IP);
      } else {
        return this.sendResponse(this.status.NP, null, 'Player name not found');
      }
    } catch (err) {
      return err;
    }
  }

  // Handler to resolve session
  // - How many balls face by {Player Name}
  async getPlayerFacedBallsCount(session) {
    try {
      const timelineData = await this.fetchTimelineData(this.eventId);
      if (timelineData instanceof Error || !timelineData) {
        return null;
      }

      const targetInning = session.match(/\d$/g) ? Number(session.match(/\d$/g)[0]) : 0;

      if (isNaN(targetInning) || (targetInning !== 0 && targetInning !== 2)) {
        return this.sendResponse(this.status.NP, null, 'Invalid session inning');
      }

      session = this.filterSessionString(session);
      session = session.trim();

      const playerName = session.match(/\s+by\s+([a-z\s,.'-]+)$/gi)[0].split(' by ')[1];

      const currentInning = timelineData.currentInningsNumber;

      for (let i = targetInning; i < currentInning; i++) {
        const batsmenList = timelineData.innings[i].batsmen;
        for (let k = 0; k < batsmenList.length; k++) {
          if (this.isPlayerNameMatched(playerName.trim(), batsmenList[k].batsmanName.trim())) {
            if (
              (!batsmenList[k].didNotBat && !batsmenList[k].active) ||
              (timelineData.matchStatus === 4 || timelineData.innings[i].conclusion !== 'In Progress')
            ) {
              return this.sendResponse(this.status.CL, batsmenList[k].balls);
            } else {
              return this.sendResponse(this.status.IP);
            }
          }
        }
      }

      if ((targetInning === 0 && currentInning < 2) || (targetInning === 2 && currentInning < 4)) {
        return this.sendResponse(this.status.IP);
      } else {
        return this.sendResponse(this.status.NP, null, 'Player name not found');
      }
    } catch (err) {
      return err;
    }
  }

  // Handler to resolve session
  // - {Player Name} boundaries
  async getPlayerBoundaries(session) {
    try {
      const timelineData = await this.fetchTimelineData(this.eventId);
      if (timelineData instanceof Error || !timelineData) {
        return null;
      }

      const targetInning = session.match(/\d$/g) ? Number(session.match(/\d$/g)[0]) : 0;

      if (isNaN(targetInning) || (targetInning !== 0 && targetInning !== 2)) {
        return this.sendResponse(this.status.NP, null, 'Invalid session inning');
      }

      session = this.filterSessionString(session);
      session = session.replace(/\s+boundaries/gi, ' boundaries');
      session = session.trim();

      const playerName = session.match(/^([a-z\s,.'-]+\s+boundaries)/gi)[0].split(' boundaries')[0];

      const currentInning = timelineData.currentInningsNumber;

      for (let i = targetInning; i < currentInning; i++) {
        const batsmenList = timelineData.innings[i].batsmen;
        for (let k = 0; k < batsmenList.length; k++) {
          if (this.isPlayerNameMatched(playerName.trim(), batsmenList[k].batsmanName.trim())) {
            if (
              (!batsmenList[k].didNotBat && !batsmenList[k].active) ||
              (timelineData.matchStatus === 4 || timelineData.innings[i].conclusion !== 'In Progress')
            ) {
              return this.sendResponse(this.status.CL, batsmenList[k].fours);
            } else {
              return this.sendResponse(this.status.IP);
            }
          }
        }
      }

      if ((targetInning === 0 && currentInning < 2) || (targetInning === 2 && currentInning < 4)) {
        return this.sendResponse(this.status.IP);
      } else {
        return this.sendResponse(this.status.NP, null, 'Player name not found');
      }
    } catch (err) {
      return err;
    }
  }
}

module.exports = { Session };
