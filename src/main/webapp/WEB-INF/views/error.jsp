<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="common/header.jsp" />
<jsp:include page="common/navbar.jsp" />

<div class="panel" style="max-width: 700px; margin: 40px auto; text-align: center; padding: 40px 30px;">
    <div style="width: 70px; height: 70px; border-radius: 50%; background: #fee2e2; color: #ef4444; display: flex; align-items: center; justify-content: center; font-size: 30px; margin: 0 auto 20px;">
        <i class="fa-solid fa-triangle-exclamation"></i>
    </div>
    <h2 style="font-size: 24px; font-weight: 800; color: #0f172a; margin-bottom: 8px;">${errorCode != null ? errorCode : 'System Error Encountered'}</h2>
    <p style="color: #64748b; font-size: 15px; margin-bottom: 20px;">${errorMessage != null ? errorMessage : 'The requested resource could not be found or processed.'}</p>

    <c:if test="${not empty requestedUri}">
        <div style="background: #f8fafc; border: 1px solid #e2e8f0; border-radius: 8px; padding: 10px; font-family: 'JetBrains Mono', monospace; font-size: 13px; color: #475569; margin-bottom: 20px;">
            Target URI: ${requestedUri}
        </div>
    </c:if>

    <c:if test="${not empty technicalDetails}">
        <div style="background: #fff1f2; border: 1px solid #fecdd3; border-radius: 8px; padding: 12px; font-family: 'JetBrains Mono', monospace; font-size: 12px; color: #9f1239; margin-bottom: 24px; text-align: left; overflow-x: auto;">
            ${technicalDetails}
        </div>
    </c:if>

    <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-primary">
        <i class="fa-solid fa-house"></i> Return to Executive Dashboard
    </a>
</div>

<jsp:include page="common/footer.jsp" />
