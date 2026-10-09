<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.smartbuilding.model.User" %>
<%@ page import="com.smartbuilding.model.MaintenanceRequest" %>
<%@ page import="com.smartbuilding.dao.MaintenanceRequestDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>

<%
    User user = (User) session.getAttribute("user");

    // Guard route: user must be authenticated
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Retrieve requests from servlet attribute, fallback to DAO
    List<MaintenanceRequest> requests = (List<MaintenanceRequest>) request.getAttribute("requests");
    if (requests == null) {
        MaintenanceRequestDAO dao = new MaintenanceRequestDAO();
        requests = dao.getRequestsByUser(user.getUserId());
    }
    if (requests == null) {
        requests = new ArrayList<MaintenanceRequest>();
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>My Work Orders - Smart Building Maintenance</title>
  <link rel="stylesheet" href="css/style.css">
  <link rel="stylesheet" href="css/dashboard.css">
</head>
<body>

  <div class="dashboard-layout">
    <div class="sidebar-backdrop" id="sidebarBackdrop"></div>

    <!-- ====================================================================
         DARK CONSOLE SIDEBAR
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
          <a href="user-dashboard.jsp" class="sidebar-link">
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
          <a href="user-maintenance" class="sidebar-link active">
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
          Sign Out
        </a>
      </div>
    </aside>

    <!-- ====================================================================
         MAIN CONTENT AREA
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
            <h1>My Maintenance Work Orders</h1>
            <p>Real-time telemetry tracking for your reported incidents</p>
          </div>
        </div>

        <div class="top-header-right">
          <a href="maintenance-request.jsp" class="btn btn-primary btn-sm">
            <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/>
            </svg>
            New Request
          </a>
        </div>
      </header>

      <div class="content-body">
        <!-- Filter and Search Toolbar -->
        <div class="filter-toolbar">
          <div class="search-box">
            <svg class="search-icon" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <circle cx="11" cy="11" r="8"/>
              <line x1="21" y1="21" x2="16.65" y2="16.65"/>
            </svg>
            <input
              type="text"
              id="tableSearchInput"
              class="form-control"
              placeholder="Search by ticket code, title, or category..."
            >
          </div>

          <div class="filter-group">
            <button type="button" class="filter-btn active" data-filter="ALL">All Orders (<%= requests.size() %>)</button>
            <button type="button" class="filter-btn" data-filter="PENDING">Pending</button>
            <button type="button" class="filter-btn" data-filter="IN PROGRESS">In Progress</button>
            <button type="button" class="filter-btn" data-filter="COMPLETED">Completed</button>
          </div>
        </div>

        <!-- Enterprise Table -->
        <div class="panel-card">
          <div class="table-responsive">
            <table class="custom-table">
              <thead>
                <tr>
                  <th>Ticket</th>
                  <th>Incident Title</th>
                  <th>Category</th>
                  <th>Symptoms / Location</th>
                  <th>Current Status</th>
                  <th>Logged Timestamp</th>
                </tr>
              </thead>
              <tbody>
                <%
                    if (!requests.isEmpty()) {
                        for (MaintenanceRequest r : requests) {
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
                  <td>
                    <div class="table-desc-text">
                      <%= r.getDescription() %>
                    </div>
                  </td>
                  <td>
                    <span class="status-badge <%= badgeClass %>"><%= st %></span>
                  </td>
                  <td style="white-space: nowrap; color: var(--text-muted); font-size: 0.8125rem;">
                    <%= r.getCreatedAt() != null ? r.getCreatedAt().toString().substring(0, 16) : "Recent" %>
                  </td>
                </tr>
                <%
                        }
                    } else {
                %>
                <tr class="no-data-row">
                  <td colspan="6">
                    <div class="empty-state">
                      <div class="empty-state-icon">
                        <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                          <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/>
                        </svg>
                      </div>
                      <h3>No Incident Orders Logged</h3>
                      <p>You haven't reported any building maintenance tickets yet.</p>
                      <a href="maintenance-request.jsp" class="btn btn-primary btn-sm">Report a Problem</a>
                    </div>
                  </td>
                </tr>
                <%
                    }
                %>
                <tr class="filter-empty-row" style="display: none;">
                  <td colspan="6">
                    <div class="empty-state" style="padding: 2rem;">
                      <p>No maintenance tickets match your search criteria.</p>
                    </div>
                  </td>
                </tr>
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
