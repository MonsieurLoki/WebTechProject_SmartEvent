package com.webtechproject.controller;

import com.webtechproject.dao.NotificationDAO;
import com.webtechproject.model.User;

import jakarta.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/notifications")
public class NotificationController {

    @GetMapping
    public String list(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) return "redirect:/login";

        NotificationDAO dao = new NotificationDAO();
        model.addAttribute("notifications", dao.findByUserId(user.getId()));
        return "notifications";
    }

    @PostMapping("/{id}/read")
    public String markAsRead(@PathVariable("id") int id, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) return "redirect:/login";

        new NotificationDAO().markAsRead(id, user.getId());
        return "redirect:/notifications";
    }

    @GetMapping("/{id}/open")
    public String open(@PathVariable("id") int id, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) return "redirect:/login";

        NotificationDAO dao = new NotificationDAO();
        String linkUrl = dao.findLinkUrl(id, user.getId());
        dao.markAsRead(id, user.getId());
        if (linkUrl == null || linkUrl.trim().isEmpty()) {
            return "redirect:/notifications";
        }
        return "redirect:" + linkUrl;
    }

    @PostMapping("/read-all")
    public String markAllAsRead(HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) return "redirect:/login";

        new NotificationDAO().markAllAsRead(user.getId());
        return "redirect:/notifications";
    }
}
