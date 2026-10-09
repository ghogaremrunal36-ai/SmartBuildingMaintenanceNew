package com.smartbuilding.model;

import java.sql.Timestamp;

public class MaintenanceRequest {

    private int requestId;
    private int userId;
    private String userName;
    private String title;
    private String description;
    private String category;
    private String status;
    private Timestamp createdAt;

    public MaintenanceRequest() {
    }

    public MaintenanceRequest(int userId, String title,
                              String description, String category) {
        this.userId = userId;
        this.title = title;
        this.description = description;
        this.category = category;
        this.status = "PENDING";
    }

    public MaintenanceRequest(int requestId, int userId, String userName, String title,
                              String description, String category, String status, Timestamp createdAt) {
        this.requestId = requestId;
        this.userId = userId;
        this.userName = userName;
        this.title = title;
        this.description = description;
        this.category = category;
        this.status = status;
        this.createdAt = createdAt;
    }

    public int getRequestId() {
        return requestId;
    }

    public void setRequestId(int requestId) {
        this.requestId = requestId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}