# Lottocat API Service

## Project Overview
An RESTful API system for lottery management using Express.js, TypeScript, MySQL, and Docker

## Completed Components

### 1. Database Schema Implementation
- **Customer Entity**: User management with authentication (bcrypt hashing)
- **Lottery Entity**: Lottery games with unique numbers and periods
- **Purchase Entity**: Customer lottery ticket purchases with relationships
- **Reward Entity**: Prize management with lottery associations

### 2. Application Architecture
- **MVC Pattern**: Clean separation of concerns
- **Services Layer**: Business logic isolation
- **Controllers**: HTTP request/response handling
- **Routes**: RESTful endpoint definitions with validation
- **Middleware**: Error handling, logging, security

### 3. Docker Infrastructure
- **API Container**: Node.js application with TypeScript compilation
- **MySQL Container**: Database with health checks
- **PHPMyAdmin Container**: Database management interface
- **Docker Compose**: Orchestrated multi-container setup

### 4. Security Features
- Password hashing with bcrypt
- Input validation with express-validator
- Rate limiting
- CORS configuration
- Helmet security headers

### 5. API Endpoints
All endpoints tested and working:
- **Customers**: CRUD operations with password hashing
- **Lotteries**: Full lottery management
- **Purchases**: Customer purchase tracking
- **Rewards**: Prize system management

## Services Access
- **API**: http://localhost:3000
- **PHPMyAdmin**: http://localhost:8080
- **Health Check**: http://localhost:3000/api/health

## Technical
**Start**

```bash
cd ./ && docker compose up -d --build --remove-orphans
```

**Logs** 
```bash
 docker logs  <id / name> -f
```

# Locatto API Documentation

## Overview

The Locatto API is a RESTful service built with Node.js, Express, TypeORM, and MySQL for managing a lottery application. The API provides endpoints for customer management, lottery operations, purchase tracking, and reward management.

## Base URL

```
http://localhost:3000
```

## Authentication

Currently, the API does not implement authentication. All endpoints are publicly accessible.

## Rate Limiting

The API implements rate limiting with the following configuration:
- **Window**: 15 minutes
- **Max Requests**: 100 requests per IP address
- **Response**: Returns 429 status code with error message when limit is exceeded

## Data Models

### Customer
```json
{
  "cid": "number (auto-generated)",
  "name": "string (1-100 chars, required)",
  "telno": "string (10-15 chars, required)",
  "img": "string (optional, max 255 chars)",
  "username": "string (3-50 chars, required, unique)",
  "password": "string (min 6 chars, required)",
  "credit": "decimal (10,2), default: 0",
  "created": "datetime (auto-generated)",
  "updated": "datetime (auto-generated)"
}
```

### Lottery
```json
{
  "lid": "number (auto-generated)",
  "lottery_number": "string (1-20 chars, required, unique)",
  "period": "string (1-50 chars, required)",
  "created": "datetime (auto-generated)",
  "updated": "datetime (auto-generated)"
}
```

### Purchase
```json
{
  "pid": "number (auto-generated)",
  "cid": "number (required, foreign key to customers.cid)",
  "lid": "number (required, foreign key to lotteries.lid)",
  "created": "datetime (auto-generated)",
  "updated": "datetime (auto-generated)"
}
```

### Reward
```json
{
  "rid": "number (auto-generated)",
  "lid": "number (required, foreign key to lotteries.lid)",
  "tier": "string (1-20 chars, required)",
  "revenue": "decimal (12,2, required)",
  "winner": "string (optional, max 100 chars)",
  "created": "datetime (auto-generated)",
  "updated": "datetime (auto-generated)"
}
```

## Endpoints

### Health Check

#### GET /api/health
Check if the API is running and healthy.

**Response:**
```json
{
  "success": true,
  "message": "API is running",
  "timestamp": "2024-01-01T00:00:00.000Z"
}
```

### Customers

#### GET /api/customers
Retrieve all customers from the database.

**Response:**
```json
[
  {
    "cid": 1,
    "name": "John Doe",
    "telno": "08123456789",
    "img": "https://example.com/avatar.jpg",
    "username": "johndoe",
    "password": "hashedpassword",
    "credit": 100.00,
    "created": "2024-01-01T00:00:00.000Z",
    "updated": "2024-01-01T00:00:00.000Z"
  }
]
```

#### GET /api/customers/:id
Retrieve a specific customer by their ID.

**Parameters:**
- `id` (number): Customer ID

**Response:**
```json
{
  "cid": 1,
  "name": "John Doe",
  "telno": "08123456789",
  "img": "https://example.com/avatar.jpg",
  "username": "johndoe",
  "password": "hashedpassword",
  "credit": 100.00,
  "created": "2024-01-01T00:00:00.000Z",
  "updated": "2024-01-01T00:00:00.000Z"
}
```

#### POST /api/customers
Create a new customer account.

**Request Body:**
```json
{
  "name": "John Doe",
  "telno": "08123456789",
  "username": "johndoe",
  "password": "password123",
  "credit": 100.00,
  "img": "https://example.com/avatar.jpg"
}
```

**Validation Rules:**
- `name`: Required, 1-100 characters
- `telno`: Required, 10-15 characters
- `username`: Required, 3-50 characters, unique
- `password`: Required, minimum 6 characters
- `credit`: Optional, numeric value
- `img`: Optional, maximum 255 characters

#### PUT /api/customers/:id
Update an existing customer's information.

**Parameters:**
- `id` (number): Customer ID

**Request Body:**
```json
{
  "name": "John Updated",
  "telno": "08123456789",
  "credit": 150.00
}
```

**Validation Rules:**
- All fields are optional for updates
- Same validation rules as POST

#### DELETE /api/customers/:id
Delete a customer account.

**Parameters:**
- `id` (number): Customer ID

### Lotteries

#### GET /api/lotteries
Retrieve all lottery entries.

**Response:**
```json
[
  {
    "lid": 1,
    "lottery_number": "12345678901234567890",
    "period": "January 2024",
    "created": "2024-01-01T00:00:00.000Z",
    "updated": "2024-01-01T00:00:00.000Z"
  }
]
```

#### GET /api/lotteries/:id
Retrieve a specific lottery by its ID.

**Parameters:**
- `id` (number): Lottery ID

#### POST /api/lotteries
Create a new lottery entry.

**Request Body:**
```json
{
  "lottery_number": "12345678901234567890",
  "period": "January 2024"
}
```

**Validation Rules:**
- `lottery_number`: Required, 1-20 characters, unique
- `period`: Required, 1-50 characters

#### PUT /api/lotteries/:id
Update an existing lottery entry.

**Parameters:**
- `id` (number): Lottery ID

**Request Body:**
```json
{
  "lottery_number": "98765432109876543210",
  "period": "February 2024"
}
```

#### DELETE /api/lotteries/:id
Delete a lottery entry.

**Parameters:**
- `id` (number): Lottery ID

### Purchases

#### GET /api/purchases
Retrieve all purchase records.

**Response:**
```json
[
  {
    "pid": 1,
    "cid": 1,
    "lid": 1,
    "created": "2024-01-01T00:00:00.000Z",
    "updated": "2024-01-01T00:00:00.000Z"
  }
]
```

#### GET /api/purchases/:id
Retrieve a specific purchase by its ID.

**Parameters:**
- `id` (number): Purchase ID

#### POST /api/purchases
Create a new purchase record (customer buying a lottery).

**Request Body:**
```json
{
  "cid": 1,
  "lid": 1
}
```

**Validation Rules:**
- `cid`: Required, positive integer (must exist in customers table)
- `lid`: Required, positive integer (must exist in lotteries table)

#### PUT /api/purchases/:id
Update an existing purchase record.

**Parameters:**
- `id` (number): Purchase ID

**Request Body:**
```json
{
  "cid": 2,
  "lid": 3
}
```

#### DELETE /api/purchases/:id
Delete a purchase record.

**Parameters:**
- `id` (number): Purchase ID

### Rewards

#### GET /api/rewards
Retrieve all reward records.

**Response:**
```json
[
  {
    "rid": 1,
    "lid": 1,
    "tier": "First Prize",
    "revenue": 1000000.00,
    "winner": "John Doe",
    "created": "2024-01-01T00:00:00.000Z",
    "updated": "2024-01-01T00:00:00.000Z"
  }
]
```

#### GET /api/rewards/:id
Retrieve a specific reward by its ID.

**Parameters:**
- `id` (number): Reward ID

#### POST /api/rewards
Create a new reward record.

**Request Body:**
```json
{
  "lid": 1,
  "tier": "First Prize",
  "revenue": 1000000.00,
  "winner": "John Doe"
}
```

