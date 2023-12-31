function f1(){
    console.log("f1");
}

function f2(){
    console.log("f2");
}

function f3(){
    console.log("f3");
}

function main(){
    console.log("main");

    setTimeout(f1, 50);
    setTimeout(f2, 30);

    new Promise((resolve, reject) => {
        resolve("I am a Promise, right after f1 and f3! Really?");
    }).then(resolve=>console.log(resolve));

    new Promise((resolve, reject) => {
        resolve("I am a Promise, right after Promise!");
    }).then(resolve=>console.log(resolve));

    f2();
}

main();


















// ========================== Пояснение кода:
// main() вызывается в начале программы.
// Сначала выводится "main" с помощью console.log("main").
// Затем две функции f1 и f2 добавляются в очередь задач для выполнения с помощью setTimeout. 
// f2 устанавливает таймер на 30 миллисекунд, а f1 на 50 миллисекунд.
// Далее создаются два обещания (Promise). Обещания сразу же разрешаются, и их обработчики .then добавляются в очередь микрозадач.
// Затем вызывается функция f2().

// ========================== Как работает Event Loop:

// Вызывается функция main().
// Внутри main() выводится "main" с помощью console.log("main").
// Затем вызывается функция f2(), и "f2" выводится в консоль.

// Затем Event Loop начинает мониторить очередь событий. В этой очереди есть два таймаута (setTimeout) и два успешно разрешенных промиса.
// Event Loop выбирает событие с наименьшим временем задержки (т.е., событие с setTimeout равным 30 миллисекундам). 
// Обработчики .then для обещаний добавляются в очередь микрозадач.
// Вызываются функции, зарегистрированные через setTimeout:
// Первым выполняется f2 (потому что его таймер завершается раньше), и "f2" выводится в консоль.
// Затем выполняется f1, и "f1" выводится в консоль.
//
// С точки зрения Event Loop, выполнение микрозадач имеет более высокий приоритет, 
// и они выполняются перед задачами из очереди задач. Поэтому вывод из .then обработчиков происходит перед 
// выводом из функций, зарегистрированных через setTimeout.

