

import { Model, DataTypes } from 'sequelize';

import sequelize from '../db.config';


export type BannerAttributes = {
  id: number;
  image: string;
  status :boolean;
  bannertype:string;

}
// Replace this with your Sequelize instance
export interface TransaBannerAttributes extends Model<BannerAttributes>,BannerAttributes { }

const AddBanner = sequelize.define('addBanner', {
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

  status: {
    type: DataTypes.BOOLEAN,
    defaultValue: false,
    allowNull: false,
    field: 'status'
  },
  bannertype: {
    type: DataTypes.STRING,
    allowNull: false,
    field: 'bannertype'
  },

} );// After defining your Sequelize models
sequelize.sync();


export default AddBanner;
