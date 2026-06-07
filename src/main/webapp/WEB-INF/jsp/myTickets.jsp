<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <title>My Tickets — SmartEvent</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"/>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css"/>
    <style>
        * { font-family: "Segoe UI", sans-serif; }
        .navbar { background:#fff; border-bottom:1px solid #eee; padding:16px 0; }
        .navbar-brand { font-weight:700; font-size:1.3rem; color:#1a1a2e !important; }
        .navbar-brand i { color:#4f46e5; }
        .nav-link { color:#555 !important; font-weight:500; }
        .nav-link.active { color:#4f46e5 !important; }
        .ticket-card { border:none; border-radius:14px; box-shadow:0 2px 12px rgba(0,0,0,0.08); }
        .status-badge { font-size:0.78rem; padding:4px 10px; border-radius:20px; font-weight:600; }
        .status-CONFIRMED { background:#dcfce7; color:#166534; }
        .status-PENDING   { background:#fef9c3; color:#854d0e; }
        .status-CANCELLED { background:#fee2e2; color:#991b1b; }
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
                    <li class="nav-item"><a class="nav-link active" href="/WebTechProject/my-tickets">My Tickets</a></li>
                </c:if>
                <c:if test="${sessionScope.user.role == 'ORGANIZER'}">
                    <li class="nav-item"><a class="nav-link" href="/WebTechProject/organizer/dashboard">My Dashboard</a></li>
                </c:if>
                <c:if test="${sessionScope.user.role == 'ORGANIZER' || sessionScope.user.role == 'ADMIN'}">
                    <li class="nav-item"><a class="nav-link" href="/WebTechProject/events/create">Create Event</a></li>
                </c:if>
                <c:if test="${sessionScope.user.role == 'ATTENDEE'}">
                    <li class="nav-item"><a class="nav-link" href="/WebTechProject/request-organizer">Become Organizer</a></li>
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

<div class="container mt-5" style="max-width:800px">
    <h2 class="fw-bold mb-4"><i class="bi bi-ticket-perforated me-2"></i>My Tickets</h2>
    <c:if test="${param.success == 'payment'}">
        <div class="alert alert-success d-flex align-items-center gap-2 mb-4">
            <i class="bi bi-check-circle-fill"></i>
            Payment successful! Your ticket has been confirmed.
        </div>
    </c:if>

    <c:choose>
        <c:when test="${empty registrations}">
            <div class="text-center py-5 text-muted">
                <i class="bi bi-inbox fs-1 d-block mb-3"></i>
                <p>You haven't registered for any events yet.</p>
                <a href="/WebTechProject/events" class="btn btn-primary">Browse Events</a>
            </div>
        </c:when>
        <c:otherwise>
            <div class="d-flex flex-column gap-3">
                <c:forEach var="reg" items="${registrations}">
                    <div class="card ticket-card p-4">
                        <div class="d-flex justify-content-between align-items-start">
                            <div>
                                <h5 class="fw-bold mb-1">
                                    <a href="/WebTechProject/events/${reg.eventId}" class="text-decoration-none text-dark">
                                        ${reg.event.title}
                                    </a>
                                </h5>
                                <p class="text-muted mb-1">
                                    <i class="bi bi-calendar3 me-1"></i>${reg.event.formattedDateTime}
                                </p>
                                <p class="text-muted mb-1">
                                    <i class="bi bi-geo-alt me-1"></i>${reg.event.location}
                                </p>
                                <p class="text-muted mb-0">
                                    <i class="bi bi-tag me-1"></i>
                                    <c:choose>
                                        <c:when test="${reg.pricePaid == 0}">Free</c:when>
                                        <c:otherwise>${reg.pricePaid} €</c:otherwise>
                                    </c:choose>
                                </p>
                            </div>
                            <span class="status-badge status-${reg.status}">${reg.status}</span>
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
