package ge.edu.freeuni.model;

import java.sql.Timestamp;

public class Achievement {
    private final int achievementId;
    private final String name;
    private final String description;
    private final String iconUrl;
    private final String conditionType;
    private final int conditionValue;

    public Achievement(int achievementId, String name, String description, String iconUrl,
                       String conditionType, int conditionValue) {
        this.achievementId = achievementId;
        this.name = name;
        this.description = description;
        this.iconUrl = iconUrl;
        this.conditionType = conditionType;
        this.conditionValue = conditionValue;
    }

    //getterebi
    public int getAchievementId() { return achievementId; }
    public String getName() { return name; }
    public String getDescription() { return description; }
    public String getIconUrl() { return iconUrl; }
    public String getConditionType() { return conditionType; }
    public int getConditionValue() { return conditionValue; }
}

