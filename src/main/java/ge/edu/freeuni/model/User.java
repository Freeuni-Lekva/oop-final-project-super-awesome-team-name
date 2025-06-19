package ge.edu.freeuni.model;

public class User {

    private String name;
    private String hashedPassword;
    private boolean isAdmin;

    public User(String name, String hashedPassword) {
        this.name = name;
        this.hashedPassword = hashedPassword;
        this.isAdmin = false;
    }

    public User(String name, String hashedPassword, boolean isAdmin) {
        this.name = name;
        this.hashedPassword = hashedPassword;
        this.isAdmin = isAdmin;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getHashedPassword() {
        return hashedPassword;
    }

    public void setHashedPassword(String hashedPassword) {
        this.hashedPassword = hashedPassword;
    }

    public boolean isAdmin() {
        return isAdmin;
    }

    public void setAdmin() {
        isAdmin = true;
    }

    public void removeAdmin() {
        isAdmin = false;
    }
}
