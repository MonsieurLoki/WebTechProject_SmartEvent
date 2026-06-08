# SmartEvent — Final Project Report
**Web Technologies — II.2306/II.2406 | ISEP Paris | 2025–2026**

**Team members:** Gaspard Derruine, Ayoub Ayoubi, Pedro Alemparte, Leopold Thomasset, Noé Capouet

---

## 1. Project Requirements

The goal of this project was to design and develop a full-stack web application for managing events. The application needed to support multiple user roles with different levels of access, cover the full lifecycle of an event from creation to post-event feedback, and be deployed on a publicly accessible server.

The core requirements were:

- User registration and authentication with role-based access control
- Event browsing, search, and filtering for all visitors
- Event creation and management for organizers
- Registration and ticket management for attendees
- A payment flow for paid events
- A feedback and rating system available after events
- An organizer dashboard with event performance statistics
- An administration panel to manage the platform
- A notification system to keep users informed in real time
- A messaging system between attendees and organizers

---

## 2. Chosen Technologies and Motivations

| Layer | Technology | Version |
|---|---|---|
| Backend | Java + Spring MVC | Spring 6 |
| Server | Apache Tomcat | 10.1 |
| Database | PostgreSQL | 18 |
| Frontend | JSP + Bootstrap | Bootstrap 5.3 |
| Build | Maven | 3.x |
| Hosting | OVHcloud VPS (Debian 12) | — |

**Java + Spring MVC** was chosen because it is the framework covered in the course, and because it offers a clean separation between controllers, models, and views through annotations. It also handles request routing, session management, and interceptors with minimal configuration.

**PostgreSQL** was selected for its reliability, support for constraints and foreign keys, and good compatibility with Java through the JDBC driver. The relational model fits the domain well since events, users, registrations and payments have clear relationships between them.

**JSP with Bootstrap 5** was a pragmatic choice: JSP integrates naturally with Spring MVC's `InternalResourceViewResolver`, and Bootstrap allowed us to build a clean, responsive interface without spending time on custom CSS from scratch.

**Apache Tomcat 10** is the standard servlet container for Jakarta EE applications and pairs directly with Spring MVC without additional configuration overhead.

---

## 3. Application Architecture and Detailed Design

The application follows a standard three-tier architecture:

- **Presentation layer** — JSP pages rendered server-side, styled with Bootstrap 5 and Bootstrap Icons
- **Business logic layer** — Spring MVC controllers handle HTTP requests, enforce authorization rules, and orchestrate DAO calls
- **Data access layer** — DAO classes execute SQL queries via JDBC and map result sets to model objects

The application is packaged as a WAR file and deployed on Tomcat. A single `DispatcherServlet` defined in `web.xml` routes all requests through Spring MVC. The Spring configuration is declared in `spring-mvc.xml`, which enables annotation-driven MVC, component scanning, and the view resolver.

Authentication state is stored in the HTTP session under the key `user`. An `AuthInterceptor` intercepts all protected routes and redirects unauthenticated users to `/login`. Public routes (login, register, static assets) are excluded from interception.

---

## 4. MVC Pattern Implementation

Spring MVC provides a clean implementation of the Model-View-Controller pattern.

**Controllers** are annotated with `@Controller` and map HTTP methods to handler methods via `@GetMapping` and `@PostMapping`. Each controller is responsible for a specific domain: `EventController` handles event browsing, creation, registration and payment; `OrganizerController` handles the organizer dashboard and attendee lists; `AdminController` handles platform administration; `AuthController` handles login, registration and logout; `NotificationController` and `EventMessageController` handle their respective features.

A `@ControllerAdvice` class (`GlobalModelAdvice`) injects shared model attributes into every view — specifically the pending request count, unread notification count, and recent notifications — so the navbar always reflects live data without each controller having to set these manually.

**Models** are plain Java objects representing domain entities: `User`, `Event`, `Registration`, `Feedback`, `Payment`, `Notification`, `EventMessage`, `OrganizerRequest`. Utility models like `EventStats` and `Attendee` are used to carry aggregated data to specific views.

**Views** are JSP files located in `/WEB-INF/jsp/`. They use JSTL (`jakarta.tags.core`, `jakarta.tags.fmt`) for conditionals and iteration. Shared UI fragments (the notification dropdown) are included via `<jsp:include>`.

---

## 5. Software Components and Their Interactions

