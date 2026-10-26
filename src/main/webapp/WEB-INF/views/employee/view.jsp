<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/navbar.jsp" />

<!-- Top Actions & Navigation -->
<div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px;">
    <div>
        <a href="${pageContext.request.contextPath}/employees" class="btn btn-secondary btn-sm">
            <i class="fa-solid fa-arrow-left"></i> Back to Directory
        </a>
    </div>
    <div style="display: flex; gap: 10px;">
        <a href="${pageContext.request.contextPath}/leaves/apply?employeeId=${employee.id}" class="btn btn-secondary btn-sm">
            <i class="fa-solid fa-plane-departure"></i> Apply Leave
        </a>
        <a href="${pageContext.request.contextPath}/employees/edit/${employee.id}" class="btn btn-primary btn-sm">
            <i class="fa-solid fa-pen-to-square"></i> Edit Profile
        </a>
    </div>
</div>

<!-- Employee Header Card -->
<div class="panel" style="margin-bottom: 24px;">
    <div class="panel-body" style="display: flex; align-items: center; justify-content: space-between; flex-wrap: wrap; gap: 20px;">
        <div style="display: flex; align-items: center; gap: 20px;">
            <div style="width: 72px; height: 72px; border-radius: 50%; background: linear-gradient(135deg, #6366f1, #4f46e5); color: #fff; display: flex; align-items: center; justify-content: center; font-size: 26px; font-weight: 800; box-shadow: 0 4px 14px rgba(79, 70, 229, 0.35);">
                ${employee.initials}
            </div>
            <div>
                <h1 style="font-size: 24px; font-weight: 800; color: #0f172a; margin-bottom: 4px;">${employee.fullName}</h1>
                <div style="display: flex; align-items: center; gap: 10px; font-size: 14px; color: #64748b;">
                    <span>${employee.jobTitle}</span>
                    <span>&bull;</span>
                    <span>${employee.email}</span>
                </div>
            </div>
        </div>

        <div style="display: flex; align-items: center; gap: 12px;">
            <c:choose>
                <c:when test="${employee.status eq 'ACTIVE'}">
                    <span class="badge badge-active" style="padding: 6px 14px; font-size: 13px;"><i class="fa-solid fa-circle" style="font-size: 7px;"></i> Active Member</span>
                </c:when>
                <c:when test="${employee.status eq 'ON_LEAVE'}">
                    <span class="badge badge-onleave" style="padding: 6px 14px; font-size: 13px;"><i class="fa-solid fa-clock"></i> Currently On Leave</span>
                </c:when>
                <c:otherwise>
                    <span class="badge badge-suspended" style="padding: 6px 14px; font-size: 13px;">${employee.status}</span>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<!-- Three Column Overview Grid -->
<div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap: 24px; margin-bottom: 30px;">
    <!-- Profile & Contact Card -->
    <div class="panel" style="margin-bottom: 0;">
        <div class="panel-header">
            <h3 class="panel-title"><i class="fa-solid fa-address-card" style="color: #4f46e5; margin-right: 8px;"></i> Profile Overview</h3>
        </div>
        <div class="panel-body" style="display: flex; flex-direction: column; gap: 14px; font-size: 14px;">
            <div>
                <div style="color: #94a3b8; font-size: 12px; font-weight: 600; text-transform: uppercase;">Employee ID</div>
                <div style="font-weight: 600; color: #0f172a; font-family: 'JetBrains Mono', monospace;">EMP-#${employee.id}</div>
            </div>
            <div>
                <div style="color: #94a3b8; font-size: 12px; font-weight: 600; text-transform: uppercase;">Phone Number</div>
                <div style="font-weight: 600; color: #0f172a;">${not empty employee.phone ? employee.phone : 'N/A'}</div>
            </div>
            <div>
                <div style="color: #94a3b8; font-size: 12px; font-weight: 600; text-transform: uppercase;">Hire Date</div>
                <div style="font-weight: 600; color: #0f172a;">${employee.hireDate}</div>
            </div>
            <div>
                <div style="color: #94a3b8; font-size: 12px; font-weight: 600; text-transform: uppercase;">Annual Compensation</div>
                <div style="font-weight: 700; color: #059669; font-size: 16px; font-family: 'JetBrains Mono', monospace;">
                    $<fmt:formatNumber value="${employee.salary}" pattern="#,##0.00" />
                </div>
            </div>
        </div>
    </div>

    <!-- Department Hierarchy Card -->
    <div class="panel" style="margin-bottom: 0;">
        <div class="panel-header">
            <h3 class="panel-title"><i class="fa-solid fa-sitemap" style="color: #0284c7; margin-right: 8px;"></i> Department Hierarchy</h3>
        </div>
        <div class="panel-body" style="display: flex; flex-direction: column; gap: 14px; font-size: 14px;">
            <c:choose>
                <c:when test="${not empty employee.department}">
                    <div>
                        <div style="color: #94a3b8; font-size: 12px; font-weight: 600; text-transform: uppercase;">Division / Department</div>
                        <div style="font-weight: 700; color: #0f172a;">
                            <a href="${pageContext.request.contextPath}/departments/view/${employee.department.id}" style="color: #4f46e5; text-decoration: none;">
                                ${employee.department.name} (${employee.department.code})
                            </a>
                        </div>
                    </div>
                    <div>
                        <div style="color: #94a3b8; font-size: 12px; font-weight: 600; text-transform: uppercase;">Physical Location</div>
                        <div style="font-weight: 600; color: #0f172a;">${employee.department.location}</div>
                    </div>
                    <div>
                        <div style="color: #94a3b8; font-size: 12px; font-weight: 600; text-transform: uppercase;">Department Head / Manager</div>
                        <div style="font-weight: 600; color: #0f172a;">${not empty employee.department.managerName ? employee.department.managerName : 'Unassigned'}</div>
                    </div>
                    <div>
                        <div style="color: #94a3b8; font-size: 12px; font-weight: 600; text-transform: uppercase;">Department Status</div>
                        <div style="font-weight: 600; color: #0f172a;">Active Business Unit</div>
                    </div>
                </c:when>
                <c:otherwise>
                    <p style="color: #94a3b8;">No departmental hierarchy assigned.</p>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <!-- Access Tier & Role Card -->
    <div class="panel" style="margin-bottom: 0;">
        <div class="panel-header">
            <h3 class="panel-title"><i class="fa-solid fa-shield-halved" style="color: #7c3aed; margin-right: 8px;"></i> Access Tier & Role</h3>
        </div>
        <div class="panel-body" style="display: flex; flex-direction: column; gap: 14px; font-size: 14px;">
            <c:choose>
                <c:when test="${not empty employee.role}">
                    <div>
                        <div style="color: #94a3b8; font-size: 12px; font-weight: 600; text-transform: uppercase;">Role Designation</div>
                        <div style="font-weight: 700; color: #0f172a;">${employee.role.displayName}</div>
                    </div>
                    <div>
                        <div style="color: #94a3b8; font-size: 12px; font-weight: 600; text-transform: uppercase;">Security Tier</div>
                        <div style="margin-top: 4px;">
                            <span class="badge badge-tier1">${employee.role.accessTier.name()}</span>
                        </div>
                    </div>
                    <div>
                        <div style="color: #94a3b8; font-size: 12px; font-weight: 600; text-transform: uppercase;">Permissions Scope</div>
                        <div style="font-size: 13px; color: #475569; margin-top: 2px;">${employee.role.description}</div>
                    </div>
                </c:when>
                <c:otherwise>
                    <p style="color: #94a3b8;">No security role assigned.</p>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<!-- Leave Requests History Table -->
<div class="panel">
    <div class="panel-header">
        <div>
            <h3 class="panel-title"><i class="fa-solid fa-calendar-days" style="color: #f59e0b; margin-right: 8px;"></i> Leave & Absence History</h3>
            <p class="panel-subtitle">Historical and upcoming leave records for this employee</p>
        </div>
        <a href="${pageContext.request.contextPath}/leaves/apply?employeeId=${employee.id}" class="btn btn-primary btn-sm">
            <i class="fa-solid fa-plus"></i> Submit Leave Request
        </a>
    </div>
    <div class="panel-body" style="padding: 0;">
        <c:choose>
            <c:when test="${not empty leaves}">
                <div class="table-responsive">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Leave Type</th>
                                <th>Start Date</th>
                                <th>End Date</th>
                                <th>Total Days</th>
                                <th>Reason</th>
                                <th>Status</th>
                                <th>Decision Notes</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="l" items="${leaves}">
                                <tr>
                                    <td><span style="font-weight: 600;">${l.leaveType.label}</span></td>
                                    <td>${l.startDate}</td>
                                    <td>${l.endDate}</td>
                                    <td>${l.daysCount} day(s)</td>
                                    <td style="max-width: 250px;">${l.reason}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${l.status eq 'APPROVED'}">
                                                <span class="badge badge-approved"><i class="fa-solid fa-check"></i> Approved</span>
                                            </c:when>
                                            <c:when test="${l.status eq 'PENDING'}">
                                                <span class="badge badge-pending"><i class="fa-solid fa-clock"></i> Pending</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge badge-rejected"><i class="fa-solid fa-xmark"></i> Rejected</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td style="font-size: 13px; color: #64748b;">${not empty l.decisionNotes ? l.decisionNotes : '-'}</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:when>
            <c:otherwise>
                <div style="padding: 40px 20px; text-align: center; color: #94a3b8;">
                    <i class="fa-solid fa-calendar-xmark" style="font-size: 32px; color: #cbd5e1; margin-bottom: 8px;"></i>
                    <p style="font-weight: 600;">No leave records found</p>
                    <p style="font-size: 13px;">This employee has not submitted any leave requests yet.</p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<jsp:include page="../common/footer.jsp" />
