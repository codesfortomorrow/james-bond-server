import { Model, DataTypes, Optional } from 'sequelize';

import sequelize from '../db.config';
 export type CasinoTransactionAttributes = {
    id: number;
    gameId: number;
    userId: string;
    username:string;
    path:string;
    gameCode: string;
    transactionId: string;
    referenceId: string;
    providerCode: string;
    providerTransactionId: string;
    amount: number;
    remark: string;
    gameType: string;
    createdAt: Date;
    updatedAt: Date;
}

 export type CasinoTransactionCreationAttributes = Optional<CasinoTransactionAttributes, 'id' | 'createdAt' | 'updatedAt'>
export interface CasinoTransactionInstance extends Model<CasinoTransactionAttributes, CasinoTransactionCreationAttributes>, CasinoTransactionAttributes { }

const CasinoTransaction = sequelize.define<CasinoTransactionInstance>('casinotransaction', {
    id: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true,
        allowNull: false
      },
      gameId: {
        type: DataTypes.INTEGER,
        allowNull: false,
        field: 'game_id'
      },
      userId: {
        type: DataTypes.STRING,
        allowNull: false,
        field: 'user_id'
      },
      username: {
        type: DataTypes.STRING,
        allowNull: true,
        field: 'username'
      },
      path: {
        type: DataTypes.STRING,
        allowNull: true,
        field: 'path'
      },
      gameCode: {
        type: DataTypes.STRING,
        allowNull: true,
        field: 'game_code'
      },
      transactionId: {
        type: DataTypes.STRING,
        allowNull: false,
        field: 'transaction_id'
      },
      referenceId: {
        type: DataTypes.STRING,
        allowNull: false,
        field: 'reference_id'
      },
      providerCode: {
        type: DataTypes.STRING,
        allowNull: false,
        field: 'provider_code'
      },
      providerTransactionId: {
        type: DataTypes.STRING,
        allowNull: false,
        field: 'provider_transaction_id'
      },
      amount: {
        type: DataTypes.DECIMAL(16, 2),
        allowNull: false
      },
      remark: {
        type: DataTypes.TEXT,
        allowNull: false
      },
      gameType: {
        type: DataTypes.STRING,
        allowNull: false,
        field: 'game_type'
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
});
sequelize.sync();


export default CasinoTransaction;
