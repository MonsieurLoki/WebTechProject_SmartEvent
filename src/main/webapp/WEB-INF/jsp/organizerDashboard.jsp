<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <title>My Dashboard — SmartEvent</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"/>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css"/>
    <style>
        * { font-family: "Segoe UI", sans-serif; }
        .navbar { background:#fff; border-bottom:1px solid #eee; padding:16px 0; }
        .navbar-brand { font-weight:700; font-size:1.3rem; color:#1a1a2e !important; }
        .navbar-brand i { color:#4f46e5; }
        .nav-link { color:#555 !important; font-weight:500; }
        .nav-link.active { color:#4f46e5 !important; }
        .stat-card { border:none; border-radius:14px; box-shadow:0 2px 12px rgba(0,0,0,0.07); }
        .stat-icon { width:48px; height:48px; border-radius:12px; display:flex; align-items:center; justify-content:center; font-size:1.4rem; }
        .progress { height:8px; border-radius:4px; }
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
                <li class="nav-item"><span class="nav-link text-muted">${sessionScope.user.fullName}</span></li>
                <li class="nav-item"><a class="nav-link" href="/WebTechProject/logout">Logout</a></li>
            </ul>
        </div>
    </div>
</nav>

<div class="container mt-5">
    <h2 class="fw-bold mb-1"><i class="bi bi-bar-chart-line me-2"></i>My Dashboard</h2>
    <p class="text-muted mb-4">Overview of your events performance</p>

    <%-- Summary cards --%>
    <div class="row g-3 mb-5">
        <div class="col-md-4">
            <div class="card stat-card p-4">
                <div class="d-flex align-items-center gap-3">
                    <div class="stat-icon" style="background:#ede9fe; color:#4f46e5">
                        <i class="bi bi-calendar-check"></i>
                    </div>
                    <div>
                        <div class="text-muted small">Total Events</div>
                        <div class="fs-3 fw-bold">${stats.size()}</div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card stat-card p-4">
                <div class="d-flex align-items-center gap-3">
                    <div class="stat-icon" style="background:#dcfce7; color:#16a34a">
                        <i class="bi bi-people"></i>
                    </div>
                    <div>
                        <div class="text-muted small">Total Registrations</div>
                        <div class="fs-3 fw-bold">${totalRegistrations}</div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card stat-card p-4">
                <div class="d-flex align-items-center gap-3">
                    <div class="stat-icon" style="background:#fef9c3; color:#ca8a04">
                        <i class="bi bi-cash-stack"></i>
                    </div>
                    <div>
                        <div class="text-muted small">Total Revenue</div>
                        <div class="fs-3 fw-bold">${totalRevenue} €</div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <%-- Events table --%>
    <h5 class="fw-semibold mb-3">Your Events</h5>
    <c:choose>
        <c:when test="${empty stats}">
            <div class="text-center py-5 text-muted">
                <i class="bi bi-inbox fs-1 d-block mb-3"></i>
                <p>You haven't created any events yet.</p>
                <a href="/WebTechProject/events/create" class="btn btn-primary">Create your first event</a>
            </div>
        </c:when>
        <c:otherwise>
            <div class="card shadow-sm">
                <table class="table table-hover mb-0">
                    <thead style="background:#f1f5f9">
                        <tr>
                            <th>Event</th>
                            <th>Date</th>
                            <th>Location</th>
                            <th>Registrations</th>
                            <th>Revenue</th>
                            <th>Rating</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="s" items="${stats}">
                            <tr>
                                <td class="align-middle">
                                    <a href="/WebTechProject/events/${s.id}" class="fw-semibold text-decoration-none text-dark">
                                        ${s.title}
                                    </a>
                                    <c:if test="${s.virtual}">
                                        <span class="badge ms-1" style="background:#ede9fe; color:#4f46e5; font-size:0.7rem">Virtual</span>
                                    </c:if>
                                </td>
                                <td class="align-middle text-muted small">${s.dateTime}</td>
                                <td class="align-middle text-muted small">${s.location}</td>
                                <td class="align-middle" style="min-width:160px">
                                    <div class="d-flex align-items-center gap-2">
                                        <div class="flex-grow-1">
                                            <div class="progress">
                                                <div class="progress-bar" style="width:${s.fillPercent}%; background:#4f46e5"></div>
                                            </div>
                                        </div>
                                        <span class="text-muted small" style="white-space:nowrap">
                                            ${s.registrations} / ${s.capacity}
                                        </span>
                                    </div>
                                </td>
                                <td class="align-middle fw-semibold">
                                    <c:choose>
                                        <c:when test="${s.revenue == 0}">
                                            <span class="text-muted">Free</span>
                                        </c:when>
                                        <c:otherwise>${s.revenue} €</c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="align-middle">
                                    <c:choose>
                                        <c:when test="${s.ratingCount > 0}">
                                            <span class="text-warning">
                                                <c:forEach begin="1" end="5" var="i">
                                                    <c:choose>
                                                        <c:when test="${i <= s.avgRating}"><i class="bi bi-star-fill"></i></c:when>
                                                        <c:when test="${i - 0.5 <= s.avgRating}"><i class="bi bi-star-half"></i></c:when>
                                                        <c:otherwise><i class="bi bi-star"></i></c:otherwise>
                                                    </c:choose>
                                                </c:forEach>
                                            </span>
                                            <span class="text-muted small ms-1"><fmt:formatNumber value="${s.avgRating}" maxFractionDigits="1"/> (${s.ratingCount})</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-muted small">No ratings</span>
                                        </c:otherwise>
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
