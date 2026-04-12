<%@ page contentType="text/html;charset=UTF-8" %> <%@ taglib prefix="c"
uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>SmartEvent - Discover Events</title>
    <link
      rel="stylesheet"
      href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
    />
    <link
      rel="stylesheet"
      href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css"
    />
    <style>
      * {
        font-family: "Segoe UI", sans-serif;
      }

      /* NAVBAR */
      .navbar {
        background: #fff;
        border-bottom: 1px solid #eee;
        padding: 16px 0;
      }
      .navbar-brand {
        font-weight: 700;
        font-size: 1.3rem;
        color: #1a1a2e !important;
      }
      .navbar-brand i {
        color: #4f46e5;
      }
      .nav-link {
        color: #555 !important;
        font-weight: 500;
      }
      .nav-link.active {
        color: #4f46e5 !important;
      }
      .btn-register {
        background: #4f46e5;
        color: #fff;
        border-radius: 8px;
        padding: 8px 20px;
      }
      .btn-register:hover {
        background: #4338ca;
        color: #fff;
      }

      /* HERO */
      .hero {
        background: linear-gradient(
          135deg,
          #1a1a2e 0%,
          #16213e 50%,
          #0f3460 100%
        );
        padding: 80px 0;
        color: white;
        text-align: center;
      }
      .hero h1 {
        font-size: 2.8rem;
        font-weight: 700;
        margin-bottom: 16px;
      }
      .hero p {
        font-size: 1.1rem;
        color: #aab4c4;
        margin-bottom: 32px;
      }
      .search-box {
        max-width: 600px;
        margin: 0 auto;
        display: flex;
        gap: 10px;
      }
      .search-box input {
        flex: 1;
        padding: 14px 20px;
        border-radius: 10px;
        border: none;
        font-size: 1rem;
      }
      .search-box button {
        background: #4f46e5;
        color: white;
        border: none;
        border-radius: 10px;
        padding: 14px 28px;
        font-weight: 600;
      }

      /* FILTERS */
      .filters {
        padding: 32px 0 0 0;
      }
      .filter-btn {
        border: 1px solid #e0e0e0;
        background: white;
        border-radius: 20px;
        padding: 6px 18px;
        font-size: 0.9rem;
        color: #555;
        cursor: pointer;
        transition: all 0.2s;
      }
      .filter-btn.active,
      .filter-btn:hover {
        background: #4f46e5;
        color: white;
        border-color: #4f46e5;
      }

      /* CARDS */
      .events-section {
        padding: 32px 0 60px 0;
      }
      .section-title {
        font-size: 1.5rem;
        font-weight: 700;
        color: #1a1a2e;
      }
      .event-count {
        color: #888;
        font-size: 0.95rem;
      }

      .event-card {
        border: none;
        border-radius: 16px;
        overflow: hidden;
        box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);
        transition: transform 0.2s, box-shadow 0.2s;
        height: 100%;
      }
      .event-card:hover {
        transform: translateY(-4px);
        box-shadow: 0 8px 24px rgba(0, 0, 0, 0.15);
      }
      .event-card-img {
        height: 180px;
        object-fit: cover;
        width: 100%;
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        display: flex;
        align-items: center;
        justify-content: center;
        color: white;
        font-size: 3rem;
      }
      .card-body {
        padding: 20px;
      }
      .badge-type {
        font-size: 0.75rem;
        padding: 4px 10px;
        border-radius: 20px;
        font-weight: 600;
      }
      .badge-virtual {
        background: #e0f2fe;
        color: #0369a1;
      }
      .badge-inperson {
        background: #dcfce7;
        color: #166534;
      }
      .event-title {
        font-size: 1.05rem;
        font-weight: 700;
        color: #1a1a2e;
        margin: 10px 0 8px;
      }
      .event-meta {
        font-size: 0.85rem;
        color: #666;
        margin-bottom: 4px;
      }
      .event-meta i {
        margin-right: 6px;
        color: #4f46e5;
      }
      .event-price {
        font-size: 1.1rem;
        font-weight: 700;
        color: #4f46e5;
        margin-top: 12px;
      }
      .event-price.free {
        color: #16a34a;
      }
      .btn-details {
        background: #4f46e5;
        color: white;
        border: none;
        border-radius: 8px;
        padding: 8px 20px;
        font-size: 0.9rem;
        font-weight: 600;
        width: 100%;
        margin-top: 12px;
      }
      .btn-details:hover {
        background: #4338ca;
        color: white;
      }
    </style>
  </head>
  <body style="background: #f8f9ff">
    <!-- NAVBAR -->
    <nav class="navbar navbar-expand-lg sticky-top">
      <div class="container">
        <a class="navbar-brand" href="#">
          <i class="bi bi-calendar-event-fill me-2"></i>SmartEvent
        </a>
        <button
          class="navbar-toggler"
          type="button"
          data-bs-toggle="collapse"
          data-bs-target="#navMenu"
        >
          <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navMenu">
          <ul class="navbar-nav ms-auto align-items-center gap-3">
            <li class="nav-item">
              <a class="nav-link active" href="/WebTechProject/events">Discover</a>
            </li>
            <li class="nav-item">
              <a class="nav-link" href="#">My Tickets</a>
            </li>
            <li class="nav-item">
              <a class="nav-link" href="#">Organizer Dashboard</a>
            </li>
            <li class="nav-item">
              <a class="nav-link" href="/WebTechProject/events/create">Create Event</a>
            </li>
            <li class="nav-item">
              <a class="btn btn-register" href="/WebTechProject/register">Register</a>
              <a class="nav-link" href="/WebTechProject/logout">Logout</a>
            </li>
          </ul>
        </div>
      </div>
    </nav>

    <!-- HERO -->
    <section class="hero">
      <div class="container">
        <h1>Discover Events That<br />Inspire You</h1>
        <p>
          Find conferences, workshops, festivals, and meetups happening around
          you or online.
        </p>
        <div class="search-box">
          <input
            type="text"
            placeholder="Search by event name, location, or category..."
          />
          <button><i class="bi bi-search me-2"></i>Search</button>
        </div>
      </div>
    </section>

    <!-- FILTERS + EVENTS -->
    <div class="container">
      <div class="filters mb-4">
        <div class="d-flex align-items-center gap-2 flex-wrap">
          <button class="filter-btn active">All</button>
          <button class="filter-btn">Technology</button>
          <button class="filter-btn">Music</button>
          <button class="filter-btn">Design</button>
          <button class="filter-btn">Networking</button>
          <button class="filter-btn">Sports</button>
        </div>
      </div>

      <div class="events-section">
        <div class="d-flex justify-content-between align-items-center mb-4">
          <h2 class="section-title">Upcoming Events</h2>
          <span class="event-count">${events.size()} events found</span>
        </div>

        <div class="row g-4">
          <c:forEach var="event" items="${events}">
            <div class="col-md-4">
              <div class="event-card card">
                <!-- Image placeholder avec icône -->
                <div class="event-card-img">
                  <i class="bi bi-calendar-event"></i>
                </div>
                <div class="card-body">
                  <!-- Badge Virtual / In-person -->
                  <span
                    class="badge-type ${event.virtual ? 'badge-virtual' : 'badge-inperson'}"
                  >
                    <i
                      class="bi ${event.virtual ? 'bi-camera-video' : 'bi-geo-alt'}"
                    ></i>
                    ${event.virtual ? 'Virtual' : 'In Person'}
                  </span>

                  <h5 class="event-title">${event.title}</h5>

                  <p class="event-meta">
                    <i class="bi bi-calendar3"></i>${event.dateTime}
                  </p>
                  <p class="event-meta">
                    <i class="bi bi-geo-alt"></i>${event.location}
                  </p>
                  <p class="event-meta">
                    <i class="bi bi-people"></i>Capacity: ${event.capacity}
                  </p>

                  <div
                    class="d-flex justify-content-between align-items-center"
                  >
                    <span class="event-price ${event.price == 0 ? 'free' : ''}">
                      <c:choose>
                        <c:when test="${event.price == 0}">Free</c:when>
                        <c:otherwise>$${event.price}</c:otherwise>
                      </c:choose>
                    </span>
                  </div>

                  <a href="/WebTechProject/events/${event.id}" class="btn btn-details">
                      <i class="bi bi-arrow-right me-1"></i>View Details
                  </a>
                </div>
              </div>
            </div>
          </c:forEach>
        </div>
      </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
      // Filtres actifs
      document.querySelectorAll(".filter-btn").forEach((btn) => {
        btn.addEventListener("click", () => {
          document
            .querySelectorAll(".filter-btn")
            .forEach((b) => b.classList.remove("active"));
          btn.classList.add("active");
        });
      });
    </script>
  </body>
</html>
