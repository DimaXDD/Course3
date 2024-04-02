const express = require('express');
const fs = require("fs");
const path = require("path");

const app = express();
const port = 3000;

app.use(express.json());

app.get('/', (req, res) => {
    fs.readFile(path.join(__dirname, 'WEB2B.html'), 'utf8', (err, text) => {
        res.send(text);
    });
});


app.post('/generate', (req, res) => {
    const n = parseInt(req.headers['x-rand-n']);

    const count = Math.floor(Math.random() * (10 - 5 + 1)) + 5; // [5, 10]
    const numbers = Array.from({ length: count }, () => Math.floor(Math.random() * (2 * n - 1)) - n); // (-n, n)

    res.json({ numbers });
});

app.listen(port, () => console.log(`Server is running at http://localhost:${port}`));