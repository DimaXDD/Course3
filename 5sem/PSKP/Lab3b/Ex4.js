const { v4: uuidv4 } = require('uuid');


function validateCard(cardNumber) {
    console.log('Card number:', cardNumber);
    return Math.random() < 0.5;
}


function createOrder(cardNumber) {
    return new Promise((resolve, reject) => {
      if (!validateCard(cardNumber)) {
        reject(new Error('Card is not valid'));
      } else {
        const orderId = uuidv4();
        setTimeout(() => {
          resolve(orderId);
        }, 5000);
      }
    });
}


function proceedToPayment(orderId) {
    return new Promise((resolve, reject) => {
      console.log('Order ID:', orderId);
      const paymentSuccess = Math.random() < 0.5;
      if (paymentSuccess) {
        resolve('Payment successful');
      } else {
        reject(new Error('Payment failed'));
      }
    });
}

// createOrder('1234-5678-9012-3456')
//   .then((orderId) => {
//     return proceedToPayment(orderId);
//   })
//   .then((paymentResult) => {
//     console.log('Result:', paymentResult);
//   })
//   .catch((error) => {
//     console.error('Error:', error.message);
//   });

// Использование async/await и try/catch
(async () => {
  try {
    const orderId = await createOrder('5678-1234-9012-3456');
    const paymentResult = await proceedToPayment(orderId);
    console.log('Result:', paymentResult);
  } catch (error) {
    console.error('Error:', error.message);
  }
})();