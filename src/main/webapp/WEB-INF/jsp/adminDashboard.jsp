<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <title>Admin Dashboard — SmartEvent</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"/>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css"/>
    <style>* { font-family: "Segoe UI", sans-serif; }</style>
</head>
<body style="background:#f8f9ff">

<nav class="navbar navbar-expand-lg sticky-top" style="background:#fff; border-bottom:1px solid #eee; padding:16px 0;">
    <div class="container">
        <a class="navbar-brand fw-bold" style="color:#1a1a2e" href="/WebTechProject/events">
            <i class="bi bi-calendar-event-fill me-2" style="color:#4f46e5"></i>SmartEvent
        </a>
        <ul class="navbar-nav ms-auto align-items-center gap-3">
            <li class="nav-item"><a class="nav-link" href="/WebTechProject/events">Discover</a></li>
            <li class="nav-item"><a class="nav-link active" href="/WebTechProject/admin/dashboard">Admin</a></li>
            <li class="nav-item"><span class="nav-link text-muted">${sessionScope.user.fullName}</span></li>
            <li class="nav-item"><a class="nav-link" href="/WebTechProject/logout">Logout</a></li>
        </ul>
    </div>
</nav>

<div class="container mt-5">
    <h2 class="fw-bold mb-1"><i class="bi bi-shield-check me-2"></i>Admin Dashboard</h2>
    <p class="text-muted mb-4">Pending organizer role requests</p>

    <c:choose>
        <c:when test="${empty requests}">
            <div class="text-center py-5 text-muted">
                <i class="bi bi-inbox fs-1 d-block mb-3"></i>
                <p>No pending requests.</p>
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

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
