/**
 * SMART BUILDING MAINTENANCE SYSTEM - APP INTERACTIONS
 * Handles mobile sidebar, live search, interactive category card selection,
 * role switcher tabs, and form validations.
 */

document.addEventListener('DOMContentLoaded', () => {
  initMobileSidebar();
  initTableSearchAndFilter();
  initCategoryCardSelector();
  initRoleSwitcherTabs();
  initFormValidation();
});

/* --------------------------------------------------------------------------
   Mobile Drawer Toggle
   -------------------------------------------------------------------------- */
function initMobileSidebar() {
  const toggleBtn = document.getElementById('mobileMenuToggle');
  const sidebar = document.querySelector('.sidebar');
  const backdrop = document.getElementById('sidebarBackdrop');

  if (!toggleBtn || !sidebar) return;

  function toggle() {
    sidebar.classList.toggle('open');
    if (backdrop) backdrop.classList.toggle('active');
  }

  function close() {
    sidebar.classList.remove('open');
    if (backdrop) backdrop.classList.remove('active');
  }

  toggleBtn.addEventListener('click', toggle);
  if (backdrop) backdrop.addEventListener('click', close);

  document.addEventListener('keydown', (e) => {
    if (e.key === 'Escape') close();
  });
}

/* --------------------------------------------------------------------------
   Interactive Category Card Selector (Maintenance Request Page)
   -------------------------------------------------------------------------- */
function initCategoryCardSelector() {
  const categoryCards = document.querySelectorAll('.category-choice-card');
  const categorySelect = document.getElementById('category');

  if (!categoryCards.length || !categorySelect) return;

  categoryCards.forEach(card => {
    card.addEventListener('click', () => {
      categoryCards.forEach(c => c.classList.remove('selected'));
      card.classList.add('selected');

      const val = card.getAttribute('data-value');
      if (val) {
        categorySelect.value = val;
      }
    });
  });

  // If select already has a value, mark that card as selected
  if (categorySelect.value) {
    const matchingCard = document.querySelector(`.category-choice-card[data-value="${categorySelect.value}"]`);
    if (matchingCard) matchingCard.classList.add('selected');
  }
}

/* --------------------------------------------------------------------------
   Role Switcher Tabs (Login Page)
   -------------------------------------------------------------------------- */
function initRoleSwitcherTabs() {
  const roleTabs = document.querySelectorAll('.role-tab');
  const emailInput = document.querySelector('input[name="email"]');
  const passwordInput = document.querySelector('input[name="password"]');

  if (!roleTabs.length || !emailInput || !passwordInput) return;

  roleTabs.forEach(tab => {
    tab.addEventListener('click', () => {
      roleTabs.forEach(t => t.classList.remove('active'));
      tab.classList.add('active');

      const role = tab.getAttribute('data-role');
      if (role === 'admin') {
        emailInput.value = 'admin@smartbuilding.com';
        passwordInput.value = 'admin123';
      } else if (role === 'user') {
        emailInput.value = 'john@gmail.com';
        passwordInput.value = 'user123';
      }
    });
  });
}

/* --------------------------------------------------------------------------
   Table Live Search & Status Filtering
   -------------------------------------------------------------------------- */
function initTableSearchAndFilter() {
  const searchInput = document.getElementById('tableSearchInput');
  const filterBtns = document.querySelectorAll('.filter-btn');
  const table = document.querySelector('.custom-table');

  if (!table) return;

  const rows = table.querySelectorAll('tbody tr:not(.no-data-row):not(.filter-empty-row)');
  let currentFilter = 'ALL';
  let currentQuery = '';

  function applyFilters() {
    let visibleCount = 0;

    rows.forEach((row) => {
      const rowText = row.innerText.toLowerCase();
      const statusBadge = row.querySelector('.status-badge');
      const rowStatus = statusBadge ? statusBadge.innerText.trim().toUpperCase() : '';

      const matchesQuery = !currentQuery || rowText.includes(currentQuery);
      const matchesFilter = (currentFilter === 'ALL') || (rowStatus === currentFilter);

      if (matchesQuery && matchesFilter) {
        row.style.display = '';
        visibleCount++;
      } else {
        row.style.display = 'none';
      }
    });

    const emptyRow = table.querySelector('.filter-empty-row');
    if (emptyRow) {
      emptyRow.style.display = visibleCount === 0 ? '' : 'none';
    }
  }

  if (searchInput) {
    searchInput.addEventListener('input', (e) => {
      currentQuery = e.target.value.trim().toLowerCase();
      applyFilters();
    });
  }

  filterBtns.forEach((btn) => {
    btn.addEventListener('click', () => {
      filterBtns.forEach((b) => b.classList.remove('active'));
      btn.classList.add('active');
      currentFilter = btn.getAttribute('data-filter') || 'ALL';
      applyFilters();
    });
  });
}

/* --------------------------------------------------------------------------
   Client-Side Form Validation
   -------------------------------------------------------------------------- */
function initFormValidation() {
  const forms = document.querySelectorAll('form[data-validate="true"]');

  forms.forEach((form) => {
    form.addEventListener('submit', (e) => {
      let isValid = true;
      const requiredInputs = form.querySelectorAll('[required]');

      requiredInputs.forEach((input) => {
        const val = input.value.trim();
        if (!val) {
          isValid = false;
          input.style.borderColor = '#ef4444';
        } else {
          input.style.borderColor = '';
        }
      });

      if (!isValid) {
        e.preventDefault();
      }
    });
  });
}
