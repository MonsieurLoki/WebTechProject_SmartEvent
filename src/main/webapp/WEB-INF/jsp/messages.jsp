<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <title>Messages - SmartEvent</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"/>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css"/>
    <style>
        * { font-family: "Segoe UI", sans-serif; }
        .navbar { background:#fff; border-bottom:1px solid #eee; padding:16px 0; }
        .navbar-brand { font-weight:700; font-size:1.3rem; color:#1a1a2e !important; }
        .navbar-brand i { color:#4f46e5; }
        .nav-link { color:#555 !important; font-weight:500; }
        .nav-link.active { color:#4f46e5 !important; }
        .message-card { border:none; border-radius:14px; box-shadow:0 2px 12px rgba(0,0,0,0.08); }
        .reply-card { background:#f8fafc; border:1px solid #e5e7eb; border-radius:10px; }
        .message-unread { border-left:4px solid #4f46e5; }
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
                <li class="nav-item">
                    <a class="nav-link active" href="/WebTechProject/messages">
                        Messages
                        <c:if test="${unreadMessageCount > 0}">
                            <span class="badge bg-primary rounded-pill ms-1">${unreadMessageCount}</span>
                        </c:if>
                    </a>
                </li>
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

<div class="container mt-5" style="max-width:900px">
    <div class="mb-4">
        <h2 class="fw-bold mb-1"><i class="bi bi-envelope me-2"></i>Messages</h2>
        <p class="text-muted mb-0">Event conversations between attendees and organizers.</p>
    </div>

    <c:if test="${param.message == 'replied'}">
        <div class="alert alert-success">Reply sent successfully.</div>
    </c:if>
    <c:if test="${param.error == 'message_empty'}">
        <div class="alert alert-danger">Message cannot be empty.</div>
    </c:if>
    <c:if test="${param.error == 'forbidden'}">
        <div class="alert alert-danger">You cannot access or reply to that message.</div>
    </c:if>
    <c:if test="${param.error == 'message_failed'}">
        <div class="alert alert-danger">Message could not be saved. Please try again.</div>
    </c:if>

    <c:choose>
        <c:when test="${empty messages}">
            <div class="text-center py-5 text-muted">
                <i class="bi bi-inbox fs-1 d-block mb-3"></i>
                <p>No messages yet.</p>
                <a href="/WebTechProject/events" class="btn btn-primary">Browse Events</a>
            </div>
        </c:when>
        <c:otherwise>
            <div class="d-flex flex-column gap-4">
                <c:forEach var="message" items="${messages}">
                    <div class="card message-card ${(!message.read && message.receiverId == sessionScope.user.id) ? 'message-unread' : ''} p-4">
                        <div class="d-flex justify-content-between align-items-start gap-3 mb-2">
                            <div>
                                <h5 class="fw-bold mb-1"><c:out value="${message.subject}"/></h5>
                                <p class="text-muted small mb-0">
                                    Event:
                                    <a href="/WebTechProject/events/${message.eventId}" class="text-decoration-none">
                                        <c:out value="${message.eventTitle}"/>
                                    </a>
                                </p>
                            </div>
                            <c:if test="${!message.read && message.receiverId == sessionScope.user.id}">
                                <span class="badge bg-primary">New</span>
                            </c:if>
                        </div>

                        <div class="mb-3">
                            <div class="text-muted small mb-1">
                                From <strong><c:out value="${message.senderName}"/></strong>
                                (<c:out value="${message.senderEmail}"/>) to <c:out value="${message.receiverName}"/>
                                · ${message.formattedCreatedAt}
                            </div>
                            <p class="mb-0"><c:out value="${message.message}"/></p>
                            <c:if test="${!message.read && message.receiverId == sessionScope.user.id}">
                                <form method="post" action="/WebTechProject/messages/${message.id}/read" class="mt-2">
                                    <button type="submit" class="btn btn-sm btn-outline-secondary">Mark as read</button>
                                </form>
                            </c:if>
                        </div>

                        <c:set var="replies" value="${repliesByMessage[message.id]}"/>
                        <c:if test="${not empty replies}">
                            <div class="d-flex flex-column gap-2 mb-3">
                                <c:forEach var="reply" items="${replies}">
                                    <div class="reply-card p-3 ${(!reply.read && reply.receiverId == sessionScope.user.id) ? 'message-unread' : ''}">
                                        <div class="d-flex justify-content-between align-items-start gap-3">
                                            <div class="text-muted small mb-1">
                                                From <strong><c:out value="${reply.senderName}"/></strong>
                                                to <c:out value="${reply.receiverName}"/>
                                                · ${reply.formattedCreatedAt}
                                            </div>
                                            <c:if test="${!reply.read && reply.receiverId == sessionScope.user.id}">
                                                <span class="badge bg-primary">New</span>
                                            </c:if>
                                        </div>
                                        <p class="mb-0"><c:out value="${reply.message}"/></p>
                                        <c:if test="${!reply.read && reply.receiverId == sessionScope.user.id}">
                                            <form method="post" action="/WebTechProject/messages/${reply.id}/read" class="mt-2">
                                                <button type="submit" class="btn btn-sm btn-outline-secondary">Mark as read</button>
                                            </form>
                                        </c:if>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:if>

                        <c:if test="${(sessionScope.user.role == 'ORGANIZER' || sessionScope.user.role == 'ADMIN') && message.receiverId == sessionScope.user.id}">
                            <form method="post" action="/WebTechProject/messages/${message.id}/reply" class="border-top pt-3">
                                <label class="form-label fw-semibold">Reply</label>
                                <textarea name="message" class="form-control mb-2" rows="3" required></textarea>
                                <button type="submit" class="btn btn-primary">
                                    <i class="bi bi-reply me-1"></i>Send reply
                                </button>
                            </form>
                        </c:if>
                    </div>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
