
const queueBody = document.getElementById("queueBody");

if (queueBody) {
  const serviceNames = {
    "1": "Document Verification",
    "2": "Fee Payment",
    "3": "Student Enquiry"
  };

  const msg = document.getElementById("staffMessage");
  const callNextBtn = document.getElementById("callNextBtn");

  async function loadQueue() {
    try {
      const queue = await QueueWise.request("/queue");

      queueBody.innerHTML = "";

      queue.forEach(ticket => {
        const tr = document.createElement("tr");

        const joined = ticket.createdAt
          ? new Date(ticket.createdAt).toLocaleTimeString([], {
              hour: "2-digit",
              minute: "2-digit"
            })
          : "—";

        const values = [
          ticket.token,
          serviceNames[ticket.serviceId] || "Unknown service",
          joined,
          ticket.status
        ];

        values.forEach(value => {
          const td = document.createElement("td");
          td.textContent = value;
          tr.appendChild(td);
        });

        const actionCell = document.createElement("td");

        if (ticket.status === "Waiting") {
          const call = document.createElement("button");
          call.className = "btn btn-secondary btn-small";
          call.textContent = "Call";
          call.addEventListener("click", () => callTicket(ticket.id));

          const skip = document.createElement("button");
          skip.className = "btn btn-warning btn-small";
          skip.textContent = "Skip";
          skip.addEventListener("click", () => skipTicket(ticket.id));

          actionCell.append(call, skip);
        } else if (ticket.status === "Serving") {
          const done = document.createElement("button");
          done.className = "btn btn-success btn-small";
          done.textContent = "Complete";
          done.addEventListener("click", () => completeTicket(ticket.id));

          actionCell.appendChild(done);
        } else {
          actionCell.textContent = "—";
        }

        tr.appendChild(actionCell);
        queueBody.appendChild(tr);
      });

      document.getElementById("waitingCount").textContent =
        queue.filter(ticket => ticket.status === "Waiting").length;

      const serving = queue.find(ticket => ticket.status === "Serving");
      document.getElementById("staffServing").textContent =
        serving ? serving.token : "None";

      document.getElementById("completedCount").textContent =
        queue.filter(ticket => ticket.status === "Completed").length;

    } catch (error) {
      msg.textContent = error.message || "Could not load queue.";
      msg.style.color = "#c92a2a";
    }
  }

  async function callNext() {
    try {
      const data = await QueueWise.request("/queue/next", {
        method: "POST",
        body: JSON.stringify({})
      });

      msg.style.color = "#087f5b";
      msg.textContent = data.message;
      await loadQueue();
    } catch (error) {
      msg.style.color = "#c92a2a";
      msg.textContent = error.message;
    }
  }

  async function callTicket(id) {
    try {
      const queue = await QueueWise.request("/queue");
      const ticket = queue.find(item => item.id === id);

      if (!ticket) throw new Error("Ticket not found.");

      // The backend's next endpoint calls the earliest waiting ticket.
      const earliest = queue
        .filter(item => item.status === "Waiting")
        .sort((a, b) => a.id - b.id)[0];

      if (earliest && earliest.id !== id) {
        throw new Error("Call the earliest waiting ticket first.");
      }

      await callNext();
    } catch (error) {
      msg.style.color = "#c92a2a";
      msg.textContent = error.message;
    }
  }

  async function skipTicket(id) {
    try {
      const data = await QueueWise.request(`/queue/${id}/skip`, {
        method: "POST",
        body: JSON.stringify({})
      });

      msg.style.color = "#087f5b";
      msg.textContent = data.message;
      await loadQueue();
    } catch (error) {
      msg.style.color = "#c92a2a";
      msg.textContent = error.message;
    }
  }

  async function completeTicket(id) {
    try {
      const data = await QueueWise.request(`/queue/${id}/complete`, {
        method: "POST",
        body: JSON.stringify({})
      });

      msg.style.color = "#087f5b";
      msg.textContent = data.message;
      await loadQueue();
    } catch (error) {
      msg.style.color = "#c92a2a";
      msg.textContent = error.message;
    }
  }

  callNextBtn.addEventListener("click", callNext);

  loadQueue();
  setInterval(loadQueue, 5000);
}
