import com.sun.messaging.ConnectionConfiguration;
import com.sun.messaging.ConnectionFactory;

import javax.jms.Destination;
import javax.jms.JMSContext;
import javax.jms.JMSProducer;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/ServletProducer")
public class ServletProducer extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        PrintWriter writer = response.getWriter();
        try {
            String message = request.getParameter("message");
            ConnectionFactory factory;
            factory = new ConnectionFactory();
            try (JMSContext context = factory.createContext("admin", "admin")) {

                factory.setProperty(ConnectionConfiguration.imqAddressList,
                        "mq://127.0.0.1:7676,mq://127.0.0.1:7676");

                JMSProducer producer = context.createProducer();
                Destination Topic = context.createTopic("topicDestination");
                producer.send(Topic, message);
            } catch (Exception e) {
                writer.println(e.getMessage());
            }
        } catch (Exception exception) {
            exception.printStackTrace();
        }
    }
}