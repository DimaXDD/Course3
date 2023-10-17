const emailModule = require('m05_tds_v1');

async function main() {
    let from = 'dimatruba2004@yandex.ru';
    let to = 'dimatruba2004@yandex.ru';
    let pass = 'lcoevsvwfcqwzqst';
    let message = 'Hello from 05-04!';
  
    try {
      await emailModule.send(from, to, pass, message);
      console.log('Функция send успешно выполнена');
    } catch (error) {
      console.error('Произошла ошибка при выполнении функции send:', error);
    }
}
  
main();
