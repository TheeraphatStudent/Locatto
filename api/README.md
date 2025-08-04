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