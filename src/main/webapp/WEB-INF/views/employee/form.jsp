<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/navbar.jsp" />

<div class="form-card">
    <div class="panel-header">
        <div>
            <h2 class="panel-title">${pageTitle}</h2>
            <p class="panel-subtitle">Configure employee profile, organizational tier, and compensation</p>
        </div>
        <a href="${pageContext.request.contextPath}/employees" class="btn btn-secondary btn-sm">
            <i class="fa-solid fa-arrow-left"></i> Back to Directory
        </a>
    </div>

    <!-- Spring Form Tag Library Binding -->
    <form:form modelAttribute="employee" method="post" action="${pageContext.request.contextPath}/employees/save">
        <form:hidden path="id" />

        <div class="panel-body">
            <!-- Global Form Errors if any -->
            <form:errors path="*" cssClass="alert alert-danger" element="div" />

            <div class="form-grid">
                <!-- First Name -->
                <div class="form-group">
                    <label for="firstName">First Name <span style="color: #ef4444;">*</span></label>
                    <form:input path="firstName" id="firstName" cssClass="form-control" placeholder="e.g. Alexander" />
                    <form:errors path="firstName" cssClass="field-error" />
                </div>

                <!-- Last Name -->
                <div class="form-group">
                    <label for="lastName">Last Name <span style="color: #ef4444;">*</span></label>
                    <form:input path="lastName" id="lastName" cssClass="form-control" placeholder="e.g. Wright" />
                    <form:errors path="lastName" cssClass="field-error" />
                </div>

                <!-- Email Address -->
                <div class="form-group">
                    <label for="email">Corporate Email Address <span style="color: #ef4444;">*</span></label>
                    <form:input path="email" id="email" type="email" cssClass="form-control" placeholder="alexander.wright@enterprise.io" />
                    <form:errors path="email" cssClass="field-error" />
                </div>

                <!-- Phone -->
                <div class="form-group">
                    <label for="phone">Contact Phone Number</label>
                    <form:input path="phone" id="phone" cssClass="form-control" placeholder="+1 (555) 019-7711" />
                    <form:errors path="phone" cssClass="field-error" />
                </div>

                <!-- Job Title -->
                <div class="form-group">
                    <label for="jobTitle">Job Title / Designation <span style="color: #ef4444;">*</span></label>
                    <form:input path="jobTitle" id="jobTitle" cssClass="form-control" placeholder="e.g. Principal Architect" />
                    <form:errors path="jobTitle" cssClass="field-error" />
                </div>

                <!-- Annual Salary -->
                <div class="form-group">
                    <label for="salary">Annual Salary (USD) <span style="color: #ef4444;">*</span></label>
                    <form:input path="salary" id="salary" type="number" step="0.01" cssClass="form-control" placeholder="125000.00" />
                    <form:errors path="salary" cssClass="field-error" />
                </div>

                <!-- Hire Date -->
                <div class="form-group">
                    <label for="hireDate">Hire / Onboarding Date <span style="color: #ef4444;">*</span></label>
                    <form:input path="hireDate" id="hireDate" type="date" cssClass="form-control" />
                    <form:errors path="hireDate" cssClass="field-error" />
                </div>

                <!-- Employment Status -->
                <div class="form-group">
                    <label for="status">Employment Status <span style="color: #ef4444;">*</span></label>
                    <form:select path="status" id="status" cssClass="form-control">
                        <c:forEach var="st" items="${statusesList}">
                            <form:option value="${st}" label="${st.displayName}" />
                        </c:forEach>
                    </form:select>
                    <form:errors path="status" cssClass="field-error" />
                </div>

                <!-- Department Selection (@ManyToOne) -->
                <div class="form-group">
                    <label for="department">Assigned Department <span style="color: #ef4444;">*</span></label>
                    <form:select path="department.id" id="department" cssClass="form-control">
                        <option value="">-- Select Department --</option>
                        <c:forEach var="dept" items="${departmentsList}">
                            <form:option value="${dept.id}" label="${dept.name} (${dept.code})" />
                        </c:forEach>
                    </form:select>
                    <form:errors path="department" cssClass="field-error" />
                </div>

                <!-- Role & Access Tier Selection (@ManyToOne) -->
                <div class="form-group">
                    <label for="role">Role & Access Tier <span style="color: #ef4444;">*</span></label>
                    <form:select path="role.id" id="role" cssClass="form-control">
                        <option value="">-- Select Role & Tier --</option>
                        <c:forEach var="r" items="${rolesList}">
                            <form:option value="${r.id}" label="${r.displayName} (${r.accessTier.name()})" />
                        </c:forEach>
                    </form:select>
                    <form:errors path="role" cssClass="field-error" />
                </div>
            </div>
        </div>

        <div class="form-footer">
            <a href="${pageContext.request.contextPath}/employees" class="btn btn-secondary">Cancel</a>
            <button type="submit" class="btn btn-primary">
                <i class="fa-solid fa-floppy-disk"></i> Save Employee Profile
            </button>
        </div>
    </form:form>
</div>

<jsp:include page="../common/footer.jsp" />
