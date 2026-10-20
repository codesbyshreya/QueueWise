
const express = require('express');

const app = express();
const PORT = 3000;

app.use(express.json());

// Sample queue data
let queue = [
    { id: 1, token: "Q001", status: "Waiting" },
    { id: 2, token: "Q002", status: "Waiting" },
    { id: 3, token: "Q003", status: "Serving" }
];

// Home route
app.get('/', (req, res) => {
    res.json({
        message: 'QueueWise backend is running!'
    });
});

// Get all queue tickets
app.get('/api/queue', (req, res) => {
    res.json(queue);
});


app.post('/api/queue', (req, res) => {
    const newId = queue.length > 0
        ? Math.max(...queue.map(ticket => ticket.id)) + 1
        : 1;

    const newToken = {
        id: newId,
        token: `Q${String(newId).padStart(3, '0')}`,
        status: 'Waiting'
    };

    queue.push(newToken);

    res.status(201).json({
        message: 'Token created successfully!',
        ticket: newToken
    });
});


app.post('/api/queue/next', (req, res) => {
    const nextTicket = queue.find(
        ticket => ticket.status === 'Waiting'
    );

    if (!nextTicket) {
        return res.status(404).json({
            message: 'No waiting tickets in the queue.'
        });
    }

    nextTicket.status = 'Serving';

    res.json({
        message: 'Next ticket called successfully!',
        ticket: nextTicket
    });
});


// Start server
app.listen(PORT, () => {
    console.log(`QueueWise server running at http://localhost:${PORT}`);
});
