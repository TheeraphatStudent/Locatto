import mysql from "mysql2";
import "dotenv/config";

export const conn = mysql.createPool({
  connectionLimit: 100,
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
  connectTimeout: 60000,
  waitForConnections: true,
  queueLimit: 0
});

// export const queryAsync = conn.promise().query.bind(conn.promise());
// export const executeAsync = conn.promise().execute.bind(conn.promise());

export const queryAsync = conn.promise().query.bind(conn.promise());
export const executeAsync = conn.promise().execute.bind(conn.promise());

export async function pingDatabase(): Promise<void> {
  try {
    await queryAsync('SELECT 1');
    const timestamp = new Date().toISOString();
    console.log(`[${timestamp}] Database ping successful`);
  } catch (error: any) {
    console.error(`[${new Date().toISOString()}] Database ping failed:`, error?.message || error);
  }
}

let keepAliveTimer: NodeJS.Timeout | null = null;

export function initDbKeepAlive(intervalMs: number = 59 * 60 * 1000): void {
  void pingDatabase();

  if (keepAliveTimer) clearInterval(keepAliveTimer);

  keepAliveTimer = setInterval(() => {
    void pingDatabase();
  }, intervalMs);
}
