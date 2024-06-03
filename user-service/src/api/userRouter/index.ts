import express, { Router } from 'express';
import UserController from './userController';
import AuthenticateSession from '../../middlewares/AuthenticateSession';
import upload from '../../multer.config';

const router: Router = express.Router();
const user = new UserController();

/* casino  */

router.get('/live-casino-games', user.liveCasinoGmae);
router.post('/create-session', user.createCasinoSession);
router.get('/live-aviator-games', user.aviatorGmae);
router.get('/live-casino-search', user.casinosearch);
router.post('/callback/get-balance', user.getCasinoBalance);
router.post('/callback/credit-balance', user.handleCreditCallback);
router.post('/callback/debit-balance', user.handleDebitCallback);
router.get('/get-casino-aviator-statement',user.casinostatement);
router.get('/get-casino-aviator-history', AuthenticateSession,user.casinoAviatorHistory);




router.post('/register-shiv-user', user.shivRegisterUser);
router.post('/send-verificationshiv-code', user.shivSendVerificationCode);




/* Authentication */
router.post('/signin', user.authUser);

/* Profile */
router.get('/get-user-details', AuthenticateSession, user.getUserDetails);
router.get('/get-particuleruser-details', AuthenticateSession, user.getParticulerUserDetails);
router.put('/change-user-password', AuthenticateSession, user.changeUserPassword);
router.post('/secure-account', AuthenticateSession, user.secureAccount);


router.post('/change-password', AuthenticateSession, user.changePassword);
router.post('/change-firsttime-password' , AuthenticateSession , user.changeFirstTimePassword);
router.get('/activity-logs', AuthenticateSession, user.activityLogs);
router.get('/particuler-activity-logs', AuthenticateSession, user.particulerActivityLogs);

/* Manage Users */
router.post('/create-sub-user', AuthenticateSession, user.createSubUser);
router.put('/change-mobile-number', AuthenticateSession, user.editMobileNumber);
router.put('/change-user-mobile-number', AuthenticateSession, user.edituserMobileNumber);
router.get('/password-history', AuthenticateSession, user.passwordHistory);

router.post('/register', user.registerUser);
router.post('/forgot-password', user.forgotPassword);
router.post('/forgot-resetpassword', user.resetPassword);
router.get('/get-sub-users', AuthenticateSession, user.getSubUsers);
router.get('/get-masters', AuthenticateSession, user.getMaster);
router.post('/locks', AuthenticateSession, user.updateUserLocks);
router.put('/delete-user', AuthenticateSession, user.deleteUser);
router.put('/restore-user', AuthenticateSession, user.restoreUser);
router.get('/deleted-user', AuthenticateSession, user.deletedUser);
router.get('/get-master-subusers', AuthenticateSession, user.getMasterSubUsers);
router.get('/get-overall-amountexposure', AuthenticateSession, user.getoverallAmount);
router.get('/get-upline-user', user.getUplineUser);


/* Credit Amount */
router.get('/get-balance', AuthenticateSession, user.getBalance);
router.post('/uploads', upload.single('image'), user.uploadImage);

router.post('/transfer-credit-amount', AuthenticateSession, user.transferCreditAmount);
router.post('/withdraw-credit-amount', AuthenticateSession, user.withdrawCreditAmount);
router.get('/get-transactions', AuthenticateSession, user.getTransactions);
// router.get('/get-transactions', AuthenticateSession, user.getTransactions);


// QR
router.post('/add-qr',AuthenticateSession, user.addQrCode);
router.put('/update-qr', AuthenticateSession , user.updateQrCode);
router.delete('/delete-qr/:id',AuthenticateSession,user.deleteQrCode);
router.get('/get-all-qr', AuthenticateSession,user.getAllQrCodes);
router.put('/qr/:id',AuthenticateSession, user.updateStatus);
router.get('/get-qr-true-status', AuthenticateSession,user.getQrCodeWithTrueStatusOrFirst);




