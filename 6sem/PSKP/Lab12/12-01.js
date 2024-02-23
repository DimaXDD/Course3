const redis = require('redis');

const client = redis.createClient({url:'redis://localhost:6379/'});

client.on('ready',() => {console.log('Ready');});
client.on('error',(err) => console.log('Error: ',err));
client.on('connect',() => console.log('Connect'))
client.on('end',() => console.log('End'));

client.connect()
.then(() => {
    client.quit();
})
.catch((err => console.log(err)))