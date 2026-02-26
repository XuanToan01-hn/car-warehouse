
/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

package context;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 *
 * @author Nhat
 */

public class DBContext {

    protected Connection connection;

//     public DBContext() {
//     try {
//     // Edit URL , username, password to authenticate with your MS SQL Server
//     String url = "jdbc:sqlserver://localhost:1433;databaseName=swp391_wh";
//     String username = "sa";
//     String password = "123";
//     Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
//     connection = DriverManager.getConnection(url, username, password);
//     } catch (ClassNotFoundException | SQLException ex) {
//     System.out.println(ex);
//     }
//     }
//    public DBContext() {
//        try {
//            // URL kết nối MySQL
//            String url = "jdbc:mysql://localhost:3306/swp391_wh?useSSL=false&serverTimezone=UTC";
//
//            // Username và password MySQL
//            String username = "root";
//            String password = "admin";
//
//            // Load MySQL Driver
//            Class.forName("com.mysql.cj.jdbc.Driver");
//
//            // Kết nối
//            connection = DriverManager.getConnection(url, username, password);
//
//        } catch (ClassNotFoundException | SQLException ex) {
//            ex.printStackTrace(); // In full stack trace ra Tomcat log để dễ debug
//        }
//    }

    public DBContext() {
        try {
            // Edit URL , username, password to authenticate with your MS SQL Server
            String url = "jdbc:sqlserver://localhost:1433;databaseName=InventoryPro_Final_Oct";
            String username = "sa";
            String password = "123";
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            connection = DriverManager.getConnection(url, username, password);
        } catch (ClassNotFoundException | SQLException ex) {
            System.err.println("[CRITICAL] DBContext Connection Error: " + ex.getMessage());
            ex.printStackTrace();
        }
    }

    public static void main(String[] args) {
    DBContext db = new DBContext();
    if (db.connection != null) {
        System.out.println("Kết nối SQL Server thành công!");
    } else {
        System.out.println("Kết nối thất bại!");
    }
}

}
