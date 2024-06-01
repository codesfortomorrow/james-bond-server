import { Model, DataTypes } from 'sequelize';
import sequelize from '../db.config';

export type BankAccountAttributes = {
  id?: number;
  accountType: string;
  bankName: string;
  accountNumber: string;
  ifscCode: string;
  userid:string;
  status?: boolean;
  path?:string;
  createdAt?: Date;
  updatedAt?: Date;
  acountholdername:string;
  
}

export interface TransaBankAccountAttributes extends Model<BankAccountAttributes>, BankAccountAttributes { }

const BankAccount = sequelize.define<TransaBankAccountAttributes>('BankAccount', {
  id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true,
    allowNull: false,
    field: 'id'
  },
  accountType: {
    type: DataTypes.STRING,
    allowNull: false,
    field: 'account_type'
  },
  bankName: {
    type: DataTypes.STRING,
    allowNull: false,
    field: 'bank_name'
  },
  userid: {
    type: DataTypes.STRING,
    allowNull: false,
    field: 'userid'
  },
  accountNumber: {
    type: DataTypes.STRING,
    allowNull: false,
    field: 'account_number'
  },
  ifscCode: {
    type: DataTypes.STRING,
    allowNull: false,
    field: 'ifsc_code'
  },
  status: {
    type: DataTypes.BOOLEAN,
    defaultValue: false,
    allowNull: false,
    field: 'status'
  },
  createdAt: {
    type: DataTypes.DATE,
    defaultValue: DataTypes.NOW,
    allowNull: false,
    field: 'created_at'
  },
  updatedAt: {
    type: DataTypes.DATE,
    allowNull: false,
    field: 'updated_at'
  },
  path: {
    type: DataTypes.STRING,
    
    allowNull: true,
    field: 'path'
  },
  
  acountholdername: {
    type: DataTypes.STRING,
    allowNull: true,
    field: 'acountholdername'
  }
});

// After defining your Sequelize models
sequelize.sync();

export default BankAccount;
