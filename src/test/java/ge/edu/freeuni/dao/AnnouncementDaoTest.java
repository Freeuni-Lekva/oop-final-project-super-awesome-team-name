package ge.edu.freeuni.dao;

import ge.edu.freeuni.model.Announcement;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit.jupiter.SpringJUnitConfig;

import java.sql.*;
import java.time.Instant;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

@SpringJUnitConfig
@ContextConfiguration(locations = {"file:src/test/resources/test-context.xml"})
//@ContextConfiguration(locations = {"file:src/main/webapp/WEB-INF/dispatcher-servlet.xml"})
public class AnnouncementDaoTest {

    Timestamp now = Timestamp.from(Instant.now());

    @Autowired
    private AnnouncementDao announcements;

    @BeforeEach
    public void setUp() throws Exception {
        String createTableSQL = "CREATE TABLE IF NOT EXISTS announcements " +
                "(id INT AUTO_INCREMENT PRIMARY KEY, " +
                "title VARCHAR(255) NOT NULL, " +
                "name VARCHAR(100) NOT NULL, " +
                "text TEXT NOT NULL, " +
                "date TIMESTAMP(3) DEFAULT CURRENT_TIMESTAMP(3))";

        String insertSQL = "INSERT INTO announcements (title,name,text,date) VALUES (?,?,?,?)";

        try (Connection con = announcements.getBasicDataSource().getConnection()) {

            try (PreparedStatement ps1 = con.prepareStatement(createTableSQL)) {
                ps1.execute();
            }

            try (PreparedStatement ps2 = con.prepareStatement(insertSQL)) {

                ps2.setString(1, "Hello World");
                ps2.setString(2, "Davit");
                ps2.setString(3, "Hello World, this is the first announcement!");
                ps2.setTimestamp(4, now);
                ps2.executeUpdate();

                ps2.setString(1, "Spam!");
                ps2.setString(2, "Admin");
                ps2.setString(3, "SPAM SPAM SPAM SPAM SPAM");
                ps2.setTimestamp(4, Timestamp.from(Instant.now()));
                ps2.executeUpdate();
            }
        }
    }

    @AfterEach
    public void tearDown() throws Exception {
        try (Connection conn = announcements.getBasicDataSource().getConnection();
             PreparedStatement ps = conn.prepareStatement("DROP TABLE IF EXISTS announcements")) {
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Failed to delete all announcements", e);
        }
    }

    @Test
    public void testGet() {
        assertEquals("Hello World", announcements.get(1).getTitle());
        assertEquals("Admin", announcements.get(2).getName());
        assertEquals(now, announcements.get(1).getDate());
        assertEquals("SPAM SPAM SPAM SPAM SPAM", announcements.get(2).getText());
        assertNull(announcements.get(3));
    }

    @Test
    public void testAdd() {
        Timestamp timestamp2 = Timestamp.from(Instant.now());
        assertEquals(3, announcements.add("addedTiTle", "meTheTester", "added text lorem ipsum", Timestamp.from(Instant.now())));
        assertEquals(4, announcements.add("addedTiTle2", "youTheTester", "There is snow on the ground, And the valleys are cold, And a midnight profound.", timestamp2));
        assertEquals(5, announcements.add("", "someone", "?!", Timestamp.from(Instant.now())));
        assertEquals("meTheTester", announcements.get(3).getName());
        assertEquals("There is snow on the ground, And the valleys are cold, And a midnight profound.", announcements.get(4).getText());
        assertEquals(timestamp2, announcements.get(4).getDate());
        assertEquals("", announcements.get(5).getTitle());
    }


    @Test
    public void testGetReversedList() {
        announcements.add("First Added", "User1", "Text1", Timestamp.from(Instant.now()));
        announcements.add("Second Added", "User2", "Text2", Timestamp.from(Instant.now()));
        announcements.add("Third Added", "User3", "Text3", Timestamp.from(Instant.now()));

        List<Announcement> list = announcements.getReversedList();

        assertEquals(5, list.size());

        for (int i = 0; i < list.size() - 1; i++) {
            assertTrue(
                    !list.get(i).getDate().before(list.get(i + 1).getDate())
            );
        }

        assertEquals("Third Added", list.get(0).getTitle());
        assertEquals("User2", list.get(1).getName());
        assertEquals("Text1", list.get(2).getText());
    }

    @Test
    public void testAddInvalidAnnouncement() {

        assertThrows(RuntimeException.class, () ->
                announcements.add(null, "name", "text", Timestamp.from(Instant.now()))
        );
        assertNull(announcements.get(-1));

        try (Connection con = announcements.getBasicDataSource().getConnection();
             PreparedStatement ps = con.prepareStatement("DROP TABLE IF EXISTS announcements")) {
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }

        assertThrows(RuntimeException.class, () ->
                announcements.get(1)
        );

        assertThrows(RuntimeException.class, () ->
                announcements.getReversedList()
        );
    }

}
