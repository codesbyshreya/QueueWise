# QueueWise Frontend Starter

This folder contains the HTML, CSS and JavaScript starter frontend for QueueWise.

## Run locally
1. Open the `frontend` folder in Visual Studio Code.
2. Install the **Live Server** extension if needed.
3. Right-click `index.html` and choose **Open with Live Server**.

## Pages
- `index.html` — landing page
- `login.html` — login form (validation demo only)
- `customer.html` — token generation demo
- `token.html` — token tracking page
- `staff.html` — staff queue demo
- `analytics.html` — sample analytics dashboard

## Important
The customer token and staff actions currently use demo/sample data. They do not write to MySQL. Before presenting the system as fully functional, coordinate with the backend teammate and replace demo logic with actual API requests. Update `QueueWise.API_BASE_URL` in `js/app.js` to the backend URL. The backend must validate users, authorize staff actions, create tickets, and persist state in MySQL. Never put database passwords in frontend code.

## Suggested project layout
QueueWise/
  frontend/
    css/style.css
    js/app.js
    js/auth.js
    js/customer.js
    js/staff.js
    js/analytics.js
    index.html
    login.html
    customer.html
    token.html
    staff.html
    analytics.html
