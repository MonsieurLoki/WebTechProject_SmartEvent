package com.webtechproject.controller;

import com.webtechproject.dao.EventDAO;
import com.webtechproject.model.Event;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PathVariable;
import java.util.List;

@Controller
public class EventController {

    @GetMapping("/events")
    public String listEvents(Model model) {
        EventDAO eventDAO = new EventDAO();
        List<Event> events = eventDAO.getAllEvents();
        model.addAttribute("events", events);
        return "eventList";
    }

    @GetMapping("/events/{id}")
    public String eventDetail(@PathVariable("id") int id, Model model) {
        EventDAO eventDAO = new EventDAO();
        Event event = eventDAO.getEventById(id);
        model.addAttribute("event", event);
        return "eventDetail";
    }
}