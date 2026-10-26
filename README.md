# KARIM Enterprise Employee & Role Management System

A web-based administrative portal engineered with **Java 17**, **Spring MVC 5.3**, **Hibernate ORM 5.6**, **JSP / JSTL**, **MySQL 8.0**, and **Maven**.

---

## 🏛️ System Architecture Overview

```
                                  +-----------------------------------------------+
                                  |                 Client Browser                |
                                  +-----------------------+-----------------------+
                                                          | HTTP (GET / POST)
                                                          v
                                  +-----------------------------------------------+
                                  |          Spring MVC DispatcherServlet         |
                                  |     (CharacterEncoding & HttpMethodFilter)    |
                                  +-----------------------+-----------------------+
                                                          | HandlerMapping
                                                          v
                                  +-----------------------------------------------+
                                  |             @Controller Layer                 |
                                  |  - DashboardController   - EmployeeController |
                                  |  - DepartmentController  - LeaveController    |
                                  +-----------------------+-----------------------+
                                                          |
                                                          v
                                  +-----------------------------------------------+
                                  |             @Service Layer                    |
                                  |  - @Transactional Boundaries                  |
                                  |  - Business Rules & Workflow Orchestration    |
                                  +-----------------------+-----------------------+
                                                          |
                                                          v
                                  +-----------------------------------------------+
                                  |               @Repository / DAO               |
                                  |  - Hibernate SessionFactory (getCurrentSession)|
                                  |  - Parameterized HQL & JOIN FETCH Optimization|
                                  +-----------------------+-----------------------+
                                                          |
                                      +-------------------+-------------------+
                                      |                                       |
                                      v                                       v
                     +---------------------------------+     +---------------------------------+
                     |     Hibernate 5.6 Entities      |     |     HikariCP Connection Pool    |
                     |  @Entity, @OneToMany, @ManyToOne|     |        MySQL 8.0 Database       |
                     +---------------------------------+     +---------------------------------+
```

---

## 💼 Core Features & Implementation Highlights

### 1. Spring MVC Architecture & `@RequestMapping` Endpoints
- **Central Dispatcher**: Handled via `web.xml` and programmatic `WebAppInitializer` (Servlet 3.0+ `AbstractAnnotationConfigDispatcherServletInitializer`).
- **RESTful-style Web MVC Controllers**: Controllers mapped to dedicated entity paths (`/employees`, `/departments`, `/leaves`, `/dashboard`).
- **Data Binding & Bean Validation**: Controller endpoints utilize `@Valid @ModelAttribute("employee") Employee employee` coupled with Spring's `BindingResult` to catch constraint violations and enforce business rules (e.g., corporate email uniqueness, non-past hire dates, positive compensation limits).

### 2. Hibernate Relational ORM Mapping
- **Department-to-Employee Association**: 
  - `Department` entity maps `@OneToMany(mappedBy = "department", cascade = {CascadeType.PERSIST, CascadeType.MERGE}, fetch = FetchType.LAZY)`.
  - `Employee` entity maps `@ManyToOne(fetch = FetchType.EAGER) @JoinColumn(name = "department_id")`.
  - Includes bidirectional synchronization helper methods (`addEmployee()`, `removeEmployee()`) ensuring object state integrity in-memory and in the database.
- **Role & Access Tiers**: Mapped with `@ManyToOne` referencing the `Role` entity, defining administrative privilege tiers (`TIER_1_ADMIN`, `TIER_2_MANAGER`, `TIER_3_STAFF`).
- **Leave Request Management**: `Employee` maps `@OneToMany(mappedBy = "employee", cascade = CascadeType.ALL, orphanRemoval = true)` to `LeaveRequest` entities.

### 3. Dynamic JSP Presentation & Spring Form Tag Libraries
- **Spring Form Tags**: Utilizes `<form:form>`, `<form:input>`, `<form:select>`, `<form:options>`, and `<form:errors cssClass="field-error" />` to automate form population, two-way model binding, and localized validation feedback.
- **JSTL Tags (`<c:forEach>`, `<c:if>`, `<c:choose>`)**: Renders workforce tables, status pills, KPI cards, and conditional action buttons based on employee statuses (`ACTIVE`, `ON_LEAVE`, `SUSPENDED`) and leave states (`PENDING`, `APPROVED`, `REJECTED`).
- **Number & Currency Formatting**: Formats compensation amounts using `<fmt:formatNumber pattern="#,##0.00" />`.

### 4. Optimized MySQL Queries & Hibernate Session Boundaries
- **Elimination of N+1 Queries**: DAO implementations leverage `JOIN FETCH` clauses (e.g., `SELECT DISTINCT e FROM Employee e LEFT JOIN FETCH e.department d LEFT JOIN FETCH e.role r`) to retrieve parent entities and associated child tables in a single query.
- **Session Management**: Direct access to Hibernate's contextual session via `sessionFactory.getCurrentSession()`, bound to thread-local contexts.
- **Declarative Transactions**: Service methods configured with `@Transactional(readOnly = true)` for query optimization and `@Transactional` for atomic mutations, automatic rollbacks on unhandled runtime exceptions, and consistent commit boundaries.

---

## 🗄️ Relational Database Schema (`schema.sql`)

The application database schema consists of 4 relational tables:
1. `departments`: id, code, name, location, budget, manager_name, created_at, updated_at
2. `roles`: id, name, display_name, access_tier, description, created_at
3. `employees`: id, first_name, last_name, email, phone, job_title, salary, hire_date, status, department_id, role_id, created_at, updated_at
4. `leave_requests`: id, employee_id, leave_type, start_date, end_date, days_count, reason, status, decision_notes, applied_at, reviewed_at

---

## 🚀 Setup & Execution Guide

### Prerequisites
- **JDK 17** or later
- **Apache Maven 3.8+**
- **MySQL 8.0+**
- **Apache Tomcat 9.0+** (or embedded plugin)

### 1. Database Setup
```bash
mysql -u root -p < schema.sql
```
Verify the connection details in `src/main/resources/database.properties`:
```properties
jdbc.url=jdbc:mysql://localhost:3306/enterprise_portal_db?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true
jdbc.username=root
jdbc.password=root
```

### 2. Maven Build
Package the web application into an executable `.war` artifact:
```bash
mvn clean package
```
This generates `target/enterprise-employee-system.war`.

### 3. Deployment
Deploy the generated `.war` file to your Tomcat container:
- Copy `target/enterprise-employee-system.war` into Tomcat's `webapps/` folder.
- Start Tomcat:
  - Windows: `bin/startup.bat`
  - Linux/Mac: `bin/startup.sh`
- Access the administrative portal at: `http://localhost:8080/enterprise-employee-system/`
