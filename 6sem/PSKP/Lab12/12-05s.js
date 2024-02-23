const redis = require('redis');

const subscriber = redis.createClient({url:'redis://localhost:6379/'});

subscriber.on('ready',() => {console.log('Ready');});
subscriber.on('error',(err) => console.log('Error: ',err));
subscriber.on('connect',() => console.log('Connect'))
subscriber.on('end',() => console.log('End'));

(async () => {
    const oneChannelSub = subscriber.duplicate();
    await oneChannelSub.connect();

    await oneChannelSub.subscribe('channel1', (message) => {
        console.log(`Channel channel1 sent message:  ${message}`);
    });

    setTimeout(async () => {
        await oneChannelSub.unsubscribe();
        await oneChannelSub.quit();
    }, 20000);
})()