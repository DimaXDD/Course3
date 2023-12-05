const rpcws = require('rpc-websockets').Client;
let ws = new rpcws('ws://localhost:4000');

ws.on('open', () => {
    ws.call('square', [3]).then((r)=>{console.log(`square[3]: ${r}`);},(error) => console.log(error.error));
    ws.call('square', [5,4]).then((r)=>{console.log(`square[5,4]: ${r}`);},(error) => console.log(error.error));
    ws.call('sum', [2]).then((r)=>{console.log(`sum[2]: ${r}`);},(error) => console.log(error.error));
    ws.call('sum', [2,4,6,8,10]).then((r)=>{console.log(`sum[2,4,6,8,10]: ${r}`);},(error) => console.log(error.error));
    ws.call('mul', [3]).then((r)=>{console.log(`mul[3]: ${r}`);},(error) => console.log(error.error));
    ws.call('mul', [3,5,7,9,11,13]).then((r)=>{console.log(`mul[3,5,7,9,11,13]: ${r}`);},(error) => console.log(error.error));


    ws.login({login: 'dima', password: 'dima123'})
        .then((login) => {
            if (login) {
                ws.call('fib', [1]).then((r)=>{console.log(`fib[1]: ${r}`);},(error) => console.log(error.error));
                ws.call('fib', [2]).then((r)=>{console.log(`fib[2]: ${r}`);},(error) => console.log(error.error));
                ws.call('fib', [7]).then((r)=>{console.log(`fib[7]: ${r}`);},(error) => console.log(error.error));
                ws.call('fact', [0]).then((r)=>{console.log(`fact[0]: ${r}`);},(error) => console.log(error.error));
                ws.call('fact', [5]).then((r)=>{console.log(`fact[5]: ${r}`);},(error) => console.log(error.error));
                ws.call('fact', [10]).then((r)=>{console.log(`fact[10]: ${r}`);},(error) => console.log(error.error));
            }
            else {
                console.log('login error');
            }
        })
        .catch((e)=>{console.log('login failed: ', e.message)});
});
ws.on('error',(e) => {
    console.log(e)
});