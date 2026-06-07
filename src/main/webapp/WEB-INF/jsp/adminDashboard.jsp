<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <title>Admin Dashboard — SmartEvent</title>
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
        .section-title { font-size:1.1rem; font-weight:700; color:#1a1a2e; margin-bottom:1rem; }
    </style>
</head>
<body style="background:#f8f9ff">

<nav class="navbar navbar-expand-lg sticky-top">
    <div class="container">
        <a class="navbar-brand" href="/WebTechProject/events">
            <i class="bi bi-calendar-event-fill me-2"></i>SmartEvent
        </a>
        <ul class="navbar-nav ms-auto align-items-center gap-3">
            <li class="nav-item"><a class="nav-link" href="/WebTechProject/events">Discover</a></li>
            <li class="nav-item">
                <a class="nav-link active" href="/WebTechProject/admin/dashboard">
                    Admin
                    <c:if test="${pendingRequestCount > 0}">
                        <span class="badge bg-danger rounded-pill ms-1">${pendingRequestCount}</span>
                    </c:if>
                </a>
            </li>
            <jsp:include page="/WEB-INF/jsp/fragments/notificationDropdown.jsp"/>
            <li class="nav-item"><span class="nav-link text-muted">${sessionScope.user.fullName}</span></li>
            <li class="nav-item"><a class="nav-link" href="/WebTechProject/logout">Logout</a></li>
        </ul>
    </div>
</nav>

<div class="container mt-5">
    <h2 class="fw-bold mb-1"><i class="bi bi-shield-check me-2"></i>Admin Dashboard</h2>
    <p class="text-muted mb-4">Platform overview and management</p>

    <%-- Stats --%>
    <div class="row g-3 mb-5">
        <div class="col-md-3">
            <div class="card stat-card p-4">
                <div class="d-flex align-items-center gap-3">
                    <div class="stat-icon" style="background:#ede9fe; color:#4f46e5">
                        <i class="bi bi-people"></i>
                    </div>
                    <div>
                        <div class="text-muted small">Total Users</div>
                        <div class="fs-3 fw-bold">${totalUsers}</div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card stat-card p-4">
                <div class="d-flex align-items-center gap-3">
                    <div class="stat-icon" style="background:#dcfce7; color:#16a34a">
                        <i class="bi bi-person-badge"></i>
                    </div>
                    <div>
                        <div class="text-muted small">Organizers</div>
                        <div class="fs-3 fw-bold">${totalOrganizers}</div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card stat-card p-4">
                <div class="d-flex align-items-center gap-3">
                    <div class="stat-icon" style="background:#fef9c3; color:#ca8a04">
                        <i class="bi bi-calendar-check"></i>
                    </div>
                    <div>
                        <div class="text-muted small">Total Events</div>
                        <div class="fs-3 fw-bold">${totalEvents}</div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card stat-card p-4">
                <div class="d-flex align-items-center gap-3">
                    <div class="stat-icon" style="background:#fee2e2; color:#dc2626">
                        <i class="bi bi-ticket-perforated"></i>
                    </div>
                    <div>
                        <div class="text-muted small">Registrations</div>
                        <div class="fs-3 fw-bold">${totalRegistrations}</div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <%-- Pending organizer requests --%>
    <div class="mb-5">
        <h5 class="section-title">
            <i class="bi bi-person-plus me-2"></i>Pending Organizer Requests
            <c:if test="${pendingRequestCount > 0}">
                <span class="badge bg-danger ms-2">${pendingRequestCount}</span>
            </c:if>
        </h5>
        <c:choose>
            <c:when test="${empty requests}">
                <div class="text-center py-4 text-muted bg-white rounded-3 shadow-sm">
                    <i class="bi bi-inbox fs-2 d-block mb-2"></i>
                    <p class="mb-0">No pending requests.</p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="card shadow-sm">
                    <table class="table table-hover mb-0">
                        <thead style="background:#f1f5f9">
                            <tr>
                                <th>Name</th>
                                <th>Email</th>
                                <th>Requested at</th>
                                <th class="text-end">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="req" items="${requests}">
                                <tr>
                                    <td class="align-middle fw-semibold">${req.userFullName}</td>
                                    <td class="align-middle text-muted">${req.userEmail}</td>
                                    <td class="align-middle text-muted">${req.requestedAt}</td>
                                    <td class="align-middle text-end">
                                        <form method="post" action="/WebTechProject/admin/approve/${req.userId}" class="d-inline">
                                            <button type="submit" class="btn btn-sm btn-success me-1">
                                                <i class="bi bi-check-lg me-1"></i>Approve
                                            </button>
                                        </form>
                                        <form method="post" action="/WebTechProject/admin/reject/${req.userId}" class="d-inline">
                                            <button type="submit" class="btn btn-sm btn-outline-danger">
                                                <i class="bi bi-x-lg me-1"></i>Reject
                                            </button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <%-- Organizers management --%>
    <div class="mb-5">
        <h5 class="section-title"><i class="bi bi-person-badge me-2"></i>Organizers</h5>
        <c:choose>
            <c:when test="${empty organizers}">
                <div class="text-center py-4 text-muted bg-white rounded-3 shadow-sm">
                    <i class="bi bi-inbox fs-2 d-block mb-2"></i>
                    <p class="mb-0">No organizers yet.</p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="card shadow-sm">
                    <table class="table table-hover mb-0">
                        <thead style="background:#f1f5f9">
                            <tr>
                                <th>Name</th>
                                <th>Email</th>
                                <th>Events</th>
                                <th>Registrations</th>
                                <th class="text-end">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="org" items="${organizers}">
                                <tr>
                                    <td class="align-middle fw-semibold">${org.fullName}</td>
                                    <td class="align-middle text-muted">${org.email}</td>
                                    <td class="align-middle">
                                        <span class="badge" style="background:#ede9fe; color:#4f46e5">${org.eventCount} events</span>
                                    </td>
                                    <td class="align-middle">
                                        <span class="badge" style="background:#dcfce7; color:#166534">${org.registrationCount} attendees</span>
                                    </td>
                                    <td class="align-middle text-end">
                                        <button type="button" class="btn btn-sm btn-outline-warning"
                                                data-bs-toggle="modal" data-bs-target="#revokeModal${org.id}">
                                            <i class="bi bi-person-dash me-1"></i>Revoke
                                        </button>
                                        <%-- Revoke confirmation modal --%>
                                        <div class="modal fade" id="revokeModal${org.id}" tabindex="-1">
                                            <div class="modal-dialog modal-dialog-centered">
                                                <div class="modal-content">
                                                    <div class="modal-header border-0">
                                                        <h5 class="modal-title fw-bold">Revoke organizer privileges?</h5>
                                                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                                    </div>
                                                    <div class="modal-body text-muted">
                                                        <strong>${org.fullName}</strong> will be set back to ATTENDEE.
                                                        They will lose access to their dashboard and won't be able to create events.
                                                    </div>
                                                    <div class="modal-footer border-0">
                                                        <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
                                                        <form method="post" action="/WebTechProject/admin/revoke/${org.id}" class="d-inline">
                                                            <button type="submit" class="btn btn-warning">
                                                                <i class="bi bi-person-dash me-1"></i>Revoke
                                                            </button>
                                                        </form>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <%-- All events --%>
    <div class="mb-5">
        <h5 class="section-title"><i class="bi bi-calendar-week me-2"></i>All Events</h5>
        <c:choose>
            <c:when test="${empty allEvents}">
                <div class="text-center py-4 text-muted bg-white rounded-3 shadow-sm">
                    <i class="bi bi-inbox fs-2 d-block mb-2"></i>
                    <p class="mb-0">No events yet.</p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="card shadow-sm">
                    <table class="table table-hover mb-0">
                        <thead style="background:#f1f5f9">
                            <tr>
                                <th>Event</th>
                                <th>Organizer</th>
                                <th>Date</th>
                                <th>Location</th>
                                <th>Registrations</th>
                                <th class="text-end">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="ev" items="${allEvents}">
                                <tr>
                                    <td class="align-middle">
                                        <a href="/WebTechProject/events/${ev.id}" class="fw-semibold text-decoration-none text-dark">
                                            ${ev.title}
                                        </a>
                                        <c:if test="${ev.virtual}">
                                            <span class="badge ms-1" style="background:#e0f2fe; color:#0369a1; font-size:0.7rem">Virtual</span>
                                        </c:if>
                                    </td>
                                    <td class="align-middle text-muted small">${ev.organizerName}</td>
                                    <td class="align-middle text-muted small">${ev.dateTime}</td>
                                    <td class="align-middle text-muted small">${ev.location}</td>
                                    <td class="align-middle">
                                        <span class="text-muted small">${ev.registrationCount} / ${ev.capacity}</span>
                                    </td>
                                    <td class="align-middle text-end">
                                        <button type="button" class="btn btn-sm btn-outline-danger"
                                                data-bs-toggle="modal" data-bs-target="#deleteEventModal${ev.id}">
                                            <i class="bi bi-trash me-1"></i>Delete
                                        </button>
                                        <%-- Delete confirmation modal --%>
                                        <div class="modal fade" id="deleteEventModal${ev.id}" tabindex="-1">
                                            <div class="modal-dialog modal-dialog-centered">
                                                <div class="modal-content">
                                                    <div class="modal-header border-0">
                                                        <h5 class="modal-title fw-bold">Delete event?</h5>
                                                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                                    </div>
                                                    <div class="modal-body text-muted">
                                                        You are about to permanently delete <strong>${ev.title}</strong>.
                                                        All registrations and feedback will also be deleted.
                                                    </div>
                                                    <div class="modal-footer border-0">
                                                        <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
                                                        <form method="post" action="/WebTechProject/admin/events/${ev.id}/delete" class="d-inline">
                                                            <button type="submit" class="btn btn-danger">
                                                                <i class="bi bi-trash me-1"></i>Delete
                                                            </button>
                                                        </form>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
