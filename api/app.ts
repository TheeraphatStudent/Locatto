import express from "express";
import { router as index } from "./route/index";
import { router as trip } from "./route/trip";
import { router as upload } from "./route/upload";
import { router as auth } from "./route/auth";
import bodyParser from "body-parser";
import cors from "cors";
import morgan from "morgan";
import { jwtMiddleware } from "./middleware/jwt";
import "dotenv/config";

export const app = express();

app.use(morgan('combined'));
app.use(jwtMiddleware);

app.use(
  cors({
    origin: "*",
    methods: ["GET", "POST", "PUT", "DELETE", "OPTIONS"],
    allowedHeaders: ["Content-Type", "Authorization"],
  })
);

app.use(bodyParser.text());
app.use(bodyParser.json());

app.use("/", index);
app.use("/trip",trip);
app.use("/upload", upload);
app.use("/auth", auth);
app.use("/uploads", express.static("uploads"));
