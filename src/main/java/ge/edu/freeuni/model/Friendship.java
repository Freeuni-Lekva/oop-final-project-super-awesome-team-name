package ge.edu.freeuni.model;

import java.time.LocalDateTime;

public class Friendship {
    private String userName;
    private String friendName;
    private LocalDateTime since;

    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }

    public String getFriendName() { return friendName; }
    public void setFriendName(String friendName) { this.friendName = friendName; }

    public LocalDateTime getSince() { return since; }
    public void setSince(LocalDateTime since) { this.since = since; }
}