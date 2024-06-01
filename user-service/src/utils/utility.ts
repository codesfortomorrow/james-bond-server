/* eslint-disable @typescript-eslint/no-unused-vars */
/* eslint-disable @typescript-eslint/no-explicit-any */
import { any } from 'sequelize/types/lib/operators';
import sequelize from '../db.config';
import { User } from '../models';
// eslint-disable-next-line quotes
import betsequelize from "../betdb.config";
import { QueryTypes } from 'sequelize';

interface UserBetData {
  id: number;
  username: string;
  path:string;
  user_type:string;
  total_user_profit: number;
  total_user_loss: number;
}

interface UserData {
  id: number;
  username: string;
  path: string;
  user_type: string;
}

export const getSubUsersPoints = async (uid: number, path: string, memo: Record<number, number> = {}): Promise<[number, Record<number, number>]> => {
  if (memo[uid]) {

    return [memo[uid], memo];
  }

  const sql = `SELECT id, path, ap::REAL, balance::REAL, credit_amount::REAL, exposure_amount::REAL, user_type FROM users WHERE id != ${uid} AND path::ltree ~ '${path}.*{1}'::lquery`;

  const users = await sequelize.query(sql, { model: User, mapToModel: true }).catch((err: Error) => err);

  if (users instanceof Error) {
    memo[uid] = 0.00;


    return [0.00, memo];
  }

  let userPoints = 0.00;

  for (let i = 0; i < users.length; i++) {
    if (users[i].userType === 'USER') {
      const _userPoints = (users[i].balance - users[i].creditAmount);

      memo[users[i].id] = Number(_userPoints.toFixed(2));
      userPoints += memo[users[i].id];

    } else {
      const [_userPoints] = await getSubUsersPoints(users[i].id, users[i].path, memo);
      memo[users[i].id] = Number(_userPoints.toFixed(2));
      userPoints += memo[users[i].id];

    }
  }

  memo[uid] = Number(userPoints.toFixed(2));


  return [memo[uid], memo];
};

export const getSettlementPoints = async (uid: number, path: string, ap: number, parentAp: number): Promise<number> => {
  const sql = `SELECT id, path, ap::REAL, balance::REAL, credit_amount::REAL, exposure_amount::REAL, user_type FROM users WHERE id != ${uid} AND path::ltree ~ '${path}.*{1}'::lquery`;

  const users = await sequelize.query(sql, { model: User, mapToModel: true }).catch((err: Error) => err);

  if (users instanceof Error) {
    return 0.00;
  }

  let settlementPoints = 0.00;

  for (let i = 0; i < users.length; i++) {
    if (users[i].userType === 'USER') {
      const _userPoints = (users[i].balance - users[i].creditAmount);
      const _settlementPoints = (_userPoints * (100 - ((100 - ap) + (parentAp > 0 ? 100 - parentAp : 0)))) / 100;
      settlementPoints += Number(_settlementPoints.toFixed(2));
    } else {
      const [_userPoints] = await getSubUsersPoints(users[i].id, users[i].path);
      const _settlementPoints = (_userPoints * (100 - users[i].ap)) / 100;
      settlementPoints += Number(_settlementPoints.toFixed(2));
    }
  }

  return settlementPoints;
};
export async function getTotalUserExposure(uid: number, path: string): Promise<{ totalExposure: number, totalbalance: number } | Error> {
  try {

    const sql = `
          SELECT 
              id, 
              path, 
              ap::REAL, 
              balance::REAL, 
              credit_amount::REAL, 
              exposure_amount::REAL, 
              user_type 
          FROM 
              users 
          WHERE 
              id != ${uid} 
              AND path::ltree ~ '${path}.*{1}'::lquery
      `;

    const users = await sequelize.query(sql, { model: User, mapToModel: true });


    let totalExposure = 0;
    let totalbalance = 0;
    //   users.forEach(user => {
    //     totalExposure += Number(user?.exposureAmount);
    //     totalbalance += Number(user?.balance);
    // });
    for (let i = 0; i < users.length; i++) {
      // eslint-disable-next-line @typescript-eslint/no-explicit-any
      let result: any;
      if (users[i].userType === 'MASTER') {

        result = await getTotalUserExposure(
          users[i]?.id,
          users[i]?.path
        );

        totalbalance = totalbalance + result.totalbalance + users[i].balance;
        totalExposure = totalExposure + result.totalExposure + users[i].exposureAmount;
      }
      else {
        totalbalance = totalbalance + users[i].balance;
        totalExposure = totalExposure + users[i].exposureAmount;
      }
    }

    return { totalExposure, totalbalance };
  } catch (error) {

    return new Error('Error fetching user exposure data');
  }
}

