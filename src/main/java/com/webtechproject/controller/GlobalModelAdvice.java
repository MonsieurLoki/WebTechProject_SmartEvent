package com.webtechproject.controller;

import com.webtechproject.dao.OrganizerRequestDAO;
import com.webtechproject.model.User;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

@ControllerAdvice
public class GlobalModelAdvice {

    @ModelAttribute("pendingRequestCount")
    public int pendingRequestCount(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return 0;
        User user = (User) session.getAttribute("user");
        if (user == null || !"ADMIN".equals(user.getRole())) return 0;
        return new OrganizerRequestDAO().countPending();
    }
}
