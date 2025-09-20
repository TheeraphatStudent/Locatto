import mysql from "mysql2";
import "dotenv/config";

export const conn = mysql.createPool({
  connectionLimit: 100,
  host: process.env.DB_HOST || "localhost",
  user: process.env.DB_USERNAME,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
  authPlugins: {
    mysql_clear_password: () => () =>
      Buffer.from((process.env.DB_PASSWORD ?? "") + "\0"),
  },
  connectTimeout: 60000,
  waitForConnections: true,
  queueLimit: 0,
});

export const queryAsync = conn.promise().query.bind(conn.promise());
export const executeAsync = conn.promise().execute.bind(conn.promise());

export async function pingDatabase(): Promise<void> {
  try {
    await queryAsync("SELECT 1");
    console.log(`[${new Date().toISOString()}] Database ping successful`);
  } catch (error: any) {
    console.error(
      `[${new Date().toISOString()}] Database ping failed:`,
      error?.message || error
    );
  }
}

let idleTimer: NodeJS.Timeout | null = null;
const idleTimeoutMs = 55 * 60 * 1000;

function scheduleKeepAlive() {
  if (idleTimer) clearTimeout(idleTimer);
  idleTimer = setTimeout(() => {
    void pingDatabase();
    scheduleKeepAlive();
  }, idleTimeoutMs);
}

conn.on("acquire", () => {
  scheduleKeepAlive();
});

conn.on("release", () => {
  scheduleKeepAlive();
});

export function initDbKeepAlive(): void {
  scheduleKeepAlive();
}
