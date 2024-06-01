

import { Model, DataTypes } from 'sequelize';

import sequelize from '../db.config';


export type QrAttributes = {
  id: number;
  image: string;
  upi: string;
  status: boolean;
  createdAt: Date;
  updatedAt: Date;
  userid:string;
  path:string;
}
// Replace this with your Sequelize instance
export interface TransaQrAttributese extends Model<QrAttributes>,QrAttributes { }

const QrCode = sequelize.define('QrCode', {
  id: {
    type: DataTypes.UUID,
    primaryKey: true,
    defaultValue: DataTypes.UUIDV4,
    allowNull: false,
    field: 'id'
  },
  image: {
    type: DataTypes.STRING,
    allowNull: false,
    field: 'image'
  },
  upi: {
    type: DataTypes.STRING,
  
    allowNull: false,
    field: 'upi'
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
  userid: {
    type: DataTypes.STRING,
    
    allowNull: true,
    field: 'userid'
  },
  path: {
    type: DataTypes.STRING,
    
    allowNull: true,
    field: 'path'
  },
} );// After defining your Sequelize models
sequelize.sync();


export default QrCode;
