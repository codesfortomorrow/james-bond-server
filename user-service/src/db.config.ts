import { Sequelize } from 'sequelize';

const sequelize = new Sequelize(
  process.env.DATABASE || '',
  process.env.DATABASE_USER || '',
  process.env.DATABASE_PASSWORD,
  {
    dialect: 'postgres',
    host: process.env.DATABASE_HOST,
    port: Number(process.env.DATABASE_PORT) || 5432,
    logging: false
  }
);

sequelize.authenticate()
  .then(() => {
    console.log('🔌️ Database Connection has been established successfully!');
  })
  .catch(err => {
    console.error('Unable to connect to the database: ', err);
  });

export default sequelize;
