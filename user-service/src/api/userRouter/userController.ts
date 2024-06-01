/* eslint-disable no-octal */
/* eslint-disable quotes */
/* eslint-disable @typescript-eslint/no-unused-vars */
/* eslint-disable @typescript-eslint/explicit-module-boundary-types */
import { Request, Response } from "express";
import UserModel from "./userModel";
import { JwtAuthPayload } from "../../types";
import getIP from "../../utils/getIP";
import Sequelize, { Op } from "sequelize";
import responses from "../../responses";
import fs from "fs";
import path from "path";
import {
  AuthUserPayload,
  GetUserDetailsPayload,
  CreateUserPayload,
  SecureAccountPayload,
  CreditAmountPayload,
  WithdrawAmountPayload,
  ChangePasswordPayload,
  UpdateBalancePayload,
  GetTransactionsPayload,
  ActivityLogsPayload,
  GetHierarchyPayload,
  GetUserLocksPayload,
  UpdateExposurePayload,
  GetSubUsersPayload,
  UpdateUserLocksPayload,
  UserDeletePayload,
  changeUserPasswordPayload,
  editMobileNumberPayload,
  particulerActivityLogsPayload,
  GetMasterSubUsersPayload,
  ShivSendVerificationCodePayload,
  ShivRegisterUserPayload,
  KYCDocumentPayload,
  AccountInfoUpdatePayload,
  createsessionPayload,
  UserDepositPayload,
  RejectKycPayload,
  GetQRPayload,
  GetParticulerUserDetailsPayload,
  searchCasinoPayload,
  casinostatementPayload,
  casinoHistoryPayload,
  GetSportsfilterPayload,
  CreditAmountPayloadd
} from "./payloads";
import { Console, error } from "console";
import { BankAccountAttributes } from "../../models/BankAccount";
import User from "../../models/User";
import md5 from "md5";
import PasswordHistory from "../../models/PasswordHistory";
import Otp from "../../models/Otp";
import { DepositRequest, UserKyc } from "../../models";
import sequelize from "../../db.config";
import { stringify } from "querystring";
import axios from "axios";
import { DepositRequestAttributes } from "../../models/DepositRequest";
import WithdrawalTransaction, { WithdrawalTransactionAttributes } from "../../models/GetWidrawReq";
import AddBanner, { BannerAttributes } from "../../models/AddBanner";

const userModel: UserModel = new UserModel();

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
/**
 * UserController have all required callbacks
 * to handle user '/user' endpoints
 */
class UserController {
  sendHttpResponse(
    res: Response,
    serverResponse: { data?: unknown; error?: string; code?: number } | Error
  ): void {
    if (serverResponse instanceof Error) {
      res.status(500).send(serverResponse.message);
    } else if (serverResponse.error) {
      res.status(serverResponse.code || 422).send(serverResponse.error);
    } else if (typeof serverResponse.data === "object") {
      res.status(200).json(serverResponse.data);
    } else {
      res.status(200).send(serverResponse.data);
    }
  }
  ////////////////// casino /////////////////

  liveCasinoGmae = async (req: Request, res: Response) => {
    try {
      const casinos = await userModel.getCasinosService();
      res.status(200).json(casinos);
    } catch (error) {
      res.status(500).json({ message: error });
    }
  };
  aviatorGmae = async (req: Request, res: Response) => {
    try {
      const casinos = await userModel.getaviatorService();
      res.status(200).json(casinos);
    } catch (error) {
      res.status(500).json({ message: error });
    }
  };
  createCasinoSession = async (req: Request, res: Response): Promise<void> => {
    try {
      const args: createsessionPayload = { ...req.body, ip: getIP(req) };



      const result = await userModel.createCasinoSessionService(args.platform, args.gameid, args.id, args.ip || "");

      res.json(result);
    } catch (error) {
      console.error(error);
      res.status(500).json({ message: 'Internal Server Error' });
    }
  };

  casinosearch = async (req: Request, res: Response): Promise<void> => {
    const query: unknown = req.query;

    if (query && typeof query === "object") {
      const args = { ...query } as searchCasinoPayload;
      // console.log(args.search,args.provider,'heheh');
      const response = await userModel.casinoSearchService(
        args.search,
        args.provider || ''

      );
      res.status(200).json({ response });
    } else {
      res.status(400).end();
    }
  };
  casinostatement = async (req: Request, res: Response): Promise<void> => {
    const query: unknown = req.query;

    if (query && typeof query === "object") {
      const args = { ...query } as casinostatementPayload;
      console.log('search', args);
      const response = await userModel.casinostatement(
        args.uid || args._uid,
        args.search || '',
        args.limit || 10,
        args.offset || 0,
        args.startdate,
        args.enddate

      );
      res.status(200).json({ response });
    } else {
      res.status(400).end();
    }
  };

  casinoAviatorHistory = async (req: Request, res: Response): Promise<void> => {
    const query: unknown = req.query;

    if (query && typeof query === "object") {
      const args = { ...query } as casinoHistoryPayload;
      console.log('search', args);
      const response = await userModel.casinoAviatorHistory(
        String(args._uid),
        args._path,
        args.search || '',
        args.startdate,
        args.enddate,
        args.limit || 10,
        args.offset || 0
      );
      res.status(200).json({ response });
    } else {
      res.status(400).end();
    }
  };



  getCasinoBalance = async (req: Request, res: Response) => {
    const { partner_id, userId, timestamp, need_status_flag } = req.body;
    console.log("check req body balance ", req.body);
    if (partner_id !== process.env.PARTNER_ID) {
      return res.status(403).json({ error: 'Invalid partner ID' });
    }


    try {

      const balance = await UserModel.getCasinoBalance(userId);

      const response = {
        bet_status: 'Y',
        balance: balance
      };
      console.log('i log while sending back balance', response);


      res.json(response);
    } catch (error) {
      console.error('Error fetching user balance:', error);
      res.status(500).json({ error: 'Internal server error' });
    }
  };

  handleCreditCallback = async (req: Request, res: Response): Promise<void> => {
    try {

      const { partnerKey, user, gameData, transactionData, timestamp } = req.body;
      if (partnerKey !== process.env.PARTNER_ID) {
        res.status(400).json({ error: 'Invalid partner key' });
        return;
      }
      const gameid = gameData?.gameCode;
      const [gameType, gameCode] = gameData.gameCode.split(":");

      const userId = user?.id;
      const transactionId = gameData.providerTransactionId;
      const referenceId = transactionData.referenceId;
      const providerCode = gameData.providerCode;
      const providerTransactionId = gameData.providerTransactionId;
      const amount = parseFloat(transactionData.amount);
      const extra = gameData.description;
      console.log(amount, "amount ");



      const updatedBalance = await userModel.handleCreditCallback(gameCode, gameType, userId, transactionId, referenceId, providerCode, providerTransactionId, amount, extra, gameid);


      res.status(200).json({ bet_status: 'Y', balance: updatedBalance });
    } catch (error) {
      console.error('Error processing casino credit callback:', error);
      res.status(500).json({ error: 'Internal server error' });
    }
  };
  handleDebitCallback = async (req: Request, res: Response): Promise<void> => {
    try {

      const { partnerKey, user, gameData, transactionData, timestamp, roll_back } = req.body;

      console.log(roll_back, 'user', user, 'gameData', gameData, 'transactionData', transactionData);

      if (partnerKey !== process.env.PARTNER_ID) {
        res.status(400).json({ error: 'Invalid partner key' });
        return;
      }
      const gameid = gameData?.gameCode;
      const [gameType, gameCode] = gameData.gameCode.split(":");

      const userId = user?.id;
      const transactionId = gameData.providerTransactionId;
      const referenceId = transactionData.referenceId;
      const providerCode = gameData.providerCode;
      const providerTransactionId = gameData.providerTransactionId;
      const amount = parseFloat(transactionData.amount);
      const extra = gameData.description;
      const updatedBalance = await userModel.handleDebitCallback(gameType, userId, transactionId, referenceId, providerCode, providerTransactionId, amount, extra, gameid, roll_back);


      res.status(200).json({ bet_status: 'Y', balance: updatedBalance });
    } catch (error) {
      console.error('Error processing casino debit callback:', error);
      res.status(500).json({ error: 'Internal server error' });
    }
  };






