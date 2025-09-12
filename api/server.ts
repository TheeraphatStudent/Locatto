import http from "http";
import { app } from "./app";
import { initDbKeepAlive } from "./db/connectiondb";

const port = process.env.PORT || 3000;
const server = http.createServer(app);

server.listen(port, () => {
  const timestamp = new Date().toISOString();
  console.log(`[${timestamp}] Server started successfully on port ${port}`);
  console.log(`[${timestamp}] Listening for incoming requests...`);

  initDbKeepAlive();

}).on("error", (error) => {
  const timestamp = new Date().toISOString();
  console.error(`[${timestamp}] ❌ Server error:`, error.message);
});