package by.Trubach.pub_sub.confirmations;



import com.sun.messaging.ConnectionConfiguration;

import javax.jms.*;

public class Receiver1 implements MessageListener {
    com.sun.messaging.ConnectionFactory factory= new com.sun.messaging.ConnectionFactory();
    private JMSConsumer consumer;

    Receiver1() {
        try (JMSContext context = factory.createContext("admin", "admin", JMSContext.AUTO_ACKNOWLEDGE )) {
            factory.setProperty(ConnectionConfiguration.imqAddressList,
                    "mq://127.0.0.1:7676, mq://127.0.0.1:7676");
            Destination priceInfo= context.createTopic("PubSub");
            consumer = context.createConsumer(priceInfo);
            consumer.setMessageListener(this);
            while (true) {
                Thread.sleep(1000);
            }
        } catch (JMSException | InterruptedException e) {
            System.out.println(e.getMessage());
        }
    }

    @Override
    public void onMessage(javax.jms.Message message) {
        try {
            System.out.println("recieved: "+ message.getBody(String.class));
        } catch (Exception e) {
            System.err.println("JMSException: " + e.toString());
        }
    }

    public static void main (String[] args){
        new Receiver1();
    }
}