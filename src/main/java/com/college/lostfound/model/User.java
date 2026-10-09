package com.college.lostfound.model;

public class User {
    private int id;
    private String username;
    private String email;
    private String password;
    private String role = "STUDENT"; // STUDENT or ADMIN

    public User() {}
    public User(int id, String username, String email) {
        this.id = id;
        this.username = username;
        this.email = email;
        this.role = "admin".equalsIgnoreCase(username) ? "ADMIN" : "STUDENT";
    }
    public User(int id, String username, String email, String role) {
        this.id = id;
        this.username = username;
        this.email = email;
        this.role = (role != null) ? role : ("admin".equalsIgnoreCase(username) ? "ADMIN" : "STUDENT");
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }

    public boolean isAdmin() {
        return "ADMIN".equalsIgnoreCase(role) || "admin".equalsIgnoreCase(username);
    }
}
