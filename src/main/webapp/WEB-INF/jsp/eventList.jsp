<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Events</title>
    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body>
<div class="container mt-5">
    <h1 class="mb-4">Upcoming Events</h1>
    <div class="row">
        <c:forEach var="event" items="${events}">
            <div class="col-md-4 mb-4">
                <div class="card h-100">
                    <div class="card-body">
                        <h5 class="card-title">${event.title}</h5>
                        <p class="card-text">${event.description}</p>
                        <p><strong>Date:</strong> ${event.dateTime}</p>
                        <p><strong>Location:</strong> ${event.location}</p>
                        <p><strong>Capacity:</strong> ${event.capacity}</p>
                        <p><strong>Price:</strong>
                            <c:choose>
                                <c:when test="${event.price == 0}">Free</c:when>
                                <c:otherwise>${event.price} €</c:otherwise>
                            </c:choose>
                        </p>
                        <span class="badge ${event.virtual ? 'bg-info' : 'bg-success'}">
                            ${event.virtual ? 'Virtual' : 'In-person'}
                        </span>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>
</div>
</body>
</html>