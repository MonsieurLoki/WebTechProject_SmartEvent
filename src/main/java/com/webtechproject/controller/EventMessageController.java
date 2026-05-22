package com.webtechproject.controller;

import com.webtechproject.dao.EventDAO;
import com.webtechproject.dao.EventMessageDAO;
import com.webtechproject.dao.NotificationDAO;
import com.webtechproject.model.Event;
import com.webtechproject.model.EventMessage;
import com.webtechproject.model.User;

import jakarta.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class EventMessageController {

    @GetMapping("/messages")
    public String listMessages(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) return "redirect:/login";

        EventMessageDAO messageDAO = new EventMessageDAO();
        List<EventMessage> messages = messageDAO.getMessagesForUser(user.getId());
        Map<Integer, List<EventMessage>> repliesByMessage = new HashMap<>();
        for (EventMessage message : messages) {
            repliesByMessage.put(message.getId(), messageDAO.getRepliesForMessage(message.getId()));
        }

        model.addAttribute("messages", messages);
        model.addAttribute("repliesByMessage", repliesByMessage);
        model.addAttribute("unreadMessageCount", messageDAO.countUnreadMessages(user.getId()));
        return "messages";
    }

    @PostMapping("/events/{eventId}/messages")
    public String sendMessage(@PathVariable("eventId") int eventId,
                              @RequestParam(value = "subject", required = false) String subject,
                              @RequestParam("message") String messageText,
                              HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) return "redirect:/login";
        if (messageText == null || messageText.trim().isEmpty()) {
            return "redirect:/events/" + eventId + "?error=message_empty";
        }

        EventDAO eventDAO = new EventDAO();
        Event event = eventDAO.getEventById(eventId);
        if (event == null) return "redirect:/events";
        if (event.getOrganizerId() == user.getId()) {
            return "redirect:/events/" + eventId + "?error=message_self";
        }

        EventMessage message = new EventMessage();
        message.setEventId(eventId);
        message.setSenderId(user.getId());
        message.setReceiverId(event.getOrganizerId());
        message.setSubject(normalizeSubject(subject, "Question about " + event.getTitle()));
        message.setMessage(messageText.trim());

        int messageId = new EventMessageDAO().createMessage(message);
        if (messageId <= 0) {
            return "redirect:/events/" + eventId + "?error=message_failed";
        }

        new NotificationDAO().create(
                event.getOrganizerId(),
                user.getFullName() + " sent you a message about \"" + event.getTitle() + "\".",
                "INFO",
                "/messages");

        return "redirect:/events/" + eventId + "?message=sent";
    }

    @PostMapping("/messages/{messageId}/reply")
    public String replyToMessage(@PathVariable("messageId") int messageId,
                                 @RequestParam("message") String replyText,
                                 HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) return "redirect:/login";
        if (replyText == null || replyText.trim().isEmpty()) {
            return "redirect:/messages?error=message_empty";
        }

        EventMessageDAO messageDAO = new EventMessageDAO();
        EventMessage original = messageDAO.getMessageById(messageId);
        if (original == null || original.getParentMessageId() != null) {
            return "redirect:/messages?error=not_found";
        }
        if (original.getReceiverId() != user.getId()) {
            return "redirect:/messages?error=forbidden";
        }

        Event event = new EventDAO().getEventById(original.getEventId());
        if (event == null || event.getOrganizerId() != user.getId()) {
            return "redirect:/messages?error=forbidden";
        }

        EventMessage reply = new EventMessage();
        reply.setEventId(original.getEventId());
        reply.setSenderId(user.getId());
        reply.setReceiverId(original.getSenderId());
        reply.setParentMessageId(original.getId());
        reply.setSubject(replySubject(original.getSubject()));
        reply.setMessage(replyText.trim());

        int replyId = messageDAO.replyToMessage(reply);
        if (replyId <= 0) {
            return "redirect:/messages?error=message_failed";
        }

        messageDAO.markAsRead(original.getId(), user.getId());
        new NotificationDAO().create(
                original.getSenderId(),
                user.getFullName() + " replied to your message about \"" + original.getEventTitle() + "\".",
                "INFO",
                "/messages");

        return "redirect:/messages?message=replied";
    }

    @PostMapping("/messages/{messageId}/read")
    public String markMessageAsRead(@PathVariable("messageId") int messageId,
                                    HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) return "redirect:/login";

        EventMessageDAO messageDAO = new EventMessageDAO();
        EventMessage message = messageDAO.getMessageById(messageId);
        if (message == null || message.getReceiverId() != user.getId()) {
            return "redirect:/messages?error=forbidden";
        }

        messageDAO.markAsRead(messageId, user.getId());
        return "redirect:/messages";
    }

    private String normalizeSubject(String subject, String defaultSubject) {
        String value = subject == null || subject.trim().isEmpty() ? defaultSubject : subject.trim();
        return value.length() > 150 ? value.substring(0, 150) : value;
    }

    private String replySubject(String subject) {
        String value = subject == null || subject.trim().isEmpty() ? "Re: Event message" : subject.trim();
        if (!value.startsWith("Re: ")) {
            value = "Re: " + value;
        }
        return value.length() > 150 ? value.substring(0, 150) : value;
    }
}
