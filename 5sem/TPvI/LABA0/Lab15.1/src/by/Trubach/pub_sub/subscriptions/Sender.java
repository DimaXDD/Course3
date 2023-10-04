package by.Trubach.pub_sub.subscriptions;

import com.sun.messaging.ConnectionConfiguration;
import com.sun.messaging.ConnectionFactory;

import javax.jms.*;

public class Sender {

    public static void main(String[] args){
        ConnectionFactory factory= new com.sun.messaging.ConnectionFactory();
        try(JMSContext context = factory.createContext("admin", "admin")){
            factory.setProperty(ConnectionConfiguration.imqAddressList,
                    "mq://127.0.0.1:7676,mq://127.0.0.1:7676");
            Destination priceInfo  = context.createTopic("PubSub");
            TextMessage outMsg = context.createTextMessage();
            outMsg.setText("PNV 100 2536721");
            outMsg.setStringProperty("symbol", "BSTU");
            context.createProducer().send(priceInfo, outMsg);
            JMSProducer producer = context.createProducer();
            producer.send(priceInfo,"Random");
            System.out.println("message sent");
        } catch (JMSException e) {
            System.out.println("ConnectionConfigurationError: " + e.getMessage());
        }
    }
}