export interface ApiResponse {
    message: string;
    data: any;
}

export type StatusCode = 200 | 201 | 202 | 302 | 400 | 401 | 403 | 404 | 500;