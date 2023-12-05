const async = require('async')
const rpcws = require('rpc-websockets').Client
let ws = new rpcws('ws://localhost:4000');

ws.on('open', () => {
    ws.login({ login: 'dima', password: 'dima123' })
        .then(async login => {
            await calculate();
        });
});

async function calculate() {
    console.log('sum(square(3), square(5,4), mul(3,5,7,9,11,13)) + fib(7) * mul(2,4,6)=\n' +
                (await ws.call('sum',
                        [
                            await ws.call('square', [3]),
                            await ws.call('square', [5, 4]),
                            await ws.call('mul', [3, 5, 7, 9, 11, 13])
                        ])
                    + await ws.call('fib', [7])
                    * await ws.call('mul', [2, 4, 6]))
    );
}