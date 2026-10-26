<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/navbar.jsp" />

<div style="display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 24px;">
    <div>
        <h1 style="font-size: 24px; font-weight: 800; color: #0f172a; letter-spacing: -0.02em;">Departmental Hierarchies</h1>
        <p style="color: #64748b; font-size: 14px; margin-top: 4px;">Organizational business units, branch offices, and annual budget allocations.</p>
    </div>
    <a href="${pageContext.request.contextPath}/departments/new" class="btn btn-primary">
        <i class="fa-solid fa-plus"></i> Add Department
    </a>
</div>

<!-- Departments Grid Panel -->
<div class="panel">
    <div class="panel-header">
        <div>
            <h3 class="panel-title">Active Divisions & Branches</h3>
            <p class="panel-subtitle">Total configured departments: ${departments.size()}</p>
        </div>
    </div>
    <div class="panel-body" style="padding: 0;">
        <div class="table-responsive">
            <table class="data-table">
                <thead>
                    <tr>
                        <th>Code</th>
                        <th>Department Name</th>
                        <th>Office Location</th>
                        <th>Department Manager</th>
                        <th>Allocated Budget</th>
                        <th>Staff Count</th>
                        <th style="text-align: right;">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="dept" items="${departments}">
                        <tr>
                            <td>
                                <span class="badge badge-tier2" style="font-family: 'JetBrains Mono', monospace; font-size: 13px;">${dept.code}</span>
                            </td>
                            <td>
                                <a href="${pageContext.request.contextPath}/departments/view/${dept.id}" style="font-weight: 700; color: #0f172a; text-decoration: none;">
                                    ${dept.name}
                                </a>
                            </td>
                            <td>${dept.location}</td>
                            <td>
                                <div style="display: flex; align-items: center; gap: 8px;">
                                    <i class="fa-solid fa-user-tie" style="color: #94a3b8; font-size: 13px;"></i>
                                    <span>${not empty dept.managerName ? dept.managerName : 'Pending Assignment'}</span>
                                </div>
                            </td>
                            <td style="font-family: 'JetBrains Mono', monospace; font-weight: 600; color: #0f172a;">
                                $<fmt:formatNumber value="${dept.budget}" pattern="#,##0.00" />
                            </td>
                            <td>
                                <span class="badge badge-active" style="font-size: 12px;">
                                    <i class="fa-solid fa-users"></i> ${dept.employeeCount} staff
                                </span>
                            </td>
                            <td>
                                <div class="actions-cell" style="justify-content: flex-end;">
                                    <a href="${pageContext.request.contextPath}/departments/view/${dept.id}" class="btn btn-secondary btn-sm" title="View Details">
                                        <i class="fa-solid fa-eye"></i>
                                    </a>
                                    <a href="${pageContext.request.contextPath}/departments/edit/${dept.id}" class="btn btn-secondary btn-sm" title="Edit Department">
                                        <i class="fa-solid fa-pen-to-square"></i>
                                    </a>
                                    <a href="${pageContext.request.contextPath}/departments/delete/${dept.id}" class="btn btn-danger btn-sm" title="Delete Department" onclick="return confirmDelete('department');">
                                        <i class="fa-solid fa-trash-can"></i>
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

<jsp:include page="../common/footer.jsp" />
