package ge.edu.freeuni.model;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.util.ArrayList;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

public class UserAndPasswordHasherTest {

    List<User> users = new ArrayList<>();

    @BeforeEach
    public void setUp() {

        users.add(new User("David", PasswordHasher.hashPassword("hardPassword2025")));
        users.add(new User("John", PasswordHasher.hashPassword("abcd1234")));
    }

    @AfterEach
    public void tearDown() {
        users.clear();
    }

    @Test
    public void testIsAdmin() {
        assertEquals("David", users.get(0).getName());
        assertEquals("John", users.get(1).getName());
    }

    @Test
    public void isAdmin() {
        assertFalse(users.get(0).isAdmin());
        assertFalse(users.get(1).isAdmin());
    }

    @Test
    public void testSetAdmin() {
        users.get(0).setAdmin();
        assertTrue(users.get(0).isAdmin());
        users.get(1).setAdmin();
        assertTrue(users.get(1).isAdmin());
    }

    @Test
    public void testCheckPassword() {
        assertFalse(users.get(0).checkPassword("?!"));
        assertTrue(users.get(0).checkPassword("hardPassword2025"));
        assertTrue(users.get(1).checkPassword("abcd1234"));
        assertFalse(users.get(1).checkPassword("adcd1234"));
    }

}
