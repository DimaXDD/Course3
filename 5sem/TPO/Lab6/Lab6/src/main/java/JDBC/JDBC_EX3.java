package JDBC;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Scanner;

public class JDBC_EX3 {
    private static final String username = "sa";
    private static final String password = "1111";
    private static final String dbUrl = "jdbc:sqlserver://DIMADD;databaseName=PoetryDatabase;trustServerCertificate=true;encrypt=false;IntegratedSecurity=false";

    public static void main(String[] args) throws ClassNotFoundException {
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");

        try (Scanner scanner = new Scanner(System.in)) {
            System.out.println("Enter author:");
            String author = scanner.nextLine();

            System.out.println("Choose option:\n1 - В каком из стихотворений больше всего восклицательных предложений?\n" +
                    "2 - В каком из стихотворений меньше всего повествовательных предложений?\n" +
                    "3 - Есть ли среди стихотворений сонеты и сколько их?");
            String option = scanner.nextLine();

            switch (option) {
                case "1":
                    System.out.println(findMostExclamatoryPoem(author));
                    break;
                case "2":
                    System.out.println(findLeastNarrativePoem(author));
                    break;
                case "3":
                    System.out.println(countSonnets(author));
                    break;
                default:
                    System.out.println("Wrong option");
            }
        }
    }

    public static String findMostExclamatoryPoem(String author) {
        String mostExclamatoryPoem = null;

        try (Connection connection = DriverManager.getConnection(dbUrl, username, password)) {
            String sql = "SELECT TOP 1 poem FROM poems WHERE author = ? ORDER BY LEN(poem) - LEN(REPLACE(poem, '!', '')) DESC";
            try (PreparedStatement statement = connection.prepareStatement(sql)) {
                statement.setString(1, author);
                try (ResultSet resultSet = statement.executeQuery()) {
                    if (resultSet.next()) {
                        mostExclamatoryPoem = resultSet.getString("poem");
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return mostExclamatoryPoem;
    }

    public static String findLeastNarrativePoem(String author) {
        String leastNarrativePoem = null;

        try (Connection connection = DriverManager.getConnection(dbUrl, username, password)) {
            String sql = "SELECT TOP 1 poem FROM poems WHERE author = ? ORDER BY LEN(poem) - LEN(REPLACE(poem, '.', '')) ASC";
            try (PreparedStatement statement = connection.prepareStatement(sql)) {
                statement.setString(1, author);
                try (ResultSet resultSet = statement.executeQuery()) {
                    if (resultSet.next()) {
                        leastNarrativePoem = resultSet.getString("poem");
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return leastNarrativePoem;
    }

    public static int countSonnets(String author) {
        int sonnetCount = 0;

        try (Connection connection = DriverManager.getConnection(dbUrl, username, password)) {
            String sql = "SELECT COUNT(*) AS sonnet_count FROM poems WHERE poem LIKE 'Л%' AND author = ?";
            try (PreparedStatement statement = connection.prepareStatement(sql)) {
                statement.setString(1, author);
                try (ResultSet resultSet = statement.executeQuery()) {
                    if (resultSet.next()) {
                        sonnetCount = resultSet.getInt("sonnet_count");
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return sonnetCount;
    }
}
