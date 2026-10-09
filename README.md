# SMART BUILDING MAINTENANCE SYSTEM

A complete, modern, responsive web-based facility management system built for residential buildings. Residents can report maintenance problems in real time, and building administrators can supervise, assign, track, and update request statuses.

---

## 🛠 Technology Stack
- **Frontend**: HTML5, CSS3 (Custom Design System, Flexbox, Grid), Vanilla JavaScript (Zero external dependencies)
- **Backend**: Java 17+, JSP (JavaServer Pages), Java Servlets (Servlet 3.1+ `@WebServlet` architecture)
- **Database**: MySQL 5.7+ / 8.0+
- **JDBC Driver**: MySQL Connector/J (`mysql-connector-j-26.7.0.jar`)
- **Web Application Server**: Apache Tomcat 9.0+
- **IDE**: NetBeans / Eclipse / IntelliJ IDEA

---

## 🗄️ Database Architecture & Setup

### 1. Database Credentials
Configured in `src/java/com/smartbuilding/util/DBConnection.java`:
- **Database Name**: `smart_building_new`
- **URL**: `jdbc:mysql://localhost:3306/smart_building_new?useSSL=false&serverTimezone=UTC`
- **Username**: `root`
- **Password**: `fycs` *(adjust if your local MySQL root password differs)*

### 2. Import Schema & Seed Records
Run the SQL script located at `database/schema.sql` via MySQL Workbench, phpMyAdmin, or MySQL CLI:
```bash
mysql -u root -p < database/schema.sql
```

The script automatically provisions:
1. `users` table (`user_id`, `name`, `email`, `password`, `phone`, `role`, `created_at`)
2. `maintenance_requests` table (`request_id`, `user_id`, `title`, `description`, `category`, `status`, `created_at`)
3. Pre-seeded demo administrators, resident accounts, and sample maintenance tickets across all categories.

---

## 🔑 Default Demo Accounts

| Role | Email | Password | Access Level |
|---|---|---|---|
| **ADMIN** | `admin@smartbuilding.com` | `admin123` | Full control dashboard, all tickets, status updates, user directory |
| **ADMIN** | `manager@smartbuilding.com` | `manager123` | Building operations management |
| **USER** | `john@gmail.com` | `user123` | Resident portal, report issues, personal ticket history |
| **USER** | `sarah@gmail.com` | `user123` | Resident portal |

> **Tip**: On `login.jsp`, clickable demo chips are provided to instantly auto-fill credentials for presentations and quick testing.

---

## 🌐 Application Navigation & Endpoints

### Public Pages
- `index.html` / `index.jsp`: Landing Page with brand hero, features, workflow, and portal links.
- `login.jsp` &rarr; `POST /login`: Secure authentication forwarding to Admin or User Dashboard.
- `register.jsp` &rarr; `POST /register`: Resident registration with live validation.
- `GET /logout`: Session termination & redirect to Home.

### Resident / User Experience
- `user-dashboard.jsp`: Summary metrics (Total, Pending, In Progress, Completed) and recent tickets.
- `maintenance-request.jsp` &rarr; `POST /maintenance-request`: Submission form with category selection. Initial status: **PENDING**.
- `GET /user-maintenance` &rarr; `user-maintenance.jsp`: Filterable table of personal requests with colored status badges.

### Administrator Experience
- `admin-dashboard.jsp`: Operational control center with 5 metrics, SVG status donut chart, and category bar chart.
- `GET /admin-maintenance` &rarr; `admin-maintenance.jsp`: All building tickets with inline status update dropdown (`POST /update-maintenance-status`).
- `GET /admin-users` &rarr; `admin-users.jsp`: Registered resident & admin directory.

---

## 🚀 How to Build & Run in NetBeans / Tomcat 9

1. Open **NetBeans IDE**.
2. Click **File &rarr; Open Project** and select `SmartBuildingMaintenanceNew`.
3. Verify the Apache Tomcat 9 server is registered under **Services &rarr; Servers**.
4. Right-click the project &rarr; **Clean and Build**.
5. Right-click the project &rarr; **Run**.
6. Access in your browser:
   ```
   http://localhost:8080/SmartBuildingMaintenanceNew/
   ```

---

## 📁 Project Directory Structure
```
SmartBuildingMaintenanceNew/
├── build.xml
├── database/
│   └── schema.sql                          # MySQL database creation & seed data
├── src/java/com/smartbuilding/
│   ├── controller/
│   │   ├── AdminMaintenanceServlet.java    # /admin-maintenance
│   │   ├── AdminUsersServlet.java          # /admin-users
│   │   ├── LoginServlet.java               # /login
│   │   ├── LogoutServlet.java              # /logout
│   │   ├── MaintenanceRequestServlet.java  # /maintenance-request
│   │   ├── RegisterServlet.java            # /register
│   │   ├── UpdateMaintenanceStatusServlet.java # /update-maintenance-status
│   │   └── UserMaintenanceServlet.java     # /user-maintenance
│   ├── dao/
│   │   ├── MaintenanceRequestDAO.java      # CRUD, counts, and category aggregations
│   │   └── UserDAO.java                    # Auth, registration, and user listings
│   ├── model/
│   │   ├── MaintenanceRequest.java         # Ticket entity model
│   │   └── User.java                       # User entity model
│   └── util/
│       └── DBConnection.java               # JDBC database connector
└── web/
    ├── css/
    │   ├── style.css                       # Core design system, cards, forms, badges
    │   └── dashboard.css                   # Layout, sidebar, charts, metrics, tables
    ├── js/
    │   ├── app.js                          # Mobile menu, live table filters, form checks
    │   └── charts.js                       # Pure SVG status donut & category bar charts
    ├── WEB-INF/
    │   └── web.xml                         # Welcome files and session settings
    ├── index.html                          # Landing page
    ├── index.jsp                           # Forward to index.html
    ├── login.jsp                           # Sign-in portal
    ├── register.jsp                        # Sign-up portal
    ├── user-dashboard.jsp                  # Resident dashboard
    ├── maintenance-request.jsp             # Ticket submission form
    ├── user-maintenance.jsp                # Personal tickets table
    ├── admin-dashboard.jsp                 # Admin control center
    ├── admin-maintenance.jsp               # Admin request management
    └── admin-users.jsp                     # Registered users directory
```
