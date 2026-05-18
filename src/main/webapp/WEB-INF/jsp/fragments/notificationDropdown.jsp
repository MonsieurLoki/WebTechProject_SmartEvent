<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<li class="nav-item dropdown">
    <button class="btn btn-link nav-link dropdown-toggle text-decoration-none" type="button" data-bs-toggle="dropdown" aria-expanded="false">
        <i class="bi bi-bell me-1"></i>Notifications
        <c:if test="${unreadNotificationCount > 0}">
            <span class="badge bg-primary rounded-pill ms-1">${unreadNotificationCount}</span>
        </c:if>
    </button>
    <ul class="dropdown-menu dropdown-menu-end shadow border-0 p-2" style="width:360px; border-radius:10px;">
        <li class="px-2 py-2 d-flex justify-content-between align-items-center">
            <span class="fw-semibold">Notifications</span>
            <a class="small text-decoration-none" href="/WebTechProject/notifications">View all</a>
        </li>
        <li><hr class="dropdown-divider"></li>
        <c:choose>
            <c:when test="${empty recentNotifications}">
                <li class="px-3 py-4 text-center text-muted">
                    <i class="bi bi-inbox d-block fs-4 mb-2"></i>
                    No notifications yet
                </li>
            </c:when>
            <c:otherwise>
                <c:forEach var="notification" items="${recentNotifications}">
                    <li>
                        <a class="dropdown-item d-flex gap-3 align-items-start py-3 rounded ${notification.read ? '' : 'bg-light'}"
                           href="/WebTechProject/notifications/${notification.id}/open"
                           style="white-space:normal;">
                            <span class="d-inline-flex align-items-center justify-content-center rounded-circle flex-shrink-0"
                                  style="width:34px;height:34px;background:${notification.type == 'SUCCESS' ? '#dcfce7' : notification.type == 'WARNING' ? '#fef3c7' : notification.type == 'ADMIN' ? '#fee2e2' : '#e0f2fe'};color:${notification.type == 'SUCCESS' ? '#166534' : notification.type == 'WARNING' ? '#92400e' : notification.type == 'ADMIN' ? '#991b1b' : '#0369a1'};">
                                <c:choose>
                                    <c:when test="${notification.type == 'SUCCESS'}"><i class="bi bi-check-lg"></i></c:when>
                                    <c:when test="${notification.type == 'WARNING'}"><i class="bi bi-exclamation-lg"></i></c:when>
                                    <c:when test="${notification.type == 'ADMIN'}"><i class="bi bi-shield-check"></i></c:when>
                                    <c:otherwise><i class="bi bi-info-lg"></i></c:otherwise>
                                </c:choose>
                            </span>
                            <span class="flex-grow-1">
                                <span class="d-flex justify-content-between gap-2">
                                    <span class="${notification.read ? 'text-muted' : 'fw-semibold'}">${notification.message}</span>
                                    <c:if test="${!notification.read}">
                                        <span class="badge bg-primary align-self-start">New</span>
                                    </c:if>
                                </span>
                                <span class="d-block small text-muted mt-1">${notification.createdAt}</span>
                            </span>
                        </a>
                    </li>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </ul>
</li>
