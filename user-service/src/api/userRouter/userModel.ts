/* eslint-disable @typescript-eslint/no-inferrable-types */
/* eslint-disable no-unexpected-multiline */
/* eslint-disable @typescript-eslint/no-explicit-any */
/* eslint-disable @typescript-eslint/explicit-module-boundary-types */
/* eslint-disable prefer-const */
/* eslint-disable @typescript-eslint/no-unused-vars */
/* eslint-disable quotes */
/* eslint-disable no-mixed-spaces-and-tabs */
import jwt, { Secret, SignOptions } from "jsonwebtoken";
import Sequelize, { ValidationError, Op, WhereOptions, QueryTypes, where } from "sequelize";
import md5 from "md5";
import sequelize from "../../db.config";
import betsequelize from "../../betdb.config";
import responses from "../../responses";
import { User, Transaction, ActivityLog, UserKyc } from "../../models";
import {
  TransactionAttributes,
  TransactionInstance,
} from "../../models/Transaction";
import { AddUserUPIPayload, JwtAuthPayload, JwtAuthPayloadForRegisterShiv, loginAuthPayload } from "../../types";
import { getPrivileges } from "../../utils/privileges";
import activity from "../../utils/activity";
import { UserInstance } from "../../models/User";
import {
  ActivityLogInstance,
  ActivityLogAttributes,
} from "../../models/ActivityLog";
import { getSubUsersPoints, getSettlementPoints, getTotalUserExposure,getdownlineUserCasinosub } from "../../utils/utility";
import QrCode, { QrAttributes } from "../../models/Qr";
import DepositRequest, { DepositRequestAttributes } from "../../models/DepositRequest";
import BankAccount, { BankAccountAttributes, TransaBankAccountAttributes } from "../../models/BankAccount";
import AddUserAccount, { TransaAddUserAccountAttributes } from "../../models/Adduseraccount";
import AddUserApi, { AddUserApiAttributes, TransaAddUserApiAttributes } from "../../models/AddUserApi";
import { promises } from "dns";
import WithdrawalTransaction from "../../models/GetWidrawReq";
import PasswordHistory from "../../models/PasswordHistory";
import CasinoGame from "../../models/CasinoGames";
import axios, { AxiosResponse } from "axios";
import { between } from "sequelize/types/lib/operators";
import CasinoTransaction, { CasinoTransactionAttributes, CasinoTransactionInstance } from "../../models/CasinoTransactions";
import { platform } from "os";
import path from "path";
import SettlementTransaction from "../../models/SettlementTransaction";
import { downlieUserQuery } from "../../utils/utility";
import { title } from "process";
import { stringify } from "querystring";
import Otp from "../../models/Otp";

type RegistrationResponse = { data?: string; error?: string };

enum DocumentType {
  AadharCard = 'aadharCard',
  PanCard = 'panCard',
  DrivingLicense = 'drivingLicense',
  Passport = 'passport'
}

enum KycStatus {
  Pending = 'pending',
  Rejected = 'rejected',
  Completed = 'completed'
}

console.log("Mongoose123!@#", md5("Mongoose123!@#"));
interface TotalCountResult {
  total_count: number;
}


interface BetData {
  settlement_time: string;
  event_type: string;
  event_id: number;
  event: string;
  market: string;
  all_user_winning_amount: string;
  all_user_losing_amount: string;
}

interface UserData {
  id: number;
  username: string;
  path: string;
  user_type: string;
}

interface UserBetData {
  id: number;
  username: string;
  user_type:string;
  path :string;
  total_user_profit: number;
  total_user_loss: number;
}


interface Bet {
  market: string;
  event_id: number;
  event: string;
  game_id: number;
  event_type: string;
  total_winning_amount: string;
  total_lossing_amount: string;
}

interface MatchData {
  settlement_time: string;
  market: string;
  event_id: number;
  event: string;
  game_id: number;
  event_type: string;
  total_winning_amount: string;
  total_lossing_amount: string;
}



/**
 * UserModel have all required models
 * to handle '/user/${xyz}' endpoint backend logics
 */

class UserModel {
  [x: string]: any;


  getCasinosService = async () => {
    try {
      const casinos = await CasinoGame.findAll({ where: { status: true } });
      return casinos;
    } catch (error) {
      throw new Error('Unable to fetch casinos');
    }
  };

  getaviatorService = async () => {
    try {
      

const casinos = await CasinoGame.findAll({
  where: {
    [Op.or]: [
      { title: 'Aviator' },
      {title: 'Aero' },
      { title: 'Mriya' }
    ]
  }
});

      return casinos;
    } catch (error) {
      throw new Error('Unable to fetch casinos');
    }
  };
  createCasinoSessionService = async (
    platformtype: string,
    gameId: string,
    id: string,
    ip: string
  ): Promise<{ message: string, url: string }> => {
    try {
      let platform;
      const apiUrl = process.env.CASINO_CREATE_SESSION || '';
      if (platformtype === "mobile") {
        platform = 'GPL_MOBILE';
      }
      else {
        platform = "GPL_DESKTOP";
      }

      const user = await User.findByPk(id);
      if (!user) {
        return {
          message: 'user not found ',
          url: responses.MSG001
        };
      }
    const updateBal =  parseFloat(user?.balance.toString()) + parseFloat(user?.exposureAmount.toString());
      const casino = await CasinoGame.findOne({ where: { id: gameId } });
      if (!casino) {
        return {
          message: 'internal error ',
          url: "try again"
        };
      }
      const requestData = {
        user: user.username,
        token: process.env.CASION_TOKEN,
        partner_id: process.env.CASION_TOKEN,
        platform: platform,
        req_url: process.env.CASINO_URL,
        lang: "en",
        ip,
        game_id: casino.identifier,
        game_code: casino.identifier,
        id,
        available_balance: updateBal
      };
      // console.log('this create session api req body data', requestData);
      const response: AxiosResponse = await axios.post(apiUrl, requestData);
      // console.debug('response after hiting api ',response);


      return {
        message: 'ok',
        url: response.data.url
      };
    } catch (error) {
      throw new Error(`Error hitting API: ${error}`);
    }
  };

  casinoSearchService = async (search?: string, provider?: string) => {
    try {
      console.log(search,'saervh, provider',provider);
        let condition: any = { status: true }; 
        
        if (search && provider !== 'all') {
          condition.title = { [Sequelize.Op.iLike]: `%${search}%` };
      }
      if (provider && provider !== 'all') {
        condition.provider = { [Op.iLike]: provider };
      }
        if (search && provider === 'all') {
          condition.title = { [Sequelize.Op.iLike]: `%${search}%` };
      }
        const casinos = await CasinoGame.findAll({ where: condition });
        return casinos;
    } catch (error) {
        throw new Error('Unable to fetch casinos');
    }
};
casinostatement = async (id: number, search?: string,limit?:number,offset?:number, startDate?: string, endDate?: string) => {
  try {
    let condition: any = {  userId :id};
    
    if (search === 'aviator') {
      condition.game_type = { [Sequelize.Op.iLike]: `%${search}%` };
    } else {
      condition.game_type = { [Sequelize.Op.notLike]: 'SPB-aviator' };
    }
    if (startDate && endDate) {
      condition.createdAt = {
        [Sequelize.Op.between]: [new Date(startDate), new Date(endDate)],
      };
    }

    const casinos = await CasinoTransaction.findAndCountAll({
      where: condition,
      offset: offset,
      limit: limit,
      order: [['id', 'DESC']], // Order by ID ascending
    });
    return casinos;
  } catch (error) {
    throw new Error('Unable to fetch casinos');
  }
};
 casinoAviatorHistory = async (uid: string, path: string, search?: string, startDate?: string, endDate?: string, limit?: number, offset?: number) => {
  try {
    let whereClause = `user_id != '${uid}' AND path  ~ '^${path}'`;

    if (startDate && endDate) {
      whereClause += ` AND created_at >= '${startDate}' AND created_at <= '${endDate}'`;
    }

    if (search === "aviator") {
      whereClause += ` AND game_type = 'SPB-aviator'`;
    }

    const sql = `
      SELECT *
      FROM casinotransactions
      WHERE ${whereClause}
      ORDER BY id DESC 
      OFFSET ${offset ? offset : 0} 
      ROWS FETCH NEXT ${limit ? limit : 10} ROWS ONLY
    `;
    
    const sqlcount = `
      SELECT COUNT(*) 
      FROM casinotransactions
      WHERE ${whereClause}
    `;
    
    const result= await Promise.all([
      sequelize.query(sql, { model: CasinoTransaction, mapToModel: true }),
 
    ]);
    const count= await Promise.all([
      sequelize.query(sqlcount, { model: CasinoTransaction, mapToModel: true }),
 
    ]);
    
    // console.log(result);

    const users = result[0];
    const totalCount = count;

    return { users, totalCount };
  } catch (error) {
    console.error('Error retrieving casino history:', error);
    throw error;
  }
};


 static getCasinoBalance = async (userId: string): Promise<number> => {
  try {
    const user = await User.findOne({ where: { id: userId } });

    if (!user) {
      throw new Error('User not found');
    }

    let updateBalance: number = 0;

    if (user) {
      // Explicit parsing (assuming user.balance and user.exposureAmount are strings)
      updateBalance = parseFloat((user.balance)as any) + parseFloat((user.exposureAmount) as any );
    }

    console.log('updateBalance:', updateBalance);
    return Math.round(updateBalance);
  } catch (error) {
    console.error('Error fetching user balance:', error);
    throw error;
  }
};


  handleCreditCallback = async (gameCode: string, gameType: string, userId: string, transactionId: string, referenceId: string, providerCode: string, providerTransactionId: string, amount: number, extra: string, gameid: string): Promise<number> => {
    try {

      const user = await User.findOne({ where: { id: userId } });
      if (!user) {
        throw new Error('User not found');
      }
      const username=user?.username;
      const path =user?.path;
      // console.log('credit amount1', amount);

      // console.log('gameid', gameid);

      const casino = await CasinoGame.findOne({ where: { identifier: gameid } });

      // console.log('casion', casino);

      const userBalance = parseFloat(user.balance.toString());
      const transactionAmount = parseFloat(amount.toString());



      if (!casino)
        return 0;
      // Calculate the new balance
      const newBalance = userBalance + transactionAmount;
      // console.log('new', newBalance);
      
      user.balance = newBalance;
      await user.save();
      gameCode = casino.title;
      await CasinoTransaction.create({
        gameCode,
        gameType :casino?.provider,
        userId,
        transactionId,
        referenceId,
        providerCode,
        providerTransactionId,
        amount,
        remark: `${extra} on ${casino.title}`,
        gameId: casino?.id,
        username,
        path:path

      });
      
console.log('credit',Math.round( parseFloat((user.balance)as any) + parseFloat((user.exposureAmount) as any ))
);
      return Math.round( parseFloat((user.balance)as any) + parseFloat((user.exposureAmount) as any ));

    } catch (error) {
      console.error('Error updating user balance:', error);
      throw error;
    }
  };
  handleDebitCallback = async (
    gameType: string,
    userId: string,
    transactionId: string,
    referenceId: string,
    providerCode: string,
    providerTransactionId: string,
    amount: number,
    extra: string,
    gameid: string,
    roll_back: string
  ): Promise<number> => {
    try {
      // Find the user
      const user = await User.findOne({ where: { id: userId } });
      if (!user) {
        throw new Error('User not found');
      }
  
      const username = user.username;
      const path = user.path;
      console.log('User:',gameid);
  
      // Find the casino game
      const casino = await CasinoGame.findOne({ where: { identifier: gameid } });
      if (!casino) {
        throw new Error('Casino game not found');
      }
      // parseFloat((user.balance)as any) + parseFloat((user.exposureAmount) as any );
      const userBalance = parseFloat((user.balance)as any) ;
      const transactionAmount = parseFloat(amount.toString());
  
      // Check if rollback is needed
      if (roll_back === 'Y') {
        const transactiondata = await CasinoTransaction.findOne({ where: { transactionId } });
        if (!transactiondata) {
          throw new Error('Transaction not found for rollback');
        }
        const rollbackBalance = parseFloat(transactiondata?.amount.toString());
        user.balance += rollbackBalance;
      }
  
      // Validate user balance
      if (userBalance + parseFloat((user.exposureAmount) as any ) < transactionAmount) {
        throw new Error('User balance is less than the debit amount');
      }
  
      // Calculate the new balance
      const newBalance = userBalance - transactionAmount;
      user.balance = newBalance;
  
      // Create CasinoTransaction
      const gameCode = casino.title;
      // console.log('Game Code:', newBalance,userBalance,transactionAmount);
      const newTransaction = await CasinoTransaction.create({
        gameCode,
        gameType : casino.provider,
        userId,
        transactionId,
        referenceId,
        providerCode,
        providerTransactionId,
        amount: transactionAmount,
        remark: `${extra} on ${casino?.title}`,
        gameId: casino.id,
        username,
        path
      });
  
      // console.log('Transaction stored:', newTransaction);
  
      // Save the updated user balance
      await user.save();
      console.log('debit',Math.round( parseFloat((user.balance)as any) + parseFloat((user.exposureAmount) as any )));
      return Math.round( parseFloat((user.balance)as any) + parseFloat((user.exposureAmount) as any ));
    } catch (error) {
      console.error('Error debiting user balance:', error);
      throw error;
    }
  };
  





  authUser = async (
    username: string,
    password: string,
    ip: string
  ): Promise<
    { data?: { token: string; ut: string; isPasswordChanged: boolean; }; error?: string } | Error
  > => {
    // console.log('useeee',username);
    const user = await User.findOne({ where: { username: username } }).catch(
      (err: Error) => err
    );
    // console.log('useeeusere',user);
    if (user instanceof Error) {
      return user;
    }
    // console.log('useris deleted cheacking ', user?.isDeleted);
    if (user) {
      const exp = Math.floor(Date.now() / 1000) + (60 * 60 * 12);
      if (user.password !== md5(password)) return { error: responses.MSG002 };
      else if (user.status === -1) return { error: responses.MSG001 };
      else if (user.lock) return { error: responses.MSG003 };
      else if (user.isDeleted) return { error: responses.MSG021 };
     
      else {
        const payload: JwtAuthPayload = {
          _uid: user.id,
          _level: user.level,
          _path: user.path,
          _status: user.status,
          _privileges: user.privileges,
          _ut: user.userType,
          _transactionCode: user.transactionCode,
          exp :exp
        };

        try {
          const jwtToken = jwt.sign(
            { ...payload },
            process.env.JWT_TOKEN_SECRET as Secret,
            { } as SignOptions
          );
          
          activity(user.id, ip, "Logged In");
          return {
            data: {
              token: jwtToken,
              ut: user.userType,
              isPasswordChanged: user.isPasswordChanged
            },
          };
        } catch (err) {
          if (err instanceof Error) {
            return err;
          } else {
            return new Error("Unhandled error occurred");
          }
        }
      }
    } else {
      return { error: responses.MSG001 };
    }
  };

  getUserDetails = async (
    uid: number,
    path: string
  ): Promise<
    { data?: Record<string, unknown>; error?: string; code?: number } | Error
  > => {
    const sql = `SELECT fullname, username, path , email ,  dob , telegramid , instagramid , whatsappnumber , city, ap::REAL, parent_ap::REAL, privileges, status, remark, dial_code, phone_number, balance, credit_amount,id, exposure_amount, user_type, lock,is_deleted, bet_lock, initial_setup FROM users WHERE id = ${uid} AND '${path}' ~ path`;

    const users = await sequelize
      .query(sql, { model: User, mapToModel: true })
      .catch((err: Error) => err);

    if (users instanceof Error) return users;
    if (!users.length) return { error: responses.MSG001 };

    let settlementPoints: number;

    if (users[0].userType !== "USER") {
      settlementPoints = await getSettlementPoints(
        uid,
        path,
        users[0].ap,
        users[0].parentAp
      );
    } else {
      settlementPoints = 0.0;
    }

    return { data: { ...users[0].toJSON(), settlementPoints } };
  };
  getParticulerUserDetails = async (
    uid: number,

  ): Promise<
    { data?: Record<string, unknown>; error?: string; code?: number } | Error
  > => {
    const sql = `SELECT fullname, username, path, email ,  dob , telegramid , instagramid , whatsappnumber , city, ap::REAL, parent_ap::REAL, privileges, status, remark, dial_code, phone_number, balance, credit_amount,id, exposure_amount, user_type, lock, bet_lock, initial_setup FROM users WHERE id = ${uid} `;

    const users = await sequelize
      .query(sql, { model: User, mapToModel: true })
      .catch((err: Error) => err);

    if (users instanceof Error) return users;
    if (!users.length) return { error: responses.MSG001 };

    let settlementPoints: number;

    if (users[0].userType !== "USER") {
      settlementPoints = await getSettlementPoints(
        uid,
        users[0].path,
        users[0].ap,
        users[0].parentAp
      );
    } else {
      settlementPoints = 0.0;
    }

    return { data: { ...users[0].toJSON(), settlementPoints } };
  };

