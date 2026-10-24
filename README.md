# QueueWise — Smart Queue Management System

DBMS mini-project: a smart queue management and waiting-time analytics system using HTML, CSS, JavaScript, Node.js, Express.js, and MySQL.

## Project Structure

- `frontend/` — HTML, CSS, and JavaScript user interface
- `Backend/` — Node.js and Express.js APIs
- `Database/` — MySQL

## Run the Frontend Locally

1. Open the `QueueWise` project folder in Visual Studio Code.
2. Install the **Live Server** extension if needed.
3. Open the `frontend` folder.
4. Right-click `index.html` and select **Open with Live Server**.

## Frontend Pages

- `index.html` — landing page
- `login.html` — login form (validation demo)
- `customer.html` — customer token generation demo
- `token.html` — token tracking page
- `staff.html` — staff queue dashboard demo
- `analytics.html` — sample analytics dashboard

## Current Implementation Status

The frontend pages and basic interactions are implemented. Customer token generation, staff actions, and analytics may still use demo or sample data until the backend APIs are integrated.

The frontend is not fully connected to MySQL directly. Coordinate with the backend teammate to connect the frontend to the Node.js/Express APIs.

Update `QueueWise.API_BASE_URL` in `frontend/js/app.js` to the appropriate backend URL when it is ready.

The backend should validate users, authorize staff actions, create and manage tickets, and persist data in MySQL. **Never place database passwords or other secrets in frontend code.**

## Team Responsibilities

- **Member 1:** Database schema, ER diagram, and SQL documentation
- **Member 2:** Frontend pages, styling, user interactions, and API integration
- **Member 3:** Backend APIs, business logic, MySQL connectivity, token management, authentication, and analytics endpoints
