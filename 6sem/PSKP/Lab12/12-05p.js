const redis = require('redis');

const publisher = redis.createClient({url:'redis://localhost:6379/'});

publisher.on('ready',() => {console.log('Ready');});
publisher.on('error',(err) => console.log('Error: ',err));
publisher.on('connect',() => console.log('Connect'))
publisher.on('end',() => console.log('End'));

(async () => {
    await publisher.connect();

    setTimeout(async () => {await publisher.publish('channel1', 'message1');}, 1000);
    setInterval(async () => {await publisher.publish('channel1', 'messageXXX');}, 2000).unref;
    setTimeout(async () => {await publisher.publish('channel2', 'message2');}, 3000);
    setTimeout(async () => {await publisher.publish('channel1', 'message3');}, 7000);

    setTimeout(async () => {await publisher.quit();}, 15000);
})()