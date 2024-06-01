import { Model, DataTypes, Optional } from 'sequelize';
import sequelize from '../db.config';

export type CasinoGameAttributes = {
  id: number;
  title: string;
  feature_group: string;
  game_images: string;
  has_freespins: boolean;
  hd: boolean;
  identifier: string;
  identifier2: string;
  lines: number;
  multiplier: number;
  payout: number;
  producer: string;
  provider: string;
  restrictions: string[];
  volatility_rating: string;
  createdAt: Date;
  updatedAt: Date;
  status: boolean;
}

type CasinoGameCreationAttributes = Optional<CasinoGameAttributes, 'id' | 'createdAt' | 'updatedAt'>
export interface CasinoGameInstance extends Model<CasinoGameAttributes, CasinoGameCreationAttributes>, CasinoGameAttributes { }

const CasinoGame = sequelize.define<CasinoGameInstance>(
  'casino_games',
  {
    id: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true,
      field: 'id'
    },
    title: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    feature_group: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    game_images: {
      type: DataTypes.TEXT,
      allowNull: false,
    },
    has_freespins: {
      type: DataTypes.BOOLEAN,
      allowNull: false,
    },
    hd: {
      type: DataTypes.BOOLEAN,
      allowNull: false,
    },
    status: {
        type: DataTypes.BOOLEAN,
        allowNull: true,
        defaultValue:false
      },
    identifier: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    identifier2: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    lines: {
      type: DataTypes.INTEGER,
      allowNull: false,
    },
    multiplier: {
      type: DataTypes.INTEGER,
      allowNull: false,
    },
    payout: {
      type: DataTypes.INTEGER,
      allowNull: false,
    },
    producer: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    provider: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    restrictions: {
      type: DataTypes.ARRAY(DataTypes.STRING),
      allowNull: false,
      defaultValue: [],
    },
    volatility_rating: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    createdAt: {
      type: DataTypes.DATE,
      allowNull: true,
      field: 'created_at'
    },
    updatedAt: {
      type: DataTypes.DATE,
      allowNull: true,
      field: 'updated_at'
    }
  },
);

sequelize.sync();


export default CasinoGame;
