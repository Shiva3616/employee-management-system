
# EMS - System Architecture

## 1. Architecture Style

Modular Monolith.

The application will initially run as one backend application with separate business modules.

## 2. Technology Stack

| Layer | Technology |
|---|---|
| Frontend | React |
| Backend | Java 21, Spring Boot |
| API | REST |
| Security | Spring Security |
| ORM | Spring Data JPA / Hibernate |
| Database | MySQL |
| Build | Maven |
| Testing | JUnit 5, Mockito |
| Documentation | Swagger / OpenAPI |
| Deployment | Docker, AWS |

## 3. Request Flow

React Frontend
    |
    v
REST Controller
    |
    v
Service Layer
    |
    v
Repository Layer
    |
    v
Hibernate / JPA
    |
    v
MySQL Database

## 4. Backend Modules

- Authentication
- Employee
- Department
- Attendance
- Leave Management
- Dashboard
- Audit Logging

## 5. User Roles

- ADMIN
- HR
- MANAGER
- EMPLOYEE

## 6. Engineering Principles

- Separation of concerns
- DTO-based API communication
- Input validation
- Global exception handling
- Database constraints
- Role-based authorization
- Unit and integration testing
- Secure configuration management