```
Browser
  │
  ▼
DispatcherServlet  ──►  AuthInterceptor  ──►  [redirect /login if not authenticated]
  │
  ▼
Controller  ──►  DAO  ──►  DBConnection  ──►  PostgreSQL
  │                │
  │            ResultSet mapped to Model objects
  │
  ▼
Model  ──►  View (JSP)  ──►  HTML response
```

**DBConnection** is a utility class that loads credentials from `db.properties` at runtime using `Class.forName("org.postgresql.Driver")` and returns a new `Connection` per call. Each DAO opens and closes its own connection within a try-with-resources block.

**DAO classes** encapsulate all SQL. There is one DAO per domain area: `EventDAO`, `UserDAO`, `RegistrationDAO`, `FeedbackDAO`, `PaymentDAO`, `NotificationDAO`, `EventMessageDAO`, `OrganizerRequestDAO`, `OrganizerDashboardDAO`, and `AdminDAO`. None of the controllers contain SQL — all data access goes through a DAO.

**NotificationDAO** is called by multiple controllers as a cross-cutting concern: whenever a significant action happens (event created, registration confirmed, payment processed, organizer request reviewed, message received), a notification is inserted for the relevant user.

---

## 6. Database Design

The database contains eight tables. All foreign keys use `ON UPDATE CASCADE ON DELETE CASCADE` to maintain referential integrity automatically.

### users
Stores all platform users. The `role` column is constrained to `ATTENDEE`, `ORGANIZER`, or `ADMIN`. Passwords are stored as hashed strings (SHA-256).

### events
Stores events created by organizers. `organizer_id` references `users`. Includes `is_virtual` flag, `category`, `capacity`, and `price` with check constraints ensuring non-negative values.

### registrations
Links users to events. A unique constraint on `(user_id, event_id)` prevents double registration. The `status` column tracks `PENDING`, `CONFIRMED`, or `CANCELLED` states. `registered_at` is used to enforce the rule that feedback can only be left by users who registered before the event started.

### feedback
Stores post-event ratings (1–5) and optional comments. A unique constraint on `(user_id, event_id)` ensures one feedback per user per event. Only accessible after the event's `date_time` has passed.

### payments
Linked one-to-one with a registration via `registration_id UNIQUE`. Records the amount, provider (`SIMULATED` for the current implementation), and a transaction reference. Designed to be swappable with a real payment gateway.

### organizer_requests
Tracks requests from attendees to become organizers. The admin can approve or reject these requests, which updates the user's role accordingly.

### notifications
Stores in-app notifications per user. Each notification has a `type` (INFO, SUCCESS, WARNING, ADMIN), a `is_read` flag, and an optional `link_url` to direct the user to the relevant page.

### event_messages
Supports a threaded messaging system between attendees and event organizers. `parent_message_id` allows one level of reply (organizer replying to attendee message). Read state is tracked per message.

---

## 7. Project Management

### Planning

[TODO]

### Releases

The project was developed incrementally using Git with a feature-branch workflow. Each feature was developed on a dedicated branch and merged into `main` via a pull request. The main releases were:

| Release | Features included |
|---|---|
| Milestone 1 | Project setup, PostgreSQL connection, user authentication, event list and detail pages |
| Milestone 2 | Event registration, simulated payment, organizer dashboard, feedback & ratings, search & filters, edit/delete events, notifications, messaging |
| Milestone 3 | Admin dashboard improvements (stats, organizer management, all-events control), permission refinements, role-based navbar |

### Team Members' Roles

[TODO — add your work here if something is missing]

- **Gaspard Derruine** — Project coordination, event registration flow, simulated payment, organizer dashboard, admin dashboard improvements, overall integration
- **Pedro Alemparte** — Search and category filters, feedback & ratings system, permission enforcement (registration/feedback rules), attendee-to-organizer messaging
- **Ayoub Ayoubi** — Notification system (backend, frontend, database)
- **Leopold Thomasset** — Edit and delete event feature
- **Noé Capouet** — [TODO]

---

## 8. Installation Instructions

### Prerequisites

- Java 17+
- Maven 3.x
- PostgreSQL (database named `smartevent`)
- Apache Tomcat 10.1

### Local setup

1. Clone the repository:
   ```bash
   git clone https://github.com/pedroalemparte/WebTechProject.git
   cd WebTechProject
   ```

2. Create the database and run the schema:
   ```bash
   psql -U postgres -c "CREATE DATABASE smartevent;"
   psql -U postgres -d smartevent -f dbschema.sql
   ```

