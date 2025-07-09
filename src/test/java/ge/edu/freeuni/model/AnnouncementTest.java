package ge.edu.freeuni.model;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.sql.Timestamp;
import java.time.Instant;
import java.util.ArrayList;
import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;

public class AnnouncementTest {

    List<Announcement> announcements = new ArrayList<Announcement>();
    Timestamp timestamp1 = Timestamp.from(Instant.now());
    Timestamp timestamp2 = Timestamp.from(Instant.now());

    @BeforeEach
    public void setUp() {
        announcements.add(new Announcement(1, "Title1", "Name1", "Text1", timestamp1));
        announcements.add(new Announcement(1, "RandTitle", "RandUser", "RandText", timestamp2));
    }

    @AfterEach
    public void tearDown() {
        announcements.clear();
    }

    @Test
    public void testGetTitle() {
        assertEquals("Title1", announcements.get(0).getTitle());
        assertEquals("RandTitle", announcements.get(1).getTitle());
    }

    @Test
    public void testGetName(){
        assertEquals("Name1", announcements.get(0).getName());
        assertEquals("RandUser", announcements.get(1).getName());
    }

    @Test
    public void testGetText(){
        assertEquals("Text1", announcements.get(0).getText());
        assertEquals("RandText", announcements.get(1).getText());
    }

    @Test
    public void testGetTimestamp(){
        assertEquals(timestamp1,announcements.get(0).getDate());
        assertEquals(timestamp2,announcements.get(1).getDate());
    }

}

