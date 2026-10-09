package com.smartbuilding.util;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {

    private static final String URL =
        "jdbc:mysql://localhost:3306/smart_building_new?useSSL=false&serverTimezone=UTC";

    private static final String USER = "root";
    private static final String PASSWORD = "fycs";

    public static Connection getConnection() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            Connection con = DriverManager.getConnection(
                URL, USER, PASSWORD
            );

            System.out.println("MySQL Connected Successfully!");

            return con;

        } catch (Exception e) {
            System.out.println("MySQL Connection Failed!");
            e.printStackTrace();
            return null;
        }
    }
}