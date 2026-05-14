package com.webtechproject.controller;

import com.webtechproject.dao.OrganizerDashboardDAO;
import com.webtechproject.model.EventStats;
import com.webtechproject.model.User;

import jakarta.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;

@Controller
@RequestMapping("/organizer")
public class OrganizerController {

    @GetMapping("/dashboard")
    public String dashboard(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null || (!"ORGANIZER".equals(user.getRole()) && !"ADMIN".equals(user.getRole()))) {
            return "redirect:/events";
        }

        OrganizerDashboardDAO dao = new OrganizerDashboardDAO();
        List<EventStats> stats = dao.getEventStats(user.getId());

        int totalRegistrations = stats.stream().mapToInt(EventStats::getRegistrations).sum();
        double totalRevenue = stats.stream().mapToDouble(EventStats::getRevenue).sum();

        model.addAttribute("stats", stats);
        model.addAttribute("totalRegistrations", totalRegistrations);
        model.addAttribute("totalRevenue", String.format("%.2f", totalRevenue));

        return "organizerDashboard";
    }
}
