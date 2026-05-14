<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Edit Event</title>
    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body>
<div class="container mt-5" style="max-width: 600px">
    <a href="/WebTechProject/events/${event.id}" class="btn btn-outline-secondary mb-4">← Back to event</a>
    <h2 class="mb-4">Edit event</h2>
    <form method="post" action="/WebTechProject/events/${event.id}/edit">
        <div class="mb-3">
            <label>Title</label>
            <input type="text" name="title" class="form-control" required value="${event.title}"/>
        </div>
        <div class="mb-3">
            <label>Description</label>
            <textarea name="description" class="form-control" rows="3">${event.description}</textarea>
        </div>
        <div class="mb-3">
            <label>Date and Time</label>
            <input type="datetime-local" name="dateTime" class="form-control" required value="${event.dateTimeLocal}"/>
        </div>
        <div class="mb-3">
            <label>Location</label>
            <input type="text" name="location" class="form-control" value="${event.location}"/>
        </div>
        <div class="mb-3">
            <label>Capacity</label>
            <input type="number" name="capacity" class="form-control" required value="${event.capacity}"/>
        </div>
        <div class="mb-3">
            <label>Price (€)</label>
            <input type="number" step="0.01" name="price" class="form-control" value="${event.price}"/>
        </div>
        <div class="mb-3 form-check">
            <input type="checkbox" name="isVirtual" class="form-check-input" id="isVirtual" <c:if test="${event.virtual}">checked</c:if>/>
            <label class="form-check-label" for="isVirtual">Virtual event</label>
        </div>
        <button type="submit" class="btn btn-primary w-100">Save changes</button>
    </form>
</div>
</body>
</html>