export async function downlieUserQuery (
  username: string,
  path: string,
  startDate: string,
  endDate: string
): Promise<any> {
  const sql = `
    SELECT 
      id, 
      path, 
      user_type,
      username
    FROM 
      users 
    WHERE 
      username != '${username}' 
      AND path::ltree ~ '${path}.*{1}'::lquery
  `;

  const [userResults, userMetadata] = await sequelize.query(sql);
  const users = userResults as UserData[];
  const userBetDataList: UserBetData[] = [];

  for (const user of users) {
    const { username, id, user_type, path } = user;
    const betQuery = `
    SELECT
        ${id} as id,
        '${username}' as username,
        COALESCE( SUM(
          CASE
            WHEN bet_on = 'BACK' AND status = 1 THEN
              CASE
                WHEN market = 'session' THEN ROUND(stake * percent / 100, 2)
                ELSE ROUND(stake * (price - 1), 2)
              END
            WHEN bet_on = 'LAY' AND status = 1 THEN
              CASE
                WHEN market = 'session' THEN ROUND(stake * percent / 100, 2)
                ELSE ROUND(stake, 2)
              END
            ELSE 0
          END
        ), 0) AS total_user_profit,
        COALESCE(SUM(
          CASE
            WHEN bet_on = 'BACK' AND status = 10 THEN
              CASE
                WHEN market = 'session' THEN ROUND(stake * percent / 100, 2)
                ELSE ROUND(stake, 2)
              END
            WHEN bet_on = 'LAY' AND status = 10 THEN
              CASE
                WHEN market = 'session' THEN ROUND(stake * percent / 100, 2)
                ELSE ROUND(stake * (price - 1), 2)
              END
            ELSE 0
          END
        ), 0) AS  total_user_loss
    FROM
        public.bets
    WHERE
        username = '${username}'
        AND updated_at >= '${startDate}' 
        AND updated_at <= '${endDate}'
    GROUP BY
        username
`;
    const betResults = await betsequelize.query(betQuery, {
      type: QueryTypes.SELECT,
    });

    const userBetDataArray: any[] = betResults;

    let totalUserProfit = 0;
    let totalUserLoss = 0;

    if (betResults.length > 0) {
      for (const betData of userBetDataArray) {
        totalUserProfit += betData.total_user_profit;
        totalUserLoss += betData.total_user_loss;
      }
    }

    userBetDataList.push({
      id,
      username,
      user_type,
      path,
      total_user_profit: totalUserProfit,
      total_user_loss: totalUserLoss,
    });

    if (user_type !== 'USER') {
      const downlineProfitLoss = await downlieUserQuery(
          username,
          path,
          startDate,
          endDate
      );
      // console.log('downee', downlineProfitLoss);
      
      for (const userData of downlineProfitLoss) {
          const userIndex = userBetDataList.findIndex(user => user.username !== userData.username);
          
          if (userIndex !== -1) {
              // console.log('Updating user data for:', userData.username);
              // console.log('Previous user data:', userBetDataList[userIndex]);
              
              // Convert string values to numbers before adding
              const profitToAdd = parseFloat(userData.total_user_profit);
              const lossToAdd = parseFloat(userData.total_user_loss);
              
              // Update user data
              userBetDataList[userIndex].total_user_profit += profitToAdd;
              userBetDataList[userIndex].total_user_loss += lossToAdd;
              
              // console.log('Updated user data:', userBetDataList[userIndex]);
          } else {
              // console.log('User not found in userBetDataList:', userData.username);
          }
      }
  }
  
  }
  // console.log('userBetDataList',userBetDataList,username);
  return userBetDataList;
}

export async function getdownlineUserCasinosub(
  username: string,
  path: string,
  startDate: string,
  endDate: string
): Promise<any> {
  const sql = `
    SELECT 
      id, 
      path, 
      user_type,
      username
    FROM 
      users 
    WHERE 
      username != '${username}' 
      AND path::ltree ~ '${path}.*{1}'::lquery
  `;

  const [userResults, userMetadata] = await sequelize.query(sql);
  const users = userResults as UserData[];
  const userBetDataList: UserBetData[] = [];

  for (const user of users) {
    const { username, id, user_type, path } = user;
    const query = `
      SELECT 
        SUM(CASE WHEN remark LIKE 'bet%' THEN amount ELSE 0 END) AS total_user_loss,
        SUM(CASE WHEN remark NOT LIKE 'bet%' THEN amount ELSE 0 END) AS total_user_profit
      FROM
        casinotransactions
      WHERE
        username = '${username}'
        AND updated_at >= '${startDate}' 
        AND updated_at <= '${endDate}'
      GROUP BY
        username;
    `;
    const betResults = await sequelize.query(query, {
      type: QueryTypes.SELECT,
    });

    const userBetDataArray: any[] = betResults;

    let totalUserProfit = 0;
    let totalUserLoss = 0;

    if (betResults.length > 0) {
      for (const betData of userBetDataArray) {
        totalUserProfit += betData.total_user_profit;
        totalUserLoss += betData.total_user_loss;
      }
    }

    userBetDataList.push({
      id,
      username,
      user_type,
      path,
      total_user_profit: totalUserProfit,
      total_user_loss: totalUserLoss,
    });

    if (user_type !== 'USER') {
      const downlineProfitLoss = await getdownlineUserCasinosub(
          username,
          path,
          startDate,
          endDate
      );
      // console.log('downee', downlineProfitLoss);
      
      for (const userData of downlineProfitLoss) {
          const userIndex = userBetDataList.findIndex(user => user.username !== userData.username);
          
          if (userIndex !== -1) {
              // console.log('Updating user data for:', userData.username);
              // console.log('Previous user data:', userBetDataList[userIndex]);
              
              // Convert string values to numbers before adding
              const profitToAdd = parseFloat(userData.total_user_profit);
              const lossToAdd = parseFloat(userData.total_user_loss);
              
              // Update user data
              userBetDataList[userIndex].total_user_profit += profitToAdd;
              userBetDataList[userIndex].total_user_loss += lossToAdd;
              
              // console.log('Updated user data:', userBetDataList[userIndex]);
          } else {
              // console.log('User not found in userBetDataList:', userData.username);
          }
      }
  }
  
  }
  // console.log('userBetDataList',userBetDataList,username);
  return userBetDataList;
}