3. Create `src/main/resources/db.properties` based on the provided template:
   ```
   db.url=jdbc:postgresql://localhost:5432/smartevent
   db.username=YOUR_USERNAME
   db.password=YOUR_PASSWORD
   ```

4. Build and deploy:
   ```bash
   mvn package
   cp target/WebTechProject.war /path/to/tomcat/webapps/
   ```

5. Start Tomcat and open `http://localhost:8080/WebTechProject/events`

### Production (VPS)

The application is deployed on an OVHcloud VPS running Debian 12 with Tomcat 10 managed by `systemd`. Deployment is done by pulling the latest code, rebuilding, and restarting Tomcat:

```bash
ssh debian@149.202.49.197
cd ~/WebTechProject && git pull origin main
mvn package
sudo cp target/WebTechProject.war /var/lib/tomcat10/webapps/
sudo systemctl restart tomcat10
```

Live URL: `http://smartevent.critiq.ovh:8080/WebTechProject/events`

---

## 9. User Guide

### Registering and logging in

New users register at `/register` by providing a name, email, and password. After registration, the default role is **ATTENDEE**. Logging in at `/login` creates a session that persists until the user logs out.

### Browsing and searching events

The home page (`/events`) lists all upcoming events. Users can search by keyword using the search bar, or filter by category using the filter buttons (Technology, Music, Design, Networking, Sports). Each event card shows the date, location, capacity, and price.

### Registering for an event

Clicking "View Details" on an event card opens the event detail page. Attendees can register using the "Register for this event" button. For free events, the ticket is confirmed immediately. For paid events, the user is redirected to a payment form where they enter their card details. The payment is simulated — no real transaction is processed.

Registered attendees can view their tickets at `/my-tickets`.

### Leaving feedback

After an event has ended, attendees who registered before the event started can leave a rating (1–5 stars) and an optional comment on the event detail page. Each attendee can leave one review per event.

### Messaging an organizer

On any event detail page, attendees can send a message to the organizer using the "Message Organizer" button. The organizer receives a notification and can reply from their messages inbox at `/messages`.

### Becoming an organizer

Attendees can request organizer privileges at `/request-organizer`. An administrator reviews the request from the admin dashboard and can approve or reject it.

### Organizer dashboard

Organizers access their dashboard at `/organizer/dashboard`. It shows summary statistics (total events, registrations, revenue) and a table of all their events with registration fill rate, revenue per event, and average rating. They can view the attendee list for each event.

### Admin dashboard

Administrators access the admin dashboard at `/admin/dashboard`. It shows platform-wide statistics, pending organizer requests (with approve/reject actions), a list of all organizers with the ability to revoke their status, and a full list of all events with the ability to delete any of them.

### Notifications

A bell icon in the navbar shows the number of unread notifications. Clicking it opens a dropdown with recent notifications. All notifications are accessible at `/notifications`.

---

## 10. Conclusion

Over the course of this project we built a fully functional event management platform, going from a blank Maven project to a deployed application with authentication, event management, payments, feedback, notifications, and messaging. The incremental approach — one feature branch per feature, merged through pull requests — helped us avoid conflicts and keep the main branch stable throughout.

The final application covers all the requirements set out at the beginning of the project and runs on a publicly accessible server.

---

## 11. Lessons Learned

Working as a team of five on a shared codebase taught us a lot about the practical side of collaborative development. Merge conflicts were inevitable and forced us to understand each other's code rather than just our own part. We also learned that establishing conventions early (naming, SQL column naming, DAO structure) saves a lot of time later.

On the technical side, we gained hands-on experience with the full stack of a Java web application — from SQL schema design and JDBC queries, to Spring MVC routing and session management, to JSP templating and Bootstrap layout. Deploying to a real VPS and dealing with environment-specific issues (database credentials, Tomcat configuration, `systemd` service management) added a dimension that purely local development would not have given us.

---

## 12. Future Perspectives

The application provides a solid foundation, but several directions could make it more production-ready:

- **Real payment integration** — replacing the simulated payment with Stripe or another gateway
- **Email notifications** — sending confirmation emails on registration and payment using JavaMail
- **Waitlist** — allowing users to join a queue when an event is full, with automatic promotion when a spot opens up
- **Event images** — letting organizers upload a cover image for their events
- **Analytics charts** — adding Chart.js graphs to the organizer dashboard (registrations over time, revenue breakdown)
- **Pagination** — handling large numbers of events gracefully on the browse page
- **Mobile responsiveness improvements** — the current layout works on mobile but was not specifically optimized for it

---

