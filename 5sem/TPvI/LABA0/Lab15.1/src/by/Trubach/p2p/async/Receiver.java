package by.Trubach.p2p.async;

import com.sun.messaging.ConnectionConfiguration;

import javax.jms.*;

public class Receiver implements MessageListener {
    com.sun.messaging.ConnectionFactory factory= new com.sun.messaging.ConnectionFactory();
    private JMSConsumer consumer;

    Receiver() {
        try (JMSContext context = factory.createContext("admin", "admin")) {
            factory.setProperty(ConnectionConfiguration.imqAddressList,
                    "mq://127.0.0.1:7676, mq://127.0.0.1:7676");
            Destination messageQueue = context.createQueue("P2PAsyncQueue");

            consumer = context.createConsumer(messageQueue);
            consumer.setMessageListener(this);
            System.out.println("Listening to P2PAsyncQueue...");
            while (true) {
                Thread.sleep(1000);
            }
        } catch (InterruptedException | JMSException e) {
            System.out.println(e.getMessage());
        }
    }

    @Override
    public void onMessage(javax.jms.Message message) {
        try {
            System.out.println("recieved: "+
                    message.getBody(by.Trubach.p2p.Message.class));
                    System.out.println("\nВот что такое toString () для печати сообщения \n"+ message);

        } catch (Exception e) {
            System.err.println("JMSException: " + e.toString());
        }
    }

    public static void main (String[] args){
        new Receiver();
    }
}