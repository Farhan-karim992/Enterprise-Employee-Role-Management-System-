<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/navbar.jsp" />

<div style="display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 24px;">
    <div>
        <h1 style="font-size: 24px; font-weight: 800; color: #0f172a; letter-spacing: -0.02em;">Leave & Absence Management</h1>
        <p style="color: #64748b; font-size: 14px; margin-top: 4px;">Review time-off requests, process manager approvals, and manage workforce scheduling.</p>
    </div>
    <a href="${pageContext.request.contextPath}/leaves/apply" class="btn btn-primary">
        <i class="fa-solid fa-paper-plane"></i> Submit Leave Request
    </a>
</div>

<!-- Status Tabs Filter -->
<div class="filter-bar" style="margin-bottom: 20px;">
    <div style="display: flex; gap: 8px; flex-wrap: wrap;">
        <a href="${pageContext.request.contextPath}/leaves" class="btn ${empty selectedStatus ? 'btn-primary' : 'btn-secondary'} btn-sm">
            All Applications
        </a>
        <a href="${pageContext.request.contextPath}/leaves?status=PENDING" class="btn ${selectedStatus eq 'PENDING' ? 'btn-primary' : 'btn-secondary'} btn-sm">
            Pending Review
        </a>
        <a href="${pageContext.request.contextPath}/leaves?status=APPROVED" class="btn ${selectedStatus eq 'APPROVED' ? 'btn-primary' : 'btn-secondary'} btn-sm">
            Approved
        </a>
        <a href="${pageContext.request.contextPath}/leaves?status=REJECTED" class="btn ${selectedStatus eq 'REJECTED' ? 'btn-primary' : 'btn-secondary'} btn-sm">
            Rejected
        </a>
    </div>
</div>

<!-- Leave Requests Panel -->
<div class="panel">
    <div class="panel-header">
        <div>
            <h3 class="panel-title">Applications Record</h3>
            <p class="panel-subtitle">Displaying ${leaveRequests.size()} leave requests</p>
        </div>
    </div>
    <div class="panel-body" style="padding: 0;">
        <c:choose>
            <c:when test="${not empty leaveRequests}">
                <div class="table-responsive">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Applicant</th>
                                <th>Department</th>
                                <th>Leave Category</th>
                                <th>Requested Schedule</th>
                                <th>Total Days</th>
                                <th>Reason</th>
                                <th>Status</th>
                                <th style="text-align: right;">Action / Review</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="req" items="${leaveRequests}">
                                <tr>
                                    <td>
                                        <div class="employee-cell">
                                            <div class="avatar-circle">${req.employee.initials}</div>
                                            <div class="emp-details">
                                                <a href="${pageContext.request.contextPath}/employees/view/${req.employee.id}" class="emp-name">${req.employee.fullName}</a>
                                                <div class="emp-email">${req.employee.email}</div>
                                            </div>
                                        </div>
                                    </td>
                                    <td>${req.employee.department != null ? req.employee.department.name : 'Unassigned'}</td>
                                    <td>
                                        <span style="font-weight: 600; color: #1e293b;">${req.leaveType.label}</span>
                                    </td>
                                    <td style="font-size: 13px;">
                                        <div><strong>${req.startDate}</strong> to <strong>${req.endDate}</strong></div>
                                    </td>
                                    <td style="font-family: 'JetBrains Mono', monospace; font-weight: 600;">
                                        ${req.daysCount} d
                                    </td>
                                    <td style="max-width: 200px; font-size: 13px; color: #475569;">
                                        ${req.reason}
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${req.status eq 'APPROVED'}">
                                                <span class="badge badge-approved"><i class="fa-solid fa-check"></i> Approved</span>
                                            </c:when>
                                            <c:when test="${req.status eq 'PENDING'}">
                                                <span class="badge badge-pending"><i class="fa-solid fa-clock"></i> Pending</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge badge-rejected"><i class="fa-solid fa-xmark"></i> Rejected</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <div class="actions-cell" style="justify-content: flex-end;">
                                            <c:if test="${req.status eq 'PENDING'}">
                                                <form action="${pageContext.request.contextPath}/leaves/${req.id}/approve" method="post" style="display: inline;">
                                                    <button type="submit" class="btn btn-success btn-sm" title="Approve Request">
                                                        <i class="fa-solid fa-check"></i> Approve
                                                    </button>
                                                </form>
                                                <form action="${pageContext.request.contextPath}/leaves/${req.id}/reject" method="post" style="display: inline;">
                                                    <button type="submit" class="btn btn-danger btn-sm" title="Reject Request">
                                                        <i class="fa-solid fa-xmark"></i> Reject
                                                    </button>
                                                </form>
                                            </c:if>
                                            <c:if test="${req.status ne 'PENDING'}">
                                                <span style="font-size: 12px; color: #94a3b8; font-style: italic;">
                                                    ${not empty req.decisionNotes ? req.decisionNotes : 'Processed'}
                                                </span>
                                            </c:if>
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
                    <i class="fa-solid fa-calendar-check" style="font-size: 40px; color: #cbd5e1; margin-bottom: 12px;"></i>
                    <p style="font-size: 16px; font-weight: 600; color: #1e293b;">No leave applications found</p>
                    <p style="font-size: 14px; color: #94a3b8; margin-bottom: 20px;">No leave requests match the selected status filter.</p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<jsp:include page="../common/footer.jsp" />
