export interface ApiResponse {
    message: string | undefined;
    data: any;
}

export type StatusCode = 200 | 201 | 202 | 302 | 400 | 401 | 403 | 404 | 500;

export type status = 'success' | 'error' | 'pending';