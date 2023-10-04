package by.trubach.springtransport.controller;

import by.trubach.springtransport.forms.TransportForm;
import by.trubach.springtransport.model.Transport;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import java.util.ArrayList;
import java.util.List;


@Slf4j
@Controller
public class TransportController {
    private static List<Transport> transports = new ArrayList<Transport>();

    static {
        transports.add(new Transport("Audi A8", "Luxury sedan with advanced features"));
        transports.add(new Transport("BMW e60", "Sporty executive car with elegance"));
    }

    // Вводится (inject) из application.properties.
    @Value("${welcome.message}")
    private String message;

    @Value("${error.message}")
    private String errorMessage;

    @RequestMapping(value = {"/", "/index"}, method = RequestMethod.GET)
    public ModelAndView index(Model model) {
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.setViewName("index");
        model.addAttribute("message", message);
        log.info("/index was called");
        return modelAndView;

    }

    @RequestMapping(value = {"/alltransports"}, method = RequestMethod.GET)
    public ModelAndView personList(Model model) {
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.setViewName("transportlist"); // имя файла html
        model.addAttribute("transports", transports);
        log.info("/alltransports was called");
        return modelAndView;
    }

    @RequestMapping(value = {"/addtransport"}, method = RequestMethod.GET)
    public  ModelAndView showAddPersonPage(Model model) {
        ModelAndView modelAndView = new ModelAndView("addtransport");
        TransportForm transportForm = new TransportForm();
        model.addAttribute("transportform", transportForm);
        log.info("/addtransport was called");
        return modelAndView;
    }
    //  @PostMapping("/addtransport")
    //GetMapping("/")
    @RequestMapping(value = {"/addtransport"}, method = RequestMethod.POST)
    public ModelAndView savePerson(Model model, //
                                   @ModelAttribute("transportform") TransportForm transportForm) {
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.setViewName("transportlist");
        String name = transportForm.getName();
        String description = transportForm.getDescription();

        if (name != null && name.length() > 0 //
                && description != null && description.length() > 0) {
            Transport newTransport = new Transport(name, description);
            transports.add(newTransport);
            model.addAttribute("transports",transports);
            return modelAndView;
        }
        model.addAttribute("errorMessage", errorMessage);
        modelAndView.setViewName("addtransport");
        return modelAndView;
    }


    // удаление
    @RequestMapping(value = "/deletetransport", method = RequestMethod.POST)
    public ModelAndView deleteTransport(Model model,
                                        @RequestParam("name") String name,
                                        @RequestParam("description") String description) {
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.setViewName("redirect:/alltransports");

        Transport transportToDelete = null;
        for (Transport transport : transports) {
            if (transport.getName().equals(name) && transport.getDescription().equals(description)) {
                transportToDelete = transport;
                break;
            }
        }

        if (transportToDelete != null) {
            transports.remove(transportToDelete);
            model.addAttribute("transports", transports);
        }
        log.info("/deletetransport was called");
        return modelAndView;
    }

    // редактирование
    @RequestMapping(value = "/edittransport", method = RequestMethod.POST)
    public ModelAndView editTransport(Model model,
                                      @RequestParam("name") String name,
                                      @RequestParam("description") String description) {
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.setViewName("edittransport");
        TransportForm transportForm = new TransportForm();
        transportForm.setName(name);
        transportForm.setDescription(description);
        model.addAttribute("transportform", transportForm);
        log.info("/edittransport was called");
        return modelAndView;
    }
    //метод для обработки запроса на обновление данных
    @RequestMapping(value = "/updatetransport", method = RequestMethod.POST)
    public ModelAndView updateTransport(Model model,
                                        @RequestParam("name") String name,
                                        @RequestParam("description") String description,
                                        @RequestParam("newName") String newName,
                                        @RequestParam("newDescription") String newDescription) {
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.setViewName("redirect:/alltransports");

        Transport transportToUpdate = null;
        for (Transport transport : transports) {
            if (transport.getName().equals(name) && transport.getDescription().equals(description)) {
                transportToUpdate = transport;
                break;
            }
        }

        if (transportToUpdate != null) {
            transportToUpdate.setName(newName);
            transportToUpdate.setDescription(newDescription);
            model.addAttribute("transports", transports);
        }

        return modelAndView;
    }

}
