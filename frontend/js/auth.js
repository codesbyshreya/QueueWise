// Demo-only login form validation. Replace with the backend login API before production.
const loginForm = document.getElementById("loginForm");
if (loginForm) {
  loginForm.addEventListener("submit", (event) => {
    event.preventDefault();
    const email = document.getElementById("email").value.trim();
    const password = document.getElementById("password").value;
    const message = document.getElementById("loginMessage");
    if (!email || !password) {
      message.textContent = "Enter both your email and password.";
      return;
    }
    message.style.color = "#996600";
    message.textContent = "Form validated. Connect the backend login API to authenticate users.";
  });
}
