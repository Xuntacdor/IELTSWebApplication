package model;

import java.io.Serializable;

public class User implements Serializable {
    private int userId;
    private String fullName;
    private String email;
    private String passwordHash;
    private String gender;
    private String dateOfBirth;
    private String role;
    private boolean isActive;
    private String phoneNumber;
    
    private int camBalance;
    private boolean isPremium;
    private String premiumExpiredAt;

    public User() {
    }

    public User(int userId, String fullName, String email, String passwordHash, String gender, String dateOfBirth, String role, boolean isActive, String phoneNumber, int camBalance, boolean isPremium, String premiumExpiredAt) {
        this.userId = userId;
        this.fullName = fullName;
        this.email = email;
        this.passwordHash = passwordHash;
        this.gender = gender;
        this.dateOfBirth = dateOfBirth;
        this.role = role;
        this.isActive = isActive;
        this.phoneNumber = phoneNumber;
        this.camBalance = camBalance;
        this.isPremium = isPremium;
        this.premiumExpiredAt = premiumExpiredAt;
    }

    

    // Getter & Setter
    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPasswordHash() {
        return passwordHash;
    }

    public void setPasswordHash(String passwordHash) {
        this.passwordHash = passwordHash;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public String getDateOfBirth() {
        return dateOfBirth;
    }

    public void setDateOfBirth(String dateOfBirth) {
        this.dateOfBirth = dateOfBirth;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean active) {
        isActive = active;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }
    //New Cam
    public boolean isIsActive() {
        return isActive;
    }

    public void setIsActive(boolean isActive) {
        this.isActive = isActive;
    }

    public int getCamBalance() {
        return camBalance;
    }

    public void setCamBalance(int camBalance) {
        this.camBalance = camBalance;
    }

    public boolean isIsPremium() {
        return isPremium;
    }

    public void setIsPremium(boolean isPremium) {
        this.isPremium = isPremium;
    }

    public String getPremiumExpiredAt() {
        return premiumExpiredAt;
    }

    public void setPremiumExpiredAt(String premiumExpiredAt) {
        this.premiumExpiredAt = premiumExpiredAt;
    }
    
    

    @Override
    public String toString() {
        return "User{" +
                "userId=" + userId +
                ", fullName='" + fullName + '\'' +
                ", email='" + email + '\'' +
                ", role='" + role + '\'' +
                ", camBalance=" + camBalance +
                ", isPremium=" + isPremium +
                '}';
    }
}
