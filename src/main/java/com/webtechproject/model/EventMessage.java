package com.webtechproject.model;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class EventMessage {
    private static final DateTimeFormatter DISPLAY_FORMATTER = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");

    private int id;
    private int eventId;
    private int senderId;
    private int receiverId;
    private Integer parentMessageId;
    private String subject;
    private String message;
    private boolean read;
    private LocalDateTime createdAt;
    private LocalDateTime readAt;
    private String eventTitle;
    private String senderName;
    private String senderEmail;
    private String receiverName;

    public EventMessage() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getEventId() { return eventId; }
    public void setEventId(int eventId) { this.eventId = eventId; }

    public int getSenderId() { return senderId; }
    public void setSenderId(int senderId) { this.senderId = senderId; }

    public int getReceiverId() { return receiverId; }
    public void setReceiverId(int receiverId) { this.receiverId = receiverId; }

    public Integer getParentMessageId() { return parentMessageId; }
    public void setParentMessageId(Integer parentMessageId) { this.parentMessageId = parentMessageId; }

    public String getSubject() { return subject; }
    public void setSubject(String subject) { this.subject = subject; }

    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }

    public boolean isRead() { return read; }
    public void setRead(boolean read) { this.read = read; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public LocalDateTime getReadAt() { return readAt; }
    public void setReadAt(LocalDateTime readAt) { this.readAt = readAt; }

    public String getEventTitle() { return eventTitle; }
    public void setEventTitle(String eventTitle) { this.eventTitle = eventTitle; }

    public String getSenderName() { return senderName; }
    public void setSenderName(String senderName) { this.senderName = senderName; }

    public String getSenderEmail() { return senderEmail; }
    public void setSenderEmail(String senderEmail) { this.senderEmail = senderEmail; }

    public String getReceiverName() { return receiverName; }
    public void setReceiverName(String receiverName) { this.receiverName = receiverName; }

    public String getFormattedCreatedAt() {
        return createdAt == null ? "" : createdAt.format(DISPLAY_FORMATTER);
    }
}
