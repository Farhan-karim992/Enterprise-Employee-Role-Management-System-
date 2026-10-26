-- =========================================================================
-- Enterprise Employee & Role Management System - Relational Database Schema
-- Database: MySQL 8.x
-- =========================================================================

DROP DATABASE IF EXISTS enterprise_portal_db;
CREATE DATABASE enterprise_portal_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE enterprise_portal_db;

-- -------------------------------------------------------------------------
-- Table: roles
-- Manages employee access tiers, authorization levels, and permissions
-- -------------------------------------------------------------------------
CREATE TABLE roles (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,
    display_name VARCHAR(100) NOT NULL,
    access_tier VARCHAR(50) NOT NULL DEFAULT 'TIER_3_STAFF',
    description VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- -------------------------------------------------------------------------
-- Table: departments
-- Represents company departments, hierarchy, and budget allocation
-- -------------------------------------------------------------------------
CREATE TABLE departments (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    code VARCHAR(10) NOT NULL UNIQUE,
    name VARCHAR(100) NOT NULL UNIQUE,
    location VARCHAR(100) NOT NULL,
    budget DECIMAL(15, 2) DEFAULT 0.00,
    manager_name VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- -------------------------------------------------------------------------
-- Table: employees
-- Core employee profiles with relational mapping to Department and Role
-- -------------------------------------------------------------------------
CREATE TABLE employees (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(20),
    job_title VARCHAR(100) NOT NULL,
    salary DECIMAL(12, 2) NOT NULL,
    hire_date DATE NOT NULL,
    status VARCHAR(50) NOT NULL DEFAULT 'ACTIVE',
    department_id BIGINT,
    role_id BIGINT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_employee_department 
        FOREIGN KEY (department_id) REFERENCES departments(id) 
        ON DELETE SET NULL 
        ON UPDATE CASCADE,
        
    CONSTRAINT fk_employee_role 
        FOREIGN KEY (role_id) REFERENCES roles(id) 
        ON DELETE RESTRICT 
        ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Create indexes for frequent query lookups
CREATE INDEX idx_emp_email ON employees(email);
CREATE INDEX idx_emp_department ON employees(department_id);
CREATE INDEX idx_emp_role ON employees(role_id);
CREATE INDEX idx_emp_status ON employees(status);

-- -------------------------------------------------------------------------
-- Table: leave_requests
-- Tracks leave applications, approval workflows, and reason logs
-- -------------------------------------------------------------------------
CREATE TABLE leave_requests (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    employee_id BIGINT NOT NULL,
    leave_type VARCHAR(50) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    days_count INT NOT NULL DEFAULT 1,
    reason TEXT NOT NULL,
    status VARCHAR(50) NOT NULL DEFAULT 'PENDING',
    decision_notes TEXT,
    applied_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    reviewed_at TIMESTAMP NULL,
    
    CONSTRAINT fk_leave_employee 
        FOREIGN KEY (employee_id) REFERENCES employees(id) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE INDEX idx_leave_emp ON leave_requests(employee_id);
CREATE INDEX idx_leave_status ON leave_requests(status);

-- =========================================================================
-- SEED DATA FOR DEMONSTRATION & TESTING
-- =========================================================================

-- Insert Access Roles
INSERT INTO roles (name, display_name, access_tier, description) VALUES
('ROLE_SUPER_ADMIN', 'Super Administrator', 'TIER_1_ADMIN', 'Full system access, role assignment, and audit management'),
('ROLE_HR_DIRECTOR', 'HR Director', 'TIER_1_ADMIN', 'Manage hiring, employee onboarding, records, and departmental changes'),
('ROLE_DEPT_MANAGER', 'Department Manager', 'TIER_2_MANAGER', 'Oversees team members, leave requests approval, and performance'),
('ROLE_SENIOR_ENGINEER', 'Senior Engineer', 'TIER_3_STAFF', 'Core product development and system maintenance'),
('ROLE_ASSOCIATE', 'Staff Associate', 'TIER_3_STAFF', 'Standard employee access for self-service leave and directory');

-- Insert Departments
INSERT INTO departments (code, name, location, budget, manager_name) VALUES
('ENG', 'Engineering & Tech', 'Building A - Floor 4', 750000.00, 'Marcus Vance'),
('HR', 'Human Resources & Talent', 'Building B - Floor 2', 250000.00, 'Elena Rodriguez'),
('FIN', 'Finance & Accounting', 'Building A - Floor 2', 380000.00, 'David Sterling'),
('MKT', 'Marketing & Operations', 'Building C - Floor 1', 420000.00, 'Sophia Lin'),
('PROD', 'Product Design & UX', 'Building A - Floor 3', 310000.00, 'Adrian Chen');

-- Insert Employees
INSERT INTO employees (first_name, last_name, email, phone, job_title, salary, hire_date, status, department_id, role_id) VALUES
('Marcus', 'Vance', 'marcus.vance@enterprise.io', '+1 (555) 019-2834', 'VP of Engineering', 165000.00, '2021-03-15', 'ACTIVE', 1, 1),
('Elena', 'Rodriguez', 'elena.rodriguez@enterprise.io', '+1 (555) 019-4821', 'Director of People', 135000.00, '2021-06-01', 'ACTIVE', 2, 2),
('David', 'Sterling', 'david.sterling@enterprise.io', '+1 (555) 019-3392', 'Head of Finance', 142000.00, '2020-11-10', 'ACTIVE', 3, 3),
('Alexander', 'Wright', 'alex.wright@enterprise.io', '+1 (555) 019-7711', 'Principal Architect', 148000.00, '2022-01-20', 'ACTIVE', 1, 4),
('Sophia', 'Lin', 'sophia.lin@enterprise.io', '+1 (555) 019-6623', 'Marketing Lead', 115000.00, '2022-04-18', 'ACTIVE', 4, 3),
('Amara', 'Kalu', 'amara.kalu@enterprise.io', '+1 (555) 019-8902', 'Full Stack Developer', 98000.00, '2023-02-14', 'ACTIVE', 1, 5),
('Liam', 'O''Connor', 'liam.oconnor@enterprise.io', '+1 (555) 019-1122', 'UI/UX Specialist', 92000.00, '2023-05-09', 'ON_LEAVE', 5, 5),
('Chloe', 'Dubois', 'chloe.dubois@enterprise.io', '+1 (555) 019-9430', 'Talent Acquisition Partner', 82000.00, '2023-08-01', 'ACTIVE', 2, 5);

-- Insert Leave Requests
INSERT INTO leave_requests (employee_id, leave_type, start_date, end_date, days_count, reason, status, decision_notes) VALUES
(7, 'ANNUAL', '2026-10-25', '2026-11-02', 8, 'Family vacation and personal rejuvenation', 'APPROVED', 'Approved by Dept Manager'),
(6, 'SICK', '2026-11-05', '2026-11-07', 3, 'Recovering from dental surgery', 'PENDING', NULL),
(4, 'CASUAL', '2026-11-15', '2026-11-16', 2, 'Attending regional technical conference', 'PENDING', NULL),
(8, 'ANNUAL', '2026-09-10', '2026-09-15', 5, 'Travel abroad', 'APPROVED', 'Approved by Elena Rodriguez');
