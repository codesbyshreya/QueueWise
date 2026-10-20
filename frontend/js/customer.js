
const tokenForm = document.getElementById("tokenForm");

if (tokenForm) {
  tokenForm.addEventListener("submit", async (event) => {
    event.preventDefault();

    const serviceId = document.getElementById("service").value;
    const generateBtn = document.getElementById("generateBtn");

    try {
      generateBtn.disabled = true;

      // Create a ticket using the shared API helper
      const data = await QueueWise.request("/queue", {
        method: "POST",
        body: JSON.stringify({ serviceId })
      });

      const ticket = data.ticket;

      // Save the real backend ticket in this browser session
      QueueWise.saveDemoToken(ticket);

      // Display the ticket details
      document.getElementById("tokenNumber").textContent = ticket.token;
      document.getElementById("peopleAhead").textContent = ticket.peopleAhead;
      document.getElementById("waitTime").textContent =
        ticket.estimatedWaitMinutes + " min";
      document.getElementById("tokenStatus").textContent = ticket.status;

      document.getElementById("tokenResult").scrollIntoView({
        behavior: "smooth",
        block: "nearest"
      });
    } catch (error) {
      alert(error.message || "Could not connect to the server.");
    } finally {
      generateBtn.disabled = false;
    }
  });
}

const trackingToken = document.getElementById("trackingToken");

async function updateTracking() {
  if (!trackingToken) return;

  const savedTicket = QueueWise.getDemoToken();

  if (!savedTicket || !savedTicket.id) {
    trackingToken.textContent = "No token";
    document.getElementById("trackingStatus").textContent = "Not found";
    document.getElementById("nowServing").textContent = "—";
    document.getElementById("trackingAhead").textContent = "—";
    document.getElementById("trackingWait").textContent = "—";
    document.getElementById("progressText").textContent =
      "Generate a token first";
    document.getElementById("progressBar").style.width = "0%";
    return;
  }

  try {
    const queue = await QueueWise.request("/queue");
    const ticket = queue.find(item => item.id === savedTicket.id);

    if (!ticket) {
      trackingToken.textContent = "Token not found";
      document.getElementById("trackingStatus").textContent = "Not found";
      document.getElementById("nowServing").textContent = "—";
      document.getElementById("trackingAhead").textContent = "—";
      document.getElementById("trackingWait").textContent = "—";
      document.getElementById("progressText").textContent =
        "Please generate a new token";
      document.getElementById("progressBar").style.width = "0%";
      return;
    }

    const serviceTimes = {
      "1": 10,
      "2": 3,
      "3": 5
    };

    const ticketsAhead = queue.filter(item =>
      item.id < ticket.id &&
      (item.status === "Waiting" || item.status === "Serving")
    );

    const peopleAhead = ticketsAhead.length;

    const estimatedWaitMinutes = ticketsAhead.reduce(
      (total, item) => total + (serviceTimes[item.serviceId] || 0),
      0
    );

    const servingTicket = queue.find(item => item.status === "Serving");

    document.getElementById("trackingToken").textContent = ticket.token;
    document.getElementById("trackingStatus").textContent = ticket.status;
    document.getElementById("nowServing").textContent =
      servingTicket ? servingTicket.token : "None";
    document.getElementById("trackingAhead").textContent = peopleAhead;
    document.getElementById("trackingWait").textContent =
      estimatedWaitMinutes + " min";

    document.getElementById("progressText").textContent =
      ticket.status === "Serving"
        ? "Your turn"
        : ticket.status === "Completed"
          ? "Completed"
          : peopleAhead === 0
            ? "Next in line"
            : "In line";

    document.getElementById("progressBar").style.width =
      ticket.status === "Serving" || ticket.status === "Completed"
        ? "100%"
        : Math.max(10, 100 - peopleAhead * 15) + "%";

  } catch (error) {
    document.getElementById("progressText").textContent =
      "Unable to refresh queue";
    console.error("Tracking error:", error);
  }
}

if (trackingToken) {
  updateTracking();
  setInterval(updateTracking, 5000);
}
