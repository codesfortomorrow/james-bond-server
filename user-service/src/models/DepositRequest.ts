import { Model, DataTypes } from 'sequelize';
import sequelize from '../db.config';

// Define the attributes for a deposit request
export interface DepositRequestAttributes {
  id?: number;
  paymentMethod: string;
  utr: string;
  img: string;
  amount: number;
  userId: number;
  status: string;
  username: string;
  userpath: string;
 
}

// Define the DepositRequest model
const DepositRequest = sequelize.define<Model<DepositRequestAttributes>>(
  'depositrequests',
  {
    id: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true,
      allowNull: true,
    },
    paymentMethod: {
      type: DataTypes.STRING,
      allowNull: true,
    },
    utr: {
      type: DataTypes.STRING,
      allowNull: true,
    },
    img: {
      type: DataTypes.STRING,
      allowNull: true,
    },
    amount: {
      type: DataTypes.INTEGER, // Adjust the precision and scale as needed
      allowNull: true,
    },
    userId: {
      type: DataTypes.INTEGER,
      allowNull: true,
    },
    status: {
      type: DataTypes.STRING,
      allowNull: true,
      defaultValue: 'pending',
    },
    username: {
      type: DataTypes.STRING,
      allowNull: true,
    },
    userpath: {
      type: DataTypes.STRING,
      allowNull: true,
    },
 
  }
);
// After defining your Sequelize models
sequelize.sync();


export default DepositRequest;
