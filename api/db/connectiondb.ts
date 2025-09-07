import mysql from "mysql2";
import "dotenv/config";

export const conn = mysql.createPool({
  connectionLimit: 10,
  // host: "202.28.34.197",
  // user: "tripbooking",
  // password: "tripbooking@csmsu",
  // database: "tripbooking",

  host: process.env.DB_HOST || 'localhost',
  user: process.env.DB_USERNAME,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
  authPlugins: {
    mysql_clear_password: () => () => Buffer.from(process.env.DB_PASSWORD + '\0')
  },
  connectTimeout: 60000
});

export const queryAsync = conn.promise().query.bind(conn.promise());
export const executeAsync = conn.promise().execute.bind(conn.promise());