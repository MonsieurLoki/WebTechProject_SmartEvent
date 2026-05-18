<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <title>Notifications - SmartEvent</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"/>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css"/>
    <style>
        * { font-family: "Segoe UI", sans-serif; }
        .navbar { background:#fff; border-bottom:1px solid #eee; padding:16px 0; }
        .navbar-brand { font-weight:700; font-size:1.3rem; color:#1a1a2e !important; }
        .navbar-brand i { color:#4f46e5; }
        .nav-link { color:#555 !important; font-weight:500; }
        .nav-link.active { color:#4f46e5 !important; }
        .notification-card { border:none; border-radius:14px; box-shadow:0 2px 12px rgba(0,0,0,0.08); }
        .notification-unread { border-left:4px solid #4f46e5; }
        .notification-read { opacity:.78; }
        .notification-icon { width:42px; height:42px; border-radius:10px; display:flex; align-items:center; justify-content:center; flex-shrink:0; }
        .icon-ADMIN { background:#fee2e2; color:#991b1b; }
        .icon-SUCCESS { background:#dcfce7; color:#166534; }
        .icon-WARNING { background:#fef3c7; color:#92400e; }
        .icon-INFO { background:#e0f2fe; color:#0369a1; }
    </style>
</head>
<body style="background:#f8f9ff">

<nav class="navbar navbar-expand-lg sticky-top">
    <div class="container">
        <a class="navbar-brand" href="/WebTechProject/events">
            <i class="bi bi-calendar-event-fill me-2"></i>SmartEvent
        </a>
        <div class="collapse navbar-collapse">
            <ul class="navbar-nav ms-auto align-items-center gap-3">
                <li class="nav-item"><a class="nav-link" href="/WebTechProject/events">Discover</a></li>
                <c:if test="${sessionScope.user.role == 'ATTENDEE'}">
                    <li class="nav-item"><a class="nav-link" href="/WebTechProject/my-tickets">My Tickets</a></li>
                    <li class="nav-item"><a class="nav-link" href="/WebTechProject/request-organizer">Become Organizer</a></li>
                </c:if>
                <c:if test="${sessionScope.user.role == 'ORGANIZER' || sessionScope.user.role == 'ADMIN'}">
                    <li class="nav-item"><a class="nav-link" href="/WebTechProject/organizer/dashboard">My Dashboard</a></li>
                    <li class="nav-item"><a class="nav-link" href="/WebTechProject/events/create">Create Event</a></li>
                </c:if>
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
    </div>
</nav>

<div class="container mt-5" style="max-width:860px">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h2 class="fw-bold mb-1"><i class="bi bi-bell me-2"></i>Notifications</h2>
            <p class="text-muted mb-0">Updates about your requests and admin actions.</p>
        </div>
        <c:if test="${unreadNotificationCount > 0}">
            <form method="post" action="/WebTechProject/notifications/read-all">
                <button type="submit" class="btn btn-outline-primary">
                    <i class="bi bi-check2-all me-1"></i>Mark all as read
                </button>
            </form>
        </c:if>
    </div>

    <c:choose>
        <c:when test="${empty notifications}">
            <div class="text-center py-5 text-muted">
                <i class="bi bi-inbox fs-1 d-block mb-3"></i>
                <p>No notifications yet.</p>
            </div>
        </c:when>
        <c:otherwise>
            <div class="d-flex flex-column gap-3">
                <c:forEach var="notification" items="${notifications}">
                    <div class="card notification-card ${notification.read ? 'notification-read' : 'notification-unread'} p-4">
                        <div class="d-flex gap-3 align-items-start">
                            <div class="notification-icon icon-${notification.type}">
                                <c:choose>
                                    <c:when test="${notification.type == 'SUCCESS'}"><i class="bi bi-check-lg"></i></c:when>
                                    <c:when test="${notification.type == 'WARNING'}"><i class="bi bi-exclamation-lg"></i></c:when>
                                    <c:when test="${notification.type == 'ADMIN'}"><i class="bi bi-shield-check"></i></c:when>
                                    <c:otherwise><i class="bi bi-info-lg"></i></c:otherwise>
                                </c:choose>
                            </div>
                            <div class="flex-grow-1">
                                <div class="d-flex justify-content-between gap-3">
                                    <p class="fw-semibold mb-1">${notification.message}</p>
                                    <c:if test="${!notification.read}">
                                        <span class="badge bg-primary align-self-start">New</span>
                                    </c:if>
                                </div>
                                <p class="text-muted small mb-3">${notification.createdAt}</p>
                                <div class="d-flex gap-2">
                                    <c:if test="${not empty notification.linkUrl}">
                                        <a href="/WebTechProject/notifications/${notification.id}/open" class="btn btn-sm btn-primary">
                                            Open
                                        </a>
                                    </c:if>
                                    <c:if test="${!notification.read}">
                                        <form method="post" action="/WebTechProject/notifications/${notification.id}/read">
                                            <button type="submit" class="btn btn-sm btn-outline-secondary">
                                                Mark as read
                                            </button>
                                        </form>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
