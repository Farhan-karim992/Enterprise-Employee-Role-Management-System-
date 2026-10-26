<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/navbar.jsp" />

<div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px;">
    <div>
        <a href="${pageContext.request.contextPath}/departments" class="btn btn-secondary btn-sm">
            <i class="fa-solid fa-arrow-left"></i> Back to Departments
        </a>
    </div>
    <div style="display: flex; gap: 10px;">
        <a href="${pageContext.request.contextPath}/departments/edit/${department.id}" class="btn btn-primary btn-sm">
            <i class="fa-solid fa-pen-to-square"></i> Edit Department
        </a>
    </div>
</div>

<!-- Department Overview Panel -->
<div class="panel" style="margin-bottom: 24px;">
    <div class="panel-body" style="display: flex; align-items: center; justify-content: space-between; flex-wrap: wrap; gap: 20px;">
        <div style="display: flex; align-items: center; gap: 20px;">
            <div style="width: 64px; height: 64px; border-radius: var(--radius-lg); background: linear-gradient(135deg, #0284c7, #0369a1); color: #fff; display: flex; align-items: center; justify-content: center; font-size: 22px; font-weight: 800;">
                ${department.code}
            </div>
            <div>
                <h1 style="font-size: 24px; font-weight: 800; color: #0f172a; margin-bottom: 4px;">${department.name}</h1>
                <div style="display: flex; align-items: center; gap: 10px; font-size: 14px; color: #64748b;">
                    <span><i class="fa-solid fa-location-dot" style="margin-right: 4px;"></i> ${department.location}</span>
                    <span>&bull;</span>
                    <span><i class="fa-solid fa-user-tie" style="margin-right: 4px;"></i> Lead: ${not empty department.managerName ? department.managerName : 'Unassigned'}</span>
                </div>
            </div>
        </div>

        <div>
            <div style="text-align: right;">
                <div style="font-size: 12px; color: #94a3b8; font-weight: 600; text-transform: uppercase;">Allocated Annual Budget</div>
                <div style="font-size: 22px; font-weight: 800; color: #059669; font-family: 'JetBrains Mono', monospace;">
                    $<fmt:formatNumber value="${department.budget}" pattern="#,##0.00" />
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Assigned Staff Members Table -->
<div class="panel">
    <div class="panel-header">
        <div>
            <h3 class="panel-title"><i class="fa-solid fa-users" style="color: #4f46e5; margin-right: 8px;"></i> Assigned Staff Members</h3>
            <p class="panel-subtitle">${staffMembers.size()} employees attached to this department</p>
        </div>
        <a href="${pageContext.request.contextPath}/employees/new" class="btn btn-secondary btn-sm">
            <i class="fa-solid fa-user-plus"></i> Add Member
        </a>
    </div>
    <div class="panel-body" style="padding: 0;">
        <c:choose>
            <c:when test="${not empty staffMembers}">
                <div class="table-responsive">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Employee</th>
                                <th>Job Title</th>
                                <th>Role</th>
                                <th>Status</th>
                                <th style="text-align: right;">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="emp" items="${staffMembers}">
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
                                    <td>${emp.jobTitle}</td>
                                    <td>${emp.role != null ? emp.role.displayName : 'Staff'}</td>
                                    <td>
                                        <span class="badge ${emp.status eq 'ACTIVE' ? 'badge-active' : 'badge-onleave'}">
                                            ${emp.status.displayName}
                                        </span>
                                    </td>
                                    <td>
                                        <div class="actions-cell" style="justify-content: flex-end;">
                                            <a href="${pageContext.request.contextPath}/employees/view/${emp.id}" class="btn btn-secondary btn-sm">
                                                <i class="fa-solid fa-eye"></i> View Profile
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
                <div style="padding: 40px 20px; text-align: center; color: #94a3b8;">
                    <p style="font-weight: 600;">No employees currently assigned to this department.</p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<jsp:include page="../common/footer.jsp" />
