import express from "express";
import { router as index } from "./route/index";
import { router as trip } from "./route/trip";
import { router as upload } from "./route/upload";
import { router as auth } from "./route/auth";
import { router as lottery } from "./route/lottery";
import { router as purchase } from "./route/purchase";
import { router as reward } from "./route/reward";
import { router as payment } from "./route/payment";

import bodyParser from "body-parser";
import cors from "cors";
import morgan from "morgan";
import { jwtMiddleware } from "./middleware/jwt";

import "dotenv/config";

declare global {
  namespace Express {
    interface Request {
      user?: any;
    }
  }
}

export const app = express();

app.use(morgan('combined'));

app.use(
  cors({
    origin: "*",
    methods: ["GET", "POST", "PUT", "DELETE", "OPTIONS"],
    allowedHeaders: ["Content-Type", "Authorization"],
  })
);

app.use(bodyParser.text());
app.use(bodyParser.json());

app.use(jwtMiddleware);

app.use("/", index);
app.use("/trip", trip);
app.use("/upload", upload);
app.use("/auth", auth);
app.use("/lottery", lottery);
app.use("/purchase", purchase);
app.use("/reward", reward);
app.use("/payment", payment);