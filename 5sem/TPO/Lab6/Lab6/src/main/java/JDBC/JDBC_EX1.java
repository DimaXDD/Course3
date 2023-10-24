package JDBC;

import java.sql.*;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.List;

/**
 * Hello world!
 *
 */
public class JDBC_EX1
{
//    В БД хранится англо-русский словарь, в котором для одного
//    английского слова может быть указано несколько его значений
//    и  наоборот. Со стороны клиента вводятся последовательно
//    английские (русские) слова. Для каждого из них вывести на
//    консоль все русские (английские) значения слова.
    public static void main( String[] args ) throws ClassNotFoundException, SQLException  {
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            String url = "jdbc:sqlserver://DIMADD;databaseName=DictionaryDatabase;trustServerCertificate=true;encrypt=false;IntegratedSecurity=false";
            Connection connection = DriverManager.getConnection(url, "sa", "1111");
            System.out.println("We're connected");
            do {
                System.out.println("Enter word:");
                String word = new java.util.Scanner(System.in).nextLine();
                List<String> list = findWord(connection, word);
                if (list.size() == 0) {
                    System.out.println("No such word in dictionary");
                } else {
                    System.out.println("Translate:");
                    for (String s : list) {
                        System.out.println(s);
                    }
                }
            } while (true);
        } catch (SQLException e) {
            System.out.println("Something went wrong");
            e.printStackTrace();
        }
    }

    public static List<String> findWord(Connection connection, String word) throws SQLException {
        Statement statement = connection.createStatement();
        ResultSet set = statement.executeQuery("select translate from dictionary where word = '" + word + "'");
        List<String> list = new java.util.ArrayList<>();
        while(set.next()) {
            list.add(set.getString("translate"));
        }
        return list;
    }
}
