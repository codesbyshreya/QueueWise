// Demo token flow. This does not create a database ticket until connected to the backend.
const tokenForm = document.getElementById("tokenForm");
if (tokenForm) {
  tokenForm.addEventListener("submit", (event) => {
    event.preventDefault();
    const serviceId = document.getElementById("service").value;
    const token = {
      tokenNumber: "A" + String(Math.floor(100 + Math.random() * 900)),
      serviceId,
      peopleAhead: Math.floor(Math.random() * 6),
      estimatedWaitMinutes: 5 + Math.floor(Math.random() * 26),
      status: "Waiting"
    };
    if (typeof QueueWise !== "undefined") QueueWise.saveDemoToken(token);
    document.getElementById("tokenNumber").textContent = token.tokenNumber;
    document.getElementById("peopleAhead").textContent = token.peopleAhead;
    document.getElementById("waitTime").textContent = token.estimatedWaitMinutes + " min";
    document.getElementById("tokenStatus").textContent = token.status;
    document.getElementById("tokenResult").scrollIntoView({ behavior: "smooth", block: "nearest" });
  });
}
const trackingToken = document.getElementById("trackingToken");
if (trackingToken) {
  const token = typeof QueueWise !== "undefined" ? QueueWise.getDemoToken() : null;
  if (token) {
    trackingToken.textContent = token.tokenNumber;
    document.getElementById("trackingAhead").textContent = token.peopleAhead;
    document.getElementById("trackingWait").textContent = token.estimatedWaitMinutes + " min";
    document.getElementById("trackingStatus").textContent = token.status;
    document.getElementById("progressText").textContent = token.peopleAhead === 0 ? "Almost your turn" : "In line";
    document.getElementById("progressBar").style.width = Math.max(15, 85 - token.peopleAhead * 12) + "%";
  }
}
