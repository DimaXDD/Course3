package service;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

public class TestDataReader {
    private static final String FILE_PATH = "credentials.properties";
    private static Properties properties;

    static {
        properties = new Properties();
        try (InputStream inputStream = TestDataReader.class.getClassLoader().getResourceAsStream(FILE_PATH)) {
            if (inputStream != null) {
                properties.load(inputStream);
            } else {
                throw new IOException("Unable to find " + FILE_PATH);
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public static String getTestData(String key) {
        return properties.getProperty(key);
    }
}
