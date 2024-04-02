const express = require('express');
const fs = require("fs");
const path = require("path");

const app = express();
const port = 3000;

app.use(express.json());

app.get('/', (req, res) => {
    fs.readFile(path.join(__dirname, 'WEB2C.html'), 'utf8', (err, text) => {
        res.send(text);
    });
});

app.post('/calculate', (req, res) => {
    const x = parseInt(req.headers['x-value-x']);
    const y = parseInt(req.headers['x-value-y']);

    const z = x + y;

    res.setHeader('X-Value-z', z.toString());
    setTimeout(() => {
        res.end();
    }, 10000);
});

app.post('/generate', (req, res) => {
    const n = parseInt(req.headers['x-rand-n']);

    const count = Math.floor(Math.random() * (10 - 5 + 1)) + 5;
    const numbers = Array.from({ length: count }, () => Math.floor(Math.random() * (2 * n + 1)) - n);

    setTimeout(() => {
        res.json({ numbers });
    }, 1000);
});

app.listen(port, () => console.log(`Server is running at http://localhost:${port}`));