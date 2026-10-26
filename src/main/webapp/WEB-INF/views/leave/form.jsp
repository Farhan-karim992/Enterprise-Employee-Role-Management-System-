<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<jsp:include page="../common/header.jsp" />
<jsp:include page="../common/navbar.jsp" />

<div class="form-card">
    <div class="panel-header">
        <div>
            <h2 class="panel-title">Apply For Leave</h2>
            <p class="panel-subtitle">Submit absence dates and category for administrative review</p>
        </div>
        <a href="${pageContext.request.contextPath}/leaves" class="btn btn-secondary btn-sm">
            <i class="fa-solid fa-arrow-left"></i> Back to Requests
        </a>
    </div>

    <form:form modelAttribute="leaveRequest" method="post" action="${pageContext.request.contextPath}/leaves/apply">
        <form:hidden path="id" />

        <div class="panel-body">
            <form:errors path="*" cssClass="alert alert-danger" element="div" />

            <div class="form-grid">
                <!-- Employee Selection -->
                <div class="form-group col-span-2">
                    <label for="employee">Employee Applicant <span style="color: #ef4444;">*</span></label>
                    <form:select path="employee.id" id="employee" cssClass="form-control">
                        <option value="">-- Choose Employee --</option>
                        <c:forEach var="emp" items="${employeesList}">
                            <form:option value="${emp.id}" label="${emp.fullName} - ${emp.jobTitle} (${emp.email})" />
                        </c:forEach>
                    </form:select>
                    <form:errors path="employee.id" cssClass="field-error" />
                </div>

                <!-- Leave Type -->
                <div class="form-group col-span-2">
                    <label for="leaveType">Leave Classification <span style="color: #ef4444;">*</span></label>
                    <form:select path="leaveType" id="leaveType" cssClass="form-control">
                        <c:forEach var="type" items="${leaveTypes}">
                            <form:option value="${type}" label="${type.label}" />
                        </c:forEach>
                    </form:select>
                    <form:errors path="leaveType" cssClass="field-error" />
                </div>

                <!-- Start Date -->
                <div class="form-group">
                    <label for="startDate">Leave Start Date <span style="color: #ef4444;">*</span></label>
                    <form:input path="startDate" id="startDate" type="date" cssClass="form-control" />
                    <form:errors path="startDate" cssClass="field-error" />
                </div>

                <!-- End Date -->
                <div class="form-group">
                    <label for="endDate">Leave End Date <span style="color: #ef4444;">*</span></label>
                    <form:input path="endDate" id="endDate" type="date" cssClass="form-control" />
                    <form:errors path="endDate" cssClass="field-error" />
                </div>

                <!-- Dynamic Duration Display -->
                <div class="form-group col-span-2">
                    <div style="background: #f8fafc; border: 1px dashed var(--border); padding: 12px 16px; border-radius: var(--radius-md); display: flex; align-items: center; justify-content: space-between;">
                        <span style="font-size: 13px; color: #64748b; font-weight: 600;">Calculated Absence Duration:</span>
                        <span id="daysCountDisplay" style="font-weight: 700; color: #4f46e5; font-size: 15px;">-</span>
                    </div>
                </div>

                <!-- Reason for leave -->
                <div class="form-group col-span-2">
                    <label for="reason">Detailed Justification / Reason <span style="color: #ef4444;">*</span></label>
                    <form:textarea path="reason" id="reason" rows="4" cssClass="form-control" placeholder="Provide context regarding the absence requirement..." />
                    <form:errors path="reason" cssClass="field-error" />
                </div>
            </div>
        </div>

        <div class="form-footer">
            <a href="${pageContext.request.contextPath}/leaves" class="btn btn-secondary">Cancel</a>
            <button type="submit" class="btn btn-primary">
                <i class="fa-solid fa-paper-plane"></i> Submit Application
            </button>
        </div>
    </form:form>
</div>

<jsp:include page="../common/footer.jsp" />
