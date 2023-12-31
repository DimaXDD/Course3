function secondJob() {
    return new Promise((resolve, reject) => {
      setTimeout(() => {
        reject(new Error("Ошибка: что-то пошло не так :("));
      }, 3000);
    });
}

secondJob()
  .then((result) => {
    console.log('Вывод результата (Promise):', result);
  })
  .catch((error) => {
    console.error('Вывод ошибки (Promise):', error.message);
  });


(async () => {
  try {
    const result = await secondJob();
    console.log('Вывод результата (async/await):', result);
  } catch (error) {
    console.error('Вывод ошибки (async/await):', error.message);
  }
})();