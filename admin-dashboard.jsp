<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.smartbuilding.model.User" %>
<%@ page import="com.smartbuilding.model.MaintenanceRequest" %>
<%@ page import="com.smartbuilding.dao.MaintenanceRequestDAO" %>
<%@ page import="com.smartbuilding.dao.UserDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>

<%
    User user = (User) session.getAttribute("user");

    // Guard route: only ADMIN can access
    if (user == null || !"ADMIN".equalsIgnoreCase(user.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Retrieve system statistics from DAOs
    MaintenanceRequestDAO requestDao = new MaintenanceRequestDAO();
    UserDAO userDao = new UserDAO();

    List<MaintenanceRequest> allRequests = requestDao.getAllRequests();
    if (allRequests == null) {
        allRequests = new ArrayList<MaintenanceRequest>();
    }

    int totalRequests = allRequests.size();
    int pendingRequests = 0;
    int inProgressRequests = 0;
    int completedRequests = 0;

    int countElectrical = 0;
    int countPlumbing = 0;
    int countAC = 0;
    int countLift = 0;
    int countCleaning = 0;
    int countOther = 0;

    for (MaintenanceRequest r : allRequests) {
        String st = r.getStatus() != null ? r.getStatus().trim().toUpperCase() : "";
        if ("PENDING".equals(st)) {
            pendingRequests++;
        } else if ("IN PROGRESS".equals(st)) {
            inProgressRequests++;
        } else if ("COMPLETED".equals(st)) {
            completedRequests++;
        }

        String cat = r.getCategory() != null ? r.getCategory().trim().toLowerCase() : "";
        if (cat.contains("electric")) countElectrical++;
        else if (cat.contains("plumb")) countPlumbing++;
        else if (cat.contains("air") || cat.contains("ac")) countAC++;
        else if (cat.contains("lift") || cat.contains("elevator")) countLift++;
        else if (cat.contains("clean")) countCleaning++;
        else countOther++;
    }

    int totalUsers = userDao.getTotalUsersCount();
    if (totalUsers == 0) totalUsers = 1;
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Admin Operations Console - Smart Building Maintenance</title>
  <link rel="stylesheet" href="css/style.css">
  <link rel="stylesheet" href="css/dashboard.css">
</head>
<body>

  <div class="dashboard-layout">
    <div class="sidebar-backdrop" id="sidebarBackdrop"></div>

    <!-- ====================================================================
         DARK-SLATE ADMIN CONSOLE SIDEBAR
         ==================================================================== -->
    <aside class="sidebar">
      <div class="sidebar-header">
        <div class="sidebar-brand-icon" style="background: linear-gradient(135deg, #4338ca 0%, #2563eb 100%);">
          <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2">
            <path d="M3 21h18"/>
            <path d="M5 21V5a2 2 0 0 1 2-2h10a2 2 0 0 1 2 2v16"/>
            <path d="M9 9h1M9 13h1M9 17h1M14 9h1M14 13h1M14 17h1"/>
          </svg>
        </div>
        <div class="sidebar-brand-text">
          <h2>Smart Building</h2>
          <span>Admin Operations</span>
        </div>
      </div>

      <div class="sidebar-facility-pill">
        <span>Facility Authority:</span>
        <strong style="color: #93c5fd;">Horizon Tower</strong>
      </div>

      <ul class="sidebar-menu">
        <li class="sidebar-menu-item">
          <a href="admin-dashboard.jsp" class="sidebar-link active">
            <svg viewBox="0 0 24 24"><rect x="3" y="3" width="7" height="7"/><rect x="14" y="3" width="7" height="7"/><rect x="14" y="14" width="7" height="7"/><rect x="3" y="14" width="7" height="7"/></svg>
            Dashboard
          </a>
        </li>
        <li class="sidebar-menu-item">
          <a href="admin-maintenance" class="sidebar-link">
            <svg viewBox="0 0 24 24"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/><line x1="16" y1="13" x2="8" y2="13"/><line x1="16" y1="17" x2="8" y2="17"/></svg>
            Maintenance Requests
          </a>
        </li>
        <li class="sidebar-menu-item">
          <a href="admin-users" class="sidebar-link">
            <svg viewBox="0 0 24 24"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M23 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg>
            Users
          </a>
        </li>
      </ul>

      <div class="sidebar-footer">
        <div class="sidebar-user-brief">
          <div class="user-avatar" style="background: #4338ca; color: #ffffff;">
            <%= user.getName() != null && user.getName().length() > 0 ? user.getName().substring(0, 1).toUpperCase() : "A" %>
          </div>
          <div class="user-details">
            <div class="user-name"><%= user.getName() %></div>
            <div class="user-email"><%= user.getEmail() %></div>
          </div>
        </div>

        <a href="logout" class="btn btn-secondary btn-block btn-sm" style="background: rgba(255,255,255,0.08); border-color: rgba(255,255,255,0.12); color: #ffffff !important;">
          Sign Out
        </a>
      </div>
    </aside>

    <!-- ====================================================================
         OPERATIONS CANVAS
         ==================================================================== -->
    <main class="main-content">
      <header class="top-header">
        <div class="top-header-left">
          <button class="mobile-menu-toggle" id="mobileMenuToggle" aria-label="Toggle navigation">
            <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <line x1="3" y1="12" x2="21" y2="12"/>
              <line x1="3" y1="6" x2="21" y2="6"/>
              <line x1="3" y1="18" x2="21" y2="18"/>
            </svg>
          </button>
          <div class="page-title">
            <h1>Building Operations Console</h1>
            <p>Welcome, <strong><%= user.getName() %></strong> &bull; Horizon Tower Master Controller</p>
          </div>
        </div>

        <div class="top-header-right">
          <span class="system-status-indicator">
            <span></span> Facility Central Online
          </span>
          <a href="admin-maintenance" class="btn btn-primary btn-sm">
            Manage Work Orders
          </a>
        </div>
      </header>

      <div class="content-body">
        <!-- Bento KPI Grid (5 Cards) -->
        <section class="bento-kpi-grid" style="grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));">
          <!-- 1. Total Requests -->
          <div class="bento-kpi-card">
            <div class="kpi-top">
              <span class="kpi-label">Total Requests</span>
              <div class="kpi-icon-pill kpi-icon-blue">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/></svg>
              </div>
            </div>
            <div class="kpi-val"><%= totalRequests %></div>
            <div class="kpi-meter"><div class="kpi-meter-fill" style="width: 100%; background: #2563eb;"></div></div>
            <div class="kpi-sla"><span>Across All Units</span><span>100%</span></div>
          </div>

          <!-- 2. Pending -->
          <div class="bento-kpi-card">
            <div class="kpi-top">
              <span class="kpi-label">Pending</span>
              <div class="kpi-icon-pill kpi-icon-amber">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
              </div>
            </div>
            <div class="kpi-val"><%= pendingRequests %></div>
            <div class="kpi-meter"><div class="kpi-meter-fill" style="width: <%= totalRequests > 0 ? (pendingRequests * 100 / totalRequests) : 0 %>%; background: #f59e0b;"></div></div>
            <div class="kpi-sla"><span>Triage Backlog</span><span>Needs Review</span></div>
          </div>

          <!-- 3. In Progress -->
          <div class="bento-kpi-card">
            <div class="kpi-top">
              <span class="kpi-label">In Progress</span>
              <div class="kpi-icon-pill kpi-icon-indigo">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/></svg>
              </div>
            </div>
            <div class="kpi-val"><%= inProgressRequests %></div>
            <div class="kpi-meter"><div class="kpi-meter-fill" style="width: <%= totalRequests > 0 ? (inProgressRequests * 100 / totalRequests) : 0 %>%; background: #4f46e5;"></div></div>
            <div class="kpi-sla"><span>Dispatched Crews</span><span>Active</span></div>
          </div>

          <!-- 4. Completed -->
          <div class="bento-kpi-card">
            <div class="kpi-top">
              <span class="kpi-label">Completed</span>
              <div class="kpi-icon-pill kpi-icon-emerald">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg>
              </div>
            </div>
            <div class="kpi-val"><%= completedRequests %></div>
            <div class="kpi-meter"><div class="kpi-meter-fill" style="width: <%= totalRequests > 0 ? (completedRequests * 100 / totalRequests) : 0 %>%; background: #10b981;"></div></div>
            <div class="kpi-sla"><span>Closed Orders</span><span>Verified</span></div>
          </div>

          <!-- 5. Total Users -->
          <div class="bento-kpi-card">
            <div class="kpi-top">
              <span class="kpi-label">Total Users</span>
              <div class="kpi-icon-pill kpi-icon-purple">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/></svg>
              </div>
            </div>
            <div class="kpi-val"><%= totalUsers %></div>
            <div class="kpi-meter"><div class="kpi-meter-fill" style="width: 100%; background: #9333ea;"></div></div>
            <div class="kpi-sla"><span>Registered Accounts</span><span>Active</span></div>
          </div>
        </section>

        <!-- Visual Analytics Grid -->
        <div class="charts-grid">
          <!-- Status Donut Chart -->
          <div class="chart-card">
            <div class="chart-header">
              <h3>Work Order Status Telemetry</h3>
              <span class="status-badge status-progress">Live Distribution</span>
            </div>
            <div
              class="chart-container"
              id="statusChartContainer"
              data-pending="<%= pendingRequests %>"
              data-progress="<%= inProgressRequests %>"
              data-completed="<%= completedRequests %>"
            ></div>
          </div>

          <!-- Category Bar Chart -->
          <div class="chart-card">
            <div class="chart-header">
              <h3>Category Load Distribution</h3>
              <span class="status-badge status-pending">Incident Breakdown</span>
            </div>
            <div
              class="chart-container"
              id="categoryChartContainer"
              data-categories='[
                {"name":"Electrical","count":<%= countElectrical %>},
                {"name":"Plumbing","count":<%= countPlumbing %>},
                {"name":"Air Conditioning","count":<%= countAC %>},
                {"name":"Lift / Elevator","count":<%= countLift %>},
                {"name":"Cleaning","count":<%= countCleaning %>},
                {"name":"Other","count":<%= countOther %>}
              ]'
            ></div>
          </div>
        </div>

        <!-- Recent Incidents Table -->
        <div class="panel-card">
          <div class="panel-header">
            <div class="panel-title">
              <h2>Recent Building Incidents</h2>
              <p>Work orders requiring technician dispatch or status review</p>
            </div>
            <a href="admin-maintenance" class="btn btn-secondary btn-sm">All Work Orders &rarr;</a>
          </div>

          <div class="table-responsive">
            <table class="custom-table">
              <thead>
                <tr>
                  <th>Ticket</th>
                  <th>Resident</th>
                  <th>Incident Title</th>
                  <th>Category</th>
                  <th>Status</th>
                  <th>Date</th>
                  <th>Quick Action</th>
                </tr>
              </thead>
              <tbody>
                <%
                    if (!allRequests.isEmpty()) {
                        int limit = Math.min(6, allRequests.size());
                        for (int i = 0; i < limit; i++) {
                            MaintenanceRequest r = allRequests.get(i);
                            String st = r.getStatus() != null ? r.getStatus().trim() : "PENDING";
                            String badgeClass = "status-pending";
                            if ("IN PROGRESS".equalsIgnoreCase(st)) {
                                badgeClass = "status-in-progress";
                            } else if ("COMPLETED".equalsIgnoreCase(st)) {
                                badgeClass = "status-completed";
                            }
                %>
                <tr>
                  <td><span class="ticket-code">#TK-<%= r.getRequestId() %></span></td>
                  <td><strong><%= r.getUserName() != null ? r.getUserName() : ("User #" + r.getUserId()) %></strong></td>
                  <td><%= r.getTitle() %></td>
                  <td><span class="category-badge"><%= r.getCategory() %></span></td>
                  <td><span class="status-badge <%= badgeClass %>"><%= st %></span></td>
                  <td style="white-space: nowrap; font-size: 0.8125rem; color: var(--text-muted);">
                    <%= r.getCreatedAt() != null ? r.getCreatedAt().toString().substring(0, 16) : "Recent" %>
                  </td>
                  <td>
                    <!-- Inline update form -->
                    <form action="update-maintenance-status" method="post" class="status-update-form">
                      <input type="hidden" name="requestId" value="<%= r.getRequestId() %>">
                      <select name="status" class="status-select-sm">
                        <option value="PENDING" <%= "PENDING".equalsIgnoreCase(st) ? "selected" : "" %>>PENDING</option>
                        <option value="IN PROGRESS" <%= "IN PROGRESS".equalsIgnoreCase(st) ? "selected" : "" %>>IN PROGRESS</option>
                        <option value="COMPLETED" <%= "COMPLETED".equalsIgnoreCase(st) ? "selected" : "" %>>COMPLETED</option>
                      </select>
                      <button type="submit" class="btn btn-primary btn-sm">Update</button>
                    </form>
                  </td>
                </tr>
                <%
                        }
                    } else {
                %>
                <tr>
                  <td colspan="7">
                    <div class="empty-state">
                      <h3>No Incidents Recorded</h3>
                      <p>All building operations are currently optimal.</p>
                    </div>
                  </td>
                </tr>
                <%
                    }
                %>
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </main>
  </div>

  <script src="js/app.js"></script>
  <script src="js/charts.js"></script>
</body>
</html>