export interface Lottery {
  lid: number;
  lottery_number: string;
  created?: string;
}

export interface LotteryResponse {
  data: Lottery[];
  totalPages: number;
  currentPage: number;
}

export interface LotterySearchResponse extends LotteryResponse {
  message: string;
}
