let http = require('http');
const axios = require('axios');

let postData = {x: 3, y: 4, s: "xxx"};

console.log('postData: ', postData);


axios.post('http://localhost:5000/3', postData)
    .then((response) => {
        console.log('Статус ответа:', response.status);
        console.log('Данные ответа:', response.data);
    })
    .catch((error) => {
        console.error('Ошибка при отправке POST-запроса:', error);
    });