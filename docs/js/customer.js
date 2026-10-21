
const tokenForm = document.getElementById("tokenForm");
const trackingToken = document.getElementById("trackingToken");

// Load services and locations from the backend.
async function loadCustomerOptions() {
  if (!tokenForm) return;

  const serviceSelect = document.getElementById("service");
  const locationSelect = document.getElementById("location");
  const generateBtn = document.getElementById("generateBtn");
  const formMessage = document.getElementById("formMessage");

  try {
    const [services, locations] = await Promise.all([
      QueueWise.request("/services"),
      QueueWise.request("/locations")
    ]);

    serviceSelect.replaceChildren(
      new Option("Select a service", "")
    );

    services.forEach(service => {
      serviceSelect.add(
        new Option(service.name, String(service.id))
      );
    });

    locationSelect.replaceChildren(
      new Option("Select a location", "")
    );

    locations.forEach(location => {
      locationSelect.add(
        new Option(location.name, String(location.id))
      );
    });

    generateBtn.disabled = false;
    formMessage.textContent =
      "Services and locations loaded successfully.";
  } catch (error) {
    generateBtn.disabled = true;
    formMessage.textContent =
      "Could not load services or locations. Check that the backend server is running.";
    console.error("Customer options error:", error);
  }
}

if (tokenForm) {
  loadCustomerOptions();

  tokenForm.addEventListener("submit", async event => {
    event.preventDefault();

    const serviceId = document.getElementById("service").value;
    const locationId = document.getElementById("location").value;
    const generateBtn = document.getElementById("generateBtn");
    const formMessage = document.getElementById("formMessage");

    if (!serviceId || !locationId) {
      formMessage.textContent =
        "Please select both a service and a location.";
      return;
    }

    try {
      generateBtn.disabled = true;
      formMessage.textContent = "Generating your token...";

      const data = await QueueWise.request("/queue", {
        method: "POST",
        body: JSON.stringify({
          serviceId: Number(serviceId),
          locationId: Number(locationId)
        })
      });

      const ticket = data.ticket;

      // Save the database ticket in this browser session.
      QueueWise.saveDemoToken(ticket);

      document.getElementById("tokenNumber").textContent =
        ticket.token;
      document.getElementById("peopleAhead").textContent =
        ticket.peopleAhead;
      document.getElementById("waitTime").textContent =
        `${ticket.estimatedWaitMinutes} min`;
      document.getElementById("tokenStatus").textContent =
        ticket.status;

      formMessage.textContent =
        `${data.message} Counter: ${ticket.counterName}, ${ticket.locationName}.`;

      document.getElementById("tokenResult").scrollIntoView({
        behavior: "smooth",
        block: "nearest"
      });
    } catch (error) {
      formMessage.textContent =
        error.message || "Could not create your token.";
      console.error("Token generation error:", error);
    } finally {
      generateBtn.disabled = false;
    }
  });
}

// Update the token tracking page.
async function updateTracking() {
  if (!trackingToken) return;

  const savedTicket = QueueWise.getDemoToken();

  const statusElement = document.getElementById("trackingStatus");
  const nowServingElement = document.getElementById("nowServing");
  const aheadElement = document.getElementById("trackingAhead");
  const waitElement = document.getElementById("trackingWait");
  const progressText = document.getElementById("progressText");
  const progressBar = document.getElementById("progressBar");

  if (!savedTicket || !savedTicket.id || !savedTicket.counterId) {
    trackingToken.textContent = "No token";
    statusElement.textContent = "Not found";
    nowServingElement.textContent = "—";
    aheadElement.textContent = "—";
    waitElement.textContent = "—";
    progressText.textContent = "Generate a token first";
    progressBar.style.width = "0%";
    return;
  }

  try {
    // Only retrieve tickets for this token's counter.
    const queue = await QueueWise.request(
      `/queue?counterId=${encodeURIComponent(savedTicket.counterId)}`
    );

    const ticket = queue.find(
      item => String(item.id) === String(savedTicket.id)
    );

    if (!ticket) {
      trackingToken.textContent = savedTicket.token || "Token not found";
      statusElement.textContent = "Not found";
      nowServingElement.textContent = "—";
      aheadElement.textContent = "—";
      waitElement.textContent = "—";
      progressText.textContent =
        "This token is not in today's queue. It may be from a previous day.";
      progressBar.style.width = "0%";
      return;
    }

    const activeStatuses = ["Waiting", "Serving"];

    const ticketsAhead = queue.filter(item =>
      item.tokenNumber < ticket.tokenNumber &&
      activeStatuses.includes(item.status)
    );

    const peopleAhead = ticketsAhead.length;

    const estimatedWaitMinutes = ticketsAhead.reduce(
      (total, item) =>
        total + Number(item.averageServiceMinutes || 0),
      0
    );

    const servingTicket = queue.find(
      item => item.status === "Serving"
    );

    trackingToken.textContent = ticket.token;
    statusElement.textContent = ticket.status;
    nowServingElement.textContent =
      servingTicket ? servingTicket.token : "None";
    aheadElement.textContent = peopleAhead;
    waitElement.textContent = `${estimatedWaitMinutes} min`;

    if (ticket.status === "Serving") {
      progressText.textContent = "Your turn";
      progressBar.style.width = "100%";
    } else if (ticket.status === "Completed") {
      progressText.textContent = "Service completed";
      progressBar.style.width = "100%";
    } else if (ticket.status === "Skipped") {
      progressText.textContent = "This ticket was skipped";
      progressBar.style.width = "0%";
    } else if (ticket.status === "Cancelled") {
      progressText.textContent = "This ticket was cancelled";
      progressBar.style.width = "0%";
    } else {
      progressText.textContent =
        peopleAhead === 0 ? "Next in line" : "Waiting in queue";

      progressBar.style.width =
        `${Math.max(10, 100 - peopleAhead * 15)}%`;
    }
  } catch (error) {
    progressText.textContent = "Unable to refresh queue";
    console.error("Tracking error:", error);
  }
}

if (trackingToken) {
  updateTracking();
  setInterval(updateTracking, 5000);
}
