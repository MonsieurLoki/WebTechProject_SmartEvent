package com.webtechproject.controller;

import com.webtechproject.dao.OrganizerRequestDAO;
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
        User user = userDAO.findByEmail(email);
        if (user == null || !user.getPasswordHash().equals(password)) {
            model.addAttribute("error", "Invalid email or password.");
            return "login";
        }
        session.setAttribute("user", user);
        return "redirect:/events";
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
        new OrganizerRequestDAO().save(user.getId());
        return "redirect:/request-organizer?submitted=true";
    }
}