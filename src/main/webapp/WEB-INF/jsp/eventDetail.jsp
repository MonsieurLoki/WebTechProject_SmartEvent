<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
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
    <c:if test="${param.error == 'registration_closed'}">
        <div class="alert alert-warning">Registration is closed because this event has already started.</div>
    </c:if>
    <c:if test="${param.error == 'registration_role'}">
        <div class="alert alert-warning">Only attendees can register for events.</div>
    </c:if>
    <c:if test="${param.error == 'invalid_rating'}">
        <div class="alert alert-danger">Rating must be between 1 and 5.</div>
    </c:if>
    <c:if test="${param.error == 'event_not_finished'}">
        <div class="alert alert-warning">Feedback is only available after the event has finished.</div>
    </c:if>
    <c:if test="${param.error == 'already_feedback'}">
        <div class="alert alert-warning">You have already rated this event.</div>
    </c:if>
    <c:if test="${param.error == 'feedback_failed'}">
        <div class="alert alert-danger">Feedback could not be saved. Please try again.</div>
    </c:if>
    <c:if test="${param.error == 'feedback_role'}">
        <div class="alert alert-warning">Organizers and admins cannot leave feedback.</div>
    </c:if>
    <c:if test="${param.error == 'feedback_not_registered'}">
        <div class="alert alert-warning">Only registered attendees can leave feedback.</div>
    </c:if>
    <c:if test="${param.error == 'feedback_late_registration'}">
        <div class="alert alert-warning">You must have registered before the event started to leave feedback.</div>
    </c:if>
    <c:if test="${param.error == 'feedback_not_allowed'}">
        <div class="alert alert-warning">You are not allowed to leave feedback for this event.</div>
    </c:if>
    <c:if test="${param.message == 'sent'}">
        <div class="alert alert-success">Your message was sent to the organizer.</div>
    </c:if>
    <c:if test="${param.error == 'message_empty'}">
        <div class="alert alert-danger">Message cannot be empty.</div>
    </c:if>
    <c:if test="${param.error == 'message_self'}">
        <div class="alert alert-warning">You cannot send a message to yourself for this event.</div>
    </c:if>
    <c:if test="${param.error == 'message_failed'}">
        <div class="alert alert-danger">Message could not be sent. Please try again.</div>
    </c:if>

    <div class="card p-4 shadow-sm">
        <div class="d-flex flex-column flex-md-row justify-content-between align-items-start gap-3 mb-3">
            <h1 class="mb-1">${event.title}</h1>
            <c:if test="${not empty sessionScope.user && (sessionScope.user.role == 'ADMIN' || (sessionScope.user.role == 'ORGANIZER' && event.organizerId == sessionScope.user.id))}">
                <div class="d-flex gap-2">
                    <c:if test="${sessionScope.user.role == 'ORGANIZER' && event.organizerId == sessionScope.user.id}">
                        <a href="/WebTechProject/events/${event.id}/edit"
                           class="btn btn-sm d-flex align-items-center gap-1"
                           style="background:#f1f5f9; color:#334155; border:none; font-weight:500;">
                            <i class="bi bi-pencil"></i> Edit
                        </a>
                    </c:if>
                    <button type="button"
                            class="btn btn-sm d-flex align-items-center gap-1"
                            style="background:#fee2e2; color:#991b1b; border:none; font-weight:500;"
                            data-bs-toggle="modal" data-bs-target="#deleteModal">
                        <i class="bi bi-trash3"></i> Delete
                    </button>
                </div>
            </c:if>
        </div>
        <p class="text-muted mb-3">${event.description}</p>
        <hr>
        <p><i class="bi bi-calendar3 me-2 text-primary"></i><strong>Date:</strong> ${event.formattedDateTime}</p>
        <p><i class="bi bi-geo-alt me-2 text-primary"></i><strong>Location:</strong> ${event.location}</p>
        <p><i class="bi bi-bookmark me-2 text-primary"></i><strong>Category:</strong> ${empty event.category ? 'General' : event.category}</p>
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

        <div class="border-top pt-3 mb-4">
            <h5 class="mb-2"><i class="bi bi-star-fill text-warning me-1"></i>Ratings</h5>
            <c:choose>
                <c:when test="${ratingCount > 0}">
                    <div class="d-flex align-items-center gap-2">
                        <span class="fs-5 fw-bold"><fmt:formatNumber value="${averageRating}" maxFractionDigits="1"/></span>
                        <span class="text-warning">
                            <c:forEach begin="1" end="5" var="i">
                                <c:choose>
                                    <c:when test="${i <= averageRating}"><i class="bi bi-star-fill"></i></c:when>
                                    <c:when test="${i - 0.5 <= averageRating}"><i class="bi bi-star-half"></i></c:when>
                                    <c:otherwise><i class="bi bi-star"></i></c:otherwise>
                                </c:choose>
                            </c:forEach>
                        </span>
                        <span class="text-muted small">(${ratingCount} ratings)</span>
                    </div>
                </c:when>
                <c:otherwise>
                    <p class="text-muted mb-0">No ratings yet.</p>
                </c:otherwise>
            </c:choose>
        </div>

        <div class="mt-2">
            <c:choose>
                <c:when test="${sessionScope.user.role == 'ATTENDEE'}">
                    <c:choose>
                        <c:when test="${eventStarted}">
                            <p class="text-muted fst-italic">Registration is closed because this event has already started.</p>
                        </c:when>
                        <c:otherwise>
                            <form method="post" action="/WebTechProject/events/${event.id}/register" class="d-inline-block me-2">
                                <button type="submit" class="btn btn-primary">
                                    <i class="bi bi-ticket me-1"></i>Register for this event
                                </button>
                            </form>
                        </c:otherwise>
                    </c:choose>
                </c:when>
                <c:when test="${sessionScope.user.role == 'ORGANIZER' || sessionScope.user.role == 'ADMIN'}">
                    <p class="text-muted fst-italic">Organizers and admins cannot register for events.</p>
                </c:when>
            </c:choose>
            <c:if test="${sessionScope.user.role == 'ATTENDEE'}">
                <button class="btn btn-outline-primary" type="button" data-bs-toggle="collapse" data-bs-target="#messageOrganizerForm">
                    <i class="bi bi-envelope me-1"></i>Message Organizer
                </button>
            </c:if>
        </div>

        <c:if test="${sessionScope.user.role == 'ATTENDEE'}">
            <div class="collapse mt-3" id="messageOrganizerForm">
                <div class="border rounded p-3 bg-light">
                    <form method="post" action="/WebTechProject/events/${event.id}/messages">
                        <div class="mb-3">
                            <label class="form-label">Subject</label>
                            <input type="text" name="subject" class="form-control" maxlength="150" placeholder="Question about this event"/>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Message</label>
                            <textarea name="message" class="form-control" rows="3" required></textarea>
                        </div>
                        <button type="submit" class="btn btn-primary">
                            <i class="bi bi-send me-1"></i>Send message
                        </button>
                    </form>
                </div>
            </div>
        </c:if>

        <c:if test="${eventFinished}">
            <div class="border-top pt-4 mt-4">
                <h5 class="mb-3"><i class="bi bi-chat-left-text me-1"></i>Your feedback</h5>
                <c:choose>
                    <c:when test="${sessionScope.user.role == 'ORGANIZER' || sessionScope.user.role == 'ADMIN'}">
                        <p class="text-muted mb-0">Organizers and admins cannot leave feedback.</p>
                    </c:when>
                    <c:when test="${sessionScope.user.role != 'ATTENDEE'}">
                        <p class="text-muted mb-0">Only registered attendees can leave feedback.</p>
                    </c:when>
                    <c:when test="${not empty userFeedback}">
                        <div class="alert alert-success mb-0">
                            <strong>You rated this event ${userFeedback.rating}/5.</strong>
                            <c:if test="${not empty userFeedback.comment}">
                                <div class="mt-2">${userFeedback.comment}</div>
                            </c:if>
                        </div>
                    </c:when>
                    <c:when test="${canLeaveFeedback}">
                        <form method="post" action="/WebTechProject/events/${event.id}/feedback">
                            <div class="mb-3">
                                <label for="rating" class="form-label">Rating</label>
                                <select class="form-select" id="rating" name="rating" required>
                                    <option value="5">5 - Excellent</option>
                                    <option value="4">4 - Good</option>
                                    <option value="3">3 - Okay</option>
                                    <option value="2">2 - Poor</option>
                                    <option value="1">1 - Bad</option>
                                </select>
                            </div>
                            <div class="mb-3">
                                <label for="comment" class="form-label">Comment</label>
                                <textarea class="form-control" id="comment" name="comment" rows="3" placeholder="Optional comment"></textarea>
                            </div>
                            <button type="submit" class="btn btn-primary">
                                <i class="bi bi-send me-1"></i>Submit feedback
                            </button>
                        </form>
                    </c:when>
                    <c:when test="${!confirmedRegistered}">
                        <p class="text-muted mb-0">Only registered attendees can leave feedback.</p>
                    </c:when>
                    <c:when test="${!registeredBeforeEventStart}">
                        <p class="text-muted mb-0">You must have registered before the event started to leave feedback.</p>
                    </c:when>
                    <c:otherwise>
                        <p class="text-muted mb-0">You are not allowed to leave feedback for this event.</p>
                    </c:otherwise>
                </c:choose>
            </div>
        </c:if>

        <div class="border-top pt-4 mt-4">
            <h5 class="mb-3"><i class="bi bi-chat-dots me-1"></i>Comments</h5>
            <c:choose>
                <c:when test="${empty feedbackList}">
                    <p class="text-muted mb-0">No comments yet.</p>
                </c:when>
                <c:otherwise>
                    <div class="d-flex flex-column gap-3">
                        <c:forEach var="feedback" items="${feedbackList}">
                            <div class="border rounded p-3 bg-light">
                                <div class="d-flex justify-content-between align-items-center mb-2">
                                    <strong>${feedback.user.fullName}</strong>
                                    <span class="badge bg-warning text-dark">${feedback.rating}/5</span>
                                </div>
                                <c:choose>
                                    <c:when test="${not empty feedback.comment}">
                                        <p class="mb-0">${feedback.comment}</p>
                                    </c:when>
                                    <c:otherwise>
                                        <p class="text-muted fst-italic mb-0">No comment provided.</p>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>
<div class="modal fade" id="deleteModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header border-0 pb-0">
                <h5 class="modal-title fw-bold"><i class="bi bi-exclamation-triangle text-danger me-2"></i>Delete event</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body text-muted">
                Are you sure you want to delete <strong>${event.title}</strong>? This action cannot be undone.
            </div>
            <div class="modal-footer border-0 pt-0">
                <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>
                <form method="post" action="/WebTechProject/events/${event.id}/delete">
                    <button type="submit" class="btn btn-danger">
                        <i class="bi bi-trash3 me-1"></i>Delete
                    </button>
                </form>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
