<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Create Event</title>
    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body>
<div class="container mt-5" style="max-width: 600px">
    <a href="/WebTechProject/events" class="btn btn-outline-secondary mb-4">← Back to events</a>
    <h2 class="mb-4">Create a new event</h2>
    <form method="post" action="/WebTechProject/events/create">
        <div class="mb-3">
            <label>Title</label>
            <input type="text" name="title" class="form-control" required/>
        </div>
        <div class="mb-3">
            <label>Description</label>
            <textarea name="description" class="form-control" rows="3"></textarea>
        </div>
        <div class="mb-3">
            <label>Date and Time</label>
            <input type="datetime-local" name="dateTime" class="form-control" required/>
        </div>
        <div class="mb-3">
            <label>Location</label>
            <input type="text" name="location" class="form-control"/>
        </div>
        <div class="mb-3">
            <label>Capacity</label>
            <input type="number" name="capacity" class="form-control" required/>
        </div>
        <div class="mb-3">
            <label>Price (€)</label>
            <input type="number" step="0.01" name="price" class="form-control" value="0"/>
        </div>
        <div class="mb-3">
            <label>Category</label>
            <select name="category" class="form-control" required>
                <option value="General">General</option>
                <option value="Technology">Technology</option>
                <option value="Music">Music</option>
                <option value="Design">Design</option>
                <option value="Networking">Networking</option>
                <option value="Sports">Sports</option>
            </select>
        </div>
        <div class="mb-3 form-check">
            <input type="checkbox" name="isVirtual" class="form-check-input" id="isVirtual"/>
            <label class="form-check-label" for="isVirtual">Virtual event</label>
        </div>
        <button type="submit" class="btn btn-primary w-100">Create Event</button>
    </form>
</div>
</body>
</html>
