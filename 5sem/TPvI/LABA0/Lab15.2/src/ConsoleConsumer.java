import com.sun.messaging.ConnectionConfiguration;
import com.sun.messaging.ConnectionFactory;

import javax.jms.*;

public class ConsoleConsumer implements MessageListener {

    ConnectionFactory factory = new ConnectionFactory();
    JMSConsumer consumer;
    static int counterID = 0;

    ConsoleConsumer() {
        try (JMSContext context = factory.createContext("admin", "admin")) {
            context.setClientID(String.valueOf((counterID++)));

            factory.setProperty(ConnectionConfiguration.imqAddressList,
                    "mq://127.0.0.1:7676,mq://127.0.0.1:7676");
            Destination Topic = context.createTopic("topicDestination");
            consumer = context.createDurableConsumer((javax.jms.Topic) Topic, "DurableConsumer");
            consumer.setMessageListener(this);
            System.out.println("Start listening");
            while (true) {
                Thread.sleep(2000);
            }
        } catch (JMSException | InterruptedException e) {
            System.out.println("Error: " + e.getMessage());
        }
    }

    @Override
    public void onMessage(Message message) {
        try {
            System.out.println(message.getBody(String.class));
        } catch (JMSException e) {
            System.out.println("Error: " + e.getMessage());
        }
    }

    public static void main(String[] args) {
        new ConsoleConsumer();
    }
}