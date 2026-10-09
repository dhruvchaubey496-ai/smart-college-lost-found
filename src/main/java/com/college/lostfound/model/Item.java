package com.college.lostfound.model;

import java.sql.Timestamp;

public class Item {
    private int id;
    private String title;
    private String category;
    private String type; // FOUND or LOST
    private String classroom;
    private String description;
    private int userId;
    private String finderUsername; // Protected username (Email is not exposed)
    private String status;
    private Timestamp createdAt;

    public Item() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

    public String getType() { return type; }
    public void setType(String type) { this.type = type; }

    public String getClassroom() { return classroom; }
    public void setClassroom(String classroom) { this.classroom = classroom; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getFinderUsername() { return finderUsername; }
    public void setFinderUsername(String finderUsername) { this.finderUsername = finderUsername; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}
