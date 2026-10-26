<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="common/header.jsp" />
<jsp:include page="common/navbar.jsp" />

<!-- Dashboard Header -->
<div style="margin-bottom: 24px; display: flex; justify-content: space-between; align-items: flex-end;">
    <div>
        <h1 style="font-size: 24px; font-weight: 800; color: #0f172a; letter-spacing: -0.02em;">Executive Overview</h1>
        <p style="color: #64748b; font-size: 14px; margin-top: 4px;">Real-time workforce demographics, departmental allocations, and leave workflows.</p>
    </div>
    <div style="display: flex; gap: 10px;">
        <a href="${pageContext.request.contextPath}/leaves/apply" class="btn btn-secondary btn-sm">
            <i class="fa-solid fa-plane-departure"></i> Apply Leave
        </a>
        <a href="${pageContext.request.contextPath}/employees/new" class="btn btn-primary btn-sm">
            <i class="fa-solid fa-user-plus"></i> Add Employee
        </a>
    </div>
</div>

<!-- KPI Cards Grid -->
<div class="kpi-grid">
    <div class="kpi-card">
        <div class="kpi-info">
            <h4>Total Workforce</h4>
            <div class="kpi-value">${stats.totalEmployees}</div>
        </div>
        <div class="kpi-icon indigo">
            <i class="fa-solid fa-id-card-clip"></i>
        </div>
    </div>

    <div class="kpi-card">
        <div class="kpi-info">
            <h4>Active Personnel</h4>
            <div class="kpi-value">${stats.activeEmployees}</div>
        </div>
        <div class="kpi-icon emerald">
            <i class="fa-solid fa-user-check"></i>
        </div>
    </div>

    <div class="kpi-card">
        <div class="kpi-info">
            <h4>On Leave</h4>
            <div class="kpi-value">${stats.onLeaveEmployees}</div>
        </div>
        <div class="kpi-icon amber">
            <i class="fa-solid fa-business-time"></i>
        </div>
    </div>

    <div class="kpi-card">
        <div class="kpi-info">
            <h4>Departments</h4>
            <div class="kpi-value">${stats.totalDepartments}</div>
        </div>
        <div class="kpi-icon blue">
            <i class="fa-solid fa-network-wired"></i>
        </div>
    </div>
</div>

<!-- Two-Column Layout: Department Distribution & Pending Leaves -->
<div style="display: grid; grid-template-columns: 1fr 1fr; gap: 24px; margin-bottom: 30px;">
    <!-- Department Distribution Panel -->
    <div class="panel" style="margin-bottom: 0;">
        <div class="panel-header">
            <div>
                <h3 class="panel-title"><i class="fa-solid fa-chart-column" style="color: #4f46e5; margin-right: 8px;"></i> Department Allocation</h3>
                <p class="panel-subtitle">Headcount distribution across divisions</p>
            </div>
            <a href="${pageContext.request.contextPath}/departments" class="btn btn-secondary btn-sm">View All</a>
        </div>
        <div class="panel-body">
            <c:choose>
                <c:when test="${not empty stats.departmentDistribution}">
                    <div style="display: flex; flex-direction: column; gap: 16px;">
                        <c:forEach var="entry" items="${stats.departmentDistribution}">
                            <div>
                                <div style="display: flex; justify-content: space-between; font-size: 13px; font-weight: 600; margin-bottom: 6px;">
                                    <span>${entry.key}</span>
                                    <span style="color: #4f46e5;">${entry.value} staff</span>
                                </div>
                                <div style="background: #e2e8f0; height: 8px; border-radius: 4px; overflow: hidden;">
                                    <c:set var="percentage" value="${(entry.value * 100.0) / (stats.totalEmployees > 0 ? stats.totalEmployees : 1)}" />
                                    <div style="background: linear-gradient(90deg, #6366f1, #4f46e5); height: 100%; width: ${percentage}%;"></div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:when>
                <c:otherwise>
                    <p style="color: #94a3b8; font-size: 14px; text-align: center; padding: 20px 0;">No departmental statistics available.</p>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <!-- Pending Leave Requests Panel -->
    <div class="panel" style="margin-bottom: 0;">
        <div class="panel-header">
            <div>
                <h3 class="panel-title"><i class="fa-solid fa-clock-rotate-left" style="color: #f59e0b; margin-right: 8px;"></i> Action Required: Pending Leaves</h3>
                <p class="panel-subtitle">${stats.pendingLeaveRequests} pending approval requests</p>
            </div>
            <a href="${pageContext.request.contextPath}/leaves" class="btn btn-secondary btn-sm">Manage</a>
        </div>
        <div class="panel-body" style="padding: 0;">
            <c:choose>
                <c:when test="${not empty pendingLeaves}">
                    <div class="table-responsive">
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>Employee</th>
                                    <th>Type</th>
                                    <th>Duration</th>
                                    <th style="text-align: right;">Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="leave" items="${pendingLeaves}">
                                    <tr>
                                        <td>
                                            <div style="font-weight: 600; color: #0f172a;">${leave.employee.fullName}</div>
                                            <div style="font-size: 11px; color: #94a3b8;">${leave.employee.jobTitle}</div>
                                        </td>
                                        <td>
                                            <span class="badge badge-pending">${leave.leaveType.label}</span>
                                        </td>
                                        <td style="font-size: 13px;">
                                            ${leave.startDate} to ${leave.endDate}
                                            <div style="font-size: 11px; color: #64748b;">${leave.daysCount} day(s)</div>
                                        </td>
                                        <td>
                                            <div style="display: flex; gap: 6px; justify-content: flex-end;">
                                                <form action="${pageContext.request.contextPath}/leaves/${leave.id}/approve" method="post" style="display: inline;">
                                                    <button type="submit" class="btn btn-success btn-sm" title="Approve Request">
                                                        <i class="fa-solid fa-check"></i>
                                                    </button>
                                                </form>
                                                <form action="${pageContext.request.contextPath}/leaves/${leave.id}/reject" method="post" style="display: inline;">
                                                    <button type="submit" class="btn btn-danger btn-sm" title="Reject Request">
                                                        <i class="fa-solid fa-xmark"></i>
                                                    </button>
                                                </form>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:when>
                <c:otherwise>
                    <div style="padding: 36px 20px; text-align: center; color: #64748b;">
                        <i class="fa-solid fa-circle-check" style="font-size: 32px; color: #10b981; margin-bottom: 8px;"></i>
                        <p style="font-weight: 600;">All caught up!</p>
                        <p style="font-size: 13px; color: #94a3b8;">No pending leave requests awaiting approval.</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<!-- Recent Employee Hires Panel -->
<div class="panel">
    <div class="panel-header">
        <div>
            <h3 class="panel-title"><i class="fa-solid fa-user-clock" style="color: #10b981; margin-right: 8px;"></i> Recent Onboardings</h3>
            <p class="panel-subtitle">Latest employees added into the system</p>
        </div>
        <a href="${pageContext.request.contextPath}/employees" class="btn btn-secondary btn-sm">Full Directory</a>
    </div>
    <div class="panel-body" style="padding: 0;">
        <div class="table-responsive">
            <table class="data-table">
                <thead>
                    <tr>
                        <th>Employee</th>
                        <th>Department</th>
                        <th>Job Title</th>
                        <th>Role & Access Tier</th>
                        <th>Hire Date</th>
                        <th>Status</th>
                        <th style="text-align: right;">Action</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="emp" items="${recentEmployees}">
                        <tr>
                            <td>
                                <div class="employee-cell">
                                    <div class="avatar-circle">${emp.initials}</div>
                                    <div class="emp-details">
                                        <a href="${pageContext.request.contextPath}/employees/view/${emp.id}" class="emp-name">${emp.fullName}</a>
                                        <div class="emp-email">${emp.email}</div>
                                    </div>
                                </div>
                            </td>
                            <td>
                                <span style="font-weight: 600; color: #334155;">
                                    ${emp.department != null ? emp.department.name : 'Unassigned'}
                                </span>
                            </td>
                            <td>${emp.jobTitle}</td>
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
                            <td style="font-size: 13px;">${emp.hireDate}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${emp.status eq 'ACTIVE'}">
                                        <span class="badge badge-active"><i class="fa-solid fa-circle" style="font-size: 7px;"></i> Active</span>
                                    </c:when>
                                    <c:when test="${emp.status eq 'ON_LEAVE'}">
                                        <span class="badge badge-onleave"><i class="fa-solid fa-clock" style="font-size: 8px;"></i> On Leave</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge badge-suspended">${emp.status}</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <div class="actions-cell" style="justify-content: flex-end;">
                                    <a href="${pageContext.request.contextPath}/employees/view/${emp.id}" class="btn btn-secondary btn-sm" title="View Profile">
                                        <i class="fa-solid fa-eye"></i>
                                    </a>
                                    <a href="${pageContext.request.contextPath}/employees/edit/${emp.id}" class="btn btn-secondary btn-sm" title="Edit Profile">
                                        <i class="fa-solid fa-pen-to-square"></i>
                                    </a>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>

<jsp:include page="common/footer.jsp" />
