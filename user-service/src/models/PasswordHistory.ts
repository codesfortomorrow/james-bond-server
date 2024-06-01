/* eslint-disable @typescript-eslint/no-unused-vars */
import { Model, DataTypes } from 'sequelize';
import sequelize from '../db.config';
import responses from '../responses';
import User from './User';

type PasswordHistoryAttributes = {
  id: number;
  userId: number;
  remarks?: string;
  createdAt?: Date;
  updatedAt?: Date;
  path? : string;
};

type PasswordHistoryCreationAttributes = Omit<PasswordHistoryAttributes, 'id'>;

export interface PasswordHistoryInstance extends Model<PasswordHistoryAttributes, PasswordHistoryCreationAttributes>, PasswordHistoryAttributes {}

const PasswordHistory = sequelize.define<PasswordHistoryInstance>('passwordHistory', {
  id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true,
    allowNull: false,
  },
  userId: {
    type: DataTypes.INTEGER,
    allowNull: false,
    field: 'userid',
    references: {
      model: User,
      key: 'id',
    },
  },
  remarks: {
    type: DataTypes.STRING,
    allowNull: true,
  },
  createdAt: {
    type: DataTypes.DATE,
    allowNull: true,
    field: 'createdat',
    defaultValue: DataTypes.NOW,
  },
  updatedAt: {
    type: DataTypes.DATE,
    allowNull: true,
    field: 'updatedat',
    defaultValue: DataTypes.NOW,
  }, path : {
    type: DataTypes.STRING,
    allowNull: true,
  }
  

}, {
  tableName: 'password_history',
});
sequelize.sync();
PasswordHistory.belongsTo(User, { foreignKey: 'userId' });

export default PasswordHistory;