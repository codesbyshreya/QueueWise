document.addEventListener("DOMContentLoaded", () => {
  const loginForm = document.getElementById("loginForm");
  const messageEl = document.getElementById("loginMessage");

  if (!loginForm) return;

  loginForm.addEventListener("submit", async (event) => {
    event.preventDefault();

    const email = document.getElementById("email").value.trim();
    const password = document.getElementById("password").value;

    if (!email || !password) {
      if (messageEl) {
        messageEl.style.color = "#b42318";
        messageEl.textContent = "Please enter both your email and password.";
      }
      return;
    }

    try {
      if (messageEl) {
        messageEl.style.color = "#58627a";
        messageEl.textContent = "Signing in...";
      }

      const response = await QueueWise.request("/login", {
        method: "POST",
        body: JSON.stringify({ email, password })
      });

      // Save user session in localStorage/sessionStorage
      sessionStorage.setItem("queuewiseUser", JSON.stringify(response.user));

      if (messageEl) {
        messageEl.style.color = "#087f5b";
        messageEl.textContent = `Welcome, ${response.user.fullName}! Redirecting...`;
      }

      // Role-based redirect
      setTimeout(() => {
        if (response.user.role === "STAFF" || response.user.role === "ADMIN") {
          window.location.href = "staff.html";
        } else {
          window.location.href = "customer.html";
        }
      }, 800);
    } catch (err) {
      if (messageEl) {
        messageEl.style.color = "#b42318";
        messageEl.textContent = err.message || "Failed to sign in. Please check your credentials.";
      }
    }
  });
});