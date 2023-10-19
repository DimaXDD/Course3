package com.example.labjms_task4;

import com.sun.messaging.ConnectionConfiguration;

import com.sun.messaging.ConnectionFactory;

import javax.jms.JMSContext;
import javax.jms.JMSException;
import javax.jms.Message;
import javax.jms.MessageListener;
import java.io.IOException;

public class Listener implements MessageListener {
    @Override
    public void onMessage(Message message) {
        try {
            System.out.println("Message from servlet: " + message.getBody(String.class));
        } catch (Exception e) {
            System.err.println("JMSException: " + e.toString());
        }
    }

    public static void main(String[] args) {
        ConnectionFactory factory = new com.sun.messaging.ConnectionFactory();
        try (JMSContext context = factory.createContext("admin", "admin")) {
            factory.setProperty(ConnectionConfiguration.imqAddressList, "mq://127.0.0.1:7676, mq://127.0.0.1:7676");
            javax.jms.Destination cardsQueue = context.createQueue("Servlet");
            javax.jms.JMSConsumer consumer = context.createConsumer(cardsQueue);
            consumer.setMessageListener(new Listener());
            System.out.println("Listening to the Servlet queue...");
            System.in.read();
        } catch (JMSException e) {
            throw new RuntimeException(e);
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }
}


