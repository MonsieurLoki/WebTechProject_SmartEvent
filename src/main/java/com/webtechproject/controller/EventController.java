package com.webtechproject.controller;

import com.webtechproject.dao.EventDAO;
import com.webtechproject.model.Event;
import com.webtechproject.model.User;

import jakarta.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.time.LocalDateTime;
import java.util.List;

@Controller
public class EventController {

    @GetMapping("/")
    public String home() {
        return "redirect:/events";
    }

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

@GetMapping("/events/create")
public String createEventPage(HttpSession session, Model model) {
    if (session.getAttribute("user") == null) {
        return "redirect:/login";
    }
    return "createEvent";
}

    @PostMapping("/events/create")
    public String createEvent(@RequestParam("title") String title,
                            @RequestParam("description") String description,
                            @RequestParam("dateTime") String dateTime,
                            @RequestParam("location") String location,
                            @RequestParam("capacity") int capacity,
                            @RequestParam("price") double price,
                            @RequestParam(value = "isVirtual", defaultValue = "false") boolean isVirtual,
                            HttpSession session) {
        User organizer = (User) session.getAttribute("user");
        Event event = new Event();
        event.setTitle(title);
        event.setDescription(description);
        event.setDateTime(LocalDateTime.parse(dateTime));
        event.setLocation(location);
        event.setCapacity(capacity);
        event.setPrice(price);
        event.setVirtual(isVirtual);
        event.setOrganizerId(organizer.getId());
        EventDAO eventDAO = new EventDAO();
        eventDAO.save(event);
        return "redirect:/events";
    }
}