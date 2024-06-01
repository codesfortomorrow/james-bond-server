import { Model, DataTypes } from 'sequelize';
import sequelize from '../db.config';

export interface AddUserAccountAttributes {
  id?: number;
  accountType: string;
  bankName: string;
  accountNumber: string;
  ifscCode: string;
  userId: number;
  acountholdername: string
  
}

export interface TransaAddUserAccountAttributes extends Model<AddUserAccountAttributes>, AddUserAccountAttributes {}

const AddUserAccount = sequelize.define<TransaAddUserAccountAttributes>('adduseraccounts', {
  id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true,
    allowNull: false
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
  userId: {
    type: DataTypes.INTEGER,
    allowNull: false,
    field: 'user_id'
  },
  acountholdername: {
    type: DataTypes.STRING,
    allowNull: false,
    field: 'acountholdername'
  }
});
sequelize.sync();
export default AddUserAccount;