**Validation Rules:**
- `lid`: Required, positive integer (must exist in lotteries table)
- `tier`: Required, 1-20 characters
- `revenue`: Required, numeric value
- `winner`: Optional, maximum 100 characters

#### PUT /api/rewards/:id
Update an existing reward record.

**Parameters:**
- `id` (number): Reward ID

**Request Body:**
```json
{
  "tier": "Second Prize",
  "revenue": 500000.00,
  "winner": "Jane Smith"
}
```

#### DELETE /api/rewards/:id
Delete a reward record.

**Parameters:**
- `id` (number): Reward ID

## Error Responses

### Validation Errors (400)
```json
{
  "success": false,
  "message": "Validation failed",
  "errors": [
    {
      "field": "name",
      "message": "Name is required and must be less than 100 characters"
    }
  ]
}
```

### Not Found (404)
```json
{
  "success": false,
  "message": "Route not found"
}
```

### Rate Limit Exceeded (429)
```json
{
  "error": "Too many requests from this IP, please try again later."
}
```

### Server Error (500)
```json
{
  "success": false,
  "message": "Internal server error"
}
```

## Database Schema

The API uses MySQL with the following tables:

### customers
- `cid` (INT, AUTO_INCREMENT, PRIMARY KEY)
- `name` (VARCHAR(100), NOT NULL)
- `telno` (VARCHAR(15), NOT NULL)
- `img` (VARCHAR(255), NULL)
- `username` (VARCHAR(50), NOT NULL, UNIQUE)
- `password` (VARCHAR(255), NOT NULL)
- `credit` (DECIMAL(10,2), NOT NULL, DEFAULT 0)
- `created` (DATETIME, NOT NULL, DEFAULT CURRENT_TIMESTAMP)
- `updated` (DATETIME, NOT NULL, DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP)

### lotteries
- `lid` (INT, AUTO_INCREMENT, PRIMARY KEY)
- `lottery_number` (VARCHAR(20), NOT NULL, UNIQUE)
- `period` (VARCHAR(50), NOT NULL)
- `created` (DATETIME, NOT NULL, DEFAULT CURRENT_TIMESTAMP)
- `updated` (DATETIME, NOT NULL, DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP)

### purchases
- `pid` (INT, AUTO_INCREMENT, PRIMARY KEY)
- `cid` (INT, NOT NULL, FOREIGN KEY)
- `lid` (INT, NOT NULL, FOREIGN KEY)
- `created` (DATETIME, NOT NULL, DEFAULT CURRENT_TIMESTAMP)
- `updated` (DATETIME, NOT NULL, DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP)

### rewards
- `rid` (INT, AUTO_INCREMENT, PRIMARY KEY)
- `lid` (INT, NOT NULL, FOREIGN KEY)
- `tier` (VARCHAR(20), NOT NULL)
- `revenue` (DECIMAL(12,2), NOT NULL)
- `winner` (VARCHAR(100), NULL)
- `created` (DATETIME, NOT NULL, DEFAULT CURRENT_TIMESTAMP)
- `updated` (DATETIME, NOT NULL, DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP)

## Setup Instructions

### Prerequisites
- Node.js (v14 or higher)
- MySQL (v8.0 or higher)
- Docker (optional)

### Installation

1. **Clone the repository and navigate to the API directory:**
   ```bash
   cd api
   ```

2. **Install dependencies:**
   ```bash
   npm install
   ```

3. **Set up environment variables:**
   Create a `.env` file in the api directory:
   ```env
   NODE_ENV=development
   PORT=3000
   DB_HOST=localhost
   DB_PORT=3306
   DB_USERNAME=root
   DB_PASSWORD=rootpassword
   DB_DATABASE=locatto
   JWT_SECRET=your-secret-key
   ```

4. **Start the database:**
   ```bash
   docker-compose up mysql -d
   ```

5. **Build and start the API:**
   ```bash
   npm run build
   npm start
   ```

   Or for development:
   ```bash
   npm run dev
   ```

### Using Docker

1. **Start all services:**
   ```bash
   docker-compose up -d
   ```

2. **Access the API:**
   - API: http://localhost:3000
   - phpMyAdmin: http://localhost:8080

## Testing with Postman

1. Import the `Locatto_API_Postman_Collection.json` file into Postman
2. Set the `base_url` variable to `http://localhost:3000`
3. Start testing the endpoints
