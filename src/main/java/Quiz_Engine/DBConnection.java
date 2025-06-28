package Quiz_Engine;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    private static final String URL = "jdbc:mysql://localhost:3306/quizdb";
    private static final String USER = "gchit21";
    private static final String PASSWORD = "Popular";
    private static final String DRIVER = "com.mysql.jdbc.Driver";

    static {
        try {
            Class.forName(DRIVER); // Load JDBC driver
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}

