const rpcws = require('rpc-websockets').Server;

let server = new rpcws({port: 4000, host: 'localhost'});

server.setAuth((l) => {return (l.login == 'dima' && l.password== 'dima123')});

server.register('sum', params => {
    let sum = 0;
    params.forEach(elem => {
        if (Number.isInteger(elem))
            sum += elem;
    });
    return sum;
}).public();

server.register('mul', params => {
    let mul = 1;
    params.forEach(elem => {
        if (Number.isInteger(elem))
            mul *= elem;
    });
    return mul;
}).public();

server.register('square', params => {
    return (params.length === 2) ? (params[0] * params[1]) : (Math.PI * (params[0] ** 2));
}).public();

server.register('fact', params => {
    if (params.length !== 1)
        return [1];
    return factorial(params[0]);
}).protected();

server.register('fib', params => {
    if (params.length !== 1)
        return [1];
    return fibonacci(params[0]);
}).protected();

function factorial(n) {
    return (n == 1 || n == 0) ? 1 : n * factorial(n - 1);
}

function fibonacci(n) {
    if (n <= 0) return [];
    if (n == 1) return [0];
    if (n == 2) return [0, 1];
    let fibArray = [0, 1];
    for (let i = 2; i < n; i++) {
        fibArray.push(fibArray[i - 1] + fibArray[i - 2]);
    }
    return fibArray;
}