// bank acount admin
router.post('/add-account',AuthenticateSession, user.addBankAccount);
router.put('/update-account', AuthenticateSession ,user.updateBankAccount);
router.delete('/delete-account/:id',AuthenticateSession, user.deleteBankAccount);
router.get('/all-bank-account', AuthenticateSession,user.getAllBankAccounts);
router.put('/upadate-account/:id', AuthenticateSession,user.updateBankAccountStatusById);
router.get('/get-account-true-status', AuthenticateSession,user.getAcountWithTrueStatusOrFirst);


// USER BANK OR DEOPOSIT 
router.post('/add-user-bank-account', AuthenticateSession, user.addUserBankAccount);
router.put('/update-user-bank-account',AuthenticateSession ,user.updateUserBankAccount);
router.get('/get-user-bank-account', AuthenticateSession, user.getUserBankAccounts);
router.delete('/delete-user-account/:id', AuthenticateSession, user.deleteUserAccount);
router.put('/deposit/update-status', AuthenticateSession,user.updateDipositStatusController);

// Deposit related 
router.post('/create-deposit',AuthenticateSession, user.createDepositRequest);
router.get('/deposits', AuthenticateSession,user.getUserDeposits);
router.get('/get-all-deposits',AuthenticateSession, user.getAllDeposits);

// admin accept reject deposit request
router.put('/accept-deposit-request' , user.acceptDepositRequest);
router.put('/reject-deposit-request' , user.rejectDepositRequest);

router.post('/add-banner', user.addBanner);
router.get('/get-all-Banner', user.getAllBanners);
router.get('/get-banner-status', user.getBannerStatus );
router.put('/banner-status', user.updateBannerStatus);

// USER UPI 
router.post('/add-userupi', AuthenticateSession, user.addUserUpi);
router.get('/get-userupi', AuthenticateSession, user.getUserUpi);
router.delete('/delete-userapi/:id', AuthenticateSession, user.deleteUserUpi);

// WID
router.post('/widraw-req',AuthenticateSession, user.widrawReq);
router.get('/get-user-widrawreq',AuthenticateSession,user.getUserWidrawReq);
router.get('/getall-widrawReq',AuthenticateSession,user.getAllWidrawReq);
router.put('/withdrawal/update-status',AuthenticateSession, user.updateWithdrawalStatusController);


/* Internal API's */

router.post('/update-exposure', user.updateExposure);
router.post('/update-balance', user.updateBalance);
router.get('/get-hierarchy', user.getHierarchy);
router.get('/locks', user.getUserLocks);

router.get('/sport-filter',AuthenticateSession, user.sportFilter);
router.get('/sport-data/:gameId', AuthenticateSession,user.sportData);
router.get('/market/:eventId',AuthenticateSession, user.marketData);
router.get('/all-user/:market/:eventId',AuthenticateSession, user.userData);
router.get('/bet-history-aviator/:userId', AuthenticateSession,user.betHistoryAviator);
router.get('/bet-history-casino/:userId', AuthenticateSession,user.betHistoryCasino);
router.get('/all-user-aviator/:market',AuthenticateSession, user.userDataAviator);
router.get('/bet-history/:userId/:market/:eventId', user.betHistory);

router.get('/downline-user', user.downlineUser);
router.get('/downline-user-casino', user.downlineUserCasino);
router.get('/user-sports', user.userSportData);
router.get('/user-casino', user.userCasinoData);
router.get('/sport-event', user.userSportEventData);
router.get('/event-market', user.userEventMarketData);


// user kyc api's
router.post('/submit-kyc-document' ,  user.submitKycDocument);
router.put('/approve-kyc' , user.approveKyc);
router.put('/reject-kyc' , user.rejectKyc);
router.get('/kyc/:userId' , user.getKycDetail);
router.get('/all-pending-kyc' , user.getAllPendingKyc);
// account info update api
router.put('/update-account-info', user.updateAccountInfo);
router.get('/user-profitandloss' , user.userProfitAndLoss);
router.get('/user-allgames-profitandloss' , user.userAllGamesProfitAndLoss);


// for bet result settlement pannel  
router.get('/session-unresolve-bets', user.fancySessionSettlement);












export default router;
