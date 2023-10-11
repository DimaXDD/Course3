function thirdJob(data) {
    return new Promise((resolve, reject) => {
        if (!Number.isInteger(data)) {
            reject(new Error('Ошибка: data не является числом'));
        } else if (data % 2 !== 0) {
            setTimeout(() => {
                resolve('odd');
            }, 1000);
        } else {
            setTimeout(() => {
                reject(new Error('even'));
            }, 2000);
        }
    });
}

thirdJob("f")
  .then((result) => {
    console.log('Вывод результата (Promise):', result);
  })
  .catch((error) => {
    console.error('Вывод ошибки (Promise):', error.message);
  });


(async () => {
  try {
    const result = await thirdJob(6);
    console.log('Вывод результата (async/await):', result);
  } catch (error) {
    console.error('Вывод ошибки (async/await):', error.message);
  }
})();