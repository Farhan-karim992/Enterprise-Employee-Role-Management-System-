<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>500 - Internal Server Error</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/styles.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body style="display: flex; align-items: center; justify-content: center; min-height: 100vh; background: #0f172a; color: #fff;">
    <div style="text-align: center; max-width: 500px; padding: 30px;">
        <div style="font-size: 72px; font-weight: 800; color: #ef4444; line-height: 1;">500</div>
        <h2 style="font-size: 24px; margin: 16px 0 8px; font-weight: 700;">Internal Server Error</h2>
        <p style="color: #94a3b8; font-size: 14px; margin-bottom: 24px;">An internal error occurred while processing the transaction or database operation.</p>
        <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-primary">
            <i class="fa-solid fa-arrow-left"></i> Return to Safety
        </a>
    </div>
</body>
</html>
