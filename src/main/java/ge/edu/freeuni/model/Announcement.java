package ge.edu.freeuni.model;

import java.sql.Time;
import java.sql.Timestamp;

public class Announcement {

    private final int id;
    private final String title;
    private final String name;
    private final String text;
    private final Timestamp date;

    public Announcement(int id, String title, String name, String text, Timestamp date) {
        this.id = id;
        this.title = title;
        this.name = name;
        this.text = text;
        this.date = date;
    }

    public int getId() {
        return id;
    }

    public String getTitle() {
        return title;
    }

    public String getName() {
        return name;
    }

    public String getText() {
        return text;
    }

    public Timestamp getDate() {
        return date;
    }
}