  // shiv register api
  shivRegisterUser = async (req: Request, res: Response): Promise<void> => {
    const args: ShivRegisterUserPayload = { ...req.body };

    if (!args.firstname || !args.lastname || !args.dialCode || !args.phoneNumber || !args.password || !args.username || !args.otp) {
      res.status(400).json({ error: 'Missing required fields' });
      return;
    }

    try {
      const otpRecord = await Otp.findOne({ where: { target: args.phoneNumber } });
      if (!otpRecord) {
        res.status(400).json({ error: 'OTP not found' });
        return;
      }

      if (otpRecord.code !== args.otp) {
        res.status(400).json({ error: 'Incorrect OTP' });
        return;
      }

      const existingUserByUsername = await User.findOne({ where: { username: args.username } });
      if (existingUserByUsername) {
        res.status(400).json({ error: 'Username already exists' });
        return;
      }

      if (args.email) {
        const existingUserByEmail = await User.findOne({ where: { email: args.email } });
        if (existingUserByEmail) {
          res.status(400).json({ error: 'Email already exists' });
          return;
        }
      }
      if (!(/^(?=.*[A-Z])(?=.*[~!@#$%^&*()/_=+[\]{}|;:,.<>?-])(?=.*[0-9])(?=.*[a-z]).{6,14}$/.test(args.password as string))) {
        res.status(400).json({ error: "Password is not strong! Enter a password in this formet Test@123" });
      }
      const existingUserByPhoneNumber = await User.findOne({
        where: { dialCode: args.dialCode, phoneNumber: args.phoneNumber }
      });
      if (existingUserByPhoneNumber) {
        res.status(400).json({ error: 'Phone number already exists' });
        return;
      }

      const fullname = `${args.firstname} ${args.lastname}`;
      const response = await userModel.shivRegisterUser(
        fullname,
        args.username,
        args.dialCode,
        args.phoneNumber,
        args.password,
        args.email,
        args.userType || "USER"
      );

      res.status(201).json(response);
    } catch (error) {
      console.log('Error during user registration:', error);
      res.status(500).json({ error: 'User registration failed' });
    }
  };

  generateOtp = () => {
    return Math.floor(100000 + Math.random() * 900000).toString();
  };
  shivSendVerificationCode = async (req: Request, res: Response): Promise<void> => {
    const args = { ...req.body };
    const generatedOtp = this.generateOtp();
    // const generatedOtp = "000000";
    try {
      const otpRecord = await Otp.findOne({ where: { target: args.mobile } });

      if (!otpRecord) {
        await Otp.create({
          code: generatedOtp,
          attempt: 1,
          lastSentAt: new Date(),
          retries: 0,
          target: args.mobile,
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
          { where: { target: args.mobile } }
        );
      }

      const authkey = process.env.SMS_AUTH_KEY;
      const sender = process.env.SMS_SENDER;
      const dltTeId = process.env.SMS_DLT_TE_ID;

      const mobile_number = args.mobile;
      const message_content = `Your verification Code is ${generatedOtp} ${sender}`;

      const url = `http://sms.ibittechnologies.in/api/sendhttp.php?authkey=${authkey}&mobiles=${mobile_number}&message=${encodeURIComponent(message_content)}&sender=${sender}&route=2&country=91&DLT_TE_ID=${dltTeId}`;
      console.log(url, 'url');
      await axios.get(url)
        .then(response => {
          console.log('SMS API Response:', response.data);
          res.status(200).send({ message: "OTP sent successfully" });
        });

    } catch (error) {
      console.error('Error:', error);
      res.status(500).send({ message: 'Failed to send OTP' });
    }
  };




  authUser = async (req: Request, res: Response): Promise<void> => {
    const args: AuthUserPayload = { ...req.body, ip: getIP(req) };
    const response = await userModel.authUser(
      args.username || "",
      args.password || "",
      args.ip
    );
    this.sendHttpResponse(res, response);
  };

  getUserDetails = async (req: Request, res: Response): Promise<void> => {
    const query: unknown = req.query;

    if (query && typeof query === "object") {
      const args = { ...query } as GetUserDetailsPayload;
      const response = await userModel.getUserDetails(
        args.uid || args._uid,
        Number(args.uid) ? `${args._path}.${args.uid}` : args._path
      );
      this.sendHttpResponse(res, response);
    } else {
      res.status(400).end();
    }
  };
  getParticulerUserDetails = async (req: Request, res: Response): Promise<void> => {
    const query: unknown = req.query;

    if (query && typeof query === "object") {
      const args = { ...query } as GetParticulerUserDetailsPayload;
      const response = await userModel.getParticulerUserDetails(
        args.id || 0

      );
      this.sendHttpResponse(res, response);
    } else {
      res.status(400).end();
    }
  };

  secureAccount = async (req: Request, res: Response): Promise<void> => {
    const args: SecureAccountPayload = { ...req.body };

    if (!args.transactionCode || !args.newPassword) {
      res.status(400).end();
    } else {
      const response = await userModel.secureAccount(
        args._uid,
        args.transactionCode,
        args.newPassword
      );
      this.sendHttpResponse(res, response);
    }
  };
  changeUserPassword = async (req: Request, res: Response) => {
    const args: changeUserPasswordPayload = { ...req.body };
    // console.log(args,'agdam bagdam',args.masterId,args.masterpassword,args.userId);

    const hashedPassword = md5(args.masterpassword);
    const Masteruser = await User.findOne({
      where: {
        id: args.masterId,
        password: hashedPassword,
        isDeleted: false,
        userType: ["OWNER", "MASTER", "SUPER MASTER", "SUPER_MASTER"],
      },
    });
    //  console.log('cheeek',Masteruser);
    if (Masteruser !== null) {
      const user = await User.findOne({
        where: { id: args.userId, isDeleted: false },
      });
      if (user !== null) {
        const updateUserPassword = await User.update(
          { password: args.userPassword },
          {
            where: { id: args.userId },
            returning: true,
          }
        );
        // create password history
        const createPasswordHistory = await PasswordHistory.create({
          userId: args.userId,
          remarks: `User Password Changed By ${Masteruser.username}`,
          path: user?.path
        });
        return res
          .status(200)
          .json({ message: "user password changed successfully" });
      } else {
        return res.status(400).json({ error: "User not found" });
      }
    } else {
      return res
        .status(400)
        .json({ error: "User Is not master or super master" });
    }
  };
  editMobileNumber = async (req: Request, res: Response) => {
    const args: editMobileNumberPayload = { ...req.body };
    const user = await User.findOne({
      where: { id: args.userId, isDeleted: false },
    });
    if (user != null) {
      if (user?.password !== md5(args.password)) {
        return res.status(400).send({ message: responses.MSG002 });
      }
      const updateUser = await User.update(
        { phoneNumber: args.mobile },
        {
          where: { id: args.userId },
          returning: true,
        }
      );
      return res
        .status(200)
        .json({ message: "User Mobile Number Updated Successfully" });
    } else {
      return res.status(400).json({ error: "User not found" });
    }
  };
  edituserMobileNumber = async (req: Request, res: Response) => {
    const args: editMobileNumberPayload = { ...req.body };
    console.log(args, 'aaaaaaaaa');
    const user = await User.findOne({
      where: { id: args.uid },
    });
    if (user != null) {
      if (user?.password !== md5(args.password)) {
        return res.status(400).send({ message: responses.MSG024 });
      }
      const usermobile = await User.findOne({
        where: { phoneNumber: args.mobile },
      });
      if (usermobile) {
        return res.status(400).send({ message: responses.MSG021 });
      }
      const updateUser = await User.update(
        { phoneNumber: args.mobile },
        {
          where: { id: args.userId },
          returning: true,
        }
      );
      return res
        .status(200)
        .json({ message: "User Mobile Number Updated Successfully" });
    } else {
      return res.status(400).json({ error: "User not found" });
    }
  };
  changePassword = async (req: Request, res: Response): Promise<void> => {
    const args: ChangePasswordPayload = { ...req.body, ip: getIP(req) };

    if (!args.oldPassword || !args.newPassword) {
      res.status(400).end();
    } else {
      const response = await userModel.changePassword(
        args._uid,
        args.oldPassword,
        args.newPassword,
        args.ip
      );
      this.sendHttpResponse(res, response);
    }
  };

  changeFirstTimePassword = async (req: Request, res: Response): Promise<void> => {
    const args: ChangePasswordPayload = { ...req.body, ip: getIP(req) };

    if (!args.oldPassword || !args.newPassword) {
      res.status(400).end();
    } else {
      const response = await userModel.changeFirstTimePassword(
        args._uid,
        args.oldPassword,
        args.newPassword,
        args.ip
      );
      this.sendHttpResponse(res, response);
    }
  };

  activityLogs = async (req: Request, res: Response): Promise<void> => {
    const query: unknown = req.query;

    if (query && typeof query === "object") {
      const args = { ...query } as ActivityLogsPayload;
      const response = await userModel.activityLogs(
        args._uid,
        args.fromDate,
        args.toDate,
        args.offset,
        args.limit
      );
      this.sendHttpResponse(res, response);
    } else {
      res.status(400).end();
    }
  };
  particulerActivityLogs = async (
    req: Request,
    res: Response
  ): Promise<void> => {
    const query: unknown = req.query;

    if (query && typeof query === "object") {
      const args = { ...query } as particulerActivityLogsPayload;
      const response = await userModel.particuleractivityLogs(
        args.id,
        args.fromDate,
        args.toDate,
        args.offset,
        args.limit
      );
      this.sendHttpResponse(res, response);
    } else {
      res.status(400).end();
    }
  };

  createSubUser = async (req: Request, res: Response): Promise<void> => {
    const args: CreateUserPayload = { ...req.body };
    if (
      !args._transactionCode ||
      (args.transactionCode !== undefined && args._transactionCode !== md5(args.transactionCode))
    ) {
      res.status(422).send(responses.MSG011);
    }

    const response = await userModel.createSubUser(
      args._uid,
      args._ut,
      args._path,
      args.fullname || "",
      args.username || "",
      args.password || "",
      args.dialCode || "",
      args.phoneNumber || "",
      args.city || "",
      args._level + 1,
      args.ap || 100.0,
      args.creditAmount || 0.0,
      args.userType || "",
      args.remark || "",
      args.privileges
    );
    this.sendHttpResponse(res, response);

  };
  registerUser = async (req: Request, res: Response): Promise<void> => {
    const args: CreateUserPayload = { ...req.body };

    if (!args) {
      res.status(422).send(responses.MSG007);
    } else {
      const response = await userModel.registerUser(
        args.password || "",
        args.phoneNumber || "",
        args.userType || "USER"
      );
      this.sendHttpResponse(res, response);
    }
  };
  // registertoken = async (req: Request, res: Response) => {
  //   const { username, password, phoneNumber } = req.body as {
  //     username: string;
  //     password: string;
  //     phoneNumber: string;
  //   };

  //   try {
  //     // Check if the user already exists
  //     if (!/^\d{10}$/.test(phoneNumber)) {
  //       return {
  //         error:
  //           "Invalid phone number. Please provide a 10-digit phone number.",
  //       };
  //     }
  //     const userExists = await userModel.checkUserExists(username);
  //     if (userExists) {
  //       return res.status(400).json({ message: 'User already exists with this username !' });
  //     }

  //     // Generate and store OTP
  //     const otp = await userModel.generateAndStoreOTP(phoneNumber,password);


  //     // Here you can implement logic for sending OTP to the user

  //     res.status(201).json({ message: 'OTP sent successfully', otp });
  //   } catch (error) {
  //     console.error('Error registering user:', error);
  //     res.status(500).json({ message: 'Internal server error' });
  //   }
  // };
  async forgotPassword(req: Request, res: Response): Promise<void> {
    const { phoneNumber } = req.body;

    try {
      await userModel.forgotPassword(phoneNumber);

      res
        .status(200)
        .json({ message: "Password reset instructions sent to your Number" });
    } catch (error) {
      res.status(400).json({ error: error });
    }
  }
  passwordHistory = async (req: Request, res: Response) => {
    try {
      const query: unknown = req.query;

      if (query && typeof query === "object") {
        const args = { ...query } as GetSubUsersPayload;
        const path = args._path;

        if (!path) {
          return res.status(400).json({ message: "Path parameter is required" });
        }

        const { count, rows } = await PasswordHistory.findAndCountAll({
          include: [{ model: User, attributes: ["username"] }],
          where: {
            [Op.and]: Sequelize.literal(`"user"."path"::ltree ~ '${path}.*'::lquery`)
          },
          order: [["createdAt", "DESC"]],
          limit: args.limit,
          offset: args.offset,
        });

        return res.status(200).json({
          totalCount: count,
          data: rows,
        });
      } else {
        return res.status(400).json({ message: "Invalid query parameters" });
      }
    } catch (error) {
      console.error(error); // Log the error for debugging
      return res.status(500).json({ message: "Internal Server Error" });
    }
  };



  async resetPassword(req: Request, res: Response): Promise<void> {
    const { phoneNumber, resetToken, newPassword } = req.body;
    try {
      console.log(req.body, 'booodddy');
      // Verify the reset token
      const isTokenValid = await userModel.verifyResetToken(
        phoneNumber,
        resetToken
      );
      if (!isTokenValid) {
        throw new Error("Invalid reset token");
      }

      // Reset the user's password
      await userModel.resetPassword(phoneNumber, newPassword);

      res.status(200).json({ message: "Password reset successfully" });
    } catch (error) {
      res.status(400).json({ error: error });
    }
  }
  getSubUsers = async (req: Request, res: Response): Promise<void> => {
    const query: unknown = req.query;

    if (query && typeof query === "object") {
      const args = { ...query } as GetSubUsersPayload;


      const response = await userModel.getSubUsers(
        args.uid || args._uid,
        args.path || args._path,
        // Number(args.uid) ? `${args._path}.${args.uid}` : args._path,
        args.offset,
        args.limit,
        args.search
      );

      res.status(200).send(response);
    } else {
      res.status(400).end();
    }
  };
  getMasterSubUsers = async (req: Request, res: Response) => {
    const query: unknown = req.query;

    if (query && typeof query === "object") {
      const args = { ...query } as GetMasterSubUsersPayload;

      const response = await userModel.getMasterSubUsers(
        args.id || "",
        args.path || "",
        // Number(args.uid) ? `${args._path}.${args.uid}` : args._path,
        args.offset,
        args.limit,
        args.search
      );
      // console.log("console ", response);

      return res.status(200).json({ response });
    } else {
      return res.status(400).end();
    }
  };

  getMaster = async (req: Request, res: Response): Promise<void> => {
    const query: unknown = req.query;

    if (query && typeof query === "object") {
      const args = { ...query } as GetSubUsersPayload;


      const response = await userModel.getMaster(
        args.uid || args._uid,
        args.path || args._path,
        // Number(args.uid) ? `${args._path}.${args.uid}` : args._path,
        args.offset,
        args.limit,
        args.search

      );

      res.status(200).send(response);
    } else {
      res.status(400).end();
    }
  };


  getoverallAmount = async (req: Request, res: Response): Promise<void> => {
    const query: unknown = req.query;

    if (query && typeof query === "object") {
      const args = { ...query } as GetSubUsersPayload;


      const response = await userModel.getoverallAmount(
        args.uid || args._uid,
        args.path || args._path,
        // Number(args.uid) ? `${args._path}.${args.uid}` : args._path,
        args.offset,
        args.limit,

      );

      res.status(200).send(response);
    } else {
      res.status(400).end();
    }
  };



  updateUserLocks = async (req: Request, res: Response): Promise<void> => {
    const args: UpdateUserLocksPayload = { ...req.body };

    if (!args.uid || !args.transactionCode) {
      res.send(400).end();
    } else {
      if (
        !args._transactionCode ||
        (args.transactionCode !== undefined && args._transactionCode !== md5(args.transactionCode))
      ) {
        res.status(422).send(responses.MSG011);
      } else {
        const response = await userModel.updateUserLocks(
          args.uid,
          args._path,
          args.userLock || false,
          args.betLock || false
        );
        this.sendHttpResponse(res, response);
      }
    }
  };
  deleteUser = async (req: Request, res: Response) => {
    const args: UserDeletePayload = { ...req.body };
    const user = await User.findByPk(args.userId);
    if (user != null) {
      user.isDeleted = true;
      await user.save();
      return res.status(200).json({ message: "User Deleted Successfully" });
    } else {
      return res.status(404).json({ error: "User not found" });
    }
  };
  restoreUser = async (req: Request, res: Response) => {
    const args: UserDeletePayload = { ...req.body };
    const user = await User.findByPk(args.userId);
    if (user != null) {
      user.isDeleted = false;
      await user.save();
      return res.status(200).json({ message: "User Restored Successfully" });
    } else {
      return res.status(404).json({ error: "User not found" });
    }
  };
  deletedUser = async (req: Request, res: Response) => {
    const query: unknown = req.query;

    if (query && typeof query === "object") {
      const args = { ...query } as GetSubUsersPayload;

      try {
        const { count, rows } = await User.findAndCountAll({
          where: {
            isDeleted: true,
            [Op.and]: Sequelize.literal(`path::ltree ~ '${args._path}.*'::lquery`)
          },
          limit: args.limit,
          offset: args.offset,
        });
        // const totalPages = Math.ceil(count / pageSize);
        return res.status(200).json({
          message: "Deleted Users Fetched Successfully",
          data: rows,
          totalCount: count,

        });

      } catch (error) {
        console.log(error);
        return res.status(500).json({ message: "Internal Server Error" });
      }
    }
  };
  addQrCode = async (req: Request, res: Response) => {
    try {
      // Extract data from request body
      const { image, upi, userid } = req.body;

      // Call service function to add QR code
      // console.log("args", image, upi ,userid);

      const qrCode = await userModel.addQrCode(image, upi, userid);
      // console.log("ghhh",qrCode)
      // Return success response
      res.status(201).json({ message: "QR code added successfully", qrCode });
    } catch (error) {
      // Return error response
      console.error("Error adding QR code:", error);
      res.status(500).json({ error: "Internal server error" });
    }
  };


  updateQrCode = async (req: Request, res: Response) => {
    try {
      const { image, upi, qrId } = req.body;
      const qrCode = await userModel.updateQrCode(image, upi, qrId);
      res.status(201).json({ message: "QR code updated successfully", qrCode });
    } catch (error) {
      console.error("Error updating QR code:", error);
      res.status(500).json({ error: "Internal server error" });
    }
  };

  deleteQrCode = async (req: Request, res: Response): Promise<void> => {
    try {
      const qrId = req.params.id;
      await userModel.deleteQrCode(qrId);
      res.status(200).json({ message: "QR code deleted successfully" });
    } catch (error) {
      console.error("Error deleting QR code:", error);
      res.status(500).json({ error: "Internal server error" });
    }
  };
  getAllQrCodes = async (req: Request, res: Response): Promise<void> => {
    try {
      const query: unknown = req.query;
      const args = query as GetQRPayload;


      const response = await userModel.getAllQrCodes(
        args.id || '',
        args.limit || 10,
        args.offset || 0
      );

      res.status(200).json(response);
    } catch (error) {
      console.error("Error fetching QR codes:", error);
      res.status(500).json({ error: "Internal server error" });
    }
  };
  async updateStatus(req: Request, res: Response): Promise<void> {
    const id = req.body.id;
    console.log("args", id);
    try {
      await userModel.updateQrCodeStatus(id);

      res.status(200).json({ message: "QR code status updated successfully" });
    } catch (error) {
      console.error("Error updating QR code status:", error);
      res.status(500).json({ error: "Internal server error" });
    }
  }
 
  async getQrCodeWithTrueStatusOrFirst(
    req: Request,
    res: Response
  ): Promise<void> {
    try {

      const query: unknown = req.query;

      if (query && typeof query === 'object') {
        const args = { ...query } as GetSubUsersPayload;

        const qrCode = await userModel.getQrCodeWithTrueStatusOrFirst(
          args.path || args._path
        );

        if (!qrCode) {
          res.status(404).json({ error: "No QR code found" });
        } else {
          res.status(200).json(qrCode);
        }
      }
    } catch (error) {
      console.error("Error fetching QR code:", error);
      res.status(500).json({ error: "Internal server error" });
    }
  }
  createDepositRequest = async (req: Request, res: Response): Promise<void> => {
    const { paymentMethod, utr, img, amount, userId } = req.body;

    try {
      const depositRequest = await userModel.createDeposit(
        paymentMethod,
        utr,
        img,
        amount,
        userId
      );
      res.status(201).json(depositRequest);
    } catch (error) {
      console.error("Error creating deposit request:", error);
      res.status(500).json({ error: "Internal server error" });
    }
  };
  getUserDeposits = async (req: Request, res: Response): Promise<void> => {
    const query: unknown = req.query;

    if (query && typeof query === "object") {
      const args = { ...query } as UserDepositPayload;
      const response = await userModel.getUserDeposits(
        args._uid,
        args.limit || 10,
        args.offset || 0,
        args.fromDate,
        args.toDate,
        args.status
      );
      res.status(201).json(response);
    } else {
      res.status(400).end();
    }
  };
  // Get ALl deposit

  getAllDeposits = async (req: Request, res: Response) => {
    const query: unknown = req.query;

    if (query && typeof query === 'object') {
      const args = { ...query } as GetSubUsersPayload;

      const response = await userModel.getAllDepositRequests(
        args.uid || args._uid,
        args.path || args._path,
        args.offset,
        args.limit
      );
      // console.log('ddhdh',response);

      if ('error' in response) {
        res.status(500).json({ error: response.error });
      } else {
        res.status(200).json(response);
      }
    } else {
      res.status(400).end();
    }
  };
  acceptDepositRequest = async (req: Request, res: Response): Promise<void> => {
    const { depositId } = req.body;
    try {
      const depositRequest = await userModel.acceptDepositRequest(depositId);
      res.status(200).json(depositRequest);
    } catch (error) {
      res.status(500).json({ error: "Error accepting deposit request" });
    }
  }

  rejectDepositRequest = async (req: Request, res: Response): Promise<void> => {
    const { depositId } = req.body;
    try {
      const depositRequest = await userModel.rejectDepositRequest(depositId);
      res.status(200).json(depositRequest);
    } catch (error) {
      res.status(500).json({ error: "Error accepting deposit request" });
    }
  }




  addBankAccount = async (req: Request, res: Response): Promise<void> => {
    try {
      const { accountNumber, accountType, bankName, ifscCode, userid, acountholdername } = req.body;
      const bankAccount = await userModel.addBankAccount(accountNumber, accountType, bankName, ifscCode, userid, acountholdername);
      // console.log("args", acountholdername);
      res.status(200).json(bankAccount);
    } catch (error) {
      console.error("Error adding bank account:", error);
      res.status(500).json({ message: "Internal server error" });
    }
  };

  updateBankAccount = async (req: Request, res: Response): Promise<void> => {
    try {
      const { accountId, accountType, accountNumber, ifscCode, bankName, acountholdername } = req.body;
      const bankAccount = await userModel.updateBankAccount(accountId, accountType, accountNumber, ifscCode, bankName, acountholdername);
      res.status(200).json(bankAccount);
    } catch (error) {
      console.error("Error updating bank account:", error);
      res.status(500).json({ message: "Internal server error" });
    }
  };

  deleteBankAccount = async (req: Request, res: Response): Promise<void> => {
    const id = parseInt(req.params.id);
    try {
      await userModel.deleteBankAccount(id);
      res.status(200).end();
    } catch (error) {
      console.error("Error deleting bank account:", error);
      res.status(500).json({ message: "Internal server error" });
    }
  };
  getAllBankAccounts = async (req: Request, res: Response): Promise<void> => {
    try {
      const query: unknown = req.query;
      const args = query as GetQRPayload;


      const bankAccounts = await userModel.getAllBankAccounts(
        args.id || '',
        args.limit || 10,
        args.offset || 0
      );
      res.json(bankAccounts);
    } catch (error) {
      console.error("Error getting bank accounts:", error);
      res.status(500).json({ message: "Internal server error" });
    }
  };
  updateBankAccountStatusById = async (req: Request, res: Response) => {
    const id = req.params.id;
    const status = true;
    try {
      await userModel.updateBankAccountStatusById(id, status);
      res.status(200).end();
    } catch (error) {
      console.error("Error updating bank account status by ID:", error);
      res.status(500).json({ message: "Internal server error" });
    }
  };
  async getAcountWithTrueStatusOrFirst(
    req: Request,
    res: Response
  ): Promise<void> {
    try {
      const query: unknown = req.query;

      if (query && typeof query === 'object') {
        const args = { ...query } as GetSubUsersPayload;
        const qrCode = await userModel.getAcountWithTrueStatusOrFirst(
          args.path || args._path
        );

        if (!qrCode) {
          res.status(404).json({ error: "No acount code found" });
        } else {
          res.status(200).json(qrCode);
        }
      }
    } catch (error) {
      console.error("Error fetching QR code:", error);
      res.status(500).json({ error: "Internal server error" });
    }
  }

  //user acount related contoller

  addUserBankAccount = async (req: Request, res: Response) => {
    try {
      const { accountType, bankName, accountNumber, ifscCode, userId, acountholdername } =
        req.body;

      // console.log('add',acountholdername);
      const newUserBankAccount = await userModel.addUserBankAccount(
        accountType,
        bankName,
        accountNumber,
        ifscCode,
        userId,
        acountholdername
      );

      res.status(200).json(newUserBankAccount);
    } catch (error) {
      console.error("Error adding user bank account:", error);
      res.status(500).json({ message: "Internal server error" });
    }
  };

  updateUserBankAccount = async (req: Request, res: Response) => {
    try {
      const { accountType, bankName, accountNumber, ifscCode, accountId, acountholdername } =
        req.body;

      // Call service function to add bank account
      const newUserBankAccount = await userModel.updateUserBankAccount(
        accountType,
        bankName,
        accountNumber,
        ifscCode,
        accountId,
        acountholdername
      );

      res.status(201).json(newUserBankAccount);
    } catch (error) {
      console.error("Error adding user bank account:", error);
      res.status(500).json({ message: "Internal server error" });
    }
  };


  getUserBankAccounts = async (req: Request, res: Response) => {
    const query: unknown = req.query;

    if (query && typeof query === "object") {
      const args = { ...query } as GetUserDetailsPayload;
      const response = await userModel.getUserBankAccounts(
        args.uid || args._uid
      );
      res.status(200).json(response);
    } else {
      res.status(400).end();
    }
  };
  deleteUserAccount = async (req: Request, res: Response) => {
    try {
      const id = Number(req.params.id);
      await userModel.deleteUserAccount(id);
      res.status(200).json({ message: "Account deleted sucessfully" });
    } catch (e) {
      console.error(error);
      res.status(500).json({ error: "Internal server error" });
    }
  };

  //USER API
  addUserUpi = async (req: Request, res: Response) => {
    try {
      const {
        upiId,
        upiName,
        userId,
      }: { upiId: string; upiName: string; userId: number } = req.body;

      const newUpi = await userModel.addUserUPI({ upiId, upiName, userId });
      res.status(201).json(newUpi);
    } catch (error) {
      res.status(500).json({ message: error });
    }
  };
  deleteUserUpi = async (req: Request, res: Response) => {
    try {
      const id = Number(req.params.id);
      await userModel.deleteUserUpi(id);
      res.status(200).json({ message: "UPI deleted sucessfully" });
    } catch (e) {
      console.error(error);
      res.status(500).json({ error: "Internal server error" });
    }
  };
  getUserUpi = async (req: Request, res: Response) => {
    const query: unknown = req.query;

    if (query && typeof query === "object") {
      const args = { ...query } as GetUserDetailsPayload;
      const response = await userModel.getUpiByUserId(args.uid || args._uid);
      res.status(200).json(response);
    } else {
      res.status(400).end();
    }
  };

  widrawReq = async (req: Request, res: Response) => {
    try {
      const { userId, bankAccountId, upiId, amount } = req.body;
      // console.log("ref", amount, userId, bankAccountId, upiId);

      const userDetails = await userModel.widrawReq(
        userId,
        amount,
        bankAccountId,
        upiId
      );

      if (userDetails) {
        res.json(userDetails);
      } else {
        res.status(404).json({ error: "you cant make widraw req" });
      }
    } catch (error) {
      console.error("Error :", error);
      res.status(500).json({ error: "Internal server error" });
    }
  };
  getUserWidrawReq = async (req: Request, res: Response): Promise<void> => {
    const query: unknown = req.query;

    if (query && typeof query === "object") {
      const args = { ...query } as UserDepositPayload;

      const response = await userModel.getUserWidrawReq(
        args._uid,
        args.limit || 10,
        args.offset || 0,
        args.fromDate,
        args.toDate,
        args.status
      );
      res.status(200).json(response);
    } else {
      res.status(400).end();
    }
  };
  getAllWidrawReq = async (req: Request, res: Response): Promise<void> => {
    const query: unknown = req.query;

    if (query && typeof query === 'object') {
      const args = { ...query } as GetSubUsersPayload;

      const response = await userModel.getAllWidrawReq(
        args.uid || args._uid,
        args.path || args._path,
        args.offset,
        args.limit
      );
      // console.log('ddhdh', response);

      if ('error' in response) {
        res.status(500).json({ error: response.error });
      } else {
        res.status(200).json(response);
      }
    } else {
      res.status(400).end();
    }
  };

  getBalance = async (req: Request, res: Response): Promise<void> => {
    const query: unknown = req.query;

    if (query && typeof query === "object") {
      const args = { ...query } as JwtAuthPayload;
      const response = await userModel.getBalance(args._uid);
      this.sendHttpResponse(res, response);
    } else {
      res.status(400).end();
    }
  };

  updateWithdrawalStatusController = async (req: Request, res: Response): Promise<void> => {
    try {
      const args: WithdrawAmountPayload = { ...req.body };

      console.log(args, 'args222');

      const acceptDepositRequest = await WithdrawalTransaction.findOne({ where: { id: args.id } }) as unknown as WithdrawalTransactionAttributes & { status: string };
      if (acceptDepositRequest && acceptDepositRequest.status === 'pending') {
        if (args.newStatus !== "Rejected") {
        if (!args.from || args.from == args._uid) {
          res.status(422).send(responses.MSG014).end();
        } else {
          if (args.withdrawAmount) {
            if (
              !args._transactionCode ||
              (args.transactionCode !== undefined && args._transactionCode !== md5(args.transactionCode))
            ) {
              res.status(422).send(responses.MSG011).end();
            } else {
              const response = await userModel.withdrawCreditAmount(
                args.from,
                args._uid,
                args.withdrawAmount,
                args.remark || ""
              );
              // this.sendHttpResponse(res, response);
            }
          } else {
            res.send(400).end();
          }
        }
      }
        const rowsUpdated = await userModel.updateWithdrawalStatusById(args.id, args.newStatus);
        res.status(200).json({ message: `${rowsUpdated} rows updated` });
      } else {
        // throw new Error('request already processed');
        res.status(400).json({ message: ' request already processed' });
      }
      console.log('accept', acceptDepositRequest);// Extract userId and newStatus from request body

    } catch (error) {
      console.log('something went wrong:', error);
      res.status(500).json({ error: 'Failed to update  status' });
    }
  };
  addBanner = async (req: Request, res: Response): Promise<void> => {
    try {
      // Extract banner data from request body
      const { image,  bannertype }: BannerAttributes = req.body;
  
      // Create the banner in the database
      const newBanner = await AddBanner.create({ image,  bannertype });
  
      res.status(200).json({
        message: 'Banner created successfully',
        data: newBanner
      });
    } catch (error) {
      console.error(`Error while adding banner: ${error}`);
      res.status(500).json({ message: 'Internal Server Error' });
    }
  };
  getAllBanners = async (req: Request, res: Response): Promise<void> => {
    try {
      // Extract limit and offset from query parameters
      const limit: number = parseInt(req.query.limit as string) || 10;
      const offset: number = parseInt(req.query.offset as string) || 0;
  
      // Retrieve banners from the database with pagination
      const banners = await AddBanner.findAll({
        limit,
        offset
      });
      const totalCount = await AddBanner.count();
      res.status(200).json({
        message: 'Banners retrieved successfully',
        data: banners,
        totalCount : totalCount
        
      });
    } catch (error) {
      console.error(`Error while retrieving banners: ${error}`);
      res.status(500).json({ message: 'Internal Server Error' });
    }
  };
  // const newStatus = qr?.status ? false : true;
  updateBannerStatus = async (req: Request, res: Response): Promise<void> => {
    try {
      const { id } = req.body;
  
      if (!id) {
        res.status(400).json({ message: 'Banner ID is required' });
        return;
      }
  
      // Find the banner by ID
      const qr = await AddBanner.findOne({ where: { id } }) as unknown as BannerAttributes;
  
      if (!qr) {
        res.status(404).json({ message: 'Banner not found' });
        return;
      }
  
      // Toggle the status
      const newStatus = !qr.status;
  
      // Update the banner status
      await AddBanner.update({ status: newStatus }, { where: { id } });
  
      // Respond with the updated status
      res.status(200).json({ message: 'Banner status updated successfully', status: newStatus });
    } catch (error) {
      console.error(`Error while updating banner status: ${error}`);
      res.status(500).json({ message: 'Internal Server Error' });
    }
  };
  getBannerStatus = async (req: Request, res: Response): Promise<void> => {
    try {
      // Retrieve banners with status = true
      const banners = await AddBanner.findAll({ where: { status: true } });
  
      res.status(200).json({
        message: 'Banners with status true retrieved successfully',
        data: banners
      });
    } catch (error) {
      console.error(`Error while retrieving banners with status true: ${error}`);
      res.status(500).json({ message: 'Internal Server Error' });
    }
  };
  updateDipositStatusController = async (req: Request, res: Response): Promise<void> => {
    try {
      const args: CreditAmountPayloadd = { ...req.body };


      console.log(args, 'args222');
      
      const acceptDepositRequest = await DepositRequest.findOne({ where: { id: args.id } }) as unknown as DepositRequestAttributes & { status: string };
      if (acceptDepositRequest && acceptDepositRequest.status === 'pending') {
        if (args.newStatus !== "Rejected") {
          if (args.creditAmount) {
            
            if ( 
              !args._transactionCode ||
              (args.transactionCode !== undefined && args._transactionCode !== md5(args.transactionCode))
            ) {
              console.log('hashh',md5('James@123'));
              res.status(422).send(responses.MSG011).end();
            } else {
              console.log(args, 'args1');
              const response = await userModel.transferCreditAmount(
                args._uid,
                args.to,
                args.creditAmount,
                args.remark || ""
              );
              // this.sendHttpResponse(res, response);
            }
          } else {
            res.send(400).end();
          }
        }
        console.log(args, 'args2');
        const rowsUpdated = await userModel.updateDepositStatusById(args.id, args.newStatus);
        res.status(200).json({ message: `${rowsUpdated} rows updated` });
      } else {
        res.status(400).json({ message: 'Deposit request already processed' });
      }
      console.log('accept', acceptDepositRequest);

    } catch (error) {
      console.error('something went wrong:', error);
      res.status(500).json({ error: 'Failed to update  status' });
    }

  };


  transferCreditAmount = async (req: Request, res: Response): Promise<void> => {
    const args: CreditAmountPayload = { ...req.body };

    if (!args.to || args.to == args._uid) {
      res.status(422).send(responses.MSG014);
    } else {
      // console.log(args._transactionCode,'',args.transactionCode);
      if (args.creditAmount) {
        if (
          !args._transactionCode ||
          (args.transactionCode !== undefined && args._transactionCode !== md5(args.transactionCode))
        ) {
          res.status(422).send(responses.MSG011);
        } else {
          const response = await userModel.transferCreditAmount(
            args._uid,
            args.to,
            args.creditAmount,
            args.remark || ""
          );
          this.sendHttpResponse(res, response);
        }
      } else {
        res.send(400).end();
      }
    }
  };

  withdrawCreditAmount = async (req: Request, res: Response): Promise<void> => {
    const args: WithdrawAmountPayload = { ...req.body };

    if (!args.from || args.from == args._uid) {
      res.status(422).send(responses.MSG014);
    } else {
      if (args.withdrawAmount) {
        if (
          !args._transactionCode ||
          (args.transactionCode !== undefined && args._transactionCode !== md5(args.transactionCode))
        ) {
          res.status(422).send(responses.MSG011);
        } else {
          const response = await userModel.withdrawCreditAmount(
            args.from,
            args._uid,
            args.withdrawAmount,
            args.remark || ""
          );
          this.sendHttpResponse(res, response);
        }
      } else {
        res.send(400).end();
      }
    }
  };

  getTransactions = async (req: Request, res: Response): Promise<void> => {
    const query: unknown = req.query;

    if (query && typeof query === "object") {
      const args = { ...query } as GetTransactionsPayload;
      // console.log('aregggg',args);
      const response = await userModel.getTransactions(
        args._uid,
        args.startdate || args.fromDate,
        args.enddate || args.toDate,
        args.filterUserId,
        args.offset,
        args.limit,
        args.filterTransaction,
        args.userid || ''
      );
      this.sendHttpResponse(res, response);
    } else {
      res.status(400).end();
    }
  };
  // eslint-disable-next-line @typescript-eslint/explicit-module-boundary-types
  uploadImage = async (req: Request, res: Response) => {
    try {
      if (!req.file) {
        return res.status(400).json({ error: "No file uploaded" });
      }

      const imageUrl = `${process.env.BASE_URL}${req.file.filename}`;
      // console.log("imageUrl", imageUrl);
      return res.status(200).json({ imageUrl: imageUrl });
    } catch (error) {
      console.error("Error uploading file:", error);
      return res.status(500).json({ error: "Internal server error" });
    }
  };
  updateExposure = async (req: Request, res: Response): Promise<void> => {
    const args: UpdateExposurePayload = { ...req.body };

    if (!args.ctx || !args.uid) {
      res.status(400).end();
      return;
    }

    if (args.change === undefined) {
      res.status(422).send(responses.MSG018);
    } else if (args.prevChange === undefined) {
      res.status(422).send(responses.MSG019);
    } else {
      const response = await userModel.updateExposure(
        args.ctx,
        args.uid,
        Math.round(args.prevChange),
        Math.round(args.change)
      );
      this.sendHttpResponse(res, response);
    }
  };

  updateBalance = async (req: Request, res: Response): Promise<void> => {
    const args: UpdateBalancePayload = { ...req.body };
    if (!args.uid || !args.from || !args.to) {
      res.status(400).end();
    } else {
      const response = await userModel.updateBalance(
        args.uid,
        args.from,
        args.to,
        args.change || 0.0,
        args.remark || "",
        args.ap,
        args.betid
      );
      this.sendHttpResponse(res, response);
    }
  };

  getHierarchy = async (req: Request, res: Response): Promise<void> => {
    const query: unknown = req.query;

    if (query && typeof query === "object") {
      const args = { ...query } as GetHierarchyPayload;
      if (!args.uid) {
        res.status(400).end();
      } else {
        const response = await userModel.getHierarchy(args.uid || 0);
        this.sendHttpResponse(res, response);
      }
    } else {
      res.status(400).end();
    }
  };
  getUplineUser = async (req: Request, res: Response): Promise<void> => {
    const query: unknown = req.query;
    // console.log('query' , query);

    if (query && typeof query === "object") {
      // console.log('herere');
      const args = { ...query } as GetHierarchyPayload;
      if (!args.username) {
        res.status(400).end();
      } else {
        const response = await userModel.getUplineUser(args.username || '');
        this.sendHttpResponse(res, response);
      }
    } else {
      res.status(400).end();
    }
  };

  getUserLocks = async (req: Request, res: Response): Promise<void> => {
    const query: unknown = req.query;

    if (query && typeof query === "object") {
      const args = { ...query } as GetUserLocksPayload;
      if (!args.uid) {
        res.status(400).end();
      } else {
        const response = await userModel.getUserLocks(args.uid);
        this.sendHttpResponse(res, response);
      }
    } else {
      res.status(400).end();
    }
  };

  sportFilter = async (req: Request, res: Response): Promise<void> => {
    // const { limit, offset, startDate, endDate } = req.query;

    const query: unknown = req.query;
    if (query && typeof query === "object") {
      const args = { ...query } as GetSportsfilterPayload;
      // Perform any necessary validation on the received parameters
      console.log('pattttttthhhhhhhhhhhhhh', args);
      // Call the userModel.getSports function with the provided parameters
      const response = await userModel.getSports(
        Number(args.limit),
        Number(args.offset),
        args.startDate as string,
        args.endDate as string,
        args._path
      );
      res.status(200).send(response);
    }
  };

  sportData = async (req: Request, res: Response): Promise<void> => {
    // const { limit, offset ,startDate, endDate} = req.query;
    const query: unknown = req.query;
    if (query && typeof query === "object") {
      const args = { ...query } as GetSportsfilterPayload;
      const gameId = Number(req.params.gameId);
      // console.log('pattttttthhhhhhhhhhhhhh',args._path,args._uid);
      const response = await userModel.getSportData(
        gameId,
        Number(args.limit),
        Number(args.offset),
        args.startDate as string,
        args.endDate as string,
        args._path
      );
      res.status(200).send(response);
    }
  };

  marketData = async (req: Request, res: Response): Promise<void> => {
    // const { limit, offset,startDate, endDate } = req.query;
    const query: unknown = req.query;
    if (query && typeof query === "object") {
      const args = { ...query } as GetSportsfilterPayload;
      const eventId = String(req.params.eventId);
      const response = await userModel.getMarketData(
        eventId,
        Number(args.limit),
        Number(args.offset),
        args.startDate as string,
        args.endDate as string,
        args._path);
      res.status(200).send(response);
    }
  };

  userData = async (req: Request, res: Response): Promise<void> => {
    // const { limit, offset,startDate, endDate } = req.query;
    const query: unknown = req.query;
    if (query && typeof query === "object") {
      const args = { ...query } as GetSportsfilterPayload;
      let market = req.params.market;
      const eventId = String(req.params.eventId);

      if (market === 'over_under_35') {
        market = 'Over/Under 3.5 Goals';
      }
      if (market === 'over_under_25') {
        market = 'Over/Under 2.5 Goals';
      }
      if (market === 'over_under_15') {
        market = 'Over/Under 1.5 Goals';
      }
      if (market === 'winner-1') {
        market = 'Set 1 Winner';
      }
      if (market === 'winner-2') {
        market = 'Set 2 Winner';
      }
      market = market.replace(/-/g, ' ');
      // console.log('winner',market);
      const response = await userModel.getUserData(
        market,
        eventId,
        Number(args.limit),
        Number(args.offset),
        args.startDate as string,
        args.endDate as string,
        args._path);
      res.status(200).send(response);
    }
  };
  userDataAviator = async (req: Request, res: Response): Promise<void> => {
    // const { limit, offset } = req.query;
    const query: unknown = req.query;
    if (query && typeof query === "object") {
      const args = { ...query } as GetSportsfilterPayload;
      const market = req.params.market;

      // market = market.replace(/-/g, ' ');
      // console.log('pattttttts',args._path,args._uid);
      const response = await userModel.getuserDataAviator(
        market,
        Number(args.limit),
        Number(args.offset),
        args.startDate as string,
        args.endDate as string,
        args._path);

      res.status(200).send(response);
    }
  };
  betHistoryAviator = async (req: Request, res: Response): Promise<void> => {
    // const { limit, offset } = req.query;
    const query: unknown = req.query;
    if (query && typeof query === "object") {
      const args = { ...query } as GetSportsfilterPayload;
      const userId = req.params.userId;

      const response = await userModel.betHistoryAviator(

        userId,
        Number(args.limit),
        Number(args.offset),
        args.startDate as string,
        args.endDate as string,
        // args._path
      );
      res.status(200).send(response);
    }
  };
  betHistoryCasino = async (req: Request, res: Response): Promise<void> => {
    // const { limit, offset } = req.query;
    const query: unknown = req.query;
    if (query && typeof query === "object") {
      const args = { ...query } as GetSportsfilterPayload;
      const userId = req.params.userId;

      const response = await userModel.betHistoryCasino(

        userId,
        Number(args.limit),
        Number(args.offset),
        args.startDate as string,
        args.endDate as string,
        // args._path
      );
      res.status(200).send(response);
    }
  };
  betHistory = async (req: Request, res: Response): Promise<void> => {
    // const { limit, offset,startDate,endDate } = req.query;
    const query: unknown = req.query;
    if (query && typeof query === "object") {
      const args = { ...query } as GetSportsfilterPayload;
      const userId = req.params.userId;
      let market = req.params.market;
      const eventId = req.params.eventId;

      if (market === 'over_under_35') {
        market = 'Over/Under 3.5 Goals';
      }
      if (market === 'over_under_25') {
        market = 'Over/Under 2.5 Goals';
      }
      if (market === 'over_under_15') {
        market = 'Over/Under 1.5 Goals';
      }
      if (market === 'winner-1') {
        market = 'Set 1 Winner';
      }
      // console.log('winner',market);
      if (market === 'winner-2') {
        market = 'Set 2 Winner';
      }
      market = market.replace(/-/g, ' ');
      const response = await userModel.getBetHistory(
        market,
        String(eventId),
        userId,
        Number(args.limit),
        Number(args.offset),
        args.startDate as string,
        args.endDate as string,
        args._path
      );
      res.status(200).send(response);
    }
  };

  // downlie user profit loss

  downlineUser = async (req: Request, res: Response): Promise<void> => {
    const { limit, offset, startDate, endDate, username, path } = req.query;
    if (typeof username === "string" && typeof path === "string") {
      const response = await userModel.getDownlineUserProfitLost(
        username,
        path,
        startDate as string,
        endDate as string,
        Number(limit),
        Number(offset)
      );
      res.status(200).send(response);
    } else {
      res.status(400).json({ error: "Invalid User" });
    }
  };
  downlineUserCasino = async (req: Request, res: Response): Promise<void> => {
    const { limit, offset, startDate, endDate, username, path } = req.query;
    if (typeof username === "string" && typeof path === "string") {
      const response = await userModel.getdownlineUserCasino(
        username,
        path,
        startDate as string,
        endDate as string,
        Number(limit),
        Number(offset)
      );
      res.status(200).send(response);
    } else {
      res.status(400).json({ error: "Invalid User" });
    }
  };

  userSportData = async (req: Request, res: Response): Promise<void> => {
    const { limit, offset, startDate, endDate, userId } = req.query;
    // const userId = req.params.userId;
    // console.log('userId' , userId);
    if (typeof userId === "string") {
      const response = await userModel.getUserSportData(
        userId,
        startDate as string,
        endDate as string,
        Number(limit),
        Number(offset)
      );
      res.status(200).send(response);
    } else {
      res.status(400).send({ error: 'Invalid user name' });
    }
  };
  userCasinoData = async (req: Request, res: Response): Promise<void> => {
    const { limit, offset, startDate, endDate, userId } = req.query;
    // const userId = req.params.userId;
    // console.log('userId' , userId);
    if (typeof userId === "string") {
      const response = await userModel.getuserCasinoData(
        userId,
        startDate as string,
        endDate as string,
        Number(limit),
        Number(offset)
      );
      res.status(200).send(response);
    } else {
      res.status(400).send({ error: 'Invalid user name' });
    }
  };

  userSportEventData = async (req: Request, res: Response): Promise<void> => {
    const { limit, offset, startDate, endDate, userId, gameId } = req.query;

    console.log('userId', limit, offset, startDate, endDate, userId, gameId);
    if (typeof userId === "string") {
      const response = await userModel.getUserSportEventData(
        userId,
        Number(gameId),
        startDate as string,
        endDate as string,
        Number(limit),
        Number(offset)
      );
      res.status(200).send(response);
    }
  };

  userEventMarketData = async (req: Request, res: Response): Promise<void> => {
    const { limit, offset, userId, gameId, eventId, startDate, endDate } = req.query;
    console.log('userId', userId);
    console.log('gameId', gameId);
    console.log('eventId', eventId);
    // const userId = req.params.userId;
    // console.log('userId' , userId);
    if (typeof userId === "string") {
      const response = await userModel.getUserEventMarketData(
        userId,
        Number(gameId),
        String(eventId),
        Number(limit),
        Number(offset),
        startDate as string,
        endDate as string,
      );
      res.status(200).send(response);
    }
  };


  userProfitAndLoss = async (req: Request, res: Response): Promise<void> => {
    const { limit, offset, startDate, endDate, userId, gameId } = req.query;
    // const userId = req.params.userId;
    // console.log('userId' , userId);
    if (typeof userId === "string") {
      const response = await userModel.getUserProfitAndLoss(
        userId,
        Number(gameId),
        startDate as string,
        endDate as string,
        Number(limit),
        Number(offset)
      );
      res.status(200).send(response);
    }
  };


  userAllGamesProfitAndLoss = async (req: Request, res: Response): Promise<void> => {
    const { startDate, endDate, userId } = req.query;
    // const userId = req.params.userId;
    // console.log('userId' , userId);
    if (typeof userId === "string") {
      const response = await userModel.getuserAllGamesProfitAndLoss(
        userId,

        startDate as string,
        endDate as string

      );
      res.status(200).send(response);
    }
  };


  // kyc api's

  submitKycDocument = async (req: Request, res: Response) => {
    try {
      const args: KYCDocumentPayload = { ...req.body };

      let isValidDocumentName = false;
      for (const enumValue of Object.values(DocumentType)) {
        if (args.documentName === enumValue) {
          isValidDocumentName = true;
          break;
        }
      }
      if (!isValidDocumentName) {
        return res.status(400).json({ error: 'Invalid documentName' });
      }
      const response = await userModel.submitKycDocument(
        args.userId,
        args.documentName as DocumentType,
        args.documentDetail,
        args.frontImage,
        args.backImage
      );
      this.sendHttpResponse(res, response);
    }
    catch (error) {
      return res.status(500).json({ error: 'Internal Server Error' });
    }
  }

  approveKyc = async (req: Request, res: Response) => {
    const args: UserDeletePayload = { ...req.body };
    const userKyc = await UserKyc.findOne({ where: { userId: args.userId } });
    if (userKyc != null) {
      userKyc.isApproved = KycStatus.Completed;
      userKyc.kycPercentage = 100;
      await userKyc.save();
      return res.status(200).json({ message: 'User Kyc Approved Successfully' });
    } else {
      return res.status(404).json({ error: 'User Kyc not found' });
    }
  }

  rejectKyc = async (req: Request, res: Response) => {
    const args: RejectKycPayload = { ...req.body };
    const userKyc = await UserKyc.findOne({ where: { userId: args.userId } });
    if (!args.reason) {
      return res.status(400).json({ error: 'provide reason of rejection' });
    }
    if (userKyc != null) {
      userKyc.isApproved = KycStatus.Rejected;
      userKyc.reason = args.reason;
      userKyc.kycPercentage = 25;
      await userKyc.save();
      return res.status(200).json({ message: 'User Kyc Rejected Successfully' });
    } else {
      return res.status(404).json({ error: 'User Kyc not found' });
    }
  }

  getKycDetail = async (req: Request, res: Response) => {
    const userId = Number(req.params.userId);

    const userKyc = await UserKyc.findOne({
      where: {
        userId: userId, isApproved: {
          [Op.ne]: 'rejected'
        }
      }
    });
    if (userKyc != null) {
      return res.status(200).json({ message: 'User Kyc Fetched Successfully', data: userKyc });
    } else {
      return res.status(404).json({ error: 'User Kyc not found' });
    }
  }

  getAllPendingKyc = async (req: Request, res: Response) => {
    const limit: number = req.query.limit ? parseInt(req.query.limit as string) : 10;
    const offset: number = req.query.offset ? parseInt(req.query.offset as string) : 0;

    const userKyc = await UserKyc.findAndCountAll({

      limit: limit,
      offset: offset

    });


    const query = `SELECT "userkyc".*, "users".username , "users".fullname , "users".email , "users".dob , "users".phone_number
    FROM "userkyc"
    INNER JOIN "users" ON "userkyc"."userid" = "users"."id"
    ORDER BY "createdat" DESC
    OFFSET ${offset || 0} 
    FETCH NEXT ${limit || 10} ROWS ONLY
   `;

    const [userResults, userMetadata] = await sequelize.query(query);




    //     const query1 = `select user`;
    //     const query = `
    //     SELECT "UserKyc".*, "User".*
    //     FROM "UserKyc"
    //     INNER JOIN "Users" AS "User" ON "UserKyc"."userId" = "User"."id"
    //     WHERE "UserKyc"."isApproved" = 'pending'
    //     LIMIT :limit OFFSET :offset;
    // `;


    const totalCount = userKyc.count;

    return res.status(200).json({
      message: 'All Pending Kyc Fetched Successfully',
      data: userResults,
      total_count: totalCount
    });
  }


  updateAccountInfo = async (req: Request, res: Response) => {
    const args: AccountInfoUpdatePayload = { ...req.body };
    const response = await userModel.updateAccountInfo(
      args.userId,
      args.DOB,
      args.email,
      args.instagramId,
      args.telegramId,
      args.whatsappNumber
    );
    if (response != null) {
      return res.status(200).json({ message: 'Account Info Updated Successfully' });
    } else {
      return res.status(404).json({ error: 'Error Updating Data' });
    }
  }

  // for pannel for maunual result 

  fancySessionSettlement = async (req: Request, res: Response): Promise<void> => {
    const { limit, offset, search } = req.query;
    try {
      const response = await userModel.fancySessionSettlement(
        Number(limit) || 10,
        Number(offset) || 0,
        search ? String(search) : ''
      );
      res.status(200).send(response);
    } catch (error) {
      console.error("Error fetching downline user profit and loss:", error);
      res.status(500).json({ error: "Internal server error" });
    }
  };


  resultFancyandsession = async (req: Request, res: Response): Promise<void> => {
    try {
      const list = await userModel.resultFancyandsession();
      res.status(200).send({
        message: "",
        error: false,
        code: 200,
        data: { list }
      });
    } catch (error) {
      console.log("un resolve bet ", error);
      res.status(500).send({
        message: "Internal server error",
        error: true,
        code: 500,
        data: null
      });
    }
  };


}

export default UserController;
