package com.webtechproject.controller;

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
        OrganizerRequestDAO dao = new OrganizerRequestDAO();
        List<OrganizerRequest> requests = dao.findPending();
        model.addAttribute("requests", requests);
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

    private boolean isAdmin(HttpSession session) {
        User user = (User) session.getAttribute("user");
        return user != null && "ADMIN".equals(user.getRole());
    }
}
