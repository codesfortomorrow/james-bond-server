import { Model, DataTypes, Optional } from 'sequelize';

import sequelize from '../db.config';
import responses from '../responses';

export type SettlementTransactionAttributes = {
  id: number;
  from: number;
  to: number;
  amount: number;
  betid: number;
  remark: string;
  receiverBalance: number;
  ap: number;
  createdAt: Date;
  updatedAt: Date;
}

type SettlementTransactionCreationAttributes = Optional<SettlementTransactionAttributes, 'id' | 'remark' | 'createdAt' | 'updatedAt'>
export interface SettlementTransactionInstance extends Model<SettlementTransactionAttributes, SettlementTransactionCreationAttributes>, SettlementTransactionAttributes { }

const SettlementTransaction = sequelize.define<SettlementTransactionInstance>('settlement-transaction', {
    id: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true,
        field: 'id'
      },
      from: {
        type: DataTypes.INTEGER,
        allowNull: true,
        field: 'from',
        validate: {
          isInt: { msg: responses.MSG013 }
        }
      },
      to: {
        type: DataTypes.INTEGER,
        allowNull: true,
        field: 'to',
        validate: {
          isInt: { msg: responses.MSG013 }
        }
      },
      amount: {
        type: DataTypes.DECIMAL(16, 2),
        allowNull: true,
        field: 'amount',
        validate: {
          isFloat: { msg: responses.MSG010 }
        }
      },
      receiverBalance: {
        type: DataTypes.DECIMAL(16, 2),
        allowNull: true,
        field: 'receiver_balance',
        validate: {
          isFloat: { msg: responses.SOMETHING_WRONG }
        }
      },
      betid: {
        type: DataTypes.INTEGER,
        allowNull: true,
        field: 'betid',
        validate: {
          isFloat: { msg: responses.SOMETHING_WRONG }
        }
      },
    
      
      remark: {
        type: DataTypes.TEXT,
        allowNull: true,
        field: 'remark'
      },
      ap: {
        type: DataTypes.INTEGER,
        allowNull: true,
        defaultValue: 0,
        field: 'ap'
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


export default SettlementTransaction;
