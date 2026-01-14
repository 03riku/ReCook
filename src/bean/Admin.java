package bean;

import java.io.Serializable;

public class Admin implements Serializable{
    private int adminId;
    private String adminPass;

    // Constructors
    public Admin() {}

    public Admin(int adminId, String adminPass) {
        this.adminId = adminId;
        this.adminPass = adminPass;
    }

    // Getters and Setters
    public int getAdminId() {
        return adminId;
    }

    public void setAdminId(int adminId) {
        this.adminId = adminId;
    }

    public String getAdminPass() {
        return adminPass;
    }

    public void setAdminPass(String adminPass) {
        this.adminPass = adminPass;
    }
}
