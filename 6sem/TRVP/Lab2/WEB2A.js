const express = require('express');
const fs = require("fs");
const path = require("path");

const app = express();
const port = 3000;

app.use(express.json());

app.get('/', (req, res) => {
    fs.readFile(path.join(__dirname, 'WEB2A.html'), 'utf8', (err, text) => {
        res.send(text);
    });
});

app.post('/calculate', (req, res) => {
    const x = parseInt(req.headers['x-value-x']);
    const y = parseInt(req.headers['x-value-y']);

    const z = x + y;

    res.setHeader('X-Value-z', z.toString());
    res.end();
});


app.listen(port, () => console.log(`Server is running at http://localhost:${port}`));