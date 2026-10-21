// Shared helpers for QueueWise frontend.
const QueueWise = {
  API_BASE_URL: "http://localhost:3000/api",

  getDemoToken() {
    try {
      return JSON.parse(sessionStorage.getItem("queuewiseDemoToken") || "null");
    } catch {
      return null;
    }
  },

  saveDemoToken(token) {
    sessionStorage.setItem("queuewiseDemoToken", JSON.stringify(token));
  },

  getUser() {
    try {
      return JSON.parse(sessionStorage.getItem("queuewiseUser") || "null");
    } catch {
      return null;
    }
  },

  saveUser(user) {
    sessionStorage.setItem("queuewiseUser", JSON.stringify(user));
  },

  clearUser() {
    sessionStorage.removeItem("queuewiseUser");
  },

  requireAuth(allowedRoles = ["STAFF", "ADMIN"]) {
    const user = this.getUser();
    if (!user || !allowedRoles.includes(user.role)) {
      window.location.replace("login.html");
      return null;
    }
    return user;
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