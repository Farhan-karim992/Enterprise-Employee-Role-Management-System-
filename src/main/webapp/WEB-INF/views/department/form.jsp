<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/navbar.jsp" />

<div class="form-card">
    <div class="panel-header">
        <div>
            <h2 class="panel-title">${pageTitle}</h2>
            <p class="panel-subtitle">Define departmental hierarchy codes, location, and operational budget</p>
        </div>
        <a href="${pageContext.request.contextPath}/departments" class="btn btn-secondary btn-sm">
            <i class="fa-solid fa-arrow-left"></i> Back to Departments
        </a>
    </div>

    <form:form modelAttribute="department" method="post" action="${pageContext.request.contextPath}/departments/save">
        <form:hidden path="id" />

        <div class="panel-body">
            <form:errors path="*" cssClass="alert alert-danger" element="div" />

            <div class="form-grid">
                <!-- Department Code -->
                <div class="form-group">
                    <label for="code">Department Code <span style="color: #ef4444;">*</span></label>
                    <form:input path="code" id="code" cssClass="form-control" placeholder="e.g. ENG, HR, FIN" style="text-transform: uppercase;" />
                    <form:errors path="code" cssClass="field-error" />
                </div>

                <!-- Department Name -->
                <div class="form-group">
                    <label for="name">Department Name <span style="color: #ef4444;">*</span></label>
                    <form:input path="name" id="name" cssClass="form-control" placeholder="e.g. Engineering & Technology" />
                    <form:errors path="name" cssClass="field-error" />
                </div>

                <!-- Office Location -->
                <div class="form-group">
                    <label for="location">Office Location / Floor <span style="color: #ef4444;">*</span></label>
                    <form:input path="location" id="location" cssClass="form-control" placeholder="Building A - Floor 4" />
                    <form:errors path="location" cssClass="field-error" />
                </div>

                <!-- Annual Budget -->
                <div class="form-group">
                    <label for="budget">Allocated Annual Budget (USD)</label>
                    <form:input path="budget" id="budget" type="number" step="0.01" cssClass="form-control" placeholder="500000.00" />
                    <form:errors path="budget" cssClass="field-error" />
                </div>

                <!-- Manager Name -->
                <div class="form-group col-span-2">
                    <label for="managerName">Department Manager / Lead</label>
                    <form:input path="managerName" id="managerName" cssClass="form-control" placeholder="e.g. Marcus Vance" />
                    <form:errors path="managerName" cssClass="field-error" />
                </div>
            </div>
        </div>

        <div class="form-footer">
            <a href="${pageContext.request.contextPath}/departments" class="btn btn-secondary">Cancel</a>
            <button type="submit" class="btn btn-primary">
                <i class="fa-solid fa-floppy-disk"></i> Save Department
            </button>
        </div>
    </form:form>
</div>

<jsp:include page="../common/footer.jsp" />
