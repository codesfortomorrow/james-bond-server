import { Model, DataTypes } from 'sequelize';
import md5 from 'md5';
import sequelize from '../db.config';
import { Privileges, ModelValidationError } from '../types';
import responses from '../responses';

type UserAttributes = {
  id: number;
  fullname: string;
  username: string;
  password: string;
  dialCode: string;
  phoneNumber: string;
  city: string;
  level: number;
  path: string;
  ap: number;
  balance: number;
  creditAmount: number;
  exposureAmount: number;
  transactionCode: string | null;
  resetToken:string|null;
  privileges: Privileges | null;
  userType: string;
  status: number;
  remark: string;
  createdAt: Date;
  updatedAt: Date;
  initialSetup: boolean;
  lock: boolean;
  betLock: boolean,
  parentAp: number;
  isDeleted:boolean;
  email?:string;
  DOB?: Date;
  telegramId?: string;
  instagramId?: string;
  whatsappNumber?: string;
  isPasswordChanged: boolean;
  newUsersAccess ?: boolean;
  
}

type UserCreationAttributes = Partial<UserAttributes> & Pick<UserAttributes,  'phoneNumber'>;
export interface UserInstance extends Model<UserAttributes, UserCreationAttributes>, UserAttributes { }

const User = sequelize.define<UserInstance>('user', {
    id: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true,
        field: 'id'
    },
    fullname: {
        type: DataTypes.STRING,
        allowNull: true, // Updated to allow null
        field: 'fullname',
        validate: {
            notEmpty: { msg: responses.MSG004 }
        }
    },
    username: {
        type: DataTypes.STRING,
        allowNull: true, // Updated to allow null
        unique: true,
        field: 'username',
        validate: {
            notEmpty: { msg: responses.MSG005 },
            isAlphanumeric: { msg: responses.MSG005 }
        }
    },
    password: {
        type: DataTypes.STRING,
        allowNull: false,
        field: 'password',
        set(value) {
            if (/^(?=.*[A-Z])(?=.*[~!@#$%^&*()/_=+[\]{}|;:,.<>?-])(?=.*[0-9])(?=.*[a-z]).{8,14}$/.test(value as string))
                return this.setDataValue('password', md5(value as string));
            else {
                throw new ModelValidationError('Password is not valid', 'ValidationError', [{ message: responses.MSG006 }]);
            }
        }
    },
    dialCode: {
        type: DataTypes.STRING,
        allowNull: true, // Updated to allow null
        field: 'dial_code',
        defaultValue: ''
    },
    phoneNumber: {
        type: DataTypes.STRING,
        allowNull: false,
        field: 'phone_number',
        defaultValue: ''
    },
   
    city: {
        type: DataTypes.STRING,
        allowNull: true, // Updated to allow null
        field: 'city',
        validate: {
            is: { msg: responses.MSG008, args: /^[a-z ]+$/i },
            notEmpty: true
        }
    },
    level: {
        type: DataTypes.SMALLINT,
        allowNull: true, // Updated to allow null
        field: 'level'
    },
    path: {
        type: DataTypes.STRING,
        allowNull: true, // Updated to allow null
        field: 'path'
    },
    ap: {
        type: DataTypes.DECIMAL(5, 2),
        allowNull: true, // Updated to allow null
        defaultValue: 100.00,
        field: 'ap',
        validate: {
            isFloat: { msg: responses.MSG009 },
            max: { msg: responses.MSG009, args: [100.00] }
        }
    },
    parentAp: {
        type: DataTypes.DECIMAL(5, 2),
        allowNull: true, // Updated to allow null
        defaultValue: 0.00,
        field: 'parent_ap'
    },
    balance: {
        type: DataTypes.DECIMAL(16, 2),
        allowNull: true, // Updated to allow null
        defaultValue: 0.00,
        field: 'balance',
        validate: {
            isFloat: { msg: responses.MSG010 }
        }
    },
    email: {
        type: DataTypes.STRING,
        allowNull: true,
        field: 'email',
        validate: {
          notEmpty: { msg: responses.MSG007 },
          isEmail: { msg: responses.MSG008 },
        },
      },
      
    creditAmount: {
        type: DataTypes.DECIMAL(16, 2),
        allowNull: true, // Updated to allow null
        defaultValue: 0.00,
        field: 'credit_amount',
        validate: {
            isFloat: { msg: responses.MSG010 }
        }
    },
    exposureAmount: {
        type: DataTypes.DECIMAL(16, 2),
        allowNull: true, // Updated to allow null
        defaultValue: 0.00,
        field: 'exposure_amount',
        validate: {
            isFloat: { msg: responses.MSG017 }
        }
    },
    transactionCode: {
        type: DataTypes.STRING(6),
        allowNull: true, // Updated to allow null
        field: 'transaction_code',
        
    },
    privileges: {
        type: DataTypes.JSON,
        allowNull: true, // Updated to allow null
        field: 'privileges'
    },
    userType: {
        type: DataTypes.STRING,
        allowNull: true,
        field: 'user_type',
        validate: {
            isIn: { msg: responses.MSG012, args: [['SUPER_MASTER', 'MASTER', 'USER']] }
        }
    },
    status: {
        type: DataTypes.TINYINT,
        allowNull: true, // Updated to allow null
        defaultValue: 1,
        field: 'status'
    },
    remark: {
        type: DataTypes.TEXT,
        allowNull: true, // Updated to allow null
        defaultValue: '',
        field: 'remark'
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
    },
    initialSetup: {
        type: DataTypes.BOOLEAN,
        allowNull: true, 
        defaultValue: false,
        field: 'initial_setup'
    },
    lock: {
        type: DataTypes.BOOLEAN,
        allowNull: true,
        defaultValue: false,
        field: 'lock'
    },
    betLock: {
        type: DataTypes.BOOLEAN,
        allowNull: true, 
        defaultValue: false,
        field: 'bet_lock'
    },
    resetToken: {
      type: DataTypes.STRING,
      allowNull: true,
      field: 'resetToken'
  },
  isDeleted: {
    type: DataTypes.BOOLEAN,
    allowNull: true,
    field: 'is_deleted',
    defaultValue: false,
  },
  DOB: {
    type: DataTypes.DATEONLY,
    allowNull: true,
    field: 'dob'
  },
  telegramId: {
    type: DataTypes.STRING,
    allowNull: true,
    field: 'telegramid'
  },
  instagramId: {
    type: DataTypes.STRING,
    allowNull: true,
    field: 'instagramid'
  },
  whatsappNumber: {
    type: DataTypes.STRING,
    allowNull: true,
    field: 'whatsappnumber'
  },
  isPasswordChanged: {
    type: DataTypes.BOOLEAN,
    allowNull: true,
    defaultValue: true,
    field: 'is-password-changed'
},
newUsersAccess : {
    type: DataTypes.BOOLEAN,
    allowNull: true,
    defaultValue: false,
    field: 'new_users_access'
},
});
sequelize.sync();
export default User;

