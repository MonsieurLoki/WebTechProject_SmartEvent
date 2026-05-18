package com.webtechproject.controller;

import com.webtechproject.dao.OrganizerRequestDAO;
import com.webtechproject.dao.NotificationDAO;
import com.webtechproject.dao.UserDAO;
import com.webtechproject.model.User;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class AuthController {

    @GetMapping("/register")
    public String registerPage() {
        return "register";
    }

    @PostMapping("/register")
    public String register(@RequestParam("name") String name,
                        @RequestParam("email") String email,
                        @RequestParam("password") String password,
                        Model model) {
        try {
            UserDAO userDAO = new UserDAO();
            User existing = userDAO.findByEmail(email);
            if (existing != null) {
                model.addAttribute("error", "Email already in use.");
                return "register";
            }
            User user = new User();
            user.setFullName(name);
            user.setEmail(email);
            user.setPasswordHash(password);
            userDAO.save(user);
            return "redirect:/login";
        } catch (RuntimeException e) {
            model.addAttribute("error", "Registration failed: " + getRootCauseMessage(e));
            return "register";
        }
    }

    @GetMapping("/login")
    public String loginPage() {
        return "login";
    }
    
    @PostMapping("/login")
    public String login(@RequestParam("email") String email,
                        @RequestParam("password") String password,
                        HttpSession session,
                        Model model) {
        UserDAO userDAO = new UserDAO();
        try {
            User user = userDAO.findByEmail(email);
            if (user == null || !user.getPasswordHash().equals(password)) {
                model.addAttribute("error", "Invalid email or password.");
                return "login";
            }
            session.setAttribute("user", user);
            return "redirect:/events";
        } catch (RuntimeException e) {
            model.addAttribute("error", "Login failed: " + getRootCauseMessage(e));
            return "login";
        }
    }

    private String getRootCauseMessage(Throwable throwable) {
        Throwable current = throwable;
        while (current.getCause() != null) {
            current = current.getCause();
        }
        return current.getMessage() != null ? current.getMessage() : current.getClass().getSimpleName();
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/login";
    }

    @GetMapping("/request-organizer")
    public String requestOrganizerPage(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) return "redirect:/login";
        if (!"ATTENDEE".equals(user.getRole())) return "redirect:/events";
        OrganizerRequestDAO dao = new OrganizerRequestDAO();
        model.addAttribute("alreadyRequested", dao.hasPendingOrApprovedRequest(user.getId()));
        return "requestOrganizer";
    }

    @PostMapping("/request-organizer")
    public String submitOrganizerRequest(HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) return "redirect:/login";
        if (!"ATTENDEE".equals(user.getRole())) return "redirect:/events";
        if (new OrganizerRequestDAO().save(user.getId())) {
            NotificationDAO notificationDAO = new NotificationDAO();
            notificationDAO.create(
                    user.getId(),
                    "Your organizer request was sent. An admin will review it soon.",
                    "INFO",
                    "/request-organizer");
            notificationDAO.createForAdmins(
                    user.getFullName() + " requested organizer access.",
                    "/admin/dashboard");
        }
        return "redirect:/request-organizer?submitted=true";
    }
}
