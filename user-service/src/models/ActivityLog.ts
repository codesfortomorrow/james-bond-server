import { Model, DataTypes, Optional } from 'sequelize';
import sequelize from '../db.config';

export type ActivityLogAttributes = {
  id: number;
  userId: number;
  activity: string;
  ip: string;
  createdAt: Date;
  updatedAt: Date;
}

type ActivityLogCreationAttributes = Optional<ActivityLogAttributes, 'id' | 'createdAt' | 'updatedAt'>
export interface ActivityLogInstance extends Model<ActivityLogAttributes, ActivityLogCreationAttributes>, ActivityLogAttributes { }

const ActivityLog = sequelize.define<ActivityLogInstance>('activity_logs', {
  id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true,
    field: 'id'
  },
  userId: {
    type: DataTypes.INTEGER,
    allowNull: false,
    field: 'user_id'
  },
  activity: {
    type: DataTypes.STRING,
    allowNull: false,
    field: 'activity'
  },
  ip: {
    type: DataTypes.STRING,
    allowNull: false,
    field: 'ip'
  },
  createdAt: {
    type: DataTypes.DATE,
    allowNull: false,
    field: 'created_at'
  },
  updatedAt: {
    type: DataTypes.DATE,
    allowNull: false,
    field: 'updated_at'
  }
});

export default ActivityLog;
