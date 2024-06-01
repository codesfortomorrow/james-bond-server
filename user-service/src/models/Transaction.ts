import { Model, DataTypes, Optional } from 'sequelize';
import { User } from '.';
import sequelize from '../db.config';
import responses from '../responses';

export type TransactionAttributes = {
  id: number;
  from?: number;
  to?: number;
  amount?: number;
  senderBalance?: number;
  receiverBalance?: number;
  remark?: string;
  status?: number;
  type?: string;
  createdAt?: Date;
  updatedAt?: Date;
}

type TransactionCreationAttributes = Optional<TransactionAttributes, 'id' | 'status' | 'createdAt' | 'updatedAt'>
export interface TransactionInstance extends Model<TransactionAttributes, TransactionCreationAttributes>, TransactionAttributes { }

const Transaction = sequelize.define<TransactionInstance>('transaction', {
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
  senderBalance: {
    type: DataTypes.DECIMAL(16, 2),
    allowNull: true,
    field: 'sender_balance',
    validate: {
      isFloat: { msg: responses.SOMETHING_WRONG }
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
  remark: {
    type: DataTypes.TEXT,
    allowNull: true,
    field: 'remark'
  },
  status: {
    type: DataTypes.TINYINT,
    allowNull: true,
    defaultValue: 0,
    field: 'status'
  },
  type: {
    type: DataTypes.STRING,
    allowNull: true,
    field: 'type'
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

Transaction.belongsTo(User, { as: 'sender', foreignKey: 'from' });
Transaction.belongsTo(User, { as: 'receiver', foreignKey: 'to' });

export default Transaction;
