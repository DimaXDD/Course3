const Koa = require('koa');
const Router = require('koa-router');
const fs = require("fs").promises;
const path = require("path");

const app = new Koa();
const router = new Router();
const port = 3000;

app.use(require('koa-bodyparser')());

router.get('/', async (ctx) => {
    const filePath = path.join(__dirname, 'WEB2A.html');
    const text = await fs.readFile(filePath, 'utf8');
    ctx.body = text;
});

router.post('/calculate', async (ctx) => {
    const x = parseInt(ctx.request.header['x-value-x']);
    const y = parseInt(ctx.request.header['x-value-y']);

    const z = x + y;

    ctx.set('X-Value-z', z.toString());
    ctx.status = 200;
});

app.use(router.routes());
app.use(router.allowedMethods());

app.listen(port, () => console.log(`Server is running at http://localhost:${port}`));