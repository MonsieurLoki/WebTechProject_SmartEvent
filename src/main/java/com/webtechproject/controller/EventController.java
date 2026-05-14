package com.webtechproject.controller;

import com.webtechproject.dao.EventDAO;
import com.webtechproject.dao.FeedbackDAO;
import com.webtechproject.dao.RegistrationDAO;
import com.webtechproject.model.Event;
import com.webtechproject.model.Feedback;
import com.webtechproject.model.Registration;
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
    public String eventDetail(@PathVariable("id") int id, HttpSession session, Model model) {
        EventDAO eventDAO = new EventDAO();
        Event event = eventDAO.getEventById(id);
        if (event == null) return "redirect:/events";

        FeedbackDAO feedbackDAO = new FeedbackDAO();
        User user = (User) session.getAttribute("user");

        model.addAttribute("event", event);
        model.addAttribute("eventFinished", feedbackDAO.isEventFinished(id));
        model.addAttribute("averageRating", feedbackDAO.getAverageRatingByEventId(id));
        model.addAttribute("ratingCount", feedbackDAO.countByEventId(id));
        model.addAttribute("feedbackList", feedbackDAO.findByEventId(id));
        if (user != null) {
            model.addAttribute("userFeedback", feedbackDAO.findByUserAndEvent(user.getId(), id));
        }
        return "eventDetail";
    }

    @PostMapping("/events/{id}/feedback")
    public String submitFeedback(@PathVariable("id") int eventId,
                                 @RequestParam("rating") int rating,
                                 @RequestParam(value = "comment", required = false) String comment,
                                 HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) return "redirect:/login";
        if (!"ATTENDEE".equals(user.getRole())) return "redirect:/events/" + eventId;
        if (rating < 1 || rating > 5) return "redirect:/events/" + eventId + "?error=invalid_rating";

        EventDAO eventDAO = new EventDAO();
        Event event = eventDAO.getEventById(eventId);
        if (event == null) return "redirect:/events";
        FeedbackDAO feedbackDAO = new FeedbackDAO();
        if (!feedbackDAO.isEventFinished(eventId)) {
            return "redirect:/events/" + eventId + "?error=event_not_finished";
        }

        if (feedbackDAO.findByUserAndEvent(user.getId(), eventId) != null) {
            return "redirect:/events/" + eventId + "?error=already_feedback";
        }

        Feedback feedback = new Feedback();
        feedback.setUserId(user.getId());
        feedback.setEventId(eventId);
        feedback.setRating(rating);
        feedback.setComment(comment == null || comment.trim().isEmpty() ? null : comment.trim());

        if (!feedbackDAO.save(feedback)) {
            return "redirect:/events/" + eventId + "?error=feedback_failed";
        }

        return "redirect:/events/" + eventId;
    }

@GetMapping("/events/create")
public String createEventPage(HttpSession session, Model model) {
    User user = (User) session.getAttribute("user");
    if (user == null) return "redirect:/login";
    if (!user.getRole().equals("ORGANIZER") && !user.getRole().equals("ADMIN")) {
        model.addAttribute("error", "Only organizers can create events.");
        return "redirect:/events";
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
        if (organizer == null) return "redirect:/login";
        if (!organizer.getRole().equals("ORGANIZER") && !organizer.getRole().equals("ADMIN")) {
            return "redirect:/events";
        }
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

    @GetMapping("/events/{id}/edit")
    public String editEventPage(@PathVariable("id") int eventId, HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) return "redirect:/login";
        EventDAO eventDAO = new EventDAO();
        Event event = eventDAO.getEventById(eventId);
        if (event == null) return "redirect:/events";
        if (!isEventOwnerOrAdmin(event, user)) return "redirect:/events";
        model.addAttribute("event", event);
        return "editEvent";
    }

    @PostMapping("/events/{id}/edit")
    public String editEvent(@PathVariable("id") int eventId,
                            @RequestParam("title") String title,
                            @RequestParam("description") String description,
                            @RequestParam("dateTime") String dateTime,
                            @RequestParam("location") String location,
                            @RequestParam("capacity") int capacity,
                            @RequestParam("price") double price,
                            @RequestParam(value = "isVirtual", defaultValue = "false") boolean isVirtual,
                            HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) return "redirect:/login";
        EventDAO eventDAO = new EventDAO();
        Event event = eventDAO.getEventById(eventId);
        if (event == null) return "redirect:/events";
        if (!isEventOwnerOrAdmin(event, user)) return "redirect:/events";

        event.setTitle(title);
        event.setDescription(description);
        event.setDateTime(LocalDateTime.parse(dateTime));
        event.setLocation(location);
        event.setCapacity(capacity);
        event.setPrice(price);
        event.setVirtual(isVirtual);

        eventDAO.update(event);
        return "redirect:/events/" + eventId;
    }

    @PostMapping("/events/{id}/delete")
    public String deleteEvent(@PathVariable("id") int eventId, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) return "redirect:/login";
        EventDAO eventDAO = new EventDAO();
        Event event = eventDAO.getEventById(eventId);
        if (event == null) return "redirect:/events";
        if (!isEventOwnerOrAdmin(event, user)) return "redirect:/events";
        eventDAO.deleteById(eventId);
        return "redirect:/events";
    }

    private boolean isEventOwnerOrAdmin(Event event, User user) {
        if (user == null) return false;
        if ("ADMIN".equals(user.getRole())) return true;
        return "ORGANIZER".equals(user.getRole()) && event.getOrganizerId() == user.getId();
    }

    @PostMapping("/events/{id}/register")
    public String registerForEvent(@PathVariable("id") int eventId, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) return "redirect:/login";
        if ("ORGANIZER".equals(user.getRole()) || "ADMIN".equals(user.getRole())) {
            return "redirect:/events/" + eventId;
        }

        RegistrationDAO registrationDAO = new RegistrationDAO();
        EventDAO eventDAO = new EventDAO();

        if (registrationDAO.existsByUserAndEvent(user.getId(), eventId)) {
            return "redirect:/events/" + eventId + "?error=already_registered";
        }

        Event event = eventDAO.getEventById(eventId);
        if (event == null) return "redirect:/events";

        int registered = registrationDAO.countByEventId(eventId);
        if (registered >= event.getCapacity()) {
            return "redirect:/events/" + eventId + "?error=full";
        }

        Registration registration = new Registration();
        registration.setUserId(user.getId());
        registration.setEventId(eventId);
        registration.setTicketType("STANDARD");
        registration.setPricePaid(event.getPrice());
        registrationDAO.save(registration);

        return "redirect:/my-tickets";
    }

    @GetMapping("/my-tickets")
    public String myTickets(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) return "redirect:/login";
        if ("ORGANIZER".equals(user.getRole()) || "ADMIN".equals(user.getRole())) {
            return "redirect:/organizer/dashboard";
        }
        RegistrationDAO registrationDAO = new RegistrationDAO();
        List<Registration> registrations = registrationDAO.findByUserId(user.getId());
        model.addAttribute("registrations", registrations);
        return "myTickets";
    }
}
