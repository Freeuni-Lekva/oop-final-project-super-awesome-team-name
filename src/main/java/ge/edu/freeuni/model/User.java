package ge.edu.freeuni.model;

public class User {

    private final String name;
    private final String hashedPassword;
    private boolean isAdmin;

    public User(String name, String hashedPassword) {
        this.name = name;
        this.hashedPassword = hashedPassword;
        this.isAdmin = false;
    }

    public String getName() {
        return name;
    }

    public boolean isAdmin() {
        return isAdmin;
    }

    public void setAdminStatus(Boolean isAdmin) {
        this.isAdmin = isAdmin;
    }

    public boolean checkHashedPassword(String suggestedHashedPassword) {
        return PasswordHasher.hashPassword(suggestedHashedPassword).equals(hashedPassword);
    }

}
