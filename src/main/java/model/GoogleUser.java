package model;

public class GoogleUser {
    private String id;
    private String fullName;
    private String email;
    private String picture;

    // Getters & Setters
    public String getId() { return id; }
    public void setId(String id) { this.id = id; }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPicture() { return picture; }
    public void setPicture(String picture) { this.picture = picture; }
}
