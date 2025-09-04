import mysql from "mysql";
import util from "util";

export const conn = mysql.createPool({
  connectionLimit: 10,
  // host: "202.28.34.197",
  // user: "tripbooking",
  // password: "tripbooking@csmsu",
  // database: "tripbooking",

  host: process.env.DB_HOST,
  user: process.env.DB_USERNAME,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
});

export const queryAsync = util.promisify(conn.query).bind(conn);