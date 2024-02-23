const redis = require('redis');

const client = redis.createClient({url:'redis://localhost:6379/'});

client.on('ready',() => {console.log('Ready');});
client.on('error',(err) => console.log('Error: ',err));
client.on('connect',() => console.log('Connect'))
client.on('end',() => console.log('End'));

(async () => {
    await client.connect();

    let startTime = new Date().getTime();
    for (let i = 0; i < 10000; i++) {
        await client.hSet('key', `${i}`, JSON.stringify({'id': i, 'val': `val-${i}`}));
    }
    let endTime = new Date().getTime();
    console.log(`Hset: ${endTime - startTime}ms`);

    startTime = new Date().getTime();
    for (let i = 0; i < 10000; i++) {
        await client.hGet('key', `${i}`);
    }
    endTime = new Date().getTime();
    console.log(`Hget: ${endTime - startTime}ms`);

    await client.quit();
})()