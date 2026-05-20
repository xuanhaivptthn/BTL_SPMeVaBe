package Test;

import dao.DBConnect;
import java.sql.Connection;
import java.sql.SQLException;

public class DBConnectionTester {

    public static boolean testConnection() {
        try (Connection conn = DBConnect.getConnection()) {
            return conn != null && !conn.isClosed();
        } catch (SQLException ex) {
            System.getLogger(DBConnectionTester.class.getName()).log(System.Logger.Level.ERROR, (String) null, ex);
            return false;
        }
    }

    public static String testConnectionDetailed() {
        try (Connection conn = DBConnect.getConnection()) {
            if (conn == null) return "Connection is null (failed to obtain).";
            if (conn.isClosed()) return "Connection is closed.";
            return "Connection successful: " + conn.getMetaData().getURL();
        } catch (SQLException ex) {
            System.getLogger(DBConnectionTester.class.getName()).log(System.Logger.Level.ERROR, (String) null, ex);
            return "Connection failed: " + ex.getMessage();
        }
    }

    public static void main(String[] args) {
        System.out.println(testConnectionDetailed());
    }
}
