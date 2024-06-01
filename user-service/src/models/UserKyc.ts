
import { Model, DataTypes } from 'sequelize';
import sequelize from '../db.config';
import User from '../models/User';

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

type UserKycAttributes = {
  id: number;
  userId: number;
  documentName: DocumentType;
  documentDetail: string;
  frontImage: string;
  backImage: string;
  isApproved: KycStatus;
  kycPercentage: number;
  reason: string;
  createdAt?: Date;
  updatedAt?: Date;
};

type UserKycCreationAttributes = Omit<UserKycAttributes, 'id'>;

export interface UserKycInstance extends Model<UserKycAttributes, UserKycCreationAttributes>, UserKycAttributes {}

const UserKyc = sequelize.define<UserKycInstance>('userKyc', {
  id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true,
    allowNull: false,
  },
  documentName: {
    type: DataTypes.ENUM(...Object.values(DocumentType)),
    allowNull: false,
    field:'documentname'
  },
  documentDetail: {
    type: DataTypes.STRING,
    allowNull: false,
    field:'documentdetail'
  },
  frontImage: {
    type: DataTypes.STRING,
    allowNull: false,
    field:'frontimage'
  },
  backImage: {
    type: DataTypes.STRING,
    allowNull: true,
    field:'backimage'
  },
  userId: {
    type: DataTypes.INTEGER,
    allowNull: false,
    references: {
      model: 'users',
      key: 'id'
    },
    field:'userid'
  },
  isApproved: {
    type: DataTypes.ENUM(...Object.values(DocumentType)),
    allowNull: false,
    defaultValue: 'pending',
    field:'isapproved'
  },
  kycPercentage: {
    type: DataTypes.INTEGER,
    allowNull: false,
    field:'kycpercentage'
  },
  reason: {
    type: DataTypes.TEXT,
    allowNull: false,
    field: 'reason'
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
  },
}, {
    tableName: 'userkyc'
  });

UserKyc.belongsTo(User, { foreignKey: 'userId' });

export default UserKyc;