import http from "http";
import { app } from "./app";

const port = process.env.port || 3000;
const server = http.createServer(app);

server.listen(port, () => {
  const timestamp = new Date().toISOString();
  console.log(`[${timestamp}] Server started successfully on port ${port}`);
  console.log(`[${timestamp}] Listening for incoming requests...`);

}).on("error", (error) => {
  const timestamp = new Date().toISOString();
  console.error(`[${timestamp}] ❌ Server error:`, error.message);
});