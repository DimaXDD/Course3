function secondJob() {
    return new Promise((resolve, reject) => {
      setTimeout(() => {
        reject(new Error("Ошибка: что-то пошло не так :("));
      }, 3000);
    });
}

secondJob()
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
    const result = await secondJob();
    console.log('Вывод результата (async/await):', result);
  } catch (error) {
    console.error('Вывод ошибки (async/await):', error);
  }
})();