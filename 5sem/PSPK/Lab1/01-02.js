const http = require('http');

const requestHandler = (request, response) => {
  const method = request.method;
  const url = request.url;
  const httpVersion = request.httpVersion;
  const headers = request.headers;

  let requestBody = '';
  request.on('data', (chunk) => {
    requestBody += chunk;
  });

  request.on('end', () => {
    const htmlResponse = `
      <html>
      <head>
        <title>Ответ сервера</title>
      </head>
      <body>
        <h1>Содержимое запроса</h1>
        <h2>Метод: ${method}</h2>
        <h2>URI: ${url}</h2>
        <h2>Версия протокола: ${httpVersion}</h2>
        <h2>Заголовки:</h2>
        <pre>${JSON.stringify(headers, null, 2)}</pre>
        <h2>Тело запроса:</h2>
        <pre>${requestBody}</pre>
      </body>
      </html>
    `;

    response.setHeader('Content-Type', 'text/html; charset=utf-8');
    response.end(htmlResponse);
  });
};

const server = http.createServer(requestHandler);
const port = 3000;

server.listen(port, () => {
  console.log(`Сервер запущен на порту ${port}`);
});