const Koa = require('koa');
const Router = require('koa-router');
const fs = require("fs").promises;
const path = require("path");

const app = new Koa();
const router = new Router();
const port = 3000;

app.use(require('koa-bodyparser')());

router.get('/', async (ctx) => {
    const filePath = path.join(__dirname, 'WEB2C.html');
    const text = await fs.readFile(filePath, 'utf8');
    ctx.body = text;
});

router.post('/calculate', async (ctx) => {
    const x = parseInt(ctx.request.header['x-value-x']);
    const y = parseInt(ctx.request.header['x-value-y']);

    const z = x + y;

    ctx.set('X-Value-z', z.toString());
    
    await new Promise(resolve => setTimeout(resolve, 10000));
    
    ctx.status = 200;
});

router.post('/generate', async (ctx) => {
    const n = parseInt(ctx.request.header['x-rand-n']);

    const count = Math.floor(Math.random() * (10 - 5 + 1)) + 5;
    const numbers = Array.from({ length: count }, () => Math.floor(Math.random() * (2 * n + 1)) - n);

    await new Promise(resolve => setTimeout(resolve, 1000));

    ctx.body = { numbers };
});

app.use(router.routes());
app.use(router.allowedMethods());

app.listen(port, () => console.log(`Server is running at http://localhost:${port}`));