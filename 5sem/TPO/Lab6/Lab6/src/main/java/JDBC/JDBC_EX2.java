package JDBC;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;

public class JDBC_EX2 {
    public static void main(String[] args) throws ClassNotFoundException {
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        String url = "jdbc:sqlserver://DIMADD;databaseName=rus_bel;trustServerCertificate=true;encrypt=false;IntegratedSecurity=false";
        String username = "sa";
        String password = "1111";

        try (Connection connection = DriverManager.getConnection(url, username, password)) {
            System.out.println("Connected to the database");
            Scanner scanner = new Scanner(System.in);

            while (true) {
                System.out.println("Enter word (or type 'exit' to quit):");
                String word = scanner.nextLine();
                if ("exit".equalsIgnoreCase(word)) {
                    break;
                }

                System.out.println("Enter language (ru, by):");
                String language = scanner.nextLine();

                List<String> translations = findWord(connection, word, language);
                if (translations.isEmpty()) {
                    System.out.println("No translations found in the dictionary");
                } else {
                    System.out.println("Translations:");
                    for (String translation : translations) {
                        System.out.println(translation);
                    }
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public static List<String> findWord(Connection connection, String word, String language) throws SQLException {
        List<String> translations = new ArrayList<>();

        if (language.equals("ru")) {
            String sql = "SELECT translate FROM dict_rus_bel WHERE word = ?";
            try (PreparedStatement statement = connection.prepareStatement(sql)) {
                statement.setString(1, word);
                ResultSet resultSet = statement.executeQuery();
                while (resultSet.next()) {
                    translations.add(resultSet.getString("translate"));
                }
            }
        } else if (language.equals("by")) {
            String sql = "SELECT word FROM dict_rus_bel WHERE translate = ?";
            try (PreparedStatement statement = connection.prepareStatement(sql)) {
                statement.setString(1, word);
                ResultSet resultSet = statement.executeQuery();
                while (resultSet.next()) {
                    translations.add(resultSet.getString("word"));
                }
            }
        }


        return translations;
    }
}
