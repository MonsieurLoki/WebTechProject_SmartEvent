<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <title>Edit Event — SmartEvent</title>
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

<div class="container mt-5" style="max-width:640px">
    <a href="/WebTechProject/events/${event.id}" class="btn btn-outline-secondary mb-4">
        <i class="bi bi-arrow-left me-1"></i>Back to event
    </a>

    <div class="card shadow-sm p-4">
        <h2 class="fw-bold mb-1"><i class="bi bi-pencil-square me-2"></i>Edit Event</h2>
        <p class="text-muted mb-4">Modifying: <strong>${event.title}</strong></p>

        <form method="post" action="/WebTechProject/events/${event.id}/edit">
            <div class="mb-3">
                <label class="form-label fw-semibold">Title</label>
                <input type="text" name="title" class="form-control" required value="${event.title}"/>
            </div>
            <div class="mb-3">
                <label class="form-label fw-semibold">Description</label>
                <textarea name="description" class="form-control" rows="4">${event.description}</textarea>
            </div>
            <div class="row g-3 mb-3">
                <div class="col-md-6">
                    <label class="form-label fw-semibold">Date and Time</label>
                    <input type="datetime-local" name="dateTime" class="form-control" required value="${event.dateTimeLocal}"/>
                </div>
                <div class="col-md-6">
                    <label class="form-label fw-semibold">Location</label>
                    <input type="text" name="location" class="form-control" value="${event.location}"/>
                </div>
            </div>
            <div class="row g-3 mb-3">
                <div class="col-md-4">
                    <label class="form-label fw-semibold">Capacity</label>
                    <input type="number" name="capacity" class="form-control" required value="${event.capacity}" min="1"/>
                </div>
                <div class="col-md-4">
                    <label class="form-label fw-semibold">Price (€)</label>
                    <input type="number" step="0.01" name="price" class="form-control" value="${event.price}" min="0"/>
                </div>
                <div class="col-md-4">
                    <label class="form-label fw-semibold">Category</label>
                    <select name="category" class="form-select">
                        <c:forEach var="cat" items="${categories}">
                            <option value="${cat}" ${event.category == cat ? 'selected' : ''}>${cat}</option>
                        </c:forEach>
                    </select>
                </div>
            </div>
            <div class="mb-4 form-check">
                <input type="checkbox" name="isVirtual" class="form-check-input" id="isVirtual" <c:if test="${event.virtual}">checked</c:if>/>
                <label class="form-check-label" for="isVirtual">Virtual event</label>
            </div>
            <div class="d-flex gap-2">
                <button type="submit" class="btn btn-primary flex-grow-1">
                    <i class="bi bi-check-lg me-1"></i>Save changes
                </button>
                <a href="/WebTechProject/events/${event.id}" class="btn btn-outline-secondary">Cancel</a>
            </div>
        </form>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
