import { Sequelize } from 'sequelize';

const sequelize = new Sequelize(
  process.env.BET_DATABASE || '',
  process.env.BET_DATABASE_USER || '',
  process.env.BET_DATABASE_PASSWORD,
  {
    dialect: 'postgres',
    host: process.env.BET_DATABASE_HOST,
    port: Number(process.env.BET_DATABASE_PORT) || 5432,
    logging: false
  }
);

sequelize.authenticate()
  .then(() => {
    console.log('🔌️Bet Database Connection has been established successfully!');
  })
  .catch(err => {
    console.error('Unable to connect to the bet database: ', err);
  });

export default sequelize;
