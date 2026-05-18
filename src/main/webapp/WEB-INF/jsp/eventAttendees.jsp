<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <title>Attendees — ${event.title}</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"/>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css"/>
    <style>
        * { font-family: "Segoe UI", sans-serif; }
        .navbar { background:#fff; border-bottom:1px solid #eee; padding:16px 0; }
        .navbar-brand { font-weight:700; font-size:1.3rem; color:#1a1a2e !important; }
        .navbar-brand i { color:#4f46e5; }
        .nav-link { color:#555 !important; font-weight:500; }
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
                <li class="nav-item"><a class="nav-link active" href="/WebTechProject/organizer/dashboard">My Dashboard</a></li>
                <li class="nav-item"><a class="nav-link" href="/WebTechProject/events/create">Create Event</a></li>
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

<div class="container mt-5">
    <a href="/WebTechProject/organizer/dashboard" class="btn btn-outline-secondary mb-4">
        <i class="bi bi-arrow-left me-1"></i>Back to dashboard
    </a>

    <div class="d-flex justify-content-between align-items-start mb-4">
        <div>
            <h2 class="fw-bold mb-1"><i class="bi bi-people me-2"></i>Attendees</h2>
            <p class="text-muted mb-0">
                <a href="/WebTechProject/events/${event.id}" class="text-decoration-none">${event.title}</a>
                &nbsp;·&nbsp;${event.formattedDateTime}
            </p>
        </div>
        <span class="badge fs-6 fw-semibold" style="background:#ede9fe; color:#4f46e5">
            ${attendees.size()} registered
        </span>
    </div>

    <c:choose>
        <c:when test="${empty attendees}">
            <div class="text-center py-5 text-muted">
                <i class="bi bi-inbox fs-1 d-block mb-3"></i>
                <p>No one has registered for this event yet.</p>
            </div>
        </c:when>
        <c:otherwise>
            <div class="card shadow-sm">
                <table class="table table-hover mb-0">
                    <thead style="background:#f1f5f9">
                        <tr>
                            <th>Name</th>
                            <th>Email</th>
                            <th>Registered at</th>
                            <th class="text-end">Paid</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="a" items="${attendees}">
                            <tr>
                                <td class="align-middle fw-semibold">${a.fullName}</td>
                                <td class="align-middle text-muted">${a.email}</td>
                                <td class="align-middle text-muted small">${a.registeredAt}</td>
                                <td class="align-middle text-end fw-semibold">
                                    <c:choose>
                                        <c:when test="${a.pricePaid == 0}">
                                            <span class="text-muted">Free</span>
                                        </c:when>
                                        <c:otherwise>${a.pricePaid} €</c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
