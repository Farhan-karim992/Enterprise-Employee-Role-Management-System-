<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- Sidebar Navigation -->
<aside class="sidebar">
    <div class="sidebar-brand">
        <div class="brand-icon">
            <i class="fa-solid fa-layer-group"></i>
        </div>
        <div class="brand-text">
            <h2>KARIM PORTAL</h2>
            <span>Enterprise Suite</span>
        </div>
    </div>

    <nav class="sidebar-nav">
        <div class="nav-section-title">Core Management</div>
        <a href="${pageContext.request.contextPath}/dashboard" class="nav-item ${activeNav eq 'dashboard' ? 'active' : ''}">
            <i class="fa-solid fa-chart-pie"></i>
            <span>Executive Dashboard</span>
        </a>
        <a href="${pageContext.request.contextPath}/employees" class="nav-item ${activeNav eq 'employees' ? 'active' : ''}">
            <i class="fa-solid fa-users"></i>
            <span>Employees Directory</span>
        </a>
        <a href="${pageContext.request.contextPath}/departments" class="nav-item ${activeNav eq 'departments' ? 'active' : ''}">
            <i class="fa-solid fa-sitemap"></i>
            <span>Departments Hierarchy</span>
        </a>

        <div class="nav-section-title">Operations & Approvals</div>
        <a href="${pageContext.request.contextPath}/leaves" class="nav-item ${activeNav eq 'leaves' ? 'active' : ''}">
            <i class="fa-solid fa-calendar-check"></i>
            <span>Leave Requests</span>
        </a>

        <div class="nav-section-title">Quick Actions</div>
        <a href="${pageContext.request.contextPath}/employees/new" class="nav-item">
            <i class="fa-solid fa-user-plus"></i>
            <span>Add New Employee</span>
        </a>
        <a href="${pageContext.request.contextPath}/leaves/apply" class="nav-item">
            <i class="fa-solid fa-paper-plane"></i>
            <span>Apply For Leave</span>
        </a>
    </nav>

    <div class="sidebar-footer">
        <div class="user-badge">
            <div class="user-avatar">KM</div>
            <div class="user-info">
                <div class="user-name">Karim Admin</div>
                <div class="user-role">Super Admin Tier</div>
            </div>
        </div>
    </div>
</aside>

<!-- Main Wrapper -->
<div class="main-wrapper">
    <header class="topbar">
        <div class="page-breadcrumb">
            <span>KARIM Portal</span>
            <i class="fa-solid fa-chevron-right" style="font-size: 11px;"></i>
            <span class="current">
                <c:choose>
                    <c:when test="${activeNav eq 'dashboard'}">Dashboard Overview</c:when>
                    <c:when test="${activeNav eq 'employees'}">Employee Profiles</c:when>
                    <c:when test="${activeNav eq 'departments'}">Department Hierarchy</c:when>
                    <c:when test="${activeNav eq 'leaves'}">Leave Approvals</c:when>
                    <c:otherwise>Management Console</c:otherwise>
                </c:choose>
            </span>
        </div>

        <div class="topbar-actions">
            <div class="live-pill">
                <span class="live-dot"></span>
                <span>Hibernate Session: Active</span>
            </div>
            <a href="${pageContext.request.contextPath}/employees/new" class="btn btn-primary btn-sm">
                <i class="fa-solid fa-plus"></i>
                <span>New Employee</span>
            </a>
        </div>
    </header>

    <main class="content-body">
        <!-- Flash Alert Messages -->
        <c:if test="${not empty successMessage}">
            <div class="alert alert-success">
                <span><i class="fa-solid fa-circle-check" style="margin-right: 8px;"></i> ${successMessage}</span>
                <button type="button" style="background: none; border: none; cursor: pointer;" onclick="this.parentElement.remove();">&times;</button>
            </div>
        </c:if>
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger">
                <span><i class="fa-solid fa-triangle-exclamation" style="margin-right: 8px;"></i> ${errorMessage}</span>
                <button type="button" style="background: none; border: none; cursor: pointer;" onclick="this.parentElement.remove();">&times;</button>
            </div>
        </c:if>
