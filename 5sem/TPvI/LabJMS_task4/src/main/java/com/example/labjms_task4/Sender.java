package com.example.labjms_task4;

import com.sun.messaging.ConnectionConfiguration;
import com.sun.messaging.ConnectionFactory;

import javax.jms.JMSContext;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;

@WebServlet(name = "Sender", value = "/Sender")
public class Sender extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String message = request.getParameter("message");
        // factory
        System.out.println(message);

        ConnectionFactory factory = new com.sun.messaging.ConnectionFactory();

        try(JMSContext context = factory.createContext("admin", "admin")) {
            factory.setProperty(ConnectionConfiguration.imqAddressList, "mq://127.0.0.1:7676, mq://127.0.0.1:7676");
            // destination
            javax.jms.Destination cardsQueue = context.createQueue("Servlet");
            // producer
            javax.jms.JMSProducer producer = context.createProducer();
            // send
            producer.send(cardsQueue, message);

            response.sendRedirect(request.getContextPath() + "/index.jsp");

        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
    }
}
