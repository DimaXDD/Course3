const TelegramBot = require('node-telegram-bot-api');
const cron = require('node-cron');
const axios = require('axios');

const token = '';
const weatherApiToken = '';

const bot = new TelegramBot(token, { polling: true });

let subscribers = [];

// Случайный факт
async function sendRandomFact(chatId) {
    try {
        const response = await axios.get('https://useless-facts.sameerkumar.website/api');
        const fact = response.data.data;
        bot.sendMessage(chatId, fact);
    } catch (error) {
        console.error('Error fetching fact:', error);
    }
}

// /subscribe
bot.onText(/\/subscribe/, (msg) => {
    const chatId = msg.chat.id;
    if (!subscribers.includes(chatId)) {
        subscribers.push(chatId);
        bot.sendMessage(chatId, 'Вы подписались на рассылку случайного факта.');
        
        if (subscribers.length === 1) {
            cron.schedule('*/3 * * * * *', () => {
                subscribers.forEach(chatId => {
                    sendRandomFact(chatId);
                });
            });
        }
    } else {
        bot.sendMessage(chatId, 'Вы уже подписаны на рассылку.');
    }

    console.log('Список подписчиков:', subscribers);
});

// /unsubscribe
bot.onText(/\/unsubscribe/, (msg) => {
    const chatId = msg.chat.id;
    if (subscribers.includes(chatId)) {
        subscribers = subscribers.filter(id => id !== chatId);
        bot.sendMessage(chatId, 'Вы отписались от рассылки.');
    } else {
        bot.sendMessage(chatId, 'Вы не подписаны на рассылку.');
    }

    console.log('Список подписчиков:', subscribers);
});

// /weather
bot.onText(/\/weather (.+)/, async (msg, match) => {
    const chatId = msg.chat.id;
    const city = match[1];
    
    try {
        const url = `https://api.weatherapi.com/v1/current.json?key=${weatherApiToken}&q=${city}&aqi=no`;
        const response = await axios.get(url);
        const { location, current } = response.data;
        
        const weatherInfo = `
            Город: ${location.name}, ${location.country}
            Температура: ${current.temp_c}°C
            Влажность: ${current.humidity}%
            Давление: ${current.pressure_mb}hPa
            Ветер: ${current.wind_kph}km/h ${current.wind_dir}
            Условия: ${current.condition.text}
            Время обновления: ${current.last_updated}
        `;
        
        bot.sendMessage(chatId, weatherInfo);
    } catch (error) {
        console.error('Error fetching weather:', error);
        bot.sendMessage(chatId, 'Не удалось получить информацию о погоде.');
    }
});

// /joke
bot.onText(/\/joke/, async (msg) => {
    const chatId = msg.chat.id;
    try {
        const response = await axios.get('http://www.anekdot.ru/random/anekdot/');

        const joke = response.data.match(/<div class="text">([\s\S]*?)<\/div>/);
        
        if (joke && joke[1]) {
            const formattedJoke = joke[1].trim().replace(/<br>/g, '\n');
            bot.sendMessage(chatId, formattedJoke);
        } else {
            throw new Error('Не удалось получить шутку.');
        }
    } catch (error) {
        console.error('Error fetching joke:', error);
        bot.sendMessage(chatId, 'Не удалось получить шутку.');
    }
});

// /cat 
bot.onText(/\/cat/, async (msg) => {
    const chatId = msg.chat.id;
    try {
        const response = await axios.get('https://api.thecatapi.com/v1/images/search');
        const imageUrl = response.data[0].url;
        bot.sendPhoto(chatId, imageUrl);
    } catch (error) {
        console.error('Error fetching cat image:', error);
        bot.sendMessage(chatId, 'Не удалось найти изображение кота.');
    }
});

// Фраза - стикер
const stickerResponses = {
    'привет': 'CAACAgIAAxkBAAEE5k5mJivGr01zxdwlzBMUYoxCMxHEywACmiYAAsW9EEg0bXhcNRBQXzQE',
    'собака': 'CAACAgIAAxkBAAEE1khmIiLak5MbAvFwzyDlEMR1lAN16QACkCcAAhLyIEg9O6gXk25-DjQE',
    'я сдал лабу': 'CAACAgIAAxkBAAEE1yhmIjv0LTmpKD592EvqbfGUDUN3PQACBiIAAvGGKEoNsuLaUDlyBzQE',
    'не сдал лабу': 'CAACAgIAAxkBAAEE1yZmIjvnOoZq8dxnZdl-eGLbgtNjJwAC6x8AAqcsMEq-EYUf5kZkljQE'
};

// Отправка стикеров в ответ
bot.on('message', (msg) => {
    const chatId = msg.chat.id;
    const messageText = msg.text.toLowerCase();

    for (const [phrase, sticker] of Object.entries(stickerResponses)) {
        if (messageText.includes(phrase)) {
            bot.sendSticker(chatId, sticker);
            return;
        }
    }
});


bot.on('message', (msg) => {
    bot.sendMessage(msg.chat.id, 'Echo: ' + msg.text);
});



console.log('Бот запущен');