    const express = require('express');

const pulpitRouter = require('./routes/pulpit.routes');
const subjectsRouter = require('./routes/subjects.routes');
const auditoriumsRouter = require('./routes/auditoriums.routes');
const auditoriumstypesRouter = require('./routes/auditoriumstypes.routes');
const facultiesRouter = require('./routes/faculties.routes');

const PORT = process.env.PORT || 3000;
const app = express();

app.use(express.json());
app.use(express.urlencoded({ extended: true }));


app.get('/', (req, res) => {
    res.sendFile(__dirname + "//index.html");
});
app.use('/api', pulpitRouter);
app.use('/api', subjectsRouter);
app.use('/api', auditoriumsRouter);
app.use('/api', auditoriumstypesRouter);
app.use('/api', facultiesRouter);

app.listen(PORT, ()=> console.log(`Server started on PORT: ${PORT}`));