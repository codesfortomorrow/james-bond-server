export class ModelValidationError extends Error {
  public name = '';
  public readonly errors: { message: string }[] = [];

  constructor(message: string, name?: string, errors?: { message: string }[]) {
    super(message);
    this.name = name || '';
    this.errors = errors || [];
  }
}
export type AddUserUPIPayload = {
  upiId: string;
  upiName: string;
  userId: number;
};

export interface Depositpayload {
  id: number;
  userId: number;
  amount: number;
  status: number;
  type: string;
  createdAt: Date;
  updatedAt: Date;
}
export interface JwtAuthPayload {
  _uid: number;
  _level: number;
  _path: string;
  _status: number;
  _privileges: Privileges | null;
  _ut: string;
  _transactionCode: string | null;
  exp: number;
}
export interface loginAuthPayload {
  _phoneNumber :string;
  _password :string;
  _ut:string;
}
export interface JwtAuthPayloadForRegisterShiv {
  _uid: number;
}

export interface UploadProfilePayload extends JwtAuthPayload {
  profile?: File;
}
export interface UploadImagePayload extends JwtAuthPayload {
  image?: File;
}
export type Privileges = Record<string, boolean>
