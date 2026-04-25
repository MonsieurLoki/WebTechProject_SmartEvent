<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <title>${event.title}</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
</head>
<body style="background:#f8f9ff">
<div class="container mt-5" style="max-width:720px">
    <a href="/WebTechProject/events" class="btn btn-outline-secondary mb-4">
        <i class="bi bi-arrow-left me-1"></i>Back to events
    </a>

    <c:if test="${param.error == 'already_registered'}">
        <div class="alert alert-warning">You are already registered for this event.</div>
    </c:if>
    <c:if test="${param.error == 'full'}">
        <div class="alert alert-danger">This event is full.</div>
    </c:if>

    <div class="card p-4 shadow-sm">
        <h1 class="mb-1">${event.title}</h1>
        <p class="text-muted mb-3">${event.description}</p>
        <hr>
        <p><i class="bi bi-calendar3 me-2 text-primary"></i><strong>Date:</strong> ${event.dateTime}</p>
        <p><i class="bi bi-geo-alt me-2 text-primary"></i><strong>Location:</strong> ${event.location}</p>
        <p><i class="bi bi-people me-2 text-primary"></i><strong>Capacity:</strong> ${event.capacity} people</p>
        <p><i class="bi bi-tag me-2 text-primary"></i><strong>Price:</strong>
            <c:choose>
                <c:when test="${event.price == 0}">Free</c:when>
                <c:otherwise>${event.price} €</c:otherwise>
            </c:choose>
        </p>
        <span class="badge ${event.virtual ? 'bg-info' : 'bg-success'} mb-4">
            <i class="bi ${event.virtual ? 'bi-camera-video' : 'bi-geo-alt'} me-1"></i>
            ${event.virtual ? 'Virtual' : 'In-person'}
        </span>

        <div class="mt-2">
            <c:choose>
                <c:when test="${sessionScope.user.role == 'ATTENDEE'}">
                    <form method="post" action="/WebTechProject/events/${event.id}/register">
                        <button type="submit" class="btn btn-primary">
                            <i class="bi bi-ticket me-1"></i>Register for this event
                        </button>
                    </form>
                </c:when>
                <c:when test="${sessionScope.user.role == 'ORGANIZER' || sessionScope.user.role == 'ADMIN'}">
                    <p class="text-muted fst-italic">Organizers cannot register for events.</p>
                </c:when>
            </c:choose>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
