# Smart College Lost & Found Management System

A web-based campus lost and found portal built with Java Servlets, JSP, JDBC, and MySQL. It features student authentication, classroom-based item tagging, category filtering, and an anonymous real-time chat system that allows finders and owners to coordinate securely without exposing personal emails or phone numbers.

---

## 🛠️ Tech Stack
- **Backend:** Java 17, Jakarta Servlets 6.0, JDBC
- **Frontend:** JSP, HTML5, CSS3 (Clean White & Light Blue Theme), Vanilla JavaScript (AJAX Polling)
- **Database:** MySQL 8.0+
- **Build Tool:** Apache Maven
- **Deployment:** Docker / Tomcat 10 on Render or Railway

---

## 📁 Project Structure
```text
smart-college-lost-found/
├── pom.xml                               # Maven project configuration
├── Dockerfile                            # Docker container for 1-click cloud deployment
├── src/
│   └── main/
│       ├── java/com/college/lostfound/
│       │   ├── config/DBConnection.java  # JDBC connection pool configuration
│       │   ├── model/                    # User, Item, Message data models
│       │   ├── dao/                      # UserDAO, ItemDAO, ChatDAO database operations
│       │   └── controller/               # AuthServlet, ItemServlet, ChatServlet
│       ├── resources/
│       │   └── schema.sql                # MySQL Database schema
│       └── webapp/
│           ├── WEB-INF/web.xml           # Servlet mapping descriptor
│           ├── assets/css/style.css      # Custom clean academic UI styling
│           ├── index.jsp                 # Item notice board & search/filtering
│           ├── item-details.jsp          # Detailed item view
│           ├── post-item.jsp             # Report found or lost item
│           ├── chat.jsp                  # Anonymous 1-to-1 chat room
│           ├── login.jsp                 # Student sign in
│           └── register.jsp              # Student account creation
└── README.md
```

---

## ⚡ Setup & Run Locally

### 1. Database Setup
1. Open MySQL Workbench or MySQL CLI:
```sql
CREATE DATABASE IF NOT EXISTS college_lost_found;
```
2. Run the SQL script from `src/main/resources/schema.sql`.

### 2. Configure Database Credentials
Edit `src/main/java/com/college/lostfound/config/DBConnection.java` or set environment variables:
- `DB_URL` (default: `jdbc:mysql://localhost:3306/college_lost_found?useSSL=false&allowPublicKeyRetrieval=true`)
- `DB_USER` (default: `root`)
- `DB_PASS` (default: `root`)

### 3. Build & Run
Run with Maven:
```bash
mvn clean package
```
Deploy the generated `ROOT.war` file into Apache Tomcat 10 (`webapps/` folder) and access `http://localhost:8080/`.

---

## 🌐 1-Click Free Cloud Deployment (Render + Free MySQL)

### Step 1: Free Cloud Database
1. Go to [TiDB Cloud](https://tidbcloud.com/) or [Aiven](https://aiven.io/) (Free tier MySQL compatible).
2. Create a free database instance.
3. In their web SQL editor, execute `schema.sql`.
4. Copy the host, username, and password.

### Step 2: Push to GitHub
```bash
git init
git add .
git commit -m "Initial commit for Smart College Lost and Found"
git branch -M main
git remote add origin <your-github-repo-url>
git push -u origin main
```

### Step 3: Deploy on Render.com
1. Go to [Render.com](https://render.com) and log in.
2. Click **New +** -> **Web Service**.
3. Connect your GitHub repository.
4. Select **Docker** environment.
5. In **Environment Variables**, add:
   - `DB_URL`: `jdbc:mysql://<cloud-db-host>:4000/college_lost_found?sslMode=VERIFY_IDENTITY`
   - `DB_USER`: `<your-db-user>`
   - `DB_PASS`: `<your-db-password>`
6. Click **Deploy Web Service**.
Your live application will be available at `https://<your-app>.onrender.com`.
