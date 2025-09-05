import { status } from "./response";

export interface LoginRequest {
  username: string;
  password: string

}

export interface LoginResponse {
  status: status;
  message: string;
  data: {
    token?: string
  };
}

export interface RegisterRequest {
  fullname: string;
  telno: string;
  cardId: string;
  email: string;
  img?: string;
  username: string;
  password: string;
  credit: number;
}

export interface RegisterResponse {
  status: status;
  message: string;
  data: {
    userId?: number
  };
}