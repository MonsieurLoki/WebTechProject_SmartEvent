package com.webtechproject.controller;

import com.webtechproject.dao.AdminDAO;
import com.webtechproject.dao.EventDAO;
import com.webtechproject.dao.NotificationDAO;
import com.webtechproject.dao.OrganizerRequestDAO;
import com.webtechproject.model.OrganizerRequest;
import com.webtechproject.model.User;

import jakarta.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;

@Controller
@RequestMapping("/admin")
public class AdminController {

    @GetMapping("/dashboard")
    public String dashboard(HttpSession session, Model model) {
        if (!isAdmin(session)) return "redirect:/events";

        AdminDAO adminDAO = new AdminDAO();
        model.addAttribute("requests", new OrganizerRequestDAO().findPending());
        model.addAttribute("totalUsers", adminDAO.countUsers());
        model.addAttribute("totalOrganizers", adminDAO.countOrganizers());
        model.addAttribute("totalEvents", adminDAO.countEvents());
        model.addAttribute("totalRegistrations", adminDAO.countRegistrations());
        model.addAttribute("organizers", adminDAO.getAllOrganizers());
        model.addAttribute("allEvents", adminDAO.getAllEvents());
        return "adminDashboard";
    }

    @PostMapping("/approve/{userId}")
    public String approve(@PathVariable("userId") int userId, HttpSession session) {
        if (!isAdmin(session)) return "redirect:/events";
        if (new OrganizerRequestDAO().approve(userId)) {
            new NotificationDAO().create(
                    userId,
                    "Your organizer request was approved. You can now create and manage events.",
                    "SUCCESS",
                    "/organizer/dashboard");
        }
        return "redirect:/admin/dashboard";
    }

    @PostMapping("/reject/{userId}")
    public String reject(@PathVariable("userId") int userId, HttpSession session) {
        if (!isAdmin(session)) return "redirect:/events";
        if (new OrganizerRequestDAO().reject(userId)) {
            new NotificationDAO().create(
                    userId,
                    "Your organizer request was rejected. You can submit another request later.",
                    "WARNING",
                    "/request-organizer");
        }
        return "redirect:/admin/dashboard";
    }

    @PostMapping("/revoke/{userId}")
    public String revokeOrganizer(@PathVariable("userId") int userId, HttpSession session) {
        if (!isAdmin(session)) return "redirect:/events";
        if (new AdminDAO().revokeOrganizer(userId)) {
            new NotificationDAO().create(
                    userId,
                    "Your organizer privileges have been revoked by an administrator.",
                    "WARNING",
                    "/events");
        }
        return "redirect:/admin/dashboard";
    }

    @PostMapping("/events/{eventId}/delete")
    public String deleteEvent(@PathVariable("eventId") int eventId, HttpSession session) {
        if (!isAdmin(session)) return "redirect:/events";
        new EventDAO().deleteById(eventId);
        return "redirect:/admin/dashboard";
    }

    private boolean isAdmin(HttpSession session) {
        User user = (User) session.getAttribute("user");
        return user != null && "ADMIN".equals(user.getRole());
    }
}
