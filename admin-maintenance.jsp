<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.smartbuilding.model.User" %>
<%@ page import="com.smartbuilding.model.MaintenanceRequest" %>
<%@ page import="com.smartbuilding.dao.MaintenanceRequestDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>

<%
    User user = (User) session.getAttribute("user");

    // Guard route: Only ADMIN can access
    if (user == null || !"ADMIN".equalsIgnoreCase(user.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Retrieve requests from servlet attribute, fallback to DAO
    List<MaintenanceRequest> requests = (List<MaintenanceRequest>) request.getAttribute("requests");
    if (requests == null) {
        MaintenanceRequestDAO dao = new MaintenanceRequestDAO();
        requests = dao.getAllRequests();
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
  <title>Manage Work Orders - Admin Console</title>
  <link rel="stylesheet" href="css/style.css">
  <link rel="stylesheet" href="css/dashboard.css">
</head>
<body>

  <div class="dashboard-layout">
    <div class="sidebar-backdrop" id="sidebarBackdrop"></div>

    <!-- ====================================================================
         DARK-SLATE ADMIN SIDEBAR
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
          <a href="admin-dashboard.jsp" class="sidebar-link">
            <svg viewBox="0 0 24 24"><rect x="3" y="3" width="7" height="7"/><rect x="14" y="3" width="7" height="7"/><rect x="14" y="14" width="7" height="7"/><rect x="3" y="14" width="7" height="7"/></svg>
            Dashboard
          </a>
        </li>
        <li class="sidebar-menu-item">
          <a href="admin-maintenance" class="sidebar-link active">
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
            <h1>Building Maintenance Work Orders</h1>
            <p>Supervise tickets, re-assign lifecycle states, and record completions</p>
          </div>
        </div>

        <div class="top-header-right">
          <a href="admin-dashboard.jsp" class="btn btn-secondary btn-sm">&larr; Return to Dashboard</a>
        </div>
      </header>

      <div class="content-body">
        <!-- Status Update Feedback -->
        <% if ("true".equals(request.getParameter("updated"))) { %>
          <div class="alert alert-success">
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/>
              <polyline points="22 4 12 14.01 9 11.01"/>
            </svg>
            Maintenance work order status updated successfully in MySQL database.
          </div>
        <% } else if ("false".equals(request.getParameter("updated"))) { %>
          <div class="alert alert-error">
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <circle cx="12" cy="12" r="10"/>
              <line x1="15" y1="9" x2="9" y2="15"/>
              <line x1="9" y1="9" x2="15" y2="15"/>
            </svg>
            Database update failed. Please verify MySQL connectivity.
          </div>
        <% } %>

        <!-- Filter & Search Toolbar -->
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
              placeholder="Search by ticket code, resident, title, category..."
            >
          </div>

          <div class="filter-group">
            <button type="button" class="filter-btn active" data-filter="ALL">All Work Orders (<%= requests.size() %>)</button>
            <button type="button" class="filter-btn" data-filter="PENDING">Pending</button>
            <button type="button" class="filter-btn" data-filter="IN PROGRESS">In Progress</button>
            <button type="button" class="filter-btn" data-filter="COMPLETED">Completed</button>
          </div>
        </div>

        <!-- Master Telemetry Table -->
        <div class="panel-card">
          <div class="table-responsive">
            <table class="custom-table">
              <thead>
                <tr>
                  <th>Ticket</th>
                  <th>User ID</th>
                  <th>Resident</th>
                  <th>Title</th>
                  <th>Category</th>
                  <th>Description</th>
                  <th>Status</th>
                  <th>Logged Date</th>
                  <th>Status Action</th>
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
                  <td><span class="unit-pill">USR-<%= r.getUserId() %></span></td>
                  <td><strong><%= r.getUserName() != null ? r.getUserName() : ("Resident #" + r.getUserId()) %></strong></td>
                  <td><%= r.getTitle() %></td>
                  <td><span class="category-badge"><%= r.getCategory() %></span></td>
                  <td>
                    <div class="table-desc-text">
                      <%= r.getDescription() %>
                    </div>
                  </td>
                  <td>
                    <span class="status-badge <%= badgeClass %>"><%= st %></span>
                  </td>
                  <td style="white-space: nowrap; font-size: 0.8125rem; color: var(--text-muted);">
                    <%= r.getCreatedAt() != null ? r.getCreatedAt().toString().substring(0, 16) : "Recent" %>
                  </td>
                  <td>
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
                <tr class="no-data-row">
                  <td colspan="9">
                    <div class="empty-state">
                      <h3>No Maintenance Work Orders</h3>
                      <p>No resident incidents are on file.</p>
                    </div>
                  </td>
                </tr>
                <%
                    }
                %>
                <tr class="filter-empty-row" style="display: none;">
                  <td colspan="9">
                    <div class="empty-state" style="padding: 2rem;">
                      <p>No work orders match your search or filter selection.</p>
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