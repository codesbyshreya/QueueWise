// --- Route Guard: Restrict analytics to authenticated Staff & Admin ---
const currentUser = QueueWise.requireAuth(["STAFF", "ADMIN"]);
if (!currentUser) {
  // Execution stops here while QueueWise.requireAuth redirects to login.html
  throw new Error("Unauthorized access. Redirecting to login...");
}

document.addEventListener("DOMContentLoaded", () => {
  const dateEl = document.getElementById("analytics-date");
  const errorEl = document.getElementById("analytics-error");
  const completedEl = document.getElementById("stat-completed");
  const servingEl = document.getElementById("stat-serving");
  const avgWaitEl = document.getElementById("stat-avg-wait");
  const waitingEl = document.getElementById("stat-waiting");
  const peakPeriodEl = document.getElementById("stat-peak-period");
  const totalIssuedEl = document.getElementById("stat-total-issued");
  const skippedEl = document.getElementById("stat-skipped");
  const hourlyChartEl = document.getElementById("hourly-chart");
  const insightsContainer = document.getElementById("insights-container");

  function formatHour(hour) {
    const h = Number(hour);
    if (h === 0) return "12 AM";
    if (h < 12) return `${h} AM`;
    if (h === 12) return "12 PM";
    return `${h - 12} PM`;
  }

  async function loadAnalytics() {
    try {
      const data = await QueueWise.request("/analytics");
      const summary = data.summary || {};
      const services = Array.isArray(data.services) ? data.services : [];
      const hourlyDemand = Array.isArray(data.hourlyDemand) ? data.hourlyDemand : [];

      if (errorEl) {
        errorEl.style.display = "none";
      }

      // 1. Display Current Date
      if (dateEl) {
        dateEl.textContent = data.date || new Date().toISOString().slice(0, 10);
      }

      // 2. Render Summary Cards
      completedEl.textContent = summary.completed ?? 0;
      servingEl.textContent = `Serving: ${summary.serving ?? 0}`;

      avgWaitEl.textContent =
        summary.averageWaitMinutes !== null && summary.averageWaitMinutes !== undefined
          ? `${summary.averageWaitMinutes} min`
          : "N/A";
      waitingEl.textContent = `Waiting: ${summary.waiting ?? 0}`;

      totalIssuedEl.textContent = `Total issued: ${summary.totalIssued ?? 0}`;
      skippedEl.textContent = summary.skipped ?? 0;

      // Determine Peak Period
      if (hourlyDemand.length > 0) {
        const peak = hourlyDemand.reduce((max, cur) =>
          cur.totalTickets > max.totalTickets ? cur : max
        );
        peakPeriodEl.textContent = formatHour(peak.hour);
      } else {
        peakPeriodEl.textContent = "None";
      }

      // 3. Render Hourly Demand Bar Chart
      if (hourlyDemand.length === 0) {
        hourlyChartEl.innerHTML = `<p class="muted" style="margin: auto;">No tickets recorded for today yet.</p>`;
      } else {
        const maxTickets = Math.max(...hourlyDemand.map(h => h.totalTickets), 1);
        hourlyChartEl.innerHTML = hourlyDemand
          .map(h => {
            const heightPercent = Math.max(Math.round((h.totalTickets / maxTickets) * 100), 12);
            return `
              <div class="bar-col">
                <span>${h.totalTickets}</span>
                <i style="height:${heightPercent}%"></i>
                <small>${formatHour(h.hour)}</small>
              </div>
            `;
          })
          .join("");
      }

      // 4. Render Service Breakdown & Queue Intelligence
      if (services.length === 0) {
        insightsContainer.innerHTML = `<p class="muted">No service activity recorded yet.</p>`;
      } else {
        const topService = services[0];
        const serviceBreakdownHtml = services
          .map(s => `
            <div class="insight">
              <span class="insight-icon">📋</span>
              <div style="flex: 1;">
                <strong>${s.serviceName}</strong>
                <p>Total: ${s.totalTickets} ticket${s.totalTickets === 1 ? '' : 's'} | Completed: ${s.completed}</p>
              </div>
            </div>
          `)
          .join("");

        const topServiceHtml = `
          <div class="insight">
            <span class="insight-icon">↗</span>
            <div>
              <strong>Highest Demand: ${topService.serviceName}</strong>
              <p>${topService.totalTickets} ticket${topService.totalTickets === 1 ? '' : 's'} requested today.</p>
            </div>
          </div>
        `;

        insightsContainer.innerHTML = topServiceHtml + serviceBreakdownHtml;
      }
    } catch (err) {
      console.error("Failed to load analytics:", err);
      if (errorEl) {
        errorEl.textContent = "Could not load analytics. Please ensure the backend server is running.";
        errorEl.style.display = "block";
      }
    }
  }

  // Initial load
  loadAnalytics();

  // Auto-refresh every 10 seconds
  const refreshInterval = setInterval(loadAnalytics, 10000);

  // Clear timer when leaving page
  window.addEventListener("beforeunload", () => {
    clearInterval(refreshInterval);
  });
});