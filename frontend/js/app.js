// Shared helpers for QueueWise frontend.
const QueueWise = {
  // Change this when Member 3 shares the actual backend URL.
  API_BASE_URL: "http://localhost:3000/api",
  getDemoToken() {
    try { return JSON.parse(sessionStorage.getItem("queuewiseDemoToken") || "null"); }
    catch { return null; }
  },
  saveDemoToken(token) {
    sessionStorage.setItem("queuewiseDemoToken", JSON.stringify(token));
  },
  async request(path, options = {}) {
    const response = await fetch(`${this.API_BASE_URL}${path}`, {
      ...options,
      headers: { "Content-Type": "application/json", ...(options.headers || {}) }
    });
    const data = await response.json().catch(() => ({}));
    if (!response.ok) throw new Error(data.message || `Request failed (${response.status})`);
    return data;
  }
};
