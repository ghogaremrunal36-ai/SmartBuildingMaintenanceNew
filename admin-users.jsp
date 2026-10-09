<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.smartbuilding.model.User" %>
<%@ page import="com.smartbuilding.dao.UserDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>

<%
    User user = (User) session.getAttribute("user");

    // Guard route: Only ADMIN can access
    if (user == null || !"ADMIN".equalsIgnoreCase(user.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Retrieve users list from servlet attribute or direct DAO fallback
    List<User> users = (List<User>) request.getAttribute("users");
    if (users == null) {
        UserDAO dao = new UserDAO();
        users = dao.getAllUsers();
    }
    if (users == null) {
        users = new ArrayList<User>();
    }

    int adminCount = 0;
    int residentCount = 0;
    for (User u : users) {
        if ("ADMIN".equalsIgnoreCase(u.getRole())) {
            adminCount++;
        } else {
            residentCount++;
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>User &amp; Resident Directory - Admin Console</title>
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
          <a href="admin-maintenance" class="sidebar-link">
            <svg viewBox="0 0 24 24"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/><line x1="16" y1="13" x2="8" y2="13"/><line x1="16" y1="17" x2="8" y2="17"/></svg>
            Maintenance Requests
          </a>
        </li>
        <li class="sidebar-menu-item">
          <a href="admin-users" class="sidebar-link active">
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
            <h1>Building Resident &amp; Staff Directory</h1>
            <p>Master registry of authorized unit tenants, technicians, and system administrators</p>
          </div>
        </div>

        <div class="top-header-right">
          <a href="admin-dashboard.jsp" class="btn btn-secondary btn-sm">&larr; Return to Dashboard</a>
        </div>
      </header>

      <div class="content-body">
        <!-- Summary Chips -->
        <div style="display: flex; gap: 1rem; margin-bottom: 1.5rem; flex-wrap: wrap;">
          <div style="background: #ffffff; border: 1px solid var(--border-hairline); padding: 0.65rem 1.15rem; border-radius: var(--radius-sm); display: flex; align-items: center; gap: 8px;">
            <span style="color: var(--text-muted); font-size: 0.8125rem; font-weight: 600;">Total Users:</span>
            <span style="font-weight: 800; font-size: 1.1rem; color: var(--text-main);"><%= users.size() %></span>
          </div>

          <div style="background: #ffffff; border: 1px solid var(--border-hairline); padding: 0.65rem 1.15rem; border-radius: var(--radius-sm); display: flex; align-items: center; gap: 8px;">
            <span style="color: var(--text-muted); font-size: 0.8125rem; font-weight: 600;">Verified Residents:</span>
            <span style="font-weight: 800; font-size: 1.1rem; color: #0284c7;"><%= residentCount %></span>
          </div>

          <div style="background: #ffffff; border: 1px solid var(--border-hairline); padding: 0.65rem 1.15rem; border-radius: var(--radius-sm); display: flex; align-items: center; gap: 8px;">
            <span style="color: var(--text-muted); font-size: 0.8125rem; font-weight: 600;">System Admins:</span>
            <span style="font-weight: 800; font-size: 1.1rem; color: #7c3aed;"><%= adminCount %></span>
          </div>
        </div>

        <!-- Filter Search Bar -->
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
              placeholder="Search user by name, email, phone, or role..."
            >
          </div>
        </div>

        <!-- Directory Table -->
        <div class="panel-card">
          <div class="table-responsive">
            <table class="custom-table">
              <thead>
                <tr>
                  <th>User ID</th>
                  <th>Name / Unit</th>
                  <th>Contact Email</th>
                  <th>Phone Number</th>
                  <th>System Role</th>
                  <th>Account Created</th>
                </tr>
              </thead>
              <tbody>
                <%
                    if (!users.isEmpty()) {
                        for (User u : users) {
                            String rRole = u.getRole() != null ? u.getRole().trim().toUpperCase() : "USER";
                            String roleBadgeClass = "ADMIN".equals(rRole) ? "role-admin" : "role-user";
                %>
                <tr>
                  <td><span class="unit-pill">USR-<%= u.getUserId() %></span></td>
                  <td><strong><%= u.getName() %></strong></td>
                  <td style="color: var(--text-muted);"><%= u.getEmail() %></td>
                  <td><%= u.getPhone() != null ? u.getPhone() : "N/A" %></td>
                  <td>
                    <span class="role-badge <%= roleBadgeClass %>"><%= rRole %></span>
                  </td>
                  <td style="white-space: nowrap; font-size: 0.8125rem; color: var(--text-muted);">
                    <%= u.getCreatedAt() != null ? u.getCreatedAt().toString().substring(0, 16) : "Active Account" %>
                  </td>
                </tr>
                <%
                        }
                    } else {
                %>
                <tr class="no-data-row">
                  <td colspan="6">
                    <div class="empty-state">
                      <h3>No User Records Found</h3>
                      <p>The database user table contains no rows.</p>
                    </div>
                  </td>
                </tr>
                <%
                    }
                %>
                <tr class="filter-empty-row" style="display: none;">
                  <td colspan="6">
                    <div class="empty-state" style="padding: 2rem;">
                      <p>No registered users match your search keyword.</p>
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
