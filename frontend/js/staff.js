// Check authentication
const currentUser = QueueWise.requireAuth(["STAFF", "ADMIN"]);

const queueBody = document.getElementById("queueBody");

if (queueBody) {
  const counterSelect = document.getElementById("counterSelect");
  const callNextBtn = document.getElementById("callNextBtn");
  const msg = document.getElementById("staffMessage");
  const staffDisplay = document.getElementById("staffUserDisplay");
  const logoutBtn = document.getElementById("logoutBtn");

  let actionInProgress = false;

  // Show user in navbar if elements exist
  if (currentUser && currentUser.fullName && staffDisplay) {
    staffDisplay.textContent = `👤 ${currentUser.fullName}`;
  }

  if (logoutBtn) {
    logoutBtn.addEventListener("click", (e) => {
      e.preventDefault();
      QueueWise.clearUser();
      window.location.replace("login.html");
    });
  }

  function showMessage(message, success = true) {
    if (!msg) return;
    msg.textContent = message;
    msg.style.color = success ? "#087f5b" : "#c92a2a";
  }

  function setActionButtonsDisabled(disabled) {
    if (callNextBtn) {
      callNextBtn.disabled = disabled || !counterSelect.value;
    }
    queueBody.querySelectorAll("button").forEach(button => {
      button.disabled = disabled;
    });
  }

  async function loadCounters() {
    try {
      const counters = await QueueWise.request("/counters");

      counterSelect.replaceChildren(
        new Option("Select a counter", "")
      );

      // Filter for staff, or show all for admin
      const isStaff = currentUser && currentUser.role === "STAFF" && currentUser.assignedCounterId;
      const allowedCounters = isStaff
        ? counters.filter(c => c.id === currentUser.assignedCounterId)
        : counters;

      allowedCounters.forEach(counter => {
        const label = `${counter.code} — ${counter.name} (${counter.locationName})`;
        counterSelect.add(new Option(label, String(counter.id)));
      });

      if (allowedCounters.length === 0) {
        showMessage("No active counter available.", false);
        return;
      }

      // Auto-select if assigned to this staff member
      if (isStaff) {
        counterSelect.value = String(currentUser.assignedCounterId);
        counterSelect.disabled = true;
        showMessage(`Operating station: ${currentUser.counterCode || ''} — ${currentUser.counterName || ''}`);
        await loadQueue();
      } else {
        counterSelect.disabled = false;
        showMessage("Counters loaded. Select a counter.");
      }
    } catch (error) {
      console.error("loadCounters error:", error);
      showMessage(error.message || "Could not load counters.", false);
    }
  }

  async function loadQueue() {
    const counterId = counterSelect.value;

    if (!counterId) {
      queueBody.replaceChildren();
      const row = queueBody.insertRow();
      const cell = row.insertCell();
      cell.colSpan = 5;
      cell.textContent = "Select a counter to view its queue.";

      document.getElementById("waitingCount").textContent = "—";
      document.getElementById("staffServing").textContent = "—";
      document.getElementById("completedCount").textContent = "—";
      if (callNextBtn) callNextBtn.disabled = true;
      return;
    }

    try {
      const queue = await QueueWise.request(
        `/queue?counterId=${encodeURIComponent(counterId)}`
      );

      queueBody.replaceChildren();

      if (queue.length === 0) {
        const row = queueBody.insertRow();
        const cell = row.insertCell();
        cell.colSpan = 5;
        cell.textContent = "No tickets at this counter today.";
      }

      queue.forEach(ticket => {
        const row = document.createElement("tr");

        const joined = ticket.createdAt
          ? new Date(ticket.createdAt).toLocaleTimeString([], {
              hour: "2-digit",
              minute: "2-digit"
            })
          : "—";

        [
          ticket.token,
          ticket.serviceName,
          joined,
          ticket.status
        ].forEach(value => {
          const cell = document.createElement("td");
          cell.textContent = value ?? "—";
          row.appendChild(cell);
        });

        const actions = document.createElement("td");

        if (ticket.rawStatus === "WAITING") {
          const skipButton = document.createElement("button");
          skipButton.className = "btn btn-warning btn-small";
          skipButton.textContent = "Skip";
          skipButton.addEventListener("click", () => skipTicket(ticket.id));
          actions.appendChild(skipButton);

        } else if (ticket.rawStatus === "CALLED") {
          const startButton = document.createElement("button");
          startButton.className = "btn btn-secondary btn-small";
          startButton.textContent = "Start service";
          startButton.addEventListener("click", () => startService(ticket.id));
          actions.appendChild(startButton);

        } else if (ticket.rawStatus === "IN_SERVICE") {
          const doneButton = document.createElement("button");
          doneButton.className = "btn btn-success btn-small";
          doneButton.textContent = "Complete";
          doneButton.addEventListener("click", () => completeTicket(ticket.id));
          actions.appendChild(doneButton);

        } else {
          actions.textContent = "—";
        }

        row.appendChild(actions);
        queueBody.appendChild(row);
      });

      const waitingCountEl = document.getElementById("waitingCount");
      const staffServingEl = document.getElementById("staffServing");
      const completedCountEl = document.getElementById("completedCount");

      if (waitingCountEl) {
        waitingCountEl.textContent = queue.filter(t => t.rawStatus === "WAITING").length;
      }

      const serving = queue.find(t => t.rawStatus === "CALLED" || t.rawStatus === "IN_SERVICE");
      if (staffServingEl) {
        staffServingEl.textContent = serving ? serving.token : "None";
      }

      if (completedCountEl) {
        completedCountEl.textContent = queue.filter(t => t.rawStatus === "COMPLETED").length;
      }

      if (callNextBtn) {
        callNextBtn.disabled =
          actionInProgress ||
          queue.some(t => t.rawStatus === "CALLED" || t.rawStatus === "IN_SERVICE") ||
          !queue.some(t => t.rawStatus === "WAITING");
      }

    } catch (error) {
      console.error("loadQueue error:", error);
      showMessage(error.message || "Could not load queue.", false);
    }
  }

  async function performAction(action, successMessage) {
    if (actionInProgress) return;

    actionInProgress = true;
    setActionButtonsDisabled(true);

    try {
      const result = await action();
      showMessage(result.message || successMessage);
      await loadQueue();
    } catch (error) {
      showMessage(error.message || "Action failed.", false);
      await loadQueue();
    } finally {
      actionInProgress = false;
      setActionButtonsDisabled(false);
      await loadQueue();
    }
  }

  async function callNext() {
    const counterId = counterSelect.value;
    if (!counterId) {
      showMessage("Select a counter first.", false);
      return;
    }

    await performAction(
      () => QueueWise.request("/queue/next", {
        method: "POST",
        body: JSON.stringify({ counterId: Number(counterId) })
      }),
      "Next ticket called."
    );
  }

  async function startService(id) {
    await performAction(
      () => QueueWise.request(`/queue/${id}/start`, {
        method: "POST",
        body: JSON.stringify({})
      }),
      "Service started."
    );
  }

  async function skipTicket(id) {
    await performAction(
      () => QueueWise.request(`/queue/${id}/skip`, {
        method: "POST",
        body: JSON.stringify({})
      }),
      "Ticket skipped."
    );
  }

  async function completeTicket(id) {
    await performAction(
      () => QueueWise.request(`/queue/${id}/complete`, {
        method: "POST",
        body: JSON.stringify({})
      }),
      "Ticket completed."
    );
  }

  counterSelect.addEventListener("change", loadQueue);
  if (callNextBtn) callNextBtn.addEventListener("click", callNext);

  // Initialize
  loadCounters();

  // Auto-refresh queue every 5 seconds
  setInterval(() => {
    if (!actionInProgress && counterSelect.value) {
      loadQueue();
    }
  }, 5000);
};