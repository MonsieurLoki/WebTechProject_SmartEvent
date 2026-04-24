# Project Context for Claude Code
 
## Project
Smart Event Management Web Application — ISEP Paris, Web Technologies course (II.2306/II.2406), 2025-2026.
 
## Team
- Gaspard Derruine (full-stack)
- Ayoub Ayoubi (full-stack)
- Pedro Alemparte (full-stack)
- Leopold Thomasset (full-stack)
- Noé Capouet (full-stack)
## Tech Stack
- **Backend**: Java + Spring MVC
- **Server**: Apache Tomcat 10
- **Database**: PostgreSQL 18
- **Frontend**: JSP + Bootstrap 5 + Bootstrap Icons
- **Build tool**: Maven
## Project Structure
```
src/
└── main/
    ├── java/com/webtechproject/
    │   ├── controller/       ← Spring MVC controllers (@GetMapping, @PostMapping)
    │   ├── dao/              ← Database access (SQL queries via JDBC)
    │   ├── interceptor/      ← AuthInterceptor (redirects to /login if not authenticated)
    │   ├── model/            ← Java entity classes
    │   └── service/          ← Business logic (not yet heavily used)
    └── webapp/
        ├── WEB-INF/
        │   ├── jsp/          ← JSP views
        │   ├── web.xml       ← Tomcat config
        │   └── spring-mvc.xml ← Spring MVC config
        ├── css/
        └── js/
src/main/resources/
    └── db.properties         ← PostgreSQL credentials (gitignored, do not commit)
    └── db.properties.example ← Template for db.properties
```
 
## Database
- Database name: `smartevent`
- Schema file: `dbschema.sql` at project root
- Tables: `users`, `events`, `registrations`, `feedback`, `payments`
- Connection handled by: `DBConnection.java` using `db.properties`
## Key conventions
- DB credentials are in `src/main/resources/db.properties` (gitignored)
- Always use `Class.forName("org.postgresql.Driver")` before DB connections
- Controllers use `HttpSession` for authentication (session key: `"user"`)
- User roles: `ATTENDEE`, `ORGANIZER`, `ADMIN` (uppercase in DB)
- All routes are protected by `AuthInterceptor` except `/login`, `/register`
## Current features (done)
- Event list page (`GET /events`) — reads from PostgreSQL
- Event detail page (`GET /events/{id}`)
- User registration (`GET/POST /register`)
- User login (`GET/POST /login`)
- User logout (`GET /logout`)
- Page protection via Spring MVC interceptor
- Create event form (`GET/POST /events/create`)
- Home redirect (`GET /` → `/events`)
## Next features (in progress)
- Event registration — attendee signs up for an event
- Show logged-in user name in navbar
- My Tickets page
- Edit / delete event
- Organizer dashboard
- Feedback and ratings
## Local deploy commands (Windows, Git Bash)
```bash
cd ~/OneDrive/Erasmus2026/WebTechno/WebTechProject
rm -rf target
mvn package
cp target/WebTechProject.war "/c/Users/gaspa/OneDrive/Bureau/apache-tomcat-10.1.53/webapps/"
rm -rf "/c/Users/gaspa/OneDrive/Bureau/apache-tomcat-10.1.53/webapps/WebTechProject"
taskkill //F //IM java.exe
cd "/c/Users/gaspa/OneDrive/Bureau/apache-tomcat-10.1.53/bin"
./startup.bat
```
 
## Local URL
```
http://localhost:8080/WebTechProject/events
```
 
## Production (VPS)
- Provider: OVHcloud VPS (Debian 12)
- IP: 149.202.49.197
- URL: http://smartevent.critiq.ovh:8080/WebTechProject/events
- Tomcat path: `/var/lib/tomcat10/webapps/`
- Deploy on VPS:
```bash
ssh debian@149.202.49.197
cd ~/WebTechProject
git pull origin main
mvn package
sudo cp target/WebTechProject.war /var/lib/tomcat10/webapps/
sudo systemctl restart tomcat10
```
 
## Git workflow
- Never commit directly to `main`
- Create a branch per feature: `git checkout -b feature/feature-name`
- Open a Pull Request on GitHub to merge into `main`
- `db.properties` is gitignored — never push it