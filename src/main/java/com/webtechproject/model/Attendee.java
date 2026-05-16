package com.webtechproject.model;

import java.time.LocalDateTime;

public class Attendee {
    private String fullName;
    private String email;
    private LocalDateTime registeredAt;
    private double pricePaid;

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public LocalDateTime getRegisteredAt() { return registeredAt; }
    public void setRegisteredAt(LocalDateTime registeredAt) { this.registeredAt = registeredAt; }
    public double getPricePaid() { return pricePaid; }
    public void setPricePaid(double pricePaid) { this.pricePaid = pricePaid; }
}
