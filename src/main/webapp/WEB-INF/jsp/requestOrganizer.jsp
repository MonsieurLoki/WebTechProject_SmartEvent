<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <title>Become an Organizer — SmartEvent</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"/>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css"/>
    <style>* { font-family: "Segoe UI", sans-serif; }</style>
</head>
<body style="background:#f8f9ff">

<nav class="navbar navbar-expand-lg sticky-top" style="background:#fff; border-bottom:1px solid #eee; padding:16px 0;">
    <div class="container">
        <a class="navbar-brand fw-bold" style="color:#1a1a2e" href="/WebTechProject/events">
            <i class="bi bi-calendar-event-fill me-2" style="color:#4f46e5"></i>SmartEvent
        </a>
        <ul class="navbar-nav ms-auto align-items-center gap-3">
            <li class="nav-item"><a class="nav-link" href="/WebTechProject/events">Discover</a></li>
            <li class="nav-item"><a class="nav-link" href="/WebTechProject/my-tickets">My Tickets</a></li>
            <c:if test="${sessionScope.user.role == 'ADMIN'}">
            <li class="nav-item">
                <a class="nav-link" href="/WebTechProject/admin/dashboard">
                    Admin
                    <c:if test="${pendingRequestCount > 0}">
                        <span class="badge bg-danger rounded-pill ms-1">${pendingRequestCount}</span>
                    </c:if>
                </a>
            </li>
            </c:if>
            <jsp:include page="/WEB-INF/jsp/fragments/notificationDropdown.jsp"/>
            <li class="nav-item"><span class="nav-link text-muted">${sessionScope.user.fullName}</span></li>
            <li class="nav-item"><a class="nav-link" href="/WebTechProject/logout">Logout</a></li>
        </ul>
    </div>
</nav>

<div class="container mt-5" style="max-width:600px">
    <div class="card p-5 shadow-sm text-center">
        <i class="bi bi-person-badge fs-1 text-primary mb-3"></i>
        <h2 class="fw-bold mb-2">Become an Organizer</h2>
        <p class="text-muted mb-4">
            As an organizer you'll be able to create and manage your own events.
            An admin will review your request.
        </p>

        <c:choose>
            <c:when test="${param.submitted == 'true'}">
                <div class="alert alert-success">
                    <i class="bi bi-check-circle me-2"></i>Your request has been submitted. We'll notify you when it's reviewed.
                </div>
                <a href="/WebTechProject/events" class="btn btn-outline-primary mt-2">Back to events</a>
            </c:when>
            <c:when test="${alreadyRequested}">
                <div class="alert alert-info">
                    <i class="bi bi-hourglass-split me-2"></i>You already have a pending request. Please wait for an admin to review it.
                </div>
                <a href="/WebTechProject/events" class="btn btn-outline-primary mt-2">Back to events</a>
            </c:when>
            <c:otherwise>
                <form method="post" action="/WebTechProject/request-organizer">
                    <button type="submit" class="btn btn-primary px-5">
                        <i class="bi bi-send me-2"></i>Submit Request
                    </button>
                </form>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
