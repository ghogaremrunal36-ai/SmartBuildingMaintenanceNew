<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.smartbuilding.model.User" %>
<%@ page import="com.smartbuilding.model.MaintenanceRequest" %>
<%@ page import="com.smartbuilding.dao.MaintenanceRequestDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>

<%
    User user = (User) session.getAttribute("user");

    // Guard route: redirect to login if session is absent
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Load maintenance requests for this user
    MaintenanceRequestDAO dao = new MaintenanceRequestDAO();
    List<MaintenanceRequest> userRequests = dao.getRequestsByUser(user.getUserId());
    if (userRequests == null) {
        userRequests = new ArrayList<MaintenanceRequest>();
    }

    int totalRequests = userRequests.size();
    int pendingRequests = 0;
    int inProgressRequests = 0;
    int completedRequests = 0;

    for (MaintenanceRequest r : userRequests) {
        String st = r.getStatus() != null ? r.getStatus().trim().toUpperCase() : "";
        if ("PENDING".equals(st)) {
            pendingRequests++;
        } else if ("IN PROGRESS".equals(st)) {
            inProgressRequests++;
        } else if ("COMPLETED".equals(st)) {
            completedRequests++;
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Resident Portal - Smart Building Maintenance System</title>
  <link rel="stylesheet" href="css/style.css">
  <link rel="stylesheet" href="css/dashboard.css">
</head>
<body>

  <div class="dashboard-layout">
    <div class="sidebar-backdrop" id="sidebarBackdrop"></div>

    <!-- ====================================================================
         DARK-SLATE CONSOLE SIDEBAR
         ==================================================================== -->
    <aside class="sidebar">
      <div class="sidebar-header">
        <div class="sidebar-brand-icon">
          <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2">
            <path d="M3 21h18"/>
            <path d="M5 21V5a2 2 0 0 1 2-2h10a2 2 0 0 1 2 2v16"/>
            <path d="M9 9h1M9 13h1M9 17h1M14 9h1M14 13h1M14 17h1"/>
          </svg>
        </div>
        <div class="sidebar-brand-text">
          <h2>Smart Building</h2>
          <span>Resident Console</span>
        </div>
      </div>

      <div class="sidebar-facility-pill">
        <span>Assigned Facility:</span>
        <strong>Horizon Tower</strong>
      </div>

      <ul class="sidebar-menu">
        <li class="sidebar-menu-item">
          <a href="user-dashboard.jsp" class="sidebar-link active">
            <svg viewBox="0 0 24 24"><rect x="3" y="3" width="7" height="7"/><rect x="14" y="3" width="7" height="7"/><rect x="14" y="14" width="7" height="7"/><rect x="3" y="14" width="7" height="7"/></svg>
            Dashboard
          </a>
        </li>
        <li class="sidebar-menu-item">
          <a href="maintenance-request.jsp" class="sidebar-link">
            <svg viewBox="0 0 24 24"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>
            Submit Request
          </a>
        </li>
        <li class="sidebar-menu-item">
          <a href="user-maintenance" class="sidebar-link">
            <svg viewBox="0 0 24 24"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/><line x1="16" y1="13" x2="8" y2="13"/><line x1="16" y1="17" x2="8" y2="17"/></svg>
            My Requests
          </a>
        </li>
      </ul>

      <div class="sidebar-footer">
        <div class="sidebar-user-brief">
          <div class="user-avatar">
            <%= user.getName() != null && user.getName().length() > 0 ? user.getName().substring(0, 1).toUpperCase() : "R" %>
          </div>
          <div class="user-details">
            <div class="user-name"><%= user.getName() %></div>
            <div class="user-email"><%= user.getEmail() %></div>
          </div>
        </div>

        <a href="logout" class="btn btn-secondary btn-block btn-sm" style="background: rgba(255,255,255,0.08); border-color: rgba(255,255,255,0.12); color: #ffffff !important;">
          <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/>
            <polyline points="16 17 21 12 16 7"/>
            <line x1="21" y1="12" x2="9" y2="12"/>
          </svg>
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
            <h1>Resident Operations Console</h1>
            <p>Welcome back, <strong><%= user.getName() %></strong> &bull; <%= user.getEmail() %></p>
          </div>
        </div>

        <div class="top-header-right">
          <span class="system-status-indicator">
            <span></span> Live Dispatch Online
          </span>
          <a href="maintenance-request.jsp" class="btn btn-primary btn-sm">
            <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/>
            </svg>
            Log Problem
          </a>
        </div>
      </header>

      <div class="content-body">
        <!-- Submission Feedback Banner -->
        <% if ("true".equals(request.getParameter("requestSubmitted"))) { %>
          <div class="alert alert-success">
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/>
              <polyline points="22 4 12 14.01 9 11.01"/>
            </svg>
            <div>
              <strong>Maintenance request submitted successfully!</strong>
              <div style="font-size: 0.8125rem;">Your ticket has been logged with initial status <strong>PENDING</strong> and routed to the facility maintenance crew.</div>
            </div>
          </div>
        <% } %>

        <!-- Bento KPI Grid -->
        <section class="bento-kpi-grid">
          <!-- Total -->
          <div class="bento-kpi-card">
            <div class="kpi-top">
              <span class="kpi-label">Total Requests</span>
              <div class="kpi-icon-pill kpi-icon-blue">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/></svg>
              </div>
            </div>
            <div class="kpi-val"><%= totalRequests %></div>
            <div class="kpi-meter"><div class="kpi-meter-fill" style="width: 100%; background: #2563eb;"></div></div>
            <div class="kpi-sla"><span>Lifetime Unit History</span><span>100%</span></div>
          </div>

          <!-- Pending -->
          <div class="bento-kpi-card">
            <div class="kpi-top">
              <span class="kpi-label">Pending</span>
              <div class="kpi-icon-pill kpi-icon-amber">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
              </div>
            </div>
            <div class="kpi-val"><%= pendingRequests %></div>
            <div class="kpi-meter"><div class="kpi-meter-fill" style="width: <%= totalRequests > 0 ? (pendingRequests * 100 / totalRequests) : 0 %>%; background: #f59e0b;"></div></div>
            <div class="kpi-sla"><span>Awaiting Technician Triage</span><span>Queue</span></div>
          </div>

          <!-- In Progress -->
          <div class="bento-kpi-card">
            <div class="kpi-top">
              <span class="kpi-label">In Progress</span>
              <div class="kpi-icon-pill kpi-icon-indigo">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/></svg>
              </div>
            </div>
            <div class="kpi-val"><%= inProgressRequests %></div>
            <div class="kpi-meter"><div class="kpi-meter-fill" style="width: <%= totalRequests > 0 ? (inProgressRequests * 100 / totalRequests) : 0 %>%; background: #4f46e5;"></div></div>
            <div class="kpi-sla"><span>Active Repair Work</span><span>Active</span></div>
          </div>

          <!-- Completed -->
          <div class="bento-kpi-card">
            <div class="kpi-top">
              <span class="kpi-label">Completed</span>
              <div class="kpi-icon-pill kpi-icon-emerald">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg>
              </div>
            </div>
            <div class="kpi-val"><%= completedRequests %></div>
            <div class="kpi-meter"><div class="kpi-meter-fill" style="width: <%= totalRequests > 0 ? (completedRequests * 100 / totalRequests) : 0 %>%; background: #10b981;"></div></div>
            <div class="kpi-sla"><span>Verified &amp; Resolved</span><span>Closed</span></div>
          </div>
        </section>

        <!-- Quick Launch Bar -->
        <div style="display: flex; gap: 0.85rem; margin-bottom: 2rem; flex-wrap: wrap;">
          <a href="maintenance-request.jsp" class="btn btn-primary" style="padding: 0.75rem 1.4rem;">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/>
            </svg>
            Submit Maintenance Request
          </a>
          <a href="user-maintenance" class="btn btn-secondary" style="padding: 0.75rem 1.4rem;">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/>
            </svg>
            My Maintenance Requests
          </a>
          <a href="logout" class="btn btn-outline" style="padding: 0.75rem 1.4rem; margin-left: auto;">
            Sign Out
          </a>
        </div>

        <!-- Recent Incident Ledger -->
        <div class="panel-card">
          <div class="panel-header">
            <div class="panel-title">
              <h2>Recent Unit Work Orders</h2>
              <p>Chronological incident logs submitted from your account</p>
            </div>
            <a href="user-maintenance" class="btn btn-secondary btn-sm">Full Work Order Ledger &rarr;</a>
          </div>

          <div class="table-responsive">
            <table class="custom-table">
              <thead>
                <tr>
                  <th>Ticket</th>
                  <th>Issue Summary</th>
                  <th>Category</th>
                  <th>Telemetry Status</th>
                  <th>Timestamp</th>
                </tr>
              </thead>
              <tbody>
                <%
                    if (!userRequests.isEmpty()) {
                        int limit = Math.min(5, userRequests.size());
                        for (int i = 0; i < limit; i++) {
                            MaintenanceRequest r = userRequests.get(i);
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
                  <td><strong><%= r.getTitle() %></strong></td>
                  <td><span class="category-badge"><%= r.getCategory() %></span></td>
                  <td><span class="status-badge <%= badgeClass %>"><%= st %></span></td>
                  <td style="white-space: nowrap; font-size: 0.8125rem; color: var(--text-muted);">
                    <%= r.getCreatedAt() != null ? r.getCreatedAt().toString().substring(0, 16) : "Recent" %>
                  </td>
                </tr>
                <%
                        }
                    } else {
                %>
                <tr>
                  <td colspan="5">
                    <div class="empty-state">
                      <div class="empty-state-icon">
                        <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                          <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/>
                        </svg>
                      </div>
                      <h3>No Incident Logs Reported</h3>
                      <p>You haven't submitted any building maintenance tickets yet.</p>
                      <a href="maintenance-request.jsp" class="btn btn-primary btn-sm">Submit First Request</a>
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
</body>
</html>