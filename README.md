# Smart Event Management Web Application

A web application for planning, managing, and attending events. Built for the Web Technologies course.

## Team

| Name | Role |
|------|------|
| Gaspard Derruine | Full-stack |
| Ayoub Ayoubi | Full-stack |
| Pedro Alemparte | Full-stack |
| Leopold Thomasset | Full-stack |
| Noé Capouet | Full-stack |

## Tech Stack

| Layer | Technology |
|-------|------------|
| Backend | Java + Spring MVC |
| Server | Apache Tomcat 10 |
| Database | PostgreSQL |
| Frontend | JSP + Bootstrap 5 |
| Authentication | JWT |
| Payment | Stripe |
| Email | SendGrid |

## Project Structure

```
src/
└── main/
    ├── java/com/webtechproject/
    │   ├── controller/     ← Spring MVC controllers
    │   ├── dao/            ← Database access objects
    │   ├── model/          ← Java entity classes
    │   └── service/        ← Business logic
    └── webapp/
        ├── WEB-INF/
        │   ├── jsp/        ← JSP views
        │   ├── web.xml
        │   └── spring-mvc.xml
        ├── css/
        └── js/
```

## Prerequisites

- Java 17+
- Maven 3.6+
- Apache Tomcat 10
- PostgreSQL

## Getting Started

### 1. Clone the repository

```bash
git clone https://github.com/pedroalemparte/WebTechProject.git
cd WebTechProject
```

### 2. Build the project

```bash
mvn package
```

### 3. Deploy to Tomcat

Copy the generated WAR file to your Tomcat webapps directory:

```bash
cp target/WebTechProject.war /path/to/tomcat/webapps/
```

### 4. Start Tomcat

```bash
/path/to/tomcat/bin/startup.bat   # Windows
/path/to/tomcat/bin/startup.sh    # Linux/Mac
```

### 5. Access the application

```
http://localhost:8080/WebTechProject/events
```

## Features

### Implemented
- [x] Project structure (MVC)
- [x] Event list page

### In progress
- [ ] PostgreSQL integration
- [ ] User authentication (register/login)
- [ ] Event creation form

### Planned
- [ ] Ticket booking and payment (Stripe)
- [ ] Email notifications (SendGrid)
- [ ] Feedback and ratings
- [ ] Analytics dashboard
- [ ] Google Calendar integration

## Git Workflow

Each team member works on their own branch and opens a Pull Request to merge into `main`.

```bash
git checkout -b feature/your-name-feature-name
git add .
git commit -m "feat: description of what you did"
git push origin feature/your-name-feature-name
```
