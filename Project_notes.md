# WebTechProject — Quick Notes

---

## For me (Gaspard)

### Start the project
```bash
# 1. Go to project
cd ~/OneDrive/Erasmus2026/WebTechno/WebTechProject

# 2. Compile and deploy
rm -rf target
mvn package
cp target/WebTechProject.war "/c/Users/gaspa/OneDrive/Bureau/apache-tomcat-10.1.53/webapps/"
rm -rf "/c/Users/gaspa/OneDrive/Bureau/apache-tomcat-10.1.53/webapps/WebTechProject"
taskkill //F //IM java.exe
cd "/c/Users/gaspa/OneDrive/Bureau/apache-tomcat-10.1.53/bin"
./startup.bat
```

### Open in browser
```
http://localhost:8080/WebTechProject/events
```

### Git workflow
```bash
# Create a new branch
git checkout -b feature/my-feature

# Commit and push
git add .
git commit -m "feat: description"
git push origin feature/my-feature

# Then open a Pull Request on GitHub to merge into main
```

### Database (PostgreSQL)
- Database name: `smartevent`
- User: `postgres`
- Port: `5432`
- Password: in `src/main/java/com/webtechproject/dao/DBConnection.java`

---

## For teammates

### Prerequisites
- Java 17+
- Maven 3.6+
- PostgreSQL
- Apache Tomcat 10

### 1. Clone the repo
```bash
git clone https://github.com/pedroalemparte/WebTechProject.git
cd WebTechProject
git pull origin main
```

### 2. Create the database
```bash
psql -U postgres
```
```sql
CREATE DATABASE smartevent;
\c smartevent

CREATE TABLE events (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    date_time TIMESTAMP NOT NULL,
    location VARCHAR(255),
    capacity INT,
    price DECIMAL(10,2),
    is_virtual BOOLEAN DEFAULT FALSE,
    organizer_id INT
);

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(50) DEFAULT 'attendee',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
\q
```

### 3. Update your PostgreSQL password
Open `src/main/java/com/webtechproject/dao/DBConnection.java` and replace:
```java
private static final String PASSWORD = "your_password_here";
```
⚠️ Do not push this change to GitHub.

### 4. Compile and deploy
```bash
# Replace /path/to/tomcat/webapps/ with your own Tomcat path
mvn package
cp target/WebTechProject.war /path/to/tomcat/webapps/
rm -rf /path/to/tomcat/webapps/WebTechProject

# Windows
taskkill //F //IM java.exe
/path/to/tomcat/bin/startup.bat

# Mac/Linux
pkill -f tomcat
/path/to/tomcat/bin/startup.sh
```

### 5. Open in browser
```
http://localhost:8080/WebTechProject/events
```