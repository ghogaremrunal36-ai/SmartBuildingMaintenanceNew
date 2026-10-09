<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Resident Registration - Smart Building Maintenance System</title>
  <link rel="stylesheet" href="css/style.css">
</head>
<body>

  <div class="auth-split-container">
    <!-- ==================================================================
         LEFT SHOWCASE PANEL
         ================================================================== -->
    <div class="auth-showcase-panel">
      <div class="auth-brand-badge">
        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
          <path d="M16 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/>
          <circle cx="9" cy="7" r="4"/>
          <polyline points="16 11 18 13 22 9"/>
        </svg>
        Resident Onboarding
      </div>

      <div class="auth-showcase-content">
        <h2>Join Your Connected Smart Building Community</h2>
        <p>
          Register your apartment unit to report maintenance problems, track repair technicians in real time, and receive facility maintenance updates.
        </p>

        <div class="telemetry-ticker">
          <div class="ticker-item">
            <span class="ticker-label">Ticket Response</span>
            <span class="ticker-val" style="color: #38bdf8;">&lt; 15 Mins</span>
          </div>
          <div class="ticker-item">
            <span class="ticker-label">Specialist Teams</span>
            <span class="ticker-val">5 Dedicated Crews</span>
          </div>
          <div class="ticker-item">
            <span class="ticker-label">Resident Satisfaction</span>
            <span class="ticker-val" style="color: #34d399;">98.6%</span>
          </div>
          <div class="ticker-item">
            <span class="ticker-label">Digital History</span>
            <span class="ticker-val">Lifetime Logs</span>
          </div>
        </div>
      </div>

      <div class="auth-showcase-footer">
        Skyline &amp; Horizon Smart Building Residencies &bull; Powered by Java &amp; MySQL
      </div>
    </div>

    <!-- ==================================================================
         RIGHT FORM PANEL
         ================================================================== -->
    <div class="auth-form-panel">
      <div class="auth-form-card">
        <div class="auth-form-header">
          <h2>Resident Registration</h2>
          <p>Create an authorized account for your residential unit</p>
        </div>

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

        <form action="register" method="post" data-validate="true">
          <div class="form-group">
            <label class="form-label" for="name">Full Name &amp; Unit Number</label>
            <input
              type="text"
              id="name"
              name="name"
              class="form-control"
              placeholder="e.g. John Doe (Apt 402)"
              required
              autocomplete="name"
            >
          </div>

          <div class="form-group">
            <label class="form-label" for="email">Email Address</label>
            <input
              type="email"
              id="email"
              name="email"
              class="form-control"
              placeholder="e.g. resident@gmail.com"
              required
              autocomplete="email"
            >
            <span class="form-hint">Used to receive status notifications and access your portal.</span>
          </div>

          <div class="form-group">
            <label class="form-label" for="password">Password</label>
            <input
              type="password"
              id="password"
              name="password"
              class="form-control"
              placeholder="Minimum 4 characters"
              required
              autocomplete="new-password"
            >
          </div>

          <div class="form-group">
            <label class="form-label" for="phone">Contact Phone Number</label>
            <input
              type="tel"
              id="phone"
              name="phone"
              class="form-control"
              placeholder="e.g. +1 555-0101"
              required
              autocomplete="tel"
            >
          </div>

          <button type="submit" class="btn btn-primary btn-block btn-lg" style="margin-top: 1.5rem;">
            Create Resident Account &rarr;
          </button>
        </form>

        <div style="margin-top: 1.75rem; padding-top: 1.25rem; border-top: 1px solid var(--border-hairline); display: flex; justify-content: space-between; font-size: 0.8125rem;">
          <span>Already registered? <a href="login.jsp" style="font-weight: 600;">Sign in here</a></span>
          <a href="index.html" style="color: var(--text-muted);">&larr; Return to Home</a>
        </div>
      </div>
    </div>
  </div>

  <script src="js/app.js"></script>
</body>
</html>