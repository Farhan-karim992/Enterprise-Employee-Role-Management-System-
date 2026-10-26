<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/navbar.jsp" />

<!-- Page Title & Actions -->
<div style="display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 24px;">
    <div>
        <h1 style="font-size: 24px; font-weight: 800; color: #0f172a; letter-spacing: -0.02em;">Employee Directory</h1>
        <p style="color: #64748b; font-size: 14px; margin-top: 4px;">Search, filter, and manage enterprise workforce records and roles.</p>
    </div>
    <a href="${pageContext.request.contextPath}/employees/new" class="btn btn-primary">
        <i class="fa-solid fa-user-plus"></i> Add New Employee
    </a>
</div>

<!-- Search & Filter Controls -->
<form method="get" action="${pageContext.request.contextPath}/employees" class="filter-bar">
    <div class="search-input-group">
        <i class="fa-solid fa-magnifying-glass search-icon"></i>
        <input type="text" name="keyword" value="${keyword}" placeholder="Search by name, email, or job title...">
    </div>

    <!-- Department Filter Dropdown -->
    <select name="departmentId" class="select-filter">
        <option value="">All Departments</option>
        <c:forEach var="dept" items="${departmentsList}">
            <option value="${dept.id}" ${selectedDeptId eq dept.id ? 'selected' : ''}>
                ${dept.name} (${dept.code})
            </option>
        </c:forEach>
    </select>

    <!-- Status Filter Dropdown -->
    <select name="status" class="select-filter">
        <option value="">All Statuses</option>
        <c:forEach var="st" items="${statusesList}">
            <option value="${st}" ${selectedStatus eq st ? 'selected' : ''}>${st.displayName}</option>
        </c:forEach>
    </select>

    <button type="submit" class="btn btn-secondary">
        <i class="fa-solid fa-filter"></i> Apply Filter
    </button>
    <a href="${pageContext.request.contextPath}/employees" class="btn btn-secondary" title="Reset Filters">
        <i class="fa-solid fa-rotate-left"></i> Reset
    </a>
</form>

<!-- Employee Data Table Panel -->
<div class="panel">
    <div class="panel-header">
        <div>
            <h3 class="panel-title">Active Directory Records</h3>
            <p class="panel-subtitle">Displaying ${employees.size()} matching records</p>
        </div>
    </div>
    <div class="panel-body" style="padding: 0;">
        <c:choose>
            <c:when test="${not empty employees}">
                <div class="table-responsive">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Employee Profile</th>
                                <th>Department</th>
                                <th>Role & Tier</th>
                                <th>Annual Salary</th>
                                <th>Hire Date</th>
                                <th>Status</th>
                                <th style="text-align: right;">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="emp" items="${employees}">
                                <tr>
                                    <td>
                                        <div class="employee-cell">
                                            <div class="avatar-circle">${emp.initials}</div>
                                            <div class="emp-details">
                                                <a href="${pageContext.request.contextPath}/employees/view/${emp.id}" class="emp-name">${emp.fullName}</a>
                                                <div class="emp-email">${emp.email}</div>
                                                <div style="font-size: 11px; color: #64748b; margin-top: 2px;">${emp.jobTitle}</div>
                                            </div>
                                        </div>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty emp.department}">
                                                <a href="${pageContext.request.contextPath}/departments/view/${emp.department.id}" style="color: #4f46e5; font-weight: 600; text-decoration: none;">
                                                    ${emp.department.name}
                                                </a>
                                                <div style="font-size: 11px; color: #94a3b8;">${emp.department.location}</div>
                                            </c:when>
                                            <c:otherwise>
                                                <span style="color: #94a3b8; font-style: italic;">Unassigned</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${emp.role != null && emp.role.accessTier eq 'TIER_1_ADMIN'}">
                                                <span class="badge badge-tier1"><i class="fa-solid fa-shield"></i> ${emp.role.displayName}</span>
                                            </c:when>
                                            <c:when test="${emp.role != null && emp.role.accessTier eq 'TIER_2_MANAGER'}">
                                                <span class="badge badge-tier2"><i class="fa-solid fa-user-tie"></i> ${emp.role.displayName}</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge badge-tier3">${emp.role != null ? emp.role.displayName : 'Staff'}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td style="font-family: 'JetBrains Mono', monospace; font-size: 13px; font-weight: 600; color: #1e293b;">
                                        $<fmt:formatNumber value="${emp.salary}" pattern="#,##0.00" />
                                    </td>
                                    <td style="font-size: 13px; color: #475569;">
                                        ${emp.hireDate}
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${emp.status eq 'ACTIVE'}">
                                                <span class="badge badge-active"><i class="fa-solid fa-circle" style="font-size: 7px;"></i> Active</span>
                                            </c:when>
                                            <c:when test="${emp.status eq 'ON_LEAVE'}">
                                                <span class="badge badge-onleave"><i class="fa-solid fa-clock" style="font-size: 8px;"></i> On Leave</span>
                                            </c:when>
                                            <c:when test="${emp.status eq 'SUSPENDED'}">
                                                <span class="badge badge-suspended"><i class="fa-solid fa-ban" style="font-size: 8px;"></i> Suspended</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge badge-terminated">${emp.status}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <div class="actions-cell" style="justify-content: flex-end;">
                                            <a href="${pageContext.request.contextPath}/employees/view/${emp.id}" class="btn btn-secondary btn-sm" title="View Profile">
                                                <i class="fa-solid fa-eye"></i>
                                            </a>
                                            <a href="${pageContext.request.contextPath}/employees/edit/${emp.id}" class="btn btn-secondary btn-sm" title="Edit Employee">
                                                <i class="fa-solid fa-pen-to-square"></i>
                                            </a>
                                            <a href="${pageContext.request.contextPath}/employees/delete/${emp.id}" class="btn btn-danger btn-sm" title="Delete Employee" onclick="return confirmDelete('employee record');">
                                                <i class="fa-solid fa-trash-can"></i>
                                            </a>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:when>
            <c:otherwise>
                <div style="padding: 60px 20px; text-align: center; color: #64748b;">
                    <i class="fa-solid fa-users-slash" style="font-size: 40px; color: #cbd5e1; margin-bottom: 12px;"></i>
                    <p style="font-size: 16px; font-weight: 600; color: #1e293b;">No employees found</p>
                    <p style="font-size: 14px; color: #94a3b8; margin-bottom: 20px;">Try adjusting your keyword filter or adding a new employee to the database.</p>
                    <a href="${pageContext.request.contextPath}/employees/new" class="btn btn-primary btn-sm">Add New Employee</a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<jsp:include page="../common/footer.jsp" />
