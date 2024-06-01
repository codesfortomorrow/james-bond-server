import { Model, DataTypes } from 'sequelize';
import sequelize from '../db.config';


export interface WithdrawalTransactionAttributes {
  id?: number;
  userName: string;
  accountNo: string;
  ifscCode: string;
  name: string;
  amount: number;
  status: string;
  userId :number;
  userpath: string;
  acountholdername: string;
  
}

export interface WithdrawalTransactionInstance
  extends Model<WithdrawalTransactionAttributes>,
    WithdrawalTransactionAttributes {}
const WithdrawalTransaction = sequelize.define<WithdrawalTransactionInstance>(
  'withdrawaltransaction',
  {
    id: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true,
      allowNull: false
    },
    userName: {
      type: DataTypes.STRING,
      allowNull: false
    },
    accountNo: {
      type: DataTypes.STRING,
      allowNull: false
    },
    ifscCode: {
      type: DataTypes.STRING,
      allowNull: false
    },
    name: {
      type: DataTypes.STRING,
      allowNull: false
    },
    amount: {
      type: DataTypes.DECIMAL(10, 2),
      allowNull: false
    },
    status: {
      type: DataTypes.STRING,
      allowNull: false
    },
    userId: {
      type: DataTypes.INTEGER,
      allowNull: false,
      field: 'userid'
    },
    userpath: {
      type: DataTypes.STRING,
      allowNull: false,
      field: 'userpath'
    },
    acountholdername: {
      type: DataTypes.STRING,
      allowNull: false,
      field: 'acountholdername'
    }
  
  
  }
);

sequelize.sync();
export default WithdrawalTransaction;
