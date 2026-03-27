package com.webtechproject.controller;

import com.webtechproject.model.Event;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.List;

@Controller
public class EventController {

    @GetMapping("/events")
    public String listEvents(Model model) {
        // Données fictives pour tester (on branchera la BDD après)
        List<Event> events = Arrays.asList(
            new Event(1, "Tech Conference 2025", "A big tech event",
                LocalDateTime.of(2025, 6, 15, 9, 0),
                "Paris", 200, 49.99, false),
            new Event(2, "Web Dev Workshop", "Learn Spring MVC",
                LocalDateTime.of(2025, 7, 10, 14, 0),
                "Online", 50, 0.0, true),
            new Event(3, "AI Summit", "Artificial Intelligence trends",
                LocalDateTime.of(2025, 8, 20, 10, 0),
                "Lyon", 300, 99.99, false)
        );

        model.addAttribute("events", events);
        return "eventList";
    }
}