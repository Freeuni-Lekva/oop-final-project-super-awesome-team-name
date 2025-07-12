package ge.edu.freeuni.model;

import java.sql.Timestamp;

// achievements the person has
public class UserAchievement {
    private final int userAchievementId;
    private final String userName;
    private final int achievementId;
    private final Timestamp earnedDate;
    private final Achievement achievement;

    public UserAchievement(int userAchievementId, String userName, int achievementId,
                           Timestamp earnedDate, Achievement achievement) {
        this.userAchievementId = userAchievementId;
        this.userName = userName;
        this.achievementId = achievementId;
        this.earnedDate = earnedDate;
        this.achievement = achievement;
    }

    //getterebi
    public int getUserAchievementId() { return userAchievementId; }
    public String getUserName() { return userName; }
    public int getAchievementId() { return achievementId; }
    public Timestamp getEarnedDate() { return earnedDate; }
    public Achievement getAchievement() { return achievement; }
}
