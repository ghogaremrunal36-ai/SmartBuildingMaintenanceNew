<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Sign In - Smart Building Maintenance System</title>
  <link rel="stylesheet" href="css/style.css">
</head>
<body>

  <div class="auth-split-container">
    <!-- ==================================================================
         LEFT SHOWCASE PANEL (TELEMETRY & ARCHITECTURAL OVERVIEW)
         ================================================================== -->
    <div class="auth-showcase-panel">
      <div class="auth-brand-badge">
        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
          <path d="M3 21h18"/>
          <path d="M5 21V5a2 2 0 0 1 2-2h10a2 2 0 0 1 2 2v16"/>
        </svg>
        Smart Facility Operations
      </div>

      <div class="auth-showcase-content">
        <h2>Intelligent Facility Operations Console</h2>
        <p>
          Real-time incident dispatching, preventive telemetry, and seamless work-order lifecycle management for residential and commercial smart buildings.
        </p>

        <!-- Live Metrics Telemetry Ticker -->
        <div class="telemetry-ticker">
          <div class="ticker-item">
            <span class="ticker-label">Telemetry Status</span>
            <span class="ticker-val" style="color: #34d399;">Active • 99.8%</span>
          </div>
          <div class="ticker-item">
            <span class="ticker-label">Avg Resolution</span>
            <span class="ticker-val">2.4 Hours</span>
          </div>
          <div class="ticker-item">
            <span class="ticker-label">Elevator Fleet</span>
            <span class="ticker-val">100% Operational</span>
          </div>
          <div class="ticker-item">
            <span class="ticker-label">Active Work Orders</span>
            <span class="ticker-val" style="color: #60a5fa;">In Dispatch</span>
          </div>
        </div>
      </div>

      <div class="auth-showcase-footer">
        Smart Building Maintenance System &bull; Java Servlet &amp; MySQL Enterprise Stack
      </div>
    </div>

    <!-- ==================================================================
         RIGHT FORM PANEL (PRECISION LOGIN)
         ================================================================== -->
    <div class="auth-form-panel">
      <div class="auth-form-card">
        <div class="auth-form-header">
          <h2>Sign In to Console</h2>
          <p>Select your portal role or enter your verified credentials</p>
        </div>

        <!-- Quick One-Click Role Switcher Tabs -->
        <div class="role-tabs">
          <button type="button" class="role-tab active" data-role="admin">
            Admin Portal
          </button>
          <button type="button" class="role-tab" data-role="user">
            Resident Portal
          </button>
        </div>

        <!-- Registration Success Notification -->
        <% if ("true".equals(request.getParameter("registered"))) { %>
          <div class="alert alert-success">
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/>
              <polyline points="22 4 12 14.01 9 11.01"/>
            </svg>
            Account created successfully! Please sign in below.
          </div>
        <% } %>

        <!-- Error Feedback -->
        <% if (request.getAttribute("error") != null) { %>
          <div class="alert alert-error">
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <circle cx="12" cy="12" r="10"/>
              <line x1="15" y1="9" x2="9" y2="15"/>
              <line x1="9" y1="9" x2="15" y2="15"/>
            </svg>
            <%= request.getAttribute("error") %>
          </div>
        <% } %>

        <form action="login" method="post" data-validate="true">
          <div class="form-group">
            <label class="form-label" for="email">Account Email</label>
            <input
              type="email"
              id="email"
              name="email"
              class="form-control"
              placeholder="e.g. admin@smartbuilding.com or resident@gmail.com"
              value="admin@smartbuilding.com"
              required
              autocomplete="email"
            >
          </div>

          <div class="form-group">
            <label class="form-label" for="password">Password</label>
            <input
              type="password"
              id="password"
              name="password"
              class="form-control"
              placeholder="Enter your security password"
              value="admin123"
              required
              autocomplete="current-password"
            >
          </div>

          <button type="submit" class="btn btn-primary btn-block btn-lg" style="margin-top: 1.5rem;">
            Sign In to Dashboard &rarr;
          </button>
        </form>

        <div style="margin-top: 1.75rem; padding-top: 1.25rem; border-top: 1px solid var(--border-hairline); display: flex; justify-content: space-between; font-size: 0.8125rem;">
          <span>New resident? <a href="register.jsp" style="font-weight: 600;">Create account</a></span>
          <a href="index.html" style="color: var(--text-muted);">&larr; Return to Home</a>
        </div>
      </div>
    </div>
  </div>

  <script src="js/app.js"></script>
</body>
</html>