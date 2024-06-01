import { Model, DataTypes } from 'sequelize';
import sequelize from '../db.config';

export type AddUserApiAttributes = {
  id?: number;
  upiId: string;
  upiName: string;
  userId: number;
  
};

export interface TransaAddUserApiAttributes extends Model<AddUserApiAttributes>, AddUserApiAttributes {}

const AddUserApi = sequelize.define<TransaAddUserApiAttributes>('adduserapis', {
  id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true,
    allowNull: false
  },
  upiId: {
    type: DataTypes.STRING,
    allowNull: false,
    field: 'upi_id'
  },
  upiName: {
    type: DataTypes.STRING,
    allowNull: false,
    field: 'upi_name'
  },
  userId: {
    type: DataTypes.INTEGER,
    allowNull: false,
    field: 'user_id'
  },
 

});

sequelize.sync();
export default AddUserApi;
