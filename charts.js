/**
 * SMART BUILDING MAINTENANCE SYSTEM - TELEMETRY CHARTS
 * Pure SVG telemetry progress rings and workload meters (Zero External Dependencies)
 */

document.addEventListener('DOMContentLoaded', () => {
  renderStatusDonutChart();
  renderCategoryBarChart();
});

/* --------------------------------------------------------------------------
   1. Requests by Status - SVG Telemetry Donut Ring
   -------------------------------------------------------------------------- */
function renderStatusDonutChart() {
  const container = document.getElementById('statusChartContainer');
  if (!container) return;

  const pending = parseInt(container.getAttribute('data-pending') || '0', 10);
  const progress = parseInt(container.getAttribute('data-progress') || '0', 10);
  const completed = parseInt(container.getAttribute('data-completed') || '0', 10);
  const total = pending + progress + completed;

  if (total === 0) {
    container.innerHTML = '<div style="color:#94a3b8; font-size:0.875rem;">No active work orders to chart</div>';
    return;
  }

  const data = [
    { label: 'Pending', count: pending, color: '#f59e0b', percent: Math.round((pending / total) * 100) },
    { label: 'In Progress', count: progress, color: '#2563eb', percent: Math.round((progress / total) * 100) },
    { label: 'Completed', count: completed, color: '#10b981', percent: Math.round((completed / total) * 100) }
  ];

  const size = 160;
  const strokeWidth = 20;
  const radius = (size - strokeWidth) / 2;
  const circumference = 2 * Math.PI * radius;

  let offset = 0;
  let circlesHtml = '';

  data.forEach(item => {
    const strokeDash = (item.count / total) * circumference;
    const strokeOffset = -offset;
    circlesHtml += `
      <circle cx="${size / 2}" cy="${size / 2}" r="${radius}"
        fill="transparent"
        stroke="${item.color}"
        stroke-width="${strokeWidth}"
        stroke-dasharray="${strokeDash} ${circumference - strokeDash}"
        stroke-dashoffset="${strokeOffset}"
        style="transition: stroke-dasharray 0.8s ease;"
      />
    `;
    offset += strokeDash;
  });

  const legendHtml = data.map(item => `
    <div style="display:flex; align-items:center; justify-content:space-between; margin-bottom:8px; font-size:0.8125rem;">
      <span style="display:flex; align-items:center; gap:8px;">
        <span style="width:8px; height:8px; border-radius:50%; background-color:${item.color};"></span>
        <strong style="color:var(--text-main); font-weight:600;">${item.label}</strong>
      </span>
      <span style="color:var(--text-muted); font-weight:700;">${item.count} <span style="font-size:0.75rem; font-weight:400;">(${item.percent}%)</span></span>
    </div>
  `).join('');

  container.innerHTML = `
    <div style="display:flex; align-items:center; gap:20px; width:100%; justify-content:space-around; flex-wrap:wrap;">
      <div style="position:relative; width:${size}px; height:${size}px;">
        <svg width="${size}" height="${size}" viewBox="0 0 ${size} ${size}" style="transform: rotate(-90deg);">
          <circle cx="${size / 2}" cy="${size / 2}" r="${radius}" fill="transparent" stroke="#f1f5f9" stroke-width="${strokeWidth}" />
          ${circlesHtml}
        </svg>
        <div style="position:absolute; inset:0; display:flex; flex-direction:column; align-items:center; justify-content:center; pointer-events:none;">
          <span style="font-size:1.65rem; font-weight:800; color:var(--text-main); line-height:1; letter-spacing:-0.03em;">${total}</span>
          <span style="font-size:0.7rem; color:var(--text-muted); text-transform:uppercase; font-weight:700; letter-spacing:0.04em;">Tickets</span>
        </div>
      </div>
      <div style="min-width:150px; flex:1; max-width:220px;">
        ${legendHtml}
      </div>
    </div>
  `;
}

/* --------------------------------------------------------------------------
   2. Requests by Category - Precision Workload Bars
   -------------------------------------------------------------------------- */
function renderCategoryBarChart() {
  const container = document.getElementById('categoryChartContainer');
  if (!container) return;

  let categories = [];
  try {
    const rawData = container.getAttribute('data-categories');
    if (rawData) categories = JSON.parse(rawData);
  } catch (e) {
    categories = [];
  }

  if (!categories || !categories.length) {
    categories = [
      { name: 'Electrical', count: 3 },
      { name: 'Plumbing', count: 4 },
      { name: 'Air Conditioning', count: 2 },
      { name: 'Lift / Elevator', count: 1 },
      { name: 'Cleaning', count: 2 },
      { name: 'Other', count: 1 }
    ];
  }

  const maxCount = Math.max(...categories.map(c => c.count), 1);
  const colors = ['#2563eb', '#0284c7', '#06b6d4', '#4f46e5', '#7c3aed', '#9333ea'];

  const barsHtml = categories.map((cat, idx) => {
    const percentage = Math.round((cat.count / maxCount) * 100);
    const color = colors[idx % colors.length];

    return `
      <div style="margin-bottom: 10px;">
        <div style="display:flex; justify-content:space-between; margin-bottom:3px; font-size:0.8125rem;">
          <span style="font-weight:600; color:var(--text-main);">${cat.name}</span>
          <span style="font-weight:700; color:${color};">${cat.count}</span>
        </div>
        <div style="background-color:#f1f5f9; height:7px; border-radius:999px; overflow:hidden;">
          <div style="background-color:${color}; width:${percentage}%; height:100%; border-radius:999px;"></div>
        </div>
      </div>
    `;
  }).join('');

  container.innerHTML = `
    <div style="width:100%; padding:2px 0;">
      ${barsHtml}
    </div>
  `;
}
