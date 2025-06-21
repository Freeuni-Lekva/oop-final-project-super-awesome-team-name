package ge.edu.freeuni.model;

import java.sql.Time;
import java.sql.Timestamp;

public class Announcement {

    private final int id;
    private final String title;
    private final String author;
    private final String text;
    private final Timestamp date;

    public Announcement(int id, String title, String text, String author, Timestamp date) {
        this.id = id;
        this.title = title;
        this.text = text;
        this.author = author;
        this.date = date;
    }

    public int getId() {
        return id;
    }

    public String getTitle() {
        return title;
    }

    public String getAuthor() {
        return author;
    }

    public String getText() {
        return text;
    }

    public Timestamp getDate() {
        return date;
    }
}