  secureAccount = async (
    uid: number,
    transactionCode: string,
    newPassword: string
  ): Promise<{ data?: boolean; error?: string } | Error> => {
    const user = await User.update(
      {
        transactionCode: transactionCode,
        password: newPassword,
        initialSetup: true,
      },
      {
        where: {
          id: uid,
        },
      }
    ).catch((err: Error) => err);

    if (user instanceof Error) {
      if (Object.prototype.hasOwnProperty.call(user, "errors")) {
        const validationError = user as ValidationError;
        const errors = validationError.errors.map((e) => e.message);
        return errors.length
          ? { error: errors[0] }
          : new Error("Unknown error occurred");
      } else {
        return user;
      }
    } else {
      return { data: true };
    }
  };

  changePassword = async (
    uid: number,
    oldPassword: string,
    newPassword: string,
    ip: string
  ): Promise<{ data?: boolean; error?: string } | Error> => {
    const user = await User.findOne({
      where: { id: uid },
      attributes: ["password","path"],
    }).catch((err: Error) => err);

    if (user instanceof Error) {
      return user;
    } else if (user) {
      if (user.password === md5(oldPassword)) {
        const response = await User.update(
          { password: newPassword, transactionCode: md5(newPassword) },
          { where: { id: uid } }
        ).catch((err: Error) => err);
        const createPasswordHistory = await PasswordHistory.create({ userId: uid, remarks: `Password Changed By Self`,path:user.path });
        if (response instanceof Error) {
          return response;
        } else {
          activity(uid, ip, "Password changed");
          return { data: true };
        }
      } else {
        return { error: responses.MSG016 };
      }
    } else {
      return { error: responses.MSG001 };
    }
  };

  changeFirstTimePassword = async (
    uid: number,
    oldPassword: string,
    newPassword: string,
    ip: string
  ): Promise<{ data?: boolean; error?: string } | Error> => {
    // console.log('word', newPassword, oldPassword, uid);

    const user = await User.findOne({
      where: { id: uid },
      attributes: ["password","path"],
    }).catch((err: Error) => err);

    if (user instanceof Error) {
      return user;
    } else if (user) {
      if (user.password === md5(oldPassword)) {
        const response = await User.update(
          { password: newPassword, isPasswordChanged: true, transactionCode: md5(newPassword) },
          { where: { id: uid } }
        ).catch((err: Error) => err);
        // console.log('password', response);

        const createPasswordHistory = await PasswordHistory.create({ userId: uid, remarks: `Password Changed By Self`,path:user.path });
        if (response instanceof Error) {
          return response;
        } else {
          activity(uid, ip, "Password changed");
          return { data: true };
        }
      } else {
        return { error: responses.MSG016 };
      }
    } else {
      return { error: responses.MSG001 };
    }
  };


  activityLogs = async (
    uid: number,
    fromDate?: string,
    toDate?: string,
    offset?: number,
    limit?: number
  ): Promise<
    | {
      data?: { count: number; activities: ActivityLogInstance[] };
      error?: string;
    }
    | Error
  > => {
    let whereOptions: WhereOptions<ActivityLogAttributes> = { userId: uid };

    if (
      fromDate &&
      !isNaN(Date.parse(fromDate)) &&
      toDate &&
      !isNaN(Date.parse(toDate))
    ) {
      whereOptions = {
        ...whereOptions,
        [Op.and]: [
          Sequelize.where(Sequelize.cast(Sequelize.col("created_at"), "DATE"), {
            [Op.gte]: fromDate,
          }),
          Sequelize.where(Sequelize.cast(Sequelize.col("created_at"), "DATE"), {
            [Op.lte]: toDate,
          }),
        ],
      };
    }

    const logs = await ActivityLog.findAndCountAll({
      where: whereOptions,
      attributes: {
        exclude: ["userId", "updatedAt"],
      },
      offset: offset ? offset : 0,
      limit: limit ? limit : 10,
      order: [["id", "DESC"]],
    }).catch((err: Error) => err);

    if (logs instanceof Error) {
      return logs;
    } else {
      return { data: { count: logs.count, activities: logs.rows } };
    }
  };

  particuleractivityLogs = async (
    uid: string,
    fromDate?: string,
    toDate?: string,
    offset?: number,
    limit?: number
  ): Promise<
    | {
      data?: { count: number; activities: ActivityLogInstance[] };
      error?: string;
    }
    | Error
  > => {
    let whereOptions: WhereOptions<ActivityLogAttributes> = { userId: uid };

    if (
      fromDate &&
      !isNaN(Date.parse(fromDate)) &&
      toDate &&
      !isNaN(Date.parse(toDate))
    ) {
      whereOptions = {
        ...whereOptions,
        [Op.and]: [
          Sequelize.where(Sequelize.cast(Sequelize.col("created_at"), "DATE"), {
            [Op.gte]: fromDate,
          }),
          Sequelize.where(Sequelize.cast(Sequelize.col("created_at"), "DATE"), {
            [Op.lte]: toDate,
          }),
        ],
      };
    }

    const logs = await ActivityLog.findAndCountAll({
      where: whereOptions,

      attributes: {
        exclude: ["userId", "updatedAt"],
      },
      order: [["id", "DESC"]],
      offset: offset ? offset : 0,
      limit: limit ? limit : 10,
    }).catch((err: Error) => err);

    if (logs instanceof Error) {
      return logs;
    } else {
      return { data: { count: logs.count, activities: logs.rows } };
    }
  };

  createSubUser = async (
    uid: number,
    userType: string,
    path: string,
    fullname: string,
    username: string,
    password: string,
    dialCode: string,
    phoneNumber: string,
    city: string,
    level: number,
    ap: number,
    creditAmount: number,
    subUserType: string,
    remark: string,
    privileges?: string[]
  ): Promise<{ data?: boolean; error?: string } | Error> => {
    const validUserTypes = ["OWNER", "SUPER_MASTER", "MASTER", "USER"];

    if (
      validUserTypes.indexOf(subUserType) <= validUserTypes.indexOf(userType)
    ) {
      return { error: responses.MSG012 };
    }

    const user = await User.findOne({
      where: { id: uid },
      attributes: ["creditAmount","ap","user_type"],
    }).catch((err: Error) => err);
    const userphone = await User.findOne({
      where: { phoneNumber: phoneNumber }
    }).catch((err: Error) => err);
    if (userphone){
      // console.log('herre1');
      return { error: responses.MSG021 };
      // console.log('222222222');
    }

    if (user instanceof Error) {
      return user;
    } else if (!user) {
      return { error: responses.MSG001 };
    } else if (+user.creditAmount < +creditAmount) {
      return { error: responses.MSG015 };
    }
    
    const subUser = await User.create({
      fullname,
      username,
      password,
      dialCode,
      phoneNumber,
      transactionCode: md5(password),
      city,
      level,
      ap,
      parentAp: subUserType === "MASTER" ? user.ap : 0.0,
      balance: 0.0,
      creditAmount: 0.0,
      privileges: privileges ? getPrivileges(privileges) : null,
      userType: subUserType,
      remark,
    }).catch((err: Error) => err);

    if (subUser instanceof Error) {
      if (Object.prototype.hasOwnProperty.call(subUser, "errors")) {
        const validationError = subUser as ValidationError;
        const errors = validationError.errors.map((e) => e.message);
        return errors.length
          ? { error: errors[0] }
          : new Error("Unknown error occurred");
      } else {
        return subUser;
      }
    } else {
      User.update(
        { path: `${path}.${subUser.id}` },
        { where: { id: subUser.id } }
      ).catch((err: Error) => err);
    
     
      this.transferCreditAmount(uid, subUser.id, creditAmount, 'opening balance');
      return { data: true };
    }
  };
  registerUser = async (
    password: string,
    phoneNumber: string,
    subUserType: string
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
  ): Promise<{ data?: { token: string; ut: string }; error?: any }> => {
    try {
      // Find owner path
      const ownerPath = await User.findOne({ where: { userType: "OWNER" } });

      // Validate phone number format
      if (!/^\d{10}$/.test(phoneNumber)) {
        return {
          error: "Invalid phone number. Please provide a 10-digit phone number.",
        };
      }

      // Check if user already exists
      const existingUser = await User.findOne({ where: { username: phoneNumber } });
      if (existingUser) {
        return {
          error: "User already registered with this phone number.",
        };
      }

      // Create new user
      const user = await User.create({
        username: phoneNumber,
        password,
        phoneNumber,
        userType: subUserType,
        isPasswordChanged: true
      });

      // Update owner's path with the new user ID
      if (ownerPath && user) {
        await User.update({ path: `${ownerPath.path}.${user.id}` }, { where: { id: user.id } });
      }

      // Generate JWT token
      const jwtToken = jwt.sign(
        { _phoneNumber: phoneNumber, _password: password, _ut: subUserType },
        process.env.JWT_TOKEN_SECRET as Secret,
        { expiresIn: "1 days" } as SignOptions
      );

      // Return token and user type
      return {
        data: {
          token: jwtToken,
          ut: subUserType,
        },
      };
    } catch (e) {
      // Handle errors
      if (e instanceof ValidationError) {
        const errors = e.errors.map((e) => e.message);
        return { error: errors.length ? errors[0] : "Unknown error occurred" };
      } else {
        return { error: e };
      }
    }
  };


  checkUserExists = async (username: string): Promise<boolean> => {
    const user = await User.findOne({ where: { username } });
    return !!user;
  };
  generateAndStoreOTP = async (phoneNumber: string, password: string): Promise<string> => {
    // Generate default OTP
    const defaultOTP = '0000';
    const userType = 'USER';

    // Find user by phoneNumber
    let user = await User.findOne({ where: { phoneNumber } });

    if (!user) {
      // If user doesn't exist, create a new user with the phone number and default OTP
      user = await User.create({ phoneNumber, resetToken: defaultOTP, password, userType });
    } else {
      // If user exists, update resetToken with default OTP
      await User.update({ resetToken: defaultOTP }, { where: { phoneNumber } });
    }

    return defaultOTP;
  };
  generateOtp = () => {
    return Math.floor(100000 + Math.random() * 900000).toString(); // Generates a 6-digit OTP
  };
  async forgotPassword(phoneNumber: string): Promise<void> {
    const generatedOtp = this.generateOtp();
    try {
      const otpRecord = await Otp.findOne({ where: { target: phoneNumber } });
  
      if (!otpRecord) {
        await Otp.create({
          code: generatedOtp,
          attempt: 1,
          lastSentAt: new Date(),
          retries: 0,
          target: phoneNumber,
          lastCodeVerified: false,
          blocked: false,
        });
      } else {
        await Otp.update(
          {
            code: generatedOtp,
            attempt: 1,
            lastSentAt: new Date(),
            retries: 0,
            lastCodeVerified: false,
            blocked: false,
          },
          { where: { target: phoneNumber } }
        );
      }
  
      const authkey = process.env.SMS_AUTH_KEY;
      const sender = process.env.SMS_SENDER;
      const dltTeId = process.env.SMS_DLT_TE_ID;
  
      const mobile_number = phoneNumber;
      const message_content = `Your verification Code is ${generatedOtp} ${sender}`;
  
      const url = `http://sms.ibittechnologies.in/api/sendhttp.php?authkey=${authkey}&mobiles=${mobile_number}&message=${encodeURIComponent(message_content)}&sender=${sender}&route=2&country=91&DLT_TE_ID=${dltTeId}`;
      console.log(url,'url'
    );
      await axios.get(url);
  
      
    } catch (error) {
      console.error('Error:', error);
     
    }
  }
  async verifyResetToken(
    phoneNumber: string,
    resetToken: string
  ): Promise<boolean> {
    const user = await Otp.findOne({ where: { target:phoneNumber, code:resetToken } });
    return !!user;
  }
  async resetPassword(phoneNumber: string, newPassword: string): Promise<void> {
    console.log(phoneNumber, 'booodddy', newPassword);
    if (!(/^(?=.*[A-Z])(?=.*[~!@#$%^&*()/_=+[\]{}|;:,.<>?-])(?=.*[0-9])(?=.*[a-z]).{8,14}$/.test(newPassword as string)))
      {
        throw new Error("Password is not strong! Enter a password Like Test@123 ");
      }
    const user = await User.findOne({ where: { phoneNumber } });

    if (!user) {
        throw new Error("User not found");
    }

    
    const hashedPassword = md5(newPassword);

    const updateResult = await User.update(
        { password: newPassword, transactionCode: hashedPassword },
        { where: { phoneNumber } }
    );
    console.log(updateResult, 'updateResult');
    if (updateResult[0] === 0) {
        throw new Error("Failed to update password");
    }

  
    await PasswordHistory.create({ userId: user.id, remarks: 'Password Changed By Self',path:user.path });
    
    const tokenClearResult = await User.update(
        { resetToken: null },
        { where: { phoneNumber } }
    );

    if (tokenClearResult[0] === 0) {
        throw new Error("Failed to clear reset token");
    }
}
  createDeposit = async (
    paymentMethod: string,
    utr: string,
    img: string,
    amount: number,
    userId: number
  ): Promise<DepositRequestAttributes> => {
    const status = 'pending';
    try {
      const users = await User.findOne({
        where: { id: userId }
      });

      if (!users) {
        throw new Error('User not found');
      }

      const existingDeposit = await DepositRequest.findOne({
        where: { utr }
      });

      if (existingDeposit) {
        throw new Error('UTR already exists!');
      }

      const deposit = await DepositRequest.create({
        paymentMethod,
        utr,
        img,
        amount,
        userId,
        status,
        username: users.username,
        userpath: users.path
      });

      return deposit.toJSON() as DepositRequestAttributes;
    } catch (error) {
      console.error('Failed to create deposit:', error);
      throw new Error('Failed to create deposit');
    }
  };

  // eslint-disable-next-line @typescript-eslint/explicit-module-boundary-types, @typescript-eslint/no-explicit-any
  getUserDeposits = async (userId: number, limit: number, offset: number, fromDate?: string,
    toDate?: string, status?: string) => {

    try {
      let whereClause: any = { userId: userId };
      if (fromDate && toDate) {
        whereClause.createdAt = {
          [Op.between]: [new Date(fromDate), new Date(toDate)]
        };
      }
      if (status && status.toLowerCase() !== 'all') {
        whereClause.status = {
          [Op.iLike]: status // Using Op.iLike for case-insensitive comparison
        };
      }
      const deposits = await DepositRequest.findAll({
        where: whereClause,
        order: [['id', 'DESC']],
        offset: offset || 0,
        limit: limit || 10
      });
      // console.log('deposits', deposits);
      const totalCount = await DepositRequest.count({ where: whereClause });

      return { deposits: deposits, totalCount: totalCount };
    } catch (error) {
      console.log('error', error);
      throw new Error('Failed to fetch user deposits');
    }
  };
  // GEt all deposit for admin 
  getAllDepositRequests = async (
    uid: number,
    path: string,
    offset?: number,
    limit?: number
  ): Promise<{ data?: Record<string, any>[]; totalCount?: number; error?: unknown } | Error> => {
    try {
      const countSql = `SELECT COUNT(*) AS total_count FROM depositrequests
      WHERE id != ${uid} AND userpath::ltree  ~ '${path}.*{1}'::lquery  AND status != 'Rejected' ` ;
      const [countResult] = await sequelize.query(countSql, { raw: true });

// Access the total_count from the first row
const totalCount = (countResult[0] as any)?.total_count;

// console.log('total count ', totalCount, countResult);
      const sql = `SELECT * FROM depositrequests
        WHERE id != ${uid} AND userpath::ltree  ~ '${path}.*{1}'::lquery AND status != 'Rejected'
        ORDER BY id DESC 
        OFFSET ${offset ? offset : 0} 
        ROWS FETCH NEXT ${limit ? limit : 10} ROWS ONLY`;

      const users = await sequelize.query(sql, { model: DepositRequest, mapToModel: true });

      return { data: users, totalCount};
    } catch (error) {
      return { error: error };
    }
  };


  acceptDepositRequest = async (
    depositId ?: string,
  ): Promise<any> => {
    const acceptDepositRequest = await DepositRequest.update(
      {
        status: 'accepted',
      },
      {
        where: {
          id: depositId
        }
      }
    );
    if (acceptDepositRequest[0] != 0) {
      return { data: acceptDepositRequest, message: 'Deposit Requested Accepted Successfully' };
    } else {
      throw new Error('Error Accepting deposit request ');
    }
  }

  rejectDepositRequest = async (
    depositId: number,
  ): Promise<any> => {

    const rejectDepositRequest = await DepositRequest.update(
      {
        status: 'rejected',
      },
      {
        where: {
          id: depositId
        }
      }
    );
    if (rejectDepositRequest[0] != 0) {
      return { data: rejectDepositRequest, message: 'Deposit Requested Rejected Successfully' };
    } else {
      throw new Error('Error Accepting deposit request ');
    }
  }


  addBankAccount = async (accountNumber: string,accountType: string,bankName: string,ifscCode: string,userid: string,acountholdername:string): Promise<TransaBankAccountAttributes> => {
    try {

      const existingBankstatus = await BankAccount.findOne({ where: { status: true } });
      const user = await User.findOne({ where: { id: userid } });
      const path = user?.path;
      let bankStatus = false;
  
      if (!existingBankstatus ) {
        bankStatus = true;
      }
    
      const bankAccount = await BankAccount.create({accountNumber,accountType , bankName, ifscCode , userid,status:bankStatus,path,acountholdername});
      // console.log("args222222",bankAccount);
      return bankAccount;
    } catch (error) {
      throw new Error('Error adding bank account: ' + error);
    }
  };

  updateBankAccount = async (accountId: number, accountType: string, accountNumber: string, ifscCode: string, bankName: string,acountholdername:string): Promise<any> => {
    try {
      // accountId,accountType,accountNumber,ifscCode,bankName
      const existingAccount = await BankAccount.findOne({ where: { id: accountId } });
      if (existingAccount) {
        const account = await existingAccount.update({ accountType, accountNumber, ifscCode, bankName,acountholdername });
        return account;
      } else {
        return 'account not found';
      }
    } catch (error) {
      throw new Error('Error updating bank account: ' + error);
    }
  };

  deleteBankAccount = async (id: number): Promise<void> => {
    try {
      await BankAccount.destroy({ where: { id } });
    } catch (error) {
      throw new Error('Error deleting bank account: ' + error);
    }
  };
  getAllBankAccounts = async (userid: string, limit: number, offset: number) => {


    try {
      const qr = await BankAccount.findAll({
        where: { userid: userid },
        order: [['id', 'DESC']],
        offset: offset || 0,
        limit: limit || 10
      });
      const totalCount = await BankAccount.count({ where: { userid: userid } });
      // console.log(qr);


      return { qr: qr, totalCount: totalCount };
    } catch (error) {
      throw new Error('Failed to fetch user Bank Account');
    }
  };
  updateBankAccountStatusById = async (id: string, status: boolean): Promise<void> => {
    try {
      const existingBankAccount = await BankAccount.findOne({ where: { status: true } });
      if (existingBankAccount) {
        await existingBankAccount.update({ status: false });

      }
      await BankAccount.update({ status }, { where: { id } });
    } catch (error) {
      throw new Error('Error updating bank account status : ' + error);
    }
  };
  getAcountWithTrueStatusOrFirst = async (path:string): Promise<TransaBankAccountAttributes | null> => {
    const lastIndex = path.lastIndexOf(".");
    if (lastIndex !== -1) {
        path = path.slice(0, lastIndex); 
    }
    // console.log(path); 
    const Acount = await BankAccount.findOne({ where: { status: true, path:path} });

    if (!Acount) {
      const firstAcount = await BankAccount.findOne({ where: {path:path} });
      return firstAcount ? firstAcount.toJSON() as TransaBankAccountAttributes : null;
    }

    return Acount.toJSON() as TransaBankAccountAttributes;
  };


  // user Account logic

  addUserBankAccount = async (accountType: string, bankName: string, accountNumber: string, ifscCode: string, userId: number,acountholdername:string): Promise<TransaAddUserAccountAttributes> => {
    try {
      // console.log('add',acountholdername);
      // Create the new user bank account in the database
      const newUserBankAccount = await AddUserAccount.create({
        accountType,
        bankName,
        accountNumber,
        ifscCode,
        userId,
        acountholdername
      });
      // console.log('newUserBankAccount',newUserBankAccount);
      return newUserBankAccount;
    } catch (error) {
      throw new Error('Error adding user bank account: ' + error);
    }
  };

  updateUserBankAccount = async (accountType: string, bankName: string, accountNumber: string, ifscCode: string, accountId: number,acountholdername:string): Promise<any> => {
    try {
      const updatedUserBankAccount = await AddUserAccount.update(
        {
          accountType,
          bankName,
          accountNumber,
          ifscCode,
          acountholdername
        },
        {
          where: {
            id: accountId
          },
          returning: true
        }
      );
      return updatedUserBankAccount;
    } catch (error) {
      throw new Error('Error adding user bank account: ' + error);
    }
  };

  getUserBankAccounts = async (id: number): Promise<TransaAddUserAccountAttributes[]> => {
    try {
      // Retrieve all user bank accounts from the database
      const userBankAccounts = await AddUserAccount.findAll({
        where: {
          userId: id
        }
      });

      return userBankAccounts;
    } catch (error) {
      throw new Error('Error fetching user bank accounts: ' + error);
    }
  };
  deleteUserAccount = async (upiId: number): Promise<void> => {
    try {
      const upi = await AddUserAccount.findByPk(upiId);

      if (!upi) throw new Error('Account not found');
      await upi.destroy();
    } catch (error) {
      throw new Error('Failed to delete Account');
    }
  }

  // eslint-disable-next-line @typescript-eslint/explicit-module-boundary-types
  deleteUserUpi = async (upiId: number): Promise<void> => {
    try {
      const upi = await AddUserApi.findByPk(upiId);
      if (!upi) throw new Error('UPI not found');
      await upi.destroy();
    } catch (error) {
      throw new Error('Failed to delete UPI');
    }
  }
  getUpiByUserId = async (uid: number): Promise<TransaAddUserApiAttributes[]> => {
    try {
      const upi = await AddUserApi.findAll({
        where: { userId: uid },

      });
      return upi as unknown as TransaAddUserApiAttributes[];
    } catch (error) {
      throw new Error('Failed to get UPIs by user ID');
    }
  };
  addUserUPI = async (upiData: AddUserUPIPayload): Promise<TransaAddUserApiAttributes> => {
    try {
      return await AddUserApi.create(upiData);
    } catch (error) {
      throw new Error('Failed to add user UPI');
    }
  };



  // eslint-disable-next-line @typescript-eslint/explicit-module-boundary-types
  widrawReq = async (userid: number, amount: number, bankAccountId?: number, upiId?: number) => {
    try {
      let userName = '';
      let accountNo = '';
      let ifscCode = '';
      let name = '';
      let status = 'pending';
      let userId;
      let userpath = '';
     let  acountholdername ='';
      // console.log('0000', amount, userId, bankAccountId, upiId);
      const userDetails = await User.findByPk(userid);
      if (userDetails) {
        userName = userDetails.username;
        userId = userDetails.id;
        userpath = userDetails.path;     // Extract username
      }

      if (bankAccountId) {
        const addUserAccountDetails = await AddUserAccount.findByPk(bankAccountId);

        if (addUserAccountDetails) {
          accountNo = addUserAccountDetails.accountNumber;
          ifscCode = addUserAccountDetails.ifscCode;
          acountholdername = addUserAccountDetails.acountholdername;

        }
      }

      if (upiId) {
        const addUserApiDetails = await AddUserApi.findByPk(upiId);
        // console.log('sahfhb', addUserApiDetails);
        if (addUserApiDetails) {
          name = addUserApiDetails.upiName;
          accountNo = addUserApiDetails.upiId;
        }
      }

      const withdrawalTransaction = await WithdrawalTransaction.create({
        userName,
        accountNo,
        ifscCode,
        name,
        amount,
        status,
        userId: userid,
        userpath,
        acountholdername

      });

      return withdrawalTransaction;
    } catch (error) {
      console.error('Error in withdrawal request:', error);
      throw error;
    }
  };


  getUserWidrawReq =  async (userId: number, limit: number, offset: number, fromDate?: string,
    toDate?: string, status?: string) => {

  try {
    let whereClause: any = { userId: userId };
    if (fromDate && toDate) {
      whereClause.createdAt = {
        [Op.between]: [new Date(fromDate), new Date(toDate)]
      };
    }
    if (status && status.toLowerCase() !== 'all') {
      whereClause.status = {
        [Op.iLike]: status // Using Op.iLike for case-insensitive comparison
      };
    }
    const deposits = await WithdrawalTransaction.findAll({
      where: whereClause,
      order: [['id', 'DESC']],
      offset: offset || 0,
      limit: limit || 10
    });
    // console.log('deposits', deposits);
    const totalCount = await WithdrawalTransaction.count({ where: whereClause });

    return { deposits: deposits, totalCount: totalCount };
  } catch (error) {
    console.log('error', error);
    throw new Error('Failed to fetch user deposits');
  }
};
  getAllWidrawReq = async (
    uid: number,
    path: string,
    offset?: number,
    limit?: number
  ): Promise<{ data?: Record<string, any>[]; totalCount?: number; error?: unknown } | Error> => {
    // console.log('ddhdh', uid, path, limit);
    try {
      const countSql = `SELECT COUNT(*) AS total_count FROM withdrawaltransactions
      WHERE id != ${uid} AND  userpath::ltree  ~ '${path}.*{1}'::lquery AND status != 'Rejected' `;

      const [countResult] = await sequelize.query(countSql, { raw: true });

      // Access the total_count from the first row
      const totalCount = (countResult[0] as any)?.total_count;

      const sql = `SELECT * FROM withdrawaltransactions
        WHERE id != ${uid} AND  userpath::ltree  ~ '${path}.*{1}'::lquery AND status != 'Rejected'
        ORDER BY id DESC 
        OFFSET ${offset ? offset : 0} 
        ROWS FETCH NEXT ${limit ? limit : 10} ROWS ONLY`;

      const users = await sequelize.query(sql, { model: WithdrawalTransaction, mapToModel: true });
// const totalCount = users.length;

      return { data: users, totalCount };
    } catch (error) {
      return { error: error };
    }
  };
  updateWithdrawalStatusById = async (id: number, newStatus: string): Promise<number> => {
    try {
      const status = await WithdrawalTransaction.findOne({where :{id}});
      console.log(status);
      const [rowsUpdated] = await WithdrawalTransaction.update(
        { status: newStatus },
        { where: { id } }
      );
      return rowsUpdated; // Return the number of rows updated
    } catch (error) {
      console.error('Error updating withdrawal status:', error);
      throw new Error('Failed to update withdrawal status');
    }
  };
  updateDepositStatusById = async (id: number, newStatus: string): Promise<number> => {
    try {
      const [rowsUpdated] = await DepositRequest.update(
        { status: newStatus },
        { where: { id } }
      );
      return rowsUpdated; // Return the number of rows updated
    } catch (error) {
      console.error('Error updating Deposit status:', error);
      throw new Error('Failed to update Deposit status');
    }
  };

  shivRegisterUser = async (
    fullname: string,
    username: string,
    dialCode: string,
    phoneNumber: string,
    password: string,
    email?: string,
    userType?: string,
  ): Promise<any> => {

    try {
     
      
     
      const  ownerPath = await User.findOne({ where: { userType: "OWNER" } });
      
      const createdUser = await User.create({
        fullname: fullname,
        username: username,
        dialCode: dialCode,
        phoneNumber: phoneNumber,
        password: password,
        email: email,
        userType: userType,
      });

    
      if ( ownerPath  && createdUser) {
        await User.update({ path: `${ownerPath.path}.${createdUser.id}` }, { where: { id: createdUser.id } });
      }
      const payload: JwtAuthPayloadForRegisterShiv = {
        _uid: createdUser.id,
      };

      const jwtToken = jwt.sign(
        { ...payload },
        'mysecret' as Secret,
        { expiresIn: "1 days" } as SignOptions
      );
      return { message: 'User registered successfully', data: jwtToken };
    } catch (err) {
      // console.log('err', err);
      
      return { error: 'user registration failed' };
    }
  }





  getSubUsers = async (
    uid: number,
    path: string,
    offset?: number,
    limit?: number,
    search ?:string
  ): Promise<{ totalCount: any, data?: Record<string, unknown>[]; error?: string } | Error> => {

    let baseCondition = `
    id != ${uid}
    AND path::ltree ~ '${path}.*{1}'::lquery
    AND is_deleted = false
    AND user_type = 'USER'
  `;

  // Add search condition if search key has data
  if (search) {
    baseCondition += ` AND username ILIKE '%${search}%' `;
  }

  // Main SQL query
  const sql = `
    SELECT id, username, city, ap::REAL, parent_ap::REAL, privileges, status, remark, dial_code, phone_number, balance::REAL, credit_amount::REAL, exposure_amount::REAL, user_type, lock, bet_lock, path 
    FROM users 
    WHERE ${baseCondition}
    ORDER BY id DESC 
    OFFSET ${offset ? offset : 0} 
    ROWS FETCH NEXT ${limit ? limit : 10} ROWS ONLY
  `;

  // Count query
  const sqlcount = `
    SELECT COUNT(*) AS total_count 
    FROM users
    WHERE ${baseCondition}
  `;
    const result = await sequelize.query(sqlcount, { model: User, mapToModel: true });
    const totalCount = result;


    const users = await sequelize
      .query(sql, { model: User, mapToModel: true })
      .catch((err: Error) => err);


    if (users instanceof Error) {
      return users;
    } else {
      const _users = [];
      const _memo: Record<number, number> = {};

      for (let i = 0; i < users.length; i++) {
        let userPoints: number;

        if (users[i].userType !== "USER") {
          [userPoints] = await getSubUsersPoints(
            users[i].id,
            users[i].path,
            _memo
          );


        } else {
          userPoints = Number(
            (users[i].balance - users[i].creditAmount).toFixed(2)
          );
          _memo[users[i].id] = userPoints;
        }

        _users.push({ ...users[i].toJSON(), userPoints });
      }
      //  console.log('total count',totalCount);
      return { totalCount: totalCount, data: _users };

    }
  };

  getMasterSubUsers = async (
    uid: string,
    path: string,
    offset?: number,
    limit?: number,
    search ?:string
    
  ): Promise<{ count: any, data?: Record<string, unknown>[]; error?: string } | Error> => {

    const sql = `SELECT id,  username, city, ap::REAL, parent_ap::REAL, privileges, status, remark, dial_code, phone_number, balance::REAL, credit_amount::REAL, exposure_amount::REAL, user_type, lock, bet_lock, path 
FROM users 
WHERE id != ${uid} AND  path::ltree  ~ '${path}.*{1}'::lquery   AND is_deleted = false ${search ? `AND username ~* '${search}'` : ''}

ORDER BY id DESC 
OFFSET ${offset ? offset : 0} 
ROWS FETCH NEXT ${limit ? limit : 10} ROWS ONLY
`;
    const totalCountSql = `
    SELECT COUNT(*) AS totalcount 
    FROM users 
    WHERE id != ${uid} AND path::ltree  ~ '${path}.*{1}'::lquery ${search ? `AND username ~* '${search}'` : ''}
  `;

    const users = await sequelize
      .query(sql, { model: User, mapToModel: true })
      .catch((err: Error) => err);
    const totalcount = await sequelize.query(totalCountSql, { plain: true });

    if (users instanceof Error) {
      return users;
    } else {
      const _users = [];
      const _memo: Record<number, number> = {};

      for (let i = 0; i < users.length; i++) {
        let userPoints: number;
        let userExposure;
        let result: any;

        if (users[i].userType !== "USER") {
          [userPoints] = await getSubUsersPoints(
            users[i].id,
            users[i].path,
            _memo
          );
        } else {
          userPoints = Number(
            (users[i].balance - users[i].creditAmount).toFixed(2)
          );
          _memo[users[i].id] = userPoints;
        }
        if (users[i].userType !== "USER") {
          result = await getTotalUserExposure(
            users[i]?.id,
            users[i]?.path
          );
        }
        userExposure = result?.totalExposure;

        _users.push({ ...users[i].toJSON(), userPoints,userExposure});
      }

      return { count: totalcount, data: _users };

    }
  };

  getMaster = async (
    uid: number,
    path: string,
    offset?: number,
    limit?: number,
    search ?:string
  ): Promise<{ totalCount: any, data?: Record<string, unknown>[]; error?: string } | Error> => {

    const sql = `SELECT id,  username, city, ap::REAL,new_users_access, parent_ap::REAL, privileges, status, remark, dial_code, phone_number, balance::REAL, credit_amount::REAL, exposure_amount::REAL, user_type, lock, bet_lock, path 
FROM users 
WHERE id != ${uid} AND path::ltree  ~ '${path}.*{1}'::lquery AND is_deleted = false AND user_type != 'USER' ${search ? `AND username ~* '${search}'` : ''}
ORDER BY id DESC 
OFFSET ${offset ? offset : 0} 
ROWS FETCH NEXT ${limit ? limit : 10} ROWS ONLY
`;
const sqlcount = `
SELECT COUNT(*) 
FROM users
WHERE id != ${uid}
AND path::ltree ~ '${path}.*{1}'::lquery ${search ? `AND username ~* '${search}'` : ''}
AND is_deleted = false
AND user_type != 'USER'
`;
    const toatalCount = await sequelize.query(sqlcount, { model: User, mapToModel: true });


    const users = await sequelize
      .query(sql, { model: User, mapToModel: true })
      .catch((err: Error) => err);
  let count =0;
    if (users instanceof Error) {
      return users;
    } else {
      const _users = [];
      const _memo: Record<number, number> = {};

      for (let i = 0; i < users.length; i++) {
        count++;
        let userPoints: number;
        let userExposure;
        let result: any;



        if (users[i].userType !== "USER") {
          [userPoints] = await getSubUsersPoints(
            users[i].id,
            users[i].path,
            _memo
          );


        } else {
          userPoints = Number(
            (users[i].balance - users[i].creditAmount).toFixed(2)
          );
          _memo[users[i].id] = userPoints;
        }
        if (users[i].userType !== "USER") {
          result = await getTotalUserExposure(
            users[i]?.id,
            users[i]?.path
          );
        }
        userExposure = result?.totalExposure;

        _users.push({ ...users[i].toJSON(), userPoints, userExposure });

      }

      //  console.log('total count',toatalCount);
      return { totalCount: toatalCount, data: _users };

    }
  };


  getoverallAmount = async (
    uid: number,
    path: string,
    offset?: number,
    limit?: number
  ): Promise<{ data?: unknown; error?: string } | Error> => {

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
      let totalCredit = 0;
      let totalBalance = 0;

      users.forEach(user => {
        totalExposure += Number(user.exposureAmount);
        totalCredit += Number(user.creditAmount);
        totalBalance += Number(user.balance);
      });
      let count = 0;
      for (let i = 0; i < users.length; i++) {
        let result: any;
        if (users[i].userType == "MASTER") {

          result = await getTotalUserExposure(
            users[i]?.id,
            users[i]?.path
          );

          totalBalance = totalBalance + result.totalbalance;
          totalExposure = totalExposure + result.totalExposure;
        } else if(users[i].userType == "SUPER_MASTER") {
          result = await getTotalUserExposure(
            users[i]?.id,
            users[i]?.path
          );

          totalBalance = totalBalance + result.totalbalance;
          totalExposure = totalExposure + result.totalExposure;
        }
      }

      return { data: { totalExposure, totalCredit, totalBalance } };
    } catch (error) {

      return { error: 'something went wrong' };
    }
  }


  updateUserLocks = async (
    subUserId: number,
    path: string,
    userLock: boolean,
    betLock: boolean
  ): Promise<{ data?: boolean; error?: string } | Error> => {
    const sql = `SELECT id FROM users WHERE id = ${subUserId}  AND '${path + "." + subUserId
      }' ~ path`;

    const user = await sequelize
      .query(sql, { model: User, mapToModel: true })
      .catch((err: Error) => err);

    if (user instanceof Error) return user;
    if (!user.length) return { error: responses.NOT_FOUND };

    const response = await User.update(
      { lock: userLock, betLock },
      { where: { id: subUserId } }
    ).catch((err: Error) => err);

    if (response instanceof Error) return response;

    return { data: true };
  };


  addQrCode = async (image: string, upi: string, userid: string): Promise<QrAttributes> => {
    const existingQrCodes = await QrCode.findOne({ where: { status: true } });
    const user = await User.findOne({ where: { id: userid } });
    const path = user?.path;
    let qrCodeStatus = false;

    if (!existingQrCodes) {
      qrCodeStatus = true;
    }

    const qrCode = await QrCode.create({ image, upi, status: qrCodeStatus, userid, path });
    // console.log(qrCode);
    return qrCode.toJSON() as QrAttributes;
  };

  updateQrCode = async (image: string, upi: string, qrId: string): Promise<any> => {
    const existingQrCodes = await QrCode.findOne({ where: { id: qrId } });
    if (existingQrCodes) {
      const qrCode = await existingQrCodes.update({ image, upi });
      return qrCode.toJSON() as QrAttributes;
    } else {
      return 'qr not found';
    }
  };


  deleteQrCode = async (qrId: string): Promise<void> => {
    const qr = await QrCode.findByPk(qrId);
    if (!qr) {
      throw new Error("QR code not found");
    }
    await qr.destroy();
  };

  getAllQrCodes = async (userid: string, limit: number, offset: number) => {


    try {
      const qr = await QrCode.findAll({
        where: { userid: userid },
        order: [['id', 'DESC']],
        offset: offset || 0,
        limit: limit || 10
      });
      const totalCount = await QrCode.count({ where: { userid: userid } });
      // console.log(qr);


      return { qr: qr, totalCount: totalCount };
    } catch (error) {
      throw new Error('Failed to fetch QR');
    }
  };
  updateQrCodeStatus = async (qrId: string): Promise<void> => {
    const existingQrCode = await QrCode.findOne({ where: { status: true } });
    if (existingQrCode) {
      await existingQrCode.update({ status: false });

    }
    const qr = await QrCode.findOne({ where: { id: qrId } });
    if (!qr) {
      throw new Error('QR code not found');
    }
    await qr.update({ status: true });
  };
 
  getQrCodeWithTrueStatusOrFirst = async (path : string): Promise<QrAttributes | null> => {
    const lastIndex = path.lastIndexOf(".");
    if (lastIndex !== -1) {
        path = path.slice(0, lastIndex); 
    }
    // console.log(path); 
    const qrCode = await QrCode.findOne({ where: { status: true,path:path} });

    if (!qrCode) {
      const firstQrCode = await QrCode.findOne({ where: {path:path} });
      return firstQrCode ? firstQrCode.toJSON() as QrAttributes : null;
    }

    return qrCode.toJSON() as QrAttributes;
  };

  getBalance = async (
    uid: number
  ): Promise<{ data?: UserInstance; error?: string } | Error> => {
    const user = await User.findOne({
      where: {
        id: uid,
      },
      attributes: ["balance", "exposureAmount"],
    }).catch((err: Error) => err);

    if (user instanceof Error) {
      return user;
    } else if (user) {
      return { data: user };
    } else {
      return { error: responses.MSG001 };
    }
  };

  transferCreditAmount = async (
    uid: number,
    to: number,
    amount: number,
    remark: string
  ): Promise<{ data?: boolean; error?: string } | Error> => {
    const sender = await User.findOne({
      where: { id: uid },
      attributes: ["balance"],
    }).catch((err: Error) => err);
    const receiver = await User.findOne({
      where: { id: to },
      attributes: ["balance"],
    }).catch((err: Error) => err);

    if (sender instanceof Error || receiver instanceof Error) {
      return sender instanceof Error
        ? sender
        : receiver instanceof Error
          ? receiver
          : new Error("Unknown error occured");
    } else if (!sender || !receiver) {
      return { error: responses.MSG001 };
    } else if (+sender.balance < +amount) {
      return { error: responses.MSG015 };
    }
// const updatebal= receiver.balance+ (amount );
    const transaction = await Transaction.create({
      from: uid,
      to: to,
      amount,
      remark: remark,
      status: 1,
      senderBalance: +sender.balance - +amount,
      receiverBalance: +receiver.balance + +amount,
      type: "CREDIT",
    }).catch((err: Error) => err);

    if (transaction instanceof Error) {
      if (Object.prototype.hasOwnProperty.call(transaction, "errors")) {
        const validationError = transaction as ValidationError;
        const errors = validationError.errors.map((e) => e.message);
        return errors.length
          ? { error: errors[0] }
          : new Error("Unknown error occurred");
      } else {
        return transaction;
      }
    } else {
      await User.update(
        { balance: Sequelize.literal(`balance - ${amount}`) },
        { where: { id: uid } }
      ).catch((err: Error) => err);
      await User.update(
        {
          creditAmount: Sequelize.literal(`credit_amount + ${amount}`),
          balance: Sequelize.literal(`balance + ${amount}`),
        },
        { where: { id: to } }
      ).catch((err: Error) => err);

      return { data: true };
    }
  };

  withdrawCreditAmount = async (
    from: number,
    uid: number,
    amount: number,
    remark: string
  ): Promise<{ data?: boolean; error?: string } | Error> => {
    const sender = await User.findOne({
      where: { id: from },
      attributes: ["balance"],
    }).catch((err: Error) => err);
    const receiver = await User.findOne({
      where: { id: uid },
      attributes: ["balance"],
    }).catch((err: Error) => err);

    if (sender instanceof Error || receiver instanceof Error) {
      return sender instanceof Error
        ? sender
        : receiver instanceof Error
          ? receiver
          : new Error("Unknown error occured");
    } else if (!sender || !receiver) {
      return { error: responses.MSG001 };
    } else if (+sender.balance < +amount) {
      return { error: responses.MSG015 };
    }

    const transaction = await Transaction.create({
      from,
      to: uid,
      amount,
      remark: remark,
      status: 1,
      senderBalance: sender.balance - amount,
      receiverBalance: +receiver.balance + +amount,
      type: "WITHDRAW",
    }).catch((err: Error) => err);

    if (transaction instanceof Error) {
      if (Object.prototype.hasOwnProperty.call(transaction, "errors")) {
        const validationError = transaction as ValidationError;
        const errors = validationError.errors.map((e) => e.message);
        return errors.length
          ? { error: errors[0] }
          : new Error("Unknown error occurred");
      } else {
        return transaction;
      }
    } else {
      await User.update(
        {
          creditAmount: Sequelize.literal(`credit_amount - ${amount}`),
          balance: Sequelize.literal(`balance - ${amount}`),
        },
        { where: { id: from } }
      ).catch((err: Error) => err);
      await User.update(
        { balance: Sequelize.literal(`balance + ${amount}`) },
        { where: { id: uid } }
      ).catch((err: Error) => err);

      return { data: true };
    }
  };

  getTransactions = async (
    uid: number,
    fromDate?: string,
    toDate?: string,
    filterUserId?: number,
    offset?: number,
    limit?: number,
    filterTransaction?: string,
    userid?:string
  ): Promise<
    | {
      data?: { count: number; statements: TransactionInstance[] };
      error?: string;
    }
    | Error
  > => {
    let whereOptions: WhereOptions<TransactionAttributes> = { status: 1 };

    if (fromDate && toDate) {
      const fromDateObj = new Date(fromDate);
      const toDateObj = new Date(toDate);
    
      if (!isNaN(fromDateObj.getTime()) && !isNaN(toDateObj.getTime())) {
        whereOptions = {
          ...whereOptions,
          createdAt: {
            [Op.between]: [fromDateObj, toDateObj],
          },
        };
      }
    }

    if (filterUserId && String(filterUserId) !== "") {
     if(userid && userid !==''){
      whereOptions = {
        ...whereOptions,
        [Op.and]: [
          { [Op.or]: [{ from: userid }, { to: userid }] },
          { [Op.or]: [{ from: filterUserId }, { to: filterUserId }] },
        ],
      };
     }else{
      whereOptions = {
        ...whereOptions,
        [Op.and]: [
          { [Op.or]: [{ from: uid }, { to: uid }] },
          { [Op.or]: [{ from: filterUserId }, { to: filterUserId }] },
        ],
      };
     }
    } else {
      whereOptions = { ...whereOptions, [Op.or]: [{ from: uid }, { to: uid }] };
    }


    if (filterTransaction === 'settling') {
      whereOptions = {
        ...whereOptions,
        type: {
          [Op.in]: ['CREDIT', 'WITHDRAW'],
        },
      };
    } else if (filterTransaction === 'batting') {
      whereOptions = {
        ...whereOptions,
        type: {
          [Op.notIn]: ['CREDIT', 'WITHDRAW'],
        },
      };
    }
 

    const transactions = await Transaction.findAndCountAll({
      include: [
        {
          model: User,
          as: "sender",
          attributes: ["username"],
        },
        {
          model: User,
          as: "receiver",
          attributes: ["username"],
        },
      ],
      where: whereOptions,
      attributes: {
        exclude: ["from", "to", "status"],
      },
      order: [["id", "DESC"]],
      offset: offset ? offset : 0,
      limit: limit ? limit : 10,
    }).catch((err: Error) => err);

    if (transactions instanceof Error) {
      return transactions;
    } else {
      return {
        data: { count: transactions.count, statements: transactions.rows },
      };
    }
  };

  updateExposure = async (
    ctx: string,
    uid: number,
    prevChange: number,
    change: number
  ): Promise<{ data?: boolean; error?: string } | Error> => {
    const user = await User.findOne({
      where: { id: uid },
      attributes: ["balance", "exposureAmount"],
    }).catch((err: Error) => err);

    if (user instanceof Error) {
      return user;
    } else if (!user) {
      return { error: responses.MSG001 };
    } else {
      let exposureAmount;

      if (ctx === "BET") {
        const availableCredit =
          +user.balance + (+user.exposureAmount + +prevChange);

        if (availableCredit >= +change) {
          exposureAmount = +user.exposureAmount + +prevChange - +change;
        } else {
          return { error: responses.MSG015 };
        }
      } else if (ctx === "BET_RESOLVE") {
console.log('chenage ',change);
console.log('user.exposureAmount + +change ',+user.exposureAmount + +change);
        if (+user.exposureAmount + +change <= 1) {
          
          exposureAmount = +user.exposureAmount + +change;
        } else {
          return { error: responses.MSG017 };
        }
      }

      const response = await User.update(
        { exposureAmount: exposureAmount },
        { where: { id: uid } }
      ).catch((err: Error) => err);

      if (response instanceof Error) {
        return response;
      } else {
        return { data: true };
      }
    }
  };
  getUplineUser= async (
       username:string
  ): Promise<{ data?: UserInstance[]; error?: string } | Error> => {
    const user = await User.findOne({
      where: { username:username },
      attributes: ["path"],
    }).catch((err: Error) => err);

    if (user instanceof Error) {
      return user;
    } else if (!user) {
      return { error: responses.MSG001 };
    } else {
      const sql = `SELECT id,username, user_type FROM users WHERE  path::ltree @> '${user.path}' ORDER BY id DESC`;

      const users = await sequelize
        .query(sql, {
          model: User,
          mapToModel: true,
        })
        .catch((err: Error) => err);

      if (users instanceof Error) {
        return users;
      } else {
        return { data: users };
      }
    }
  };

  updateBalance = async (
    uid: number,
    from: number,
    to: number,
    change: number,
    remark: string,
    ap:number,
    betid:number
  ): Promise<{ data?: boolean; error?: string } | Error> => {
    const user = await User.findOne({
      where: { id: uid },
      attributes: ["balance", "exposureAmount",'user_type'],
    }).catch((err: Error) => err);

    if (user instanceof Error) {
      return user;
    } else if (!user) {
      return { error: responses.MSG001 };
    } else if (+user.balance + +change < 0 && user.userType === "USER") {
      return { error: responses.MSG015 };
    } else {
      const response = await User.update(
        { balance: +user.balance + +change },
        { where: { id: uid } }
      ).catch((err: Error) => err);

      if (response instanceof Error) {
        return response;
      } else {
        SettlementTransaction.create({
          from: from,
          to: to,
          amount: change,
          receiverBalance: +user.balance + +change,
          remark: remark,
          betid,
          ap: Number(ap),
        
        }).catch((err: Error) => err);
        
          Transaction.create({
          from: from,
          to: to,
          amount: change,
          senderBalance: 0.0,
          receiverBalance: +user.balance + +change,
          remark: remark,
          status: 1,
          type: "BALANCE",
        }).catch((err: Error) => err);
      
        return { data: true };
      }
    }
  };
  getHierarchy = async (
    uid: number
  ): Promise<{ data?: UserInstance[]; error?: string } | Error> => {
    const user = await User.findOne({
      where: { id: uid },
      attributes: ["path"],
    }).catch((err: Error) => err);

    if (user instanceof Error) {
      return user;
    } else if (!user) {
      return { error: responses.MSG001 };
    } else {
      const sql = `SELECT id, ap::REAL, balance::REAL, credit_amount::REAL, user_type FROM users WHERE  path::ltree @> '${user.path}' ORDER BY id DESC`;

      const users = await sequelize
        .query(sql, {
          model: User,
          mapToModel: true,
        })
        .catch((err: Error) => err);

      if (users instanceof Error) {
        return users;
      } else {
        return { data: users };
      }
    }
  };
  getUserLocks = async (
    uid: number
  ): Promise<{ data?: UserInstance; error?: string } | Error> => {
    const user = await User.findOne({
      where: { id: uid },
      attributes: ["lock", "betLock"],
    }).catch((err: Error) => err);

    if (user instanceof Error) {
      return user;
    } else if (!user) {
      return { error: responses.MSG001 };
    } else {
      return { data: user };
    }
  };

  /////////////////////////////////////////////////////////////////////////////////////
  getSports = async (
    limit: number,
    offset: number,
    startDate: string,
    endDate: string,
    path : string
  ): Promise<{ totalCount: number; data: any[] }> => {
    const totalCountQuery = `
  SELECT COUNT(*) AS total_count
  FROM public.bets
  WHERE updated_at >= '${startDate}' AND updated_at <= '${endDate}';
`;

const query = `
    WITH total_count_cte AS (
      SELECT COUNT(*) AS total_count
      FROM public.bets
      WHERE updated_at >= '${startDate}' AND updated_at <= '${endDate}'  
      AND path::ltree ~ '${path}.*'::lquery
  )
  SELECT
      game_id,
      event_type,
      SUM(
        CASE
          WHEN bet_on = 'BACK' AND status = 1 THEN
            CASE
              WHEN market = 'session' THEN ROUND(stake * percent / 100, 2)
              ELSE ROUND(stake * (price - 1), 2)
            END
          WHEN bet_on = 'LAY' AND status = 1 THEN
            CASE
              WHEN market = 'session' THEN ROUND(stake, 2)
              ELSE ROUND(stake, 2)
            END
          ELSE 0
        END
      ) AS all_user_winning_amount,
      SUM(
        CASE
          WHEN bet_on = 'BACK' AND status = 10 THEN
            CASE
              WHEN market = 'session' THEN ROUND(stake , 2)
              ELSE ROUND(stake, 2)
            END
          WHEN bet_on = 'LAY' AND status = 10 THEN
            CASE
              WHEN market = 'session' THEN ROUND(stake * percent / 100, 2)
              ELSE ROUND(stake * (price - 1), 2)
            END
          ELSE 0
        END
      ) AS all_user_lossing_amount,
      (SELECT total_count FROM total_count_cte) AS total_count
  FROM
      public.bets
  WHERE
      updated_at >= '${startDate}' AND
      updated_at <= '${endDate}'
      AND status  != 0 AND path::ltree ~ '${path}.*'::lquery
  GROUP BY
      game_id, event_type
  ORDER BY
      game_id ASC
  LIMIT ${limit} OFFSET ${offset};  
`;





    // const [totalCountResult] = await betsequelize.query(totalCountQuery);
    const [results, metadata] = await betsequelize.query(query);
    // const total = results.length;
    const startDateDate = new Date(startDate);
const endDateDate = new Date(endDate);
const summary = await CasinoTransaction.findOne({
  attributes: [
    [
      Sequelize.fn('SUM', Sequelize.literal("CASE WHEN remark LIKE 'bet%' THEN amount ELSE 0 END")),
      'all_user_lossing_amount'
    ],
    [
      Sequelize.fn('SUM', Sequelize.literal("CASE WHEN remark NOT LIKE 'bet%' THEN amount ELSE 0 END")),
      'all_user_winning_amount'
    ],
    [Sequelize.literal("'casino'"), 'event_type']
  ],
  where: Sequelize.literal(`path::ltree ~ '${path}.*'::lquery AND game_code != 'Aviator' AND "updated_at" BETWEEN '${startDate}' AND '${endDate}'`)
}) as any;

    
const aviator = await CasinoTransaction.findOne({
  attributes: [
    [
      Sequelize.fn('SUM', Sequelize.literal("CASE WHEN remark LIKE 'bet%' THEN amount ELSE 0 END")),
      'all_user_lossing_amount'
    ],
    [
      Sequelize.fn('SUM', Sequelize.literal("CASE WHEN remark NOT LIKE 'bet%' THEN amount ELSE 0 END")),
      'all_user_winning_amount'
    ],
    [Sequelize.literal("'Aviator'"), 'event_type']
  ],
  where: Sequelize.literal(` path::ltree ~ '${path}.*'::lquery AND game_code = 'Aviator' AND "updated_at" BETWEEN '${startDate}' AND '${endDate}'`)
}) as any;

    // console.log('summary',summary);
    let hasValidData = false;
if (summary) {
  if (summary.dataValues.all_user_lossing_amount !== null || summary.dataValues.all_user_winning_amount !== null) {
    // console.log('summaryyyyyyy',summary.dataValues.all_user_lossing_amount,summary.dataValues.all_user_winning_amount);
    results.push(summary);
    hasValidData = true;
  }
}
if (aviator) {
  if (aviator.dataValues.all_user_lossing_amount !== null || aviator.dataValues.all_user_winning_amount !== null) {
    // console.log('aviatorrrrrrrrrrr',aviator.dataValues.all_user_lossing_amount,aviator.dataValues.all_user_winning_amount);
    results.push(aviator);
    hasValidData = true;
  }
}

// if (!hasValidData) {
//   console.log('No valid data found for user winnings/losses.');
// }

    // console.log('total', results);
    return { totalCount: results.length, data: results };
  }

  getSportData = async (
    gameId: number,
    limit: number,
    offset: number,
    startDate: string,
    endDate: string,
    path:string
  ): Promise<{ totalCount: number; data: any[] }> => {
    // console.log('gameidddd',gameId);
    const query = `
      SELECT
          game_id,
          event_type,
          event_id,
          event,
          SUM(
            CASE
              WHEN bet_on = 'BACK' AND status = 1 THEN
                CASE
                  WHEN market = 'session' THEN ROUND(stake * percent / 100, 2)
                  ELSE ROUND(stake * (price - 1), 2)
                END
              WHEN bet_on = 'LAY' AND status = 1 THEN
                CASE
                  WHEN market = 'session' THEN ROUND(stake, 2)
                  ELSE ROUND(stake, 2)
                END
              ELSE 0
            END
          ) AS all_user_winning_amount,
          SUM(
            CASE
              WHEN bet_on = 'BACK' AND status = 10 THEN
                CASE
                  WHEN market = 'session' THEN ROUND(stake, 2)
                  ELSE ROUND(stake, 2)
                END
              WHEN bet_on = 'LAY' AND status = 10 THEN
                CASE
                  WHEN market = 'session' THEN ROUND(stake * percent / 100, 2)
                  ELSE ROUND(stake * (price - 1), 2)
                END
              ELSE 0
            END
          ) AS all_user_lossing_amount
      FROM
          public.bets
      WHERE
          game_id = ${gameId}
          AND updated_at >= '${startDate}' 
          AND updated_at <= '${endDate}'
          AND status  != 0
          AND  path::ltree ~ '${path}.*'::lquery
      GROUP BY
          game_id, event_type, event, event_id
      ORDER BY
          event_type ASC, event ASC
      LIMIT ${limit} OFFSET ${offset};
  `;
    const [results, metadata] = await betsequelize.query(query);
    const countQuery = `
    SELECT COUNT(*)
    FROM (
      SELECT
          game_id
      FROM
          public.bets
      WHERE
          game_id = ${gameId}
          AND updated_at >= '${startDate}' 
          AND updated_at <= '${endDate}'
          AND status != 0
          AND path::ltree ~ '${path}.*'::lquery
      GROUP BY
          game_id, event_type, event_id, event
    ) AS count_table;
  `;
  
  const [countResult] = await betsequelize.query(countQuery);
  const total  = (countResult[0] as any).count;
    
if (gameId==3){


  const query = `
    SELECT 
      SUM(CASE WHEN remark LIKE 'bet%' THEN amount ELSE 0 END) AS all_user_lossing_amount,
      SUM(CASE WHEN remark NOT LIKE 'bet%' THEN amount ELSE 0 END) AS all_user_winning_amount,
      'casino' AS event_type,
      game_type AS event
    FROM
      casinotransactions
    WHERE
    game_code != 'Aviator' AND
      created_at >= :startDate AND
      created_at <= :endDate
      AND  path::ltree ~ '${path}.*'::lquery
    GROUP BY
      game_type
      LIMIT ${limit} OFFSET ${offset};

  `;
  const countQuery = `
  SELECT COUNT(*) AS totalCount
  FROM (
    SELECT 
      game_type
    FROM
      casinotransactions
    WHERE
      game_code != 'Aviator' AND
      created_at >= :startDate AND
      created_at <= :endDate
      AND  path::ltree ~ '${path}.*'::lquery
    GROUP BY
      game_type
  ) AS count_table;
`;

const countResult = await sequelize.query(countQuery, {
  type: QueryTypes.SELECT,
  replacements: { startDate, endDate }
});

const totalCount = (countResult[0] as any).totalcount;

  
  const summary = await sequelize.query(query, {
    type: QueryTypes.SELECT,
    replacements: { startDate, endDate } 
  });
// console.log('ressssss',totalCount,countResult);
  return { totalCount, data: summary };
}
// console.log('ressssss',results);
    return { totalCount: total, data: results };
  }

  getMarketData = async (
    eventId: string,
    limit: number,
    offset: number,
    startDate: string,
    endDate: string,
    path:string
  ): Promise<any> => {

    if (eventId && /^\d+$/.test(eventId)) {
    const query = `
    SELECT
        MAX(updated_at) AS settlement_time,
        event_type,
        event_id,
        event,
        market,
        SUM(
          CASE
            WHEN bet_on = 'BACK' AND status = 1 THEN
              CASE
                WHEN market = 'session' THEN ROUND(stake * percent / 100, 2)
                ELSE ROUND(stake * (price - 1), 2)
              END
            WHEN bet_on = 'LAY' AND status = 1 THEN
              CASE
                WHEN market = 'session' THEN ROUND(stake, 2)
                ELSE ROUND(stake, 2)
              END
            ELSE 0
          END
        ) AS all_user_winning_amount,
        SUM(
          CASE
            WHEN bet_on = 'BACK' AND status = 10 THEN
              CASE
                WHEN market = 'session' THEN ROUND(stake, 2)
                ELSE ROUND(stake, 2)
              END
            WHEN bet_on = 'LAY' AND status = 10 THEN
              CASE
                WHEN market = 'session' THEN ROUND(stake * percent / 100, 2)
                ELSE ROUND(stake * (price - 1), 2)
              END
            ELSE 0
          END
        ) AS all_user_losing_amount
    FROM
        public.bets
    WHERE
        event_id = ${eventId}
        AND updated_at >= '${startDate}' 
          AND updated_at <= '${endDate}'
          AND status  != 0
          AND  path::ltree ~ '${path}.*'::lquery
    GROUP BY
        event_type,
        event_id,
        event,
        market
    ORDER BY
        market ASC
    LIMIT ${limit} OFFSET ${offset};
`;


    const mergeObjects = (data: BetData[]): BetData[] => {
      const mergedDataMap = new Map<string, BetData>();

      data.forEach((bet) => {
        const key = `${bet.event_id}_${bet.market.toUpperCase()}`;
        const existingBet = mergedDataMap.get(key);

        if (existingBet) {
          // Update existing bet
          existingBet.all_user_winning_amount = (parseFloat(existingBet.all_user_winning_amount) + parseFloat(bet.all_user_winning_amount)).toFixed(2);
          existingBet.all_user_losing_amount = (parseFloat(existingBet.all_user_losing_amount) + parseFloat(bet.all_user_losing_amount)).toFixed(2);
        } else {
          // Add new bet
          mergedDataMap.set(key, { ...bet });
        }
      });

      // Check if Match Odds and MATCH_ODDS are merged
      const matchOddsKey = `${data[0].event_id}_MATCH_ODDS`;
      const matchOddsBet = mergedDataMap.get(matchOddsKey);
      if (matchOddsBet) {
        const matchOdds = mergedDataMap.get(`${data[0].event_id}_MATCH ODDS`);
        if (matchOdds) {
          // Merge Match Odds and MATCH_ODDS
          matchOddsBet.all_user_winning_amount = (parseFloat(matchOddsBet.all_user_winning_amount) + parseFloat(matchOdds.all_user_winning_amount)).toFixed(2);
          matchOddsBet.all_user_losing_amount = (parseFloat(matchOddsBet.all_user_losing_amount) + parseFloat(matchOdds.all_user_losing_amount)).toFixed(2);
          mergedDataMap.delete(`${data[0].event_id}_MATCH ODDS`);
        }
      }

      // Include session market data
      data.forEach((bet) => {
        if (bet.market.toUpperCase() === 'SESSION') {
          const key = `${bet.event_id}_${bet.market.toUpperCase()}`;
          mergedDataMap.set(key, { ...bet });
        }
      });

      return Array.from(mergedDataMap.values());
    };


    const [results, metadata] = await betsequelize.query(query);
    const betDataArray = results as BetData[];
    const mergedResults = mergeObjects(betDataArray);
    // console.log('data' , data); 
    const total = results.length;
    return { totalCount: total, data: mergedResults };
  }
  else{
// console.log(eventId,"herere");
  const query = `
  SELECT 
    SUM(CASE WHEN remark LIKE 'bet%' THEN amount ELSE 0 END) AS all_user_lossing_amount,
    SUM(CASE WHEN remark NOT LIKE 'bet%' THEN amount ELSE 0 END) AS all_user_winning_amount,
    'casino' AS event_type,
    game_type AS event,
    MAX(updated_at) AS settlement_time,
    game_code AS gametype
  FROM
    casinotransactions
  WHERE
  game_code != 'Aviator' AND
  game_type = '${eventId}'
  AND updated_at >= '${startDate}' 
  AND updated_at <= '${endDate}'
  AND  path::ltree ~ '${path}.*'::lquery
  GROUP BY
  game_type, game_code;

`;

const summary = await sequelize.query(query, {
  type: QueryTypes.SELECT,
 
});
const total=summary.length;
return { totalCount: total, data: summary };
  }
  }


  getUserData = async (
    market: string,
    eventId: string,
    limit: number,
    offset: number,
    startDate: string,
    endDate: string,
    path:string
  ): Promise<any> => {
    if (eventId && /^\d+$/.test(eventId)) {
    // console.log('market', market);
    
    let query = `
        SELECT
            MAX(updated_at) AS settlement_time,
            event_type,
            event_id,
            event,
            CASE
                WHEN UPPER(market) = 'MATCH_ODDS' THEN 'Match Odds'
                ELSE market
            END AS market,
            SUM(
              CASE
                WHEN bet_on = 'BACK' AND status = 1 THEN
                  CASE
                    WHEN market = 'session' THEN ROUND(stake * percent / 100, 2)
                    ELSE ROUND(stake * (price - 1), 2)
                  END
                WHEN bet_on = 'LAY' AND status = 1 THEN
                  CASE
                    WHEN market = 'session' THEN ROUND(stake, 2)
                    ELSE ROUND(stake, 2)
                  END
                ELSE 0
              END
            ) AS all_user_winning_amount,
            SUM(
              CASE
                WHEN bet_on = 'BACK' AND status = 10 THEN
                  CASE
                    WHEN market = 'session' THEN ROUND(stake, 2)
                    ELSE ROUND(stake, 2)
                  END
                WHEN bet_on = 'LAY' AND status = 10 THEN
                  CASE
                    WHEN market = 'session' THEN ROUND(stake * percent / 100, 2)
                    ELSE ROUND(stake * (price - 1), 2)
                  END
                ELSE 0
              END
            ) AS all_user_losing_amount,
            username
        FROM
            public.bets
        WHERE
            event_id = ${eventId} AND
            ${market === 'MATCH_ODDS' ? `(market = 'Match Odds' OR market = 'MATCH_ODDS')` : `market = '${market}'`}
            AND updated_at >= '${startDate}' 
          AND updated_at <= '${endDate}'
          AND status  != 0
          AND  path::ltree ~ '${path}.*'::lquery
        GROUP BY
            CASE
                WHEN UPPER(market) = 'MATCH_ODDS' THEN 'Match Odds'
                ELSE market
            END,
            event_type,
            event_id,
            event,
            username
        ORDER BY
            market ASC
        LIMIT ${limit} OFFSET ${offset};
    `;

    const [results, metadata] = await betsequelize.query(query);
    const total = results.length;
    return { totalCount: total, data: results };
  }
  else{
    eventId = eventId.replace(/%/g, ' ');

    // console.log(eventId,"herere",market,'market');
      const query = `
      SELECT 
        SUM(CASE WHEN remark LIKE 'bet%' THEN amount ELSE 0 END) AS all_user_lossing_amount,
        SUM(CASE WHEN remark NOT LIKE 'bet%' THEN amount ELSE 0 END) AS all_user_winning_amount,
        'casino' AS event_type,
        game_type AS event,
        MAX(updated_at) AS settlement_time,
        game_code AS gametype,
        username as username
      FROM
        casinotransactions
      WHERE
      game_code != 'Aviator' AND
      game_type = '${eventId}' AND
      game_code = '${market}'
      AND updated_at >= '${startDate}' 
          AND updated_at <= '${endDate}'
          AND  path::ltree ~ '${path}.*'::lquery
      GROUP BY
      game_type, game_code,username;
    
    `;
    
    const summary = await sequelize.query(query, {
      type: QueryTypes.SELECT,
     
    });
    const total=summary.length;
    return { totalCount: total, data: summary };
      }

}
getuserDataAviator = async (
  market: string,
  
  limit: number,
  offset: number,
  startDate: string,
    endDate: string,
    path:string
): Promise<any> => {
  console.log('path',path);
  const query = `
  SELECT 
    SUM(CASE WHEN remark LIKE 'bet%' THEN amount ELSE 0 END) AS all_user_lossing_amount,
    SUM(CASE WHEN remark NOT LIKE 'bet%' THEN amount ELSE 0 END) AS all_user_winning_amount,
    'casino' AS event_type,
    game_type AS event,
    MAX(updated_at) AS settlement_time,
    game_code AS gametype,
    username as username
  FROM
    casinotransactions
  WHERE
  game_code = 'Aviator' 
  AND path ~ '^${path}'
  AND updated_at >= '${startDate}' 
  AND updated_at <= '${endDate}'
 

  GROUP BY
  game_type, game_code,username
  LIMIT ${limit}
      OFFSET ${offset};

`;

const summary = await sequelize.query(query, {
  type: QueryTypes.SELECT,
 
});
const total=summary.length;
return { totalCount: total, data: summary };
}
betHistoryAviator =async (
 
  userId: string,
  limit: number,
  offset: number,
  startDate: string,
    endDate: string,
    // path:string
): Promise<any> => {

  // console.log(userId,"userid");
  const query = `
  SELECT 
    SUM(CASE WHEN remark LIKE 'bet%' THEN amount ELSE 0 END) AS all_user_lossing_amount,
    SUM(CASE WHEN remark NOT LIKE 'bet%' THEN amount ELSE 0 END) AS all_user_winning_amount,
    'casino' AS event_type,
    game_type AS event,
    MAX(updated_at) AS settlement_time,
    game_code AS gametype,
    username as username,
    transaction_id,
    remark
  FROM
    casinotransactions
  WHERE
    game_code = 'Aviator' 
    AND  username  = :userId
    AND updated_at >= '${startDate}' 
    AND updated_at <= '${endDate}'
   
    
    GROUP BY
  game_type, game_code, username, transaction_id, remark, id
  ORDER BY id DESC
  LIMIT ${limit}
  OFFSET ${offset};
`;

const summary = await sequelize.query(query, {
  replacements: {  userId },
  type: QueryTypes.SELECT,
});

const total = summary.length;
return { totalCount: total, data: summary };
}
 betHistoryCasino = async (
  userId: string,
  limit: number,
  offset: number,
  startDate: string,
  endDate: string
  // path:string
): Promise<any> => {
  console.log('astart date, ', startDate, endDate);

  // Detail query
  const detailQuery = `
    SELECT *
    FROM casinotransactions
    WHERE user_id = :userId
      AND updated_at >= :startDate
      AND updated_at <= :endDate
    LIMIT :limit
    OFFSET :offset;
  `;

  // Count query
  const countQuery = `
    SELECT COUNT(*) as totalCount
    FROM (
      SELECT 1
      FROM casinotransactions
      WHERE user_id = :userId
        AND updated_at >= :startDate
        AND updated_at <= :endDate
    ) as countQuery;
  `;


  const details = await sequelize.query(detailQuery, {
    replacements: {
      userId: userId,
      startDate: startDate,
      endDate: endDate,
      limit: limit,
      offset: offset
    },
    type: QueryTypes.SELECT
  });

  let countResult;
  try {
    countResult = await sequelize.query(countQuery, {
      replacements: {
        userId: userId,
        startDate: startDate,
        endDate: endDate
      },
      type: QueryTypes.SELECT
    });
  } catch (error) {
    console.error('Error fetching count:', error);
    
  }

  let totalCount = 0;
  if (countResult && countResult.length > 0) {
    totalCount = (countResult as any).totalCount;
  }


  console.log('countResult, ', countResult, totalCount);

  return { totalCount: countResult, data: details };
};


  getBetHistory = async (
    market: string,
    eventId: string,
    userId: string,
    limit: number,
    offset: number,
    startDate :string,
    endDate :string,
    path:string
  ): Promise<any> => {
    
    if (eventId && /^\d+$/.test(eventId)) {
    let query = `
      SELECT 
          event_type,
          bet_on,
          event,
          game_id,
          selection,
          percent,
          price,
          stake,
          created_at,
          updated_at,
          username,
          CASE
              WHEN market = 'MATCH_ODDS' THEN 'Match Odds'
              ELSE market
          END AS market,
          status,
          CASE
        WHEN bet_on = 'BACK' AND status = 1 THEN
          CASE
            WHEN market = 'session' THEN ROUND(stake * percent / 100, 2)
            ELSE ROUND(stake * (price - 1), 2)
          END
        WHEN bet_on = 'LAY' AND status = 1 THEN
          CASE
            WHEN market = 'session' THEN ROUND(stake, 2)
            ELSE ROUND(stake, 2)
          END
        ELSE 0
      END AS user_winning_amount,
      CASE
      WHEN bet_on = 'BACK' AND status = 10 THEN
        CASE
          WHEN market = 'session' THEN ROUND(stake, 2)
          ELSE ROUND(stake, 2)
        END
      WHEN bet_on = 'LAY' AND status = 10 THEN
        CASE
          WHEN market = 'session' THEN ROUND(stake * percent / 100, 2)
          ELSE ROUND(stake * (price - 1), 2)
        END
      ELSE 0
    END AS user_losing_amount,
          COUNT(*) OVER() AS total_count
      FROM 
          public.bets 
      WHERE 
          username = '${userId}' 
          AND ${market === 'MATCH_ODDS' ? `(market = 'Match Odds' OR market = 'MATCH_ODDS')` : `market = '${market}'`}
          AND event_id = ${eventId}
          AND updated_at >= '${startDate}' 
          AND updated_at <= '${endDate}'
          AND status  != 0 
         
      LIMIT ${limit}
      OFFSET ${offset};
  `;

    const [results, metadata] = await betsequelize.query(query);
    const total = results.length;
    return { totalCount: total, data: results };
  }
  else{
    

    // console.log(eventId,"herere",market,'market',userId,"userid");
    const query = `
    SELECT 
      SUM(CASE WHEN remark LIKE 'bet%' THEN amount ELSE 0 END) AS all_user_lossing_amount,
      SUM(CASE WHEN remark NOT LIKE 'bet%' THEN amount ELSE 0 END) AS all_user_winning_amount,
      'casino' AS event_type,
      game_type AS event,
      MAX(updated_at) AS settlement_time,
      game_code AS gametype,
      username as username,
      transaction_id,
      remark
    FROM
      casinotransactions
    WHERE
      game_code != 'Aviator' AND
      game_type = :eventId AND
      game_code = :market AND
      username  = :userId 
      AND updated_at >= '${startDate}' 
      AND updated_at <= '${endDate}'
      
      GROUP BY
    game_type, game_code, username, transaction_id, remark
    LIMIT ${limit}
    OFFSET ${offset};
  `;
  
  const summary = await sequelize.query(query, {
    replacements: { eventId, market, userId },
    type: QueryTypes.SELECT,
  });
  
  const total = summary.length;
  return { totalCount: total, data: summary };
  
   
      }


}

  

//   // downlie user api's
  getDownlineUserProfitLost = async (
    username: string,
    path: string,
    startDate: string,
    endDate: string,
    limit: number,
    offset: number
): Promise<any> => {
    const userQuery = `
        SELECT id, username, path, user_type
        FROM users 
        WHERE
        username != '${username}' 
      AND path::ltree ~ '${path}.*{1}'::lquery AND is_deleted = false
        ORDER BY id DESC
        OFFSET ${offset ? offset : 0} 
        FETCH NEXT ${limit ? limit : 10} ROWS ONLY
    `;
    const countQuery = `
    SELECT COUNT(*) AS total_count
    FROM users
    WHERE
    username != '${username}' 
    AND path::ltree ~ '${path}.*{1}'::lquery AND is_deleted = false
`; const [countResults, countMetadata] = await sequelize.query(countQuery);
const totalCount: number = (countResults[0] as any)?.total_count ?? 0;

    const [userResults, userMetadata] = await sequelize.query(userQuery);
    const users = userResults as UserData[];
    const userBetDataList: UserBetData[] = [];

    for (const user of users) {
        const { username, id, user_type,path } = user;
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
                        WHEN market = 'session' THEN ROUND(stake, 2)
                        ELSE ROUND(stake, 2)
                      END
                    ELSE 0
                  END
                ), 0) AS total_user_profit,
                COALESCE(SUM(
                  CASE
                    WHEN bet_on = 'BACK' AND status = 10 THEN
                      CASE
                        WHEN market = 'session' THEN ROUND(stake, 2)
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
       
        const [betResults, betMetadata] = await betsequelize.query(betQuery);
        const userBetDataArray = betResults as UserBetData[];

      
        if (betResults.length === 0 ) {
           
            userBetDataList.push({
                id,
                username,
                user_type,
                path,
                total_user_profit: 0,
                total_user_loss: 0,
            });
        } else {
          const updatedUserBetDataArray = userBetDataArray.map(data => ({
            ...data,
            id,
            user_type
        }));
      
        userBetDataList.push(...updatedUserBetDataArray);
           
        }
        if (user_type !== 'USER') {
          const downlineProfitLoss = await downlieUserQuery(username, path, startDate, endDate);
          // console.log('downlineProfitLoss', downlineProfitLoss);
          
          if (Array.isArray(downlineProfitLoss) && downlineProfitLoss.length > 0) {
              userBetDataList.forEach((userData) => {
                  if (userData.username) {
                      // console.log('Processing user:', userData.username);
                      
                      const userDownlineData = downlineProfitLoss.find((downlineData) =>username === userData.username);
                      
                      if (userDownlineData) {
                          // console.log('Found matching data for user:', userData.username);
                          // console.log('userDownlineData:', userDownlineData);
                          
                          // Convert string values to numbers before adding
                          const profitToAdd = parseFloat(userDownlineData.total_user_profit);
                          const lossToAdd = parseFloat(userDownlineData.total_user_loss);
                          
                          // console.log('Adding profit:', profitToAdd);
                          // console.log('Adding loss:', lossToAdd);
                          
                          userData.total_user_profit += profitToAdd;
                          userData.total_user_loss += lossToAdd;
                          
                          // console.log('Updated userData:', userData);
                      } else {
                          // console.log('No matching data found for user:', userData.username);
                      }
                  }
                  
              });
          }
      }
      
      
      
      }
      return { totalCount: totalCount , data: userBetDataList };
      
      }
getdownlineUserCasino = async (
  username: string,
  path: string,
  startDate: string,
  endDate: string,
  limit: number,
  offset: number
): Promise<any> => {
 
  
  const userQuery = `
  SELECT id, username, path, user_type
  FROM users 
  WHERE
  username != '${username}' 
AND path::ltree ~ '${path}.*{1}'::lquery AND is_deleted = false
  ORDER BY id DESC
  OFFSET ${offset ? offset : 0} 
  FETCH NEXT ${limit ? limit : 10} ROWS ONLY
`;
const totalCountQuery = `
SELECT COUNT(*) AS total_count
FROM users 
WHERE
username != '${username}' 
AND path::ltree ~ '${path}.*{1}'::lquery AND is_deleted = false
`;
const [totalCountResults, totalCountMetadata] = await sequelize.query(totalCountQuery);
const totalCount = (totalCountResults[0] as any).total_count;
const [userResults, userMetadata] = await sequelize.query(userQuery);
const users = userResults as UserData[];
const userBetDataList: UserBetData[] = [];


for (const user of users) {
  const { username, id, user_type,path } = user;
  const query = `
  SELECT 
    SUM(CASE WHEN remark LIKE 'bet%' THEN amount ELSE 0 END) AS total_user_loss,
    SUM(CASE WHEN remark NOT LIKE 'bet%' THEN amount ELSE 0 END) AS total_user_profit,
    'casino' AS event_type,
    
    username as username
  
  FROM
    casinotransactions
  WHERE
    username = '${username}'
    AND updated_at >= '${startDate}' 
    AND updated_at <= '${endDate}'
  GROUP BY
    username
  LIMIT ${limit}
  OFFSET ${offset};
`;
  const betResults =await sequelize.query(query, {
  
    type: QueryTypes.SELECT,
  });
  const userBetDataArray = betResults as UserBetData[];
  if (betResults.length === 0 ) {
     
      userBetDataList.push({
          id,
          username,
          user_type,
          path,
          total_user_profit: 0,
          total_user_loss: 0,
      });
  } else {
    const updatedUserBetDataArray = userBetDataArray.map(data => ({
      ...data,
      id,
      user_type
  }));

  userBetDataList.push(...updatedUserBetDataArray);
     
  }
  if (user_type !== 'USER') {
    const downlineProfitLoss = await getdownlineUserCasinosub(username, path, startDate, endDate);
    // console.log('downlineProfitLoss', downlineProfitLoss);
    
    if (Array.isArray(downlineProfitLoss) && downlineProfitLoss.length > 0) {
        userBetDataList.forEach((userData) => {
            if (userData.username) {
                // console.log('Processing user:', userData.username);
                
                const userDownlineData = downlineProfitLoss.find((downlineData) =>username === userData.username);
                
                if (userDownlineData) {
                    // console.log('Found matching data for user:', userData.username);
                    // console.log('userDownlineData:', userDownlineData);
                    
                    // Convert string values to numbers before adding
                    const profitToAdd = parseFloat(userDownlineData.total_user_profit);
                    const lossToAdd = parseFloat(userDownlineData.total_user_loss);
                    
                    // console.log('Adding profit:', profitToAdd);
                    // console.log('Adding loss:', lossToAdd);
                    
                    userData.total_user_profit += profitToAdd;
                    userData.total_user_loss += lossToAdd;
                    
                    // console.log('Updated userData:', userData);
                } else {
                    // console.log('No matching data found for user:', userData.username);
                }
            }
            // console.log('master111', userData, user_type);
        });
    }
}



}
return { totalCount: totalCount, data: userBetDataList };

}



getDownlineProfitLoss = async (
  username: string,
  path:string,
  startDate: string,
  endDate: string
): Promise<any> => {
  // Fetch downline users
  const downlineQuery = `
      SELECT id, username
      FROM users 
      WHERE username != '${username}' AND path::ltree  ~ '${path}.*{1}'::lquery AND is_deleted = false
  `;
  const [downlineResults, downlineMetadata] = await sequelize.query(downlineQuery);
  const downlineUsers = downlineResults as UserData[];

  let totalProfit = 0;
  let totalLoss = 0;

  for (const downlineUser of downlineUsers) {
      const { username } = downlineUser;
      const betQuery = `
          SELECT
              COALESCE( SUM(
                CASE
                  WHEN bet_on = 'BACK' AND status = 1 THEN
                    CASE
                      WHEN market = 'session' THEN ROUND(stake * percent / 100, 2)
                      ELSE ROUND(stake * (price - 1), 2)
                    END
                  WHEN bet_on = 'LAY' AND status = 1 THEN
                    CASE
                      WHEN market = 'session' THEN ROUND(stake , 2)
                      ELSE ROUND(stake, 2)
                    END
                  ELSE 0
                END
              ), 0) AS total_user_profit,
              COALESCE(SUM(
                CASE
                  WHEN bet_on = 'BACK' AND status = 10 THEN
                    CASE
                      WHEN market = 'session' THEN ROUND(stake, 2)
                      ELSE ROUND(stake, 2)
                    END
                  WHEN bet_on = 'LAY' AND status = 10 THEN
                    CASE
                      WHEN market = 'session' THEN ROUND(stake * percent / 100, 2)
                      ELSE ROUND(stake * (price - 1), 2)
                    END
                  ELSE 0
                END
              ), 0) AS total_user_loss
          FROM
              public.bets
          WHERE
              username = '${username}'
              AND updated_at >= '${startDate}' 
              AND updated_at <= '${endDate}'
          GROUP BY
              username
      `;
      const [betResults, betMetadata] = await betsequelize.query(betQuery);
if (betResults.length > 0) {
    const { total_user_profit, total_user_loss } = betResults[0] as {
        total_user_profit: number;
        total_user_loss: number;
    };
    totalProfit += total_user_profit;
    totalLoss += total_user_loss;
}
  }

  return { total_user_profit: totalProfit, total_user_loss: totalLoss };
}

// getDownlineUserProfitLost = async (
//   username: string,
//   path: string,
//   startDate: string,
//   endDate: string,
//   limit: number,
//   offset: number
// ): Promise<any> => {
//   const userQuery = `
//   SELECT id, username, path 
//   FROM users 
//   WHERE username != '${username}' AND path ~ '^${path}' AND is_deleted = false
//   ORDER BY id DESC
//   OFFSET ${offset ? offset : 0} 
//   FETCH NEXT ${limit ? limit : 10} ROWS ONLY
// `;

//   const countQuery = `
// SELECT id, username, path 
// FROM users 
// WHERE username != '${username}' AND path ~ '^${path}' AND is_deleted = false
// ORDER BY id DESC
// `;

//   const [totalCount] = await sequelize.query(countQuery);
//   const [userResults, userMetadata] = await sequelize.query(userQuery);
//   const users = userResults as UserData[];
//   const userBetDataList: UserBetData[] = [];
//   console.log('users' , users);

//   for (const user of users) {
//     const { username, id } = user;
//     const betQuery = `
//     SELECT
//          ${id} as id,
//         '${username}' as username,
//         COALESCE(SUM(
//             CASE
//                 WHEN bet_on = 'BACK' AND status = 1 THEN ROUND(stake * (price - 1), 2)
//                 WHEN bet_on = 'LAY' AND status = 1 THEN ROUND(stake, 2)
//                 ELSE 0
//             END
//         ), 0) AS total_user_profit,
//         COALESCE(SUM(
//             CASE
//                 WHEN bet_on = 'BACK' AND status = 10 THEN ROUND(stake, 2)
//                 WHEN bet_on = 'LAY' AND status = 10 THEN ROUND(stake * (price - 1), 2)
//                 ELSE 0
//             END
//         ), 0) AS total_user_loss
//     FROM
//         public.bets
//     WHERE
//         username = '${username}'
//         AND updated_at >= '${startDate}' 
//         AND updated_at <= '${endDate}'
//     GROUP BY
//        username
//   `;

//     const [betResults, betMetadata] = await betsequelize.query(betQuery);
//     const userBetDataArray = betResults as UserBetData[];
//     if (betResults.length === 0) {
//       // No bets found for the user, add with 0 profit/loss
//       userBetDataList.push({
//         id,
//         username,
//         total_user_profit: 0,
//         total_user_loss: 0,
//       });
//     } else {
//       userBetDataList.push(...userBetDataArray);
//     }
//   }
//   return { totalCount: totalCount.length, data: userBetDataList };
// }


  getUserSportData = async (
    userId: string,
    startDate: string,
    endDate: string,
    limit: number,
    offset: number
  ): Promise<any> => {


    const query = `
  SELECT
    game_id,
    event_type,
    SUM(
      CASE
        WHEN bet_on = 'BACK' AND status = 1 THEN
          CASE
            WHEN market = 'session' THEN ROUND(stake * percent / 100, 2)
            ELSE ROUND(stake * (price - 1), 2)
          END
        WHEN bet_on = 'LAY' AND status = 1 THEN
          CASE
            WHEN market = 'session' THEN ROUND(stake, 2)
            ELSE ROUND(stake, 2)
          END
        ELSE 0
      END
    ) AS total_winning_amount,
    SUM(
      CASE
        WHEN bet_on = 'BACK' AND status = 10 THEN
          CASE
            WHEN market = 'session' THEN ROUND(stake, 2)
            ELSE ROUND(stake, 2)
          END
        WHEN bet_on = 'LAY' AND status = 10 THEN
          CASE
            WHEN market = 'session' THEN ROUND(stake * percent / 100, 2)
            ELSE ROUND(stake * (price - 1), 2)
          END
        ELSE 0
      END
    ) AS total_lossing_amount
  FROM
    public.bets
  WHERE
    username = '${userId}'
    AND updated_at >= '${startDate}'
    AND updated_at <= '${endDate}'
  GROUP BY
    game_id,
    event_type
  OFFSET ${offset ? offset : 0} 
  LIMIT ${limit ? limit : 10};
`;

    const countQuery = `
  SELECT COUNT(DISTINCT b.game_id) AS total_count
  FROM public.bets AS b
  JOIN (
    SELECT DISTINCT game_id
    FROM public.bets
    WHERE
      username = '${userId}'
      AND updated_at >= '${startDate}'
      AND updated_at <= '${endDate}'
  ) AS subquery
  ON b.game_id = subquery.game_id
  WHERE b.username = '${userId}';
`;
    const [results, metadata] = await betsequelize.query(query);
    const [count] = await betsequelize.query(countQuery);
 


    const countData = count as TotalCountResult[];
    return { data: results, totalCount: countData[0]?.total_count };
  }
  getuserCasinoData= async (
    userId: string,
    startDate: string,
    endDate: string,
    limit: number,
    offset: number
  ): Promise<any> => {
    const results: any[] = [];

    const summary = await CasinoTransaction.findOne({
      attributes: [
        [
          Sequelize.fn('SUM', Sequelize.literal("CASE WHEN remark LIKE 'bet%' THEN amount ELSE 0 END")),
          'total_lossing_amount'
        ],
        [
          Sequelize.fn('SUM', Sequelize.literal("CASE WHEN remark NOT LIKE 'bet%' THEN amount ELSE 0 END")),
          'total_winning_amount'
        ],
        [Sequelize.literal("'casino'"), 'event_type'] 
      ],
      where: {
        gameCode: {
          [Sequelize.Op.not]: 'Aviator' 
        },
        username: userId, 
        createdAt: {
          
          [Op.and]: [
            { [Op.gte]: new Date(startDate) }, 
            { [Op.lt]: new Date(endDate) }     
          ]
        }
      }
    });
    const aviator = await CasinoTransaction.findOne({
      attributes: [
        [
          Sequelize.fn('SUM', Sequelize.literal("CASE WHEN remark LIKE 'bet%' THEN amount ELSE 0 END")),
          'total_lossing_amount'
        ],
        [
          Sequelize.fn('SUM', Sequelize.literal("CASE WHEN remark NOT LIKE 'bet%' THEN amount ELSE 0 END")),
          'total_winning_amount'
        ],
        [Sequelize.literal("'Aviator'"), 'event_type'] 
      ],
      where: {
        gameCode: 'Aviator', 
        userId: userId, // Filter by userId
        createdAt: {
          
          [Op.and]: [
            { [Op.gte]: new Date(startDate) }, // createdAt >= startDate
            { [Op.lt]: new Date(endDate) }     // createdAt < endDate
          ]
        }
      }
    });
    
    
    results.push(summary);
    results.push(aviator);


   
    return { data: results, totalCount: 2 };
  }
  getUserSportEventData = async (
    userId: string,
    gameId: number,
    startDate:string,
    endDate:string,
    limit: number,
    offset: number
  ): Promise<any> => {
  
    const query = `
      SELECT
        event_id,
        event,
        game_id,
        event_type,
        SUM(
          CASE
            WHEN bet_on = 'BACK' AND status = 1 THEN
              CASE
                WHEN market = 'session' THEN ROUND(stake * percent / 100, 2)
                ELSE ROUND(stake * (price - 1), 2)
              END
            WHEN bet_on = 'LAY' AND status = 1 THEN
              CASE
                WHEN market = 'session' THEN ROUND(stake, 2)
                ELSE ROUND(stake, 2)
              END
            ELSE 0
          END
        ) AS total_winning_amount,
        SUM(
          CASE
            WHEN bet_on = 'BACK' AND status = 10 THEN
              CASE
                WHEN market = 'session' THEN ROUND(stake, 2)
                ELSE ROUND(stake, 2)
              END
            WHEN bet_on = 'LAY' AND status = 10 THEN
              CASE
                WHEN market = 'session' THEN ROUND(stake * percent / 100, 2)
                ELSE ROUND(stake * (price - 1), 2)
              END
            ELSE 0
          END
        ) AS total_lossing_amount
      FROM
        public.bets
      WHERE
        username = '${userId}'
        AND game_id = ${gameId}
        AND updated_at >= '${startDate}' 
        AND updated_at <= '${endDate}'
      GROUP BY
        game_id,
        event_id,
        event,
        event_type
      OFFSET ${offset ? offset : 0} 
      LIMIT ${limit ? limit : 10};
    `;
  
    const countQuery = `
      SELECT COUNT(DISTINCT event_id) AS total_count
      FROM public.bets
      WHERE
        username = '${userId}'
        AND game_id = ${gameId}
        AND updated_at >= '${startDate}' 
        AND updated_at <= '${endDate}';
    `;
    
    const [results, metadata] = await betsequelize.query(query);
    const [count] = await betsequelize.query(countQuery);
    const countData = count as TotalCountResult[];
  
    if (gameId == 3) {
      const casinoQuery = `
  SELECT 
    SUM(CASE WHEN remark LIKE 'bet%' THEN amount ELSE 0 END) AS total_lossing_amount,
    SUM(CASE WHEN remark NOT LIKE 'bet%' THEN amount ELSE 0 END) AS total_winning_amount,
    'casino' AS event_type,
    game_type AS event
  FROM
    casinotransactions
  WHERE
    game_code != 'Aviator' AND
    username = '${userId}'
    AND updated_at >= '${startDate}' 
    AND updated_at <= '${endDate}'
  GROUP BY
    game_type;
`;

      
      const summary = await sequelize.query(casinoQuery, {
        type: QueryTypes.SELECT,
        // replacements: { startDate, endDate } 
      });
      const total = summary.length;
      return { totalCount: total, data: summary };
    }
    return { data: results, totalCount: countData[0]?.total_count };
  }
  
  getUserEventMarketData = async (
    userId: string,
    gameId: number,
    eventId: string,
    limit: number,
    offset: number,
    startDate:string,
    endDate:string
  ): Promise<any> => {
    if (eventId && /^\d+$/.test(eventId)) {
    const query = `
    SELECT
        MAX(updated_at) AS settlement_time,
        username,
        event_type,
        event_id,
        event,
        market,
        SUM(
          CASE
            WHEN bet_on = 'BACK' AND status = 1 THEN
              CASE
                WHEN market = 'session' THEN ROUND(stake * percent / 100, 2)
                ELSE ROUND(stake * (price - 1), 2)
              END
            WHEN bet_on = 'LAY' AND status = 1 THEN
              CASE
                WHEN market = 'session' THEN ROUND(stake, 2)
                ELSE ROUND(stake, 2)
              END
            ELSE 0
          END
        ) AS all_user_winning_amount,
        SUM(
          CASE
            WHEN bet_on = 'BACK' AND status = 10 THEN
              CASE
                WHEN market = 'session' THEN ROUND(stake, 2)
                ELSE ROUND(stake, 2)
              END
            WHEN bet_on = 'LAY' AND status = 10 THEN
              CASE
                WHEN market = 'session' THEN ROUND(stake * percent / 100, 2)
                ELSE ROUND(stake * (price - 1), 2)
              END
            ELSE 0
          END
        ) AS all_user_losing_amount
    FROM
        public.bets
    WHERE
        event_id = ${eventId}
        AND game_id = ${gameId}
        AND username = '${userId}'
        AND updated_at >= '${startDate}' 
        AND updated_at <= '${endDate}'
        
    GROUP BY
        event_type,
        event_id,
        event,
        market,
        username
    ORDER BY
        market ASC
    LIMIT ${limit} OFFSET ${offset};
`;


    const mergeObjects = (data: BetData[]): BetData[] => {
      const mergedDataMap = new Map<string, BetData>();

      data.forEach((bet) => {
        const key = `${bet.event_id}_${bet.market.toUpperCase()}`;
        const existingBet = mergedDataMap.get(key);

        if (existingBet) {
          // Update existing bet
          existingBet.all_user_winning_amount = (parseFloat(existingBet.all_user_winning_amount) + parseFloat(bet.all_user_winning_amount)).toFixed(2);
          existingBet.all_user_losing_amount = (parseFloat(existingBet.all_user_losing_amount) + parseFloat(bet.all_user_losing_amount)).toFixed(2);
        } else {
          // Add new bet
          mergedDataMap.set(key, { ...bet });
        }
      });

      // Check if Match Odds and MATCH_ODDS are merged
      const matchOddsKey = `${data[0]?.event_id}_MATCH_ODDS`;
      const matchOddsBet = mergedDataMap.get(matchOddsKey);
      if (matchOddsBet) {
        const matchOdds = mergedDataMap.get(`${data[0]?.event_id}_MATCH ODDS`);
        if (matchOdds) {
          // Merge Match Odds and MATCH_ODDS
          matchOddsBet.all_user_winning_amount = (parseFloat(matchOddsBet.all_user_winning_amount) + parseFloat(matchOdds.all_user_winning_amount)).toFixed(2);
          matchOddsBet.all_user_losing_amount = (parseFloat(matchOddsBet.all_user_losing_amount) + parseFloat(matchOdds.all_user_losing_amount)).toFixed(2);
          mergedDataMap.delete(`${data[0].event_id}_MATCH ODDS`);
        }
      }

      data.forEach((bet) => {
        if (bet.market.toUpperCase() === 'SESSION') {
          const key = `${bet.event_id}_${bet.market.toUpperCase()}`;
          mergedDataMap.set(key, { ...bet });
        }
      });
      return Array.from(mergedDataMap.values());
    };

    const [results, metadata] = await betsequelize.query(query);
    const betDataArray = results as BetData[];
    const mergedResults = mergeObjects(betDataArray);
    const countQuery = `
  SELECT COUNT(DISTINCT event_id) AS total_count
  FROM public.bets
  WHERE
    username = '${userId}'
    AND game_id = ${gameId}
    AND event_id = ${eventId}
    AND updated_at >= '${startDate}' 
    AND updated_at <= '${endDate}'
   
`;
    const [toatalCount] = await betsequelize.query(countQuery);
    const countData = toatalCount as TotalCountResult[];
    return { totalCount: countData[0]?.total_count, data: mergedResults };
    }
     else{
// console.log(eventId,"herere");
  const query = `
  SELECT 
    SUM(CASE WHEN remark LIKE 'bet%' THEN amount ELSE 0 END) AS all_user_lossing_amount,
    SUM(CASE WHEN remark NOT LIKE 'bet%' THEN amount ELSE 0 END) AS all_user_winning_amount,
    'casino' AS event_type,
    game_type AS event,
    MAX(updated_at) AS settlement_time,
    game_code AS gametype
  FROM
    casinotransactions
  WHERE
  username = '${userId}' AND
  game_code != 'Aviator' AND
  game_type = '${eventId}'
  AND updated_at >= '${startDate}' 
  AND updated_at <= '${endDate}'
 
  GROUP BY
  game_type, game_code;

`;
const countQuery = `
  SELECT COUNT(*) AS total_count
  FROM (
    SELECT 1
    FROM casinotransactions
    WHERE
      username = '${userId}' AND
      game_code != 'Aviator' AND
      game_type = '${eventId}' AND
      updated_at >= '${startDate}' AND
      updated_at <= '${endDate}'
    GROUP BY
      game_type, game_code
  ) AS subquery;
`;
const summary = await sequelize.query(query, {
  type: QueryTypes.SELECT,
 
});
const countResult = await sequelize.query(countQuery, {
  type: QueryTypes.SELECT,
});

// Extract the total count from the count result
const totalCount =( countResult as any).total_count;

return { totalCount: totalCount, data: summary };
  }
  }



  getUserProfitAndLoss = async (
    userId: string,
    gameId: number,
    startDate: string,
    endDate: string,
    limit: number,
    offset: number
  ): Promise<any> => {


  const query = `
    SELECT
    MAX(updated_at) AS settlement_time,
      market,
      event_id,
      event,
      game_id,
      event_type,
      SUM(
        CASE
          WHEN bet_on = 'BACK' AND status = 1 THEN
            CASE
              WHEN market = 'session' THEN ROUND(stake * percent / 100, 2)
              ELSE ROUND(stake * (price - 1), 2)
            END
          WHEN bet_on = 'LAY' AND status = 1 THEN
            CASE
              WHEN market = 'session' THEN ROUND(stake, 2)
              ELSE ROUND(stake, 2)
            END
          ELSE 0
        END
      ) AS total_winning_amount,
      SUM(
        CASE
          WHEN bet_on = 'BACK' AND status = 10 THEN
            CASE
              WHEN market = 'session' THEN ROUND(stake, 2)
              ELSE ROUND(stake, 2)
            END
          WHEN bet_on = 'LAY' AND status = 10 THEN
            CASE
              WHEN market = 'session' THEN ROUND(stake * percent / 100, 2)
              ELSE ROUND(stake * (price - 1), 2)
            END
          ELSE 0
        END
      ) AS total_lossing_amount
    FROM
      public.bets
    WHERE
      username = '${userId}'
      AND game_id = ${gameId}
      AND updated_at >= '${startDate}'
      AND updated_at <= '${endDate}'
      AND status != 0
    GROUP BY
      market,
      game_id,
      event_id,
      event,
      event_type
    OFFSET ${offset ? offset : 0} 
    LIMIT ${limit ? limit : 10};
  `;


    // const [results, metadata] = await betsequelize.query(query);

    const countQuery = `
  SELECT COUNT(DISTINCT event_id) AS total_count
  FROM public.bets
  WHERE
  username = '${userId}'
  AND game_id = ${gameId}
  AND updated_at >= '${startDate}'
  AND updated_at <= '${endDate}'
  AND status !=0
 
 
`;

    const [count] = await betsequelize.query(countQuery);
    // console.log('count', count);
    const countData = count as TotalCountResult[];

    const mergeObjects = (data: MatchData[]): MatchData[] => {
      const mergedDataMap = new Map<string, MatchData>();

      // data.forEach((bet) => {
      //   console.log('bet' , bet);
      // });
      // console.log('data' , data);
      // return data;
      data.forEach((bet) => {
        const key = `${bet.event_id}_${bet.market.toUpperCase()}`;
        const existingBet = mergedDataMap.get(key);

        if (existingBet) {
          // Update existing bet
          existingBet.total_winning_amount = (parseFloat(existingBet.total_winning_amount) + parseFloat(bet.total_winning_amount)).toFixed(2);
          existingBet.total_lossing_amount = (parseFloat(existingBet.total_lossing_amount) + parseFloat(bet.total_lossing_amount)).toFixed(2);
        } else {
          // Add new bet
          mergedDataMap.set(key, { ...bet });
        }
      });

      // Check if Match Odds and MATCH_ODDS are merged
      const matchOddsKey = `${data[0]?.event_id}_MATCH_ODDS`;
      const matchOddsBet = mergedDataMap.get(matchOddsKey);
      if (matchOddsBet) {
        const matchOdds = mergedDataMap.get(`${data[0]?.event_id}_MATCH ODDS`);
        if (matchOdds) {
          // Merge Match Odds and MATCH_ODDS
          matchOddsBet.total_winning_amount = (parseFloat(matchOddsBet.total_winning_amount) + parseFloat(matchOdds.total_winning_amount)).toFixed(2);
          matchOddsBet.total_lossing_amount = (parseFloat(matchOddsBet.total_lossing_amount) + parseFloat(matchOdds.total_lossing_amount)).toFixed(2);
          mergedDataMap.delete(`${data[0]?.event_id}_MATCH ODDS`);
        }
      }

      // Include session market data
      data.forEach((bet) => {
        if (bet.market.toUpperCase() === 'SESSION') {
          const key = `${bet.event_id}_${bet.market.toUpperCase()}`;
          mergedDataMap.set(key, { ...bet });
        }
      });
      return Array.from(mergedDataMap.values());
    };
    const [results, metadata] = await betsequelize.query(query);
    // console.log('results', results);
    const betDataArray = results as MatchData[];
    const mergedResults = mergeObjects(betDataArray);
    if (gameId == 3) {
      const casinoQuery = `
  SELECT 
    SUM(CASE WHEN remark LIKE 'bet%' THEN amount ELSE 0 END) AS total_lossing_amount,
    SUM(CASE WHEN remark NOT LIKE 'bet%' THEN amount ELSE 0 END) AS total_winning_amount,
    'casino' AS event_type,
    game_type AS event ,
    game_code
  FROM
    casinotransactions
  WHERE
    
    username = '${userId}'
    AND updated_at >= '${startDate}' 
    AND updated_at <= '${endDate}'
  GROUP BY
    game_type,game_code;
`;
const countQuery = `
SELECT COUNT(*) AS total_count
FROM (
  SELECT 1
  FROM casinotransactions
  WHERE
    
    username = '${userId}' AND
    updated_at >= '${startDate}' AND
    updated_at <= '${endDate}'
  GROUP BY
    game_type, game_code
) AS subquery;
`;
const countResult = await sequelize.query(countQuery, {
  type: QueryTypes.SELECT,
});

const totalCount = (countResult[0]as any).total_count;
      const summary = await sequelize.query(casinoQuery, {
        type: QueryTypes.SELECT,
        // replacements: { startDate, endDate } 
      });
     
      return { totalCount: totalCount, data: summary };
    }




    return { totalCount: countData[0]?.total_count, data: mergedResults };
  }




  getuserAllGamesProfitAndLoss =  async (
    userId: string,
    
    startDate: string,
    endDate: string
  
  ): Promise<any> => {


  const query = `
    SELECT
      game_id,
      event_type,
    
      SUM(
        CASE
          WHEN bet_on = 'BACK' AND status = 1 THEN
            CASE
              WHEN market = 'session' THEN ROUND(stake * percent / 100, 2)
              ELSE ROUND(stake * (price - 1), 2)
            END
          WHEN bet_on = 'LAY' AND status = 1 THEN
            CASE
              WHEN market = 'session' THEN ROUND(stake, 2)
              ELSE ROUND(stake, 2)
            END
          ELSE 0
        END
      ) AS total_winning_amount,
      SUM(
        CASE
          WHEN bet_on = 'BACK' AND status = 10 THEN
            CASE
              WHEN market = 'session' THEN ROUND(stake, 2)
              ELSE ROUND(stake, 2)
            END
          WHEN bet_on = 'LAY' AND status = 10 THEN
            CASE
              WHEN market = 'session' THEN ROUND(stake * percent / 100, 2)
              ELSE ROUND(stake * (price - 1), 2)
            END
          ELSE 0
        END
      ) AS total_lossing_amount
    FROM
      public.bets
    WHERE
      username = '${userId}'
      
      AND updated_at >= '${startDate}'
      AND updated_at <= '${endDate}'
      AND status != 0
    GROUP BY
    event_type,
      game_id;
  `;
  const [results, metadata] = await betsequelize.query(query);
    // console.log('apiresss',results);

      const casinoQuery = `
  SELECT 
    SUM(CASE WHEN remark LIKE 'bet%' THEN amount ELSE 0 END) AS total_lossing_amount,
    SUM(CASE WHEN remark NOT LIKE 'bet%' THEN amount ELSE 0 END) AS total_winning_amount,
    'casino' AS event_type,
    3 AS game_id
   
  FROM
    casinotransactions
  WHERE
   
    username = '${userId}'
    AND updated_at >= '${startDate}' 
    AND updated_at <= '${endDate}';
`;

      
      const summary = await sequelize.query(casinoQuery, {
        type: QueryTypes.SELECT,
        // replacements: { startDate, endDate } 
      });
      results.push(...summary);

    
    return { data: results };
  }



  // kyc api's controller

  submitKycDocument = async (
    userId: number,
    documentName: DocumentType,
    documentDetail: string,
    frontImage: string,
    backImage: string
  ): Promise<RegistrationResponse> => {
    // console.log('userId', userId);
    const checkUser = await User.findByPk(userId);

    if (!checkUser) {
      return { error: 'User does not exist' };
    }
    const checkKyc = await UserKyc.findOne({
      where: {
        userId: userId, isApproved: {
          [Op.ne]: 'rejected'
        }
      }
    });
    if (checkKyc !== null) {
      return { error: 'Kyc already exist' };
    }
    try {
      const createKyc = await UserKyc.create({
        userId: userId,
        documentName: documentName,
        documentDetail: documentDetail,
        frontImage: frontImage,
        backImage: backImage,
        isApproved: KycStatus.Pending,
        kycPercentage: 75,
        reason: ''
      });
      // console.log('checkUser', createKyc);
      return { data: 'User kyc submitted successfully' };
    } catch (err) {
      console.log('errr', err);
      return { error: 'user kyc failed' };
    }
  }
  updateAccountInfo = async (
    userId: number,
    DOB: Date,
    email: string,
    instagramId: string,
    telegramId: string,
    whatsappNumber: string
  ): Promise<RegistrationResponse> => {
    const checkUser = await User.findByPk(userId);
    if (!checkUser) {
      return { error: 'User does not exist' };
    }
    const updateAccountInfo = await User.update({
      DOB: DOB,
      email: email,
      instagramId: instagramId,
      telegramId: telegramId,
      whatsappNumber: whatsappNumber
    }, {
      where: {
        id: userId
      }
    });
    return { data: 'user account info updated successfully' };
  }
  resultFancyandsession = async () => {
    try {
      const query = `
      SELECT
          "matchId",
          "selectionId",
          "selectionName",
          "gtype"
      FROM (
          SELECT
              event_id AS "matchId",
              selection_id AS "selectionId",
              selection AS "selectionName",
              CASE 
                  WHEN market = 'session' THEN 'session'
                  ELSE 'fancy1'
              END AS gtype,
              ROW_NUMBER() OVER(PARTITION BY event_id, selection_id) AS rn
          FROM
              public.bets
          WHERE
              status = 0
              AND market IN ('session', 'fancy')
      ) AS subquery
      WHERE rn = 1
  `;
  
  
    
    
    
    // console.log("un resolve bet ");
        const [results, metadata] = await betsequelize.query(query);
        // console.log("un resolve bet ",results);
        return results;
        
    } catch (error) {
      throw new Error(`Unable to fetch bets ${error}`);
    }

    
  };
  fancySessionSettlement = async (limit: number, offset: number, search: string): Promise<any> => {
    try {
        const escapedSearch = search ? search.replace(/[.*+?^${}()|[\]\\]/g, '\\$&') : '';

        let countQuery = `
        SELECT COUNT(*) AS total_count
        FROM (
            SELECT *,
                ROW_NUMBER() OVER(PARTITION BY event_id, selection_id, market) AS rn
            FROM public.bets
            WHERE status = 0
            AND market IN ('session', 'fancy')
            ${escapedSearch ? `AND selection ~* '${escapedSearch}'` : ''}
        ) AS subquery
        WHERE rn = 1
    `;

        const [countResult] = await betsequelize.query(countQuery);
        const totalCount = (countResult[0] as any).total_count;

        let query = `
            SELECT
                "matchId",
                "selectionId",
                "selectionName",
                "gtype"
            FROM (
                SELECT
                    event_id AS "matchId",
                    selection_id AS "selectionId",
                    selection AS "selectionName",
                    market AS "market",
                    CASE 
                        WHEN market = 'session' THEN 'session'
                        ELSE 'fancy1'
                    END AS gtype,
                    ROW_NUMBER() OVER(PARTITION BY event_id, selection_id, market) AS rn
                FROM
                    public.bets
                WHERE
                    status = 0
                    AND market IN ('session', 'fancy')
                    ${escapedSearch ? `AND username ~* '${escapedSearch}'` : ''}
            ) AS subquery
            WHERE rn = 1
            LIMIT ${limit} OFFSET ${offset}
        `;

        const [results, metadata] = await betsequelize.query(query);
        return { totalCount, data: results };
    } catch (error) {
        throw new Error(`Unable to fetch bets ${error}`);
    }
};



  

}

export default UserModel;
