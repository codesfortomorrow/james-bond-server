import { JwtAuthPayload } from '../../types';

export interface AuthUserPayload {
  ip: string;
  phoneNumber:string;
  username?: string;
  password?: string;
} 
export interface GetParticulerUserDetailsPayload  {
  id?: number;
  path?:string;
}
export interface GetQRPayload {
  id?: string;
  
  offset?: number;
  limit?: number;
}
export interface GetUserDetailsPayload extends JwtAuthPayload {
  uid?: number;
}
export interface casinostatementPayload extends JwtAuthPayload {
  uid: number;
  search?:string;
  offset?: number;
  limit?: number;
  startdate?:string;
  enddate?:string;
}
export interface casinoHistoryPayload extends JwtAuthPayload {
  uid: string;
  search?:string;
  startdate:string;
  enddate:string;
  offset?: number;
  limit?: number;
}


export interface CreateUserPayload extends JwtAuthPayload {
  fullname?: string;
  firstname?: string;
  lastname?: string;
  username?: string;
  password?: string;
  dialCode?: string;
  phoneNumber?: string;
  city?: string;
  ap?: number;
  creditAmount?: number;
  transactionCode?: string;
  privileges?: string[];
  userType?: string;
  remark?: string;
  otp? : string;
  
}

export interface GetSubUsersPayload extends JwtAuthPayload {
  uid?: number;
  path? : string;
  offset?: number;
  limit?: number;
  usertype? :string;
  search ?:string;
}
export interface GetMasterSubUsersPayload  {
  id?: string;
  path? : string;
  offset?: number;
  limit?: number;
  search ?:string;
}
export interface ShivRegisterUserPayload extends JwtAuthPayload {
  firstname: string,
  lastname: string;
  username:string;
  email?: string;
  password: string;
  dialCode: string;
  phoneNumber: string;
  otp: string;
  userType :string;
}

export interface createsessionPayload  {
  platform:string;
   gameid: string;
   id:string;
   ip?: string;
}
export interface searchCasinoPayload  {
  provider?:string;
  search:string;
}
export interface ShivSendVerificationCodePayload {
  mobile: string;
}
export interface UpdateUserLocksPayload extends JwtAuthPayload {
  uid?: number;
  betLock?: boolean;
  userLock?: boolean;
  transactionCode?: string;
}
export interface UserDeletePayload {
  userId: number;
}
export interface editMobileNumberPayload  extends JwtAuthPayload {
  uid?: number;
  userId: number;
  mobile: string;
  password:string;
}
export interface changeUserPasswordPayload {
  userId: number;
  masterId: number;
  masterpassword:string;
  userPassword:string;
}
export interface SecureAccountPayload extends JwtAuthPayload {
  oldPassword?: string;
  newPassword?: string;
  transactionCode?: string;
}

export interface ChangePasswordPayload extends JwtAuthPayload {
  ip: string;
  oldPassword?: string;
  newPassword?: string;
  transactionCode?: string;
}

export interface ActivityLogsPayload extends JwtAuthPayload {
  fromDate?: string;
  toDate?: string;
  offset?: number;
  limit?: number;
}
export interface particulerActivityLogsPayload {
  id : string;
  fromDate?: string;
  toDate?: string;
  offset?: number;
  limit?: number;
}
export interface GetSportsfilterPayload extends JwtAuthPayload {
  limit :string ; 
  startDate?: string;
  endDate?: string;
  offset?: number;
}
export interface CreditAmountPayload extends JwtAuthPayload {
  to?: number;
  creditAmount?: number;
  remark?: string;
  transactionCode?: string;
  depositId?: string;
}
export interface CreditAmountPayloadd extends JwtAuthPayload {
  to : number;
  creditAmount?: number;
  remark?: string;
  transactionCode?: string;
  id : number;
  newStatus :string;
}
export interface WithdrawAmountPayload extends JwtAuthPayload {
  from?: number;
  withdrawAmount?: number;
  remark?: string;
  transactionCode?: string;
  id : number;
  newStatus :string;
}

export interface GetTransactionsPayload extends JwtAuthPayload {
  filterUserId?: number;
  userid?:string;
  startdate?: string;
  enddate?: string;
  fromDate?: string;
  toDate?: string;
  offset?: number;
  limit?: number;
  filterTransaction?: string;
}

export interface UpdateExposurePayload {
  uid?: number;
  change?: number;
  prevChange?: number;
  ctx?: string;
}

export interface UpdateBalancePayload {
  uid?: number;
  from?: number;
  to?: number;
  change?: number;
  remark?: string;
  ap :number;
  betid:number;
  ctx?: string;
}


export interface GetHierarchyPayload {
  uid?: number;
  username?:string;
}

export interface GetUserLocksPayload {
  uid?: number;
}

export interface KYCDocumentPayload {
  userId: number;
  documentName: string;
  documentDetail: string;
  frontImage: string;
  backImage: string;
}

export interface AccountInfoUpdatePayload {
  userId: number;
  DOB: Date;
  email: string;
  telegramId: string;
  instagramId: string;
  whatsappNumber: string;
}

export interface UserDepositPayload extends JwtAuthPayload {
  uid?: number;
  path? : string;
  offset?: number;
  limit?: number;
  fromDate?: string;
  toDate?: string;
  status?:string;
}


export interface RejectKycPayload {
  userId: number;
  reason: string;
}