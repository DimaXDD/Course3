const express = require('express');
const bodyParser = require('body-parser');
const swaggerUi = require('swagger-ui-express');
const swaggerDocument = require('./swagger.json');
const fs = require('fs');

const port = 3000;
const app = express();

app.use(bodyParser.json());
app.use('/swagger', swaggerUi.serve, swaggerUi.setup(swaggerDocument));

let phonebook = JSON.parse(fs.readFileSync('phone.json', 'utf8'));

app.get('/TS', (req, res) => {
    res.json(phonebook);
});

app.get('/TS/:id', (req, res) => {
    const id = parseInt(req.params.id);
    const contact = phonebook.find(contact => contact.id === id);
    if (contact) {
        res.json(contact);
    } else {
        res.status(404).json({ message: 'Контакт не найден' });
    }
});

app.post('/TS', (req, res) => {
    const { id, name, number } = req.body;

    if (!id || !name || !number) {
        return res.status(400).json({ message: 'ID, имя и номер обязательны' });
    }

    if (phonebook.some(contact => contact.id === id)) {
        return res.status(400).json({ message: 'Контакт с таким ID уже существует' });
    }

    if (phonebook.some(contact => contact.number === number)) {
        return res.status(400).json({ message: 'Контакт с таким номером уже существует' });
    }

    const newContact = { id, name, number };
    phonebook.push(newContact);
    fs.writeFileSync('phone.json', JSON.stringify(phonebook, null, 2));
    res.json(newContact);
});

app.put('/TS/:id', (req, res) => {
    const id = parseInt(req.params.id);
    const { name, number } = req.body;

    if (!name || !number) {
        return res.status(400).json({ message: 'Имя и номер обязательны' });
    }

    if (phonebook.some(contact => contact.id !== id && contact.number === number)) {
        return res.status(400).json({ message: 'Контакт с таким номером уже существует' });
    }

    const index = phonebook.findIndex(contact => contact.id === id);
    if (index !== -1) {
        phonebook[index] = { id, name, number };
        fs.writeFileSync('phone.json', JSON.stringify(phonebook, null, 2));
        res.json(phonebook[index]);
    } else {
        res.status(404).json({ message: 'Контакт не найден' });
    }
});

app.delete('/TS/:id', (req, res) => {
    const id = parseInt(req.params.id);
    const index = phonebook.findIndex(contact => contact.id === id);
    if (index !== -1) {
        phonebook.splice(index, 1);
        fs.writeFileSync('phone.json', JSON.stringify(phonebook, null, 2));
        res.json({ message: 'Контакт успешно удален' });
    } else {
        res.status(404).json({ message: 'Контакт не найден' });
    }
});

app.listen(port, () => { console.log(`Server is running on port ${port}`);});