function firstJob() {
    return new Promise((resolve, reject) => {
      setTimeout(() => {
        resolve('Hello World');
      }, 2000);
    });
}


firstJob()
    // первая функция-обработчик - запустится при вызове resolve
    // вторая функция - запустится при вызове reject
  .then((result) => {
    console.log('Вывод результата (Promise):', result);
  })
  .catch((error) => {
    console.error('Вывод ошибки (Promise):', error);
  });


(async () => {
  try {
    const result = await firstJob();
    console.log('Вывод результата (async/await):', result);
  } catch (error) {
    console.error('Вывод ошибки (async/await):', error);
  }
})();