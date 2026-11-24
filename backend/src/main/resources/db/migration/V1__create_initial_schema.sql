
-- ============================================
-- EMS V1: Initial Database Schema
-- Database: employee_management_db
-- ============================================

-- 1. DEPARTMENTS
CREATE TABLE departments (
                             id BIGINT AUTO_INCREMENT PRIMARY KEY,
                             name VARCHAR(100) NOT NULL,
                             description VARCHAR(500),
                             created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                             updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
                                 ON UPDATE CURRENT_TIMESTAMP,

                             CONSTRAINT uk_departments_name UNIQUE (name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- 2. EMPLOYEES
CREATE TABLE employees (
                           id BIGINT AUTO_INCREMENT PRIMARY KEY,
                           employee_code VARCHAR(30) NOT NULL,
                           first_name VARCHAR(100) NOT NULL,
                           last_name VARCHAR(100) NOT NULL,
                           email VARCHAR(255) NOT NULL,
                           phone VARCHAR(20),
                           designation VARCHAR(100) NOT NULL,
                           department_id BIGINT NOT NULL,
                           manager_id BIGINT,
                           joining_date DATE NOT NULL,
                           salary DECIMAL(12,2),
                           status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
                           created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                           updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
                               ON UPDATE CURRENT_TIMESTAMP,

                           CONSTRAINT uk_employees_code UNIQUE (employee_code),
                           CONSTRAINT uk_employees_email UNIQUE (email),

                           CONSTRAINT chk_employee_status
                               CHECK (status IN ('ACTIVE', 'INACTIVE', 'ON_NOTICE')),

                           CONSTRAINT fk_employee_department
                               FOREIGN KEY (department_id) REFERENCES departments(id),

                           CONSTRAINT fk_employee_manager
                               FOREIGN KEY (manager_id) REFERENCES employees(id),

                           INDEX idx_employees_department (department_id),
                           INDEX idx_employees_manager (manager_id),
                           INDEX idx_employees_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- 3. USERS
CREATE TABLE users (
                       id BIGINT AUTO_INCREMENT PRIMARY KEY,
                       employee_id BIGINT NOT NULL,
                       password_hash VARCHAR(255) NOT NULL,
                       enabled BOOLEAN NOT NULL DEFAULT TRUE,
                       created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

                       CONSTRAINT uk_users_employee UNIQUE (employee_id),

                       CONSTRAINT fk_users_employee
                           FOREIGN KEY (employee_id) REFERENCES employees(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- 4. ROLES
CREATE TABLE roles (
                       id BIGINT AUTO_INCREMENT PRIMARY KEY,
                       name VARCHAR(30) NOT NULL,

                       CONSTRAINT uk_roles_name UNIQUE (name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- 5. USER ROLES
CREATE TABLE user_roles (
                            user_id BIGINT NOT NULL,
                            role_id BIGINT NOT NULL,

                            PRIMARY KEY (user_id, role_id),

                            CONSTRAINT fk_user_roles_user
                                FOREIGN KEY (user_id) REFERENCES users(id),

                            CONSTRAINT fk_user_roles_role
                                FOREIGN KEY (role_id) REFERENCES roles(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- 6. ATTENDANCE
CREATE TABLE attendance (
                            id BIGINT AUTO_INCREMENT PRIMARY KEY,
                            employee_id BIGINT NOT NULL,
                            attendance_date DATE NOT NULL,
                            check_in TIME,
                            check_out TIME,
                            created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

                            CONSTRAINT uk_attendance_employee_date
                                UNIQUE (employee_id, attendance_date),

                            CONSTRAINT fk_attendance_employee
                                FOREIGN KEY (employee_id) REFERENCES employees(id),

                            INDEX idx_attendance_date (attendance_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- 7. LEAVE REQUESTS
CREATE TABLE leave_requests (
                                id BIGINT AUTO_INCREMENT PRIMARY KEY,
                                employee_id BIGINT NOT NULL,
                                leave_type VARCHAR(30) NOT NULL,
                                start_date DATE NOT NULL,
                                end_date DATE NOT NULL,
                                reason VARCHAR(1000) NOT NULL,
                                status VARCHAR(20) NOT NULL DEFAULT 'PENDING',
                                reviewed_by_employee_id BIGINT,
                                review_comment VARCHAR(1000),
                                created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
                                    ON UPDATE CURRENT_TIMESTAMP,

                                CONSTRAINT chk_leave_dates
                                    CHECK (end_date >= start_date),

                                CONSTRAINT chk_leave_status
                                    CHECK (status IN ('PENDING', 'APPROVED', 'REJECTED', 'CANCELLED')),

                                CONSTRAINT fk_leave_employee
                                    FOREIGN KEY (employee_id) REFERENCES employees(id),

                                CONSTRAINT fk_leave_reviewer
                                    FOREIGN KEY (reviewed_by_employee_id) REFERENCES employees(id),

                                INDEX idx_leave_employee (employee_id),
                                INDEX idx_leave_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- 8. AUDIT LOGS
CREATE TABLE audit_logs (
                            id BIGINT AUTO_INCREMENT PRIMARY KEY,
                            actor_employee_id BIGINT,
                            action VARCHAR(100) NOT NULL,
                            entity_type VARCHAR(100) NOT NULL,
                            entity_id BIGINT,
                            details JSON,
                            created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

                            CONSTRAINT fk_audit_actor
                                FOREIGN KEY (actor_employee_id) REFERENCES employees(id),

                            INDEX idx_audit_actor (actor_employee_id),
                            INDEX idx_audit_entity (entity_type, entity_id),
                            INDEX idx_audit_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- 9. INITIAL ROLE DATA
INSERT INTO roles (name) VALUES
                             ('ADMIN'),
                             ('HR'),
                             ('MANAGER'),
                             ('EMPLOYEE');
