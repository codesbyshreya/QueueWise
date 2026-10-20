// Staff dashboard sample data only. Real queue actions must be handled by the backend.
const queueBody = document.getElementById("queueBody");
if (queueBody) {
  let queue = [
    { token: "A012", service: "Document Verification", joined: "09:12", status: "Waiting" },
    { token: "A013", service: "Fee Payment", joined: "09:14", status: "Waiting" },
    { token: "A014", service: "Student Enquiry", joined: "09:16", status: "Waiting" }
  ];
  let serving = "A011";
  let completed = 8;
  function renderQueue() {
    queueBody.innerHTML = "";
    queue.forEach((item) => {
      const tr = document.createElement("tr");
      const values = [item.token, item.service, item.joined, item.status];
      values.forEach((value) => {
        const td = document.createElement("td");
        td.textContent = value;
        tr.appendChild(td);
      });
      const actionCell = document.createElement("td");
      if (item.status === "Waiting") {
        const call = document.createElement("button");
        call.className = "btn btn-secondary btn-small";
        call.textContent = "Call";
        call.addEventListener("click", () => { item.status = "Called"; serving = item.token; renderQueue(); });
        const skip = document.createElement("button");
        skip.className = "btn btn-warning btn-small";
        skip.textContent = "Skip";
        skip.addEventListener("click", () => { item.status = "Skipped"; renderQueue(); });
        actionCell.append(call, skip);
      } else if (item.status === "Called") {
        const done = document.createElement("button");
        done.className = "btn btn-success btn-small";
        done.textContent = "Complete";
        done.addEventListener("click", () => { item.status = "Completed"; completed++; renderQueue(); });
        actionCell.append(done);
      } else {
        actionCell.textContent = "—";
      }
      tr.appendChild(actionCell);
      queueBody.appendChild(tr);
    });
    document.getElementById("waitingCount").textContent = queue.filter(x => x.status === "Waiting").length;
    document.getElementById("staffServing").textContent = serving;
    document.getElementById("completedCount").textContent = completed;
  }
  document.getElementById("callNextBtn").addEventListener("click", () => {
    const next = queue.find(x => x.status === "Waiting");
    const msg = document.getElementById("staffMessage");
    if (!next) { msg.textContent = "No waiting demo tickets remain."; return; }
    next.status = "Called";
    serving = next.token;
    msg.style.color = "#087f5b";
    msg.textContent = `Called ${next.token}. Demo state only; backend integration is still required.`;
    renderQueue();
  });
  renderQueue();
}
