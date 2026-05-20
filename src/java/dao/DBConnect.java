/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.*;

public class DBConnect {

    public static Connection getConnection() {
        String dbPort = "3306";
        String dbUsername = "root";
        String dbPassword = "";

        String dbName = "BTL_SPMeVaBe";

        String dbUrl = "jdbc:mysql://localhost:" + dbPort + "/" + dbName;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            return DriverManager.getConnection(dbUrl, dbUsername, dbPassword);
        } catch (ClassNotFoundException | SQLException ex) {
            System.getLogger(DBConnect.class.getName()).log(System.Logger.Level.ERROR, (String) null, ex);
        }
        return null;
    }
}
