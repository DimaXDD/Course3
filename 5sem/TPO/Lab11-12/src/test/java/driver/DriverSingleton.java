package driver;

import io.github.bonigarcia.wdm.WebDriverManager;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeOptions;
import org.openqa.selenium.edge.EdgeDriver;
import org.openqa.selenium.firefox.FirefoxDriver;
import org.openqa.selenium.ie.InternetExplorerDriver;
import org.openqa.selenium.remote.DesiredCapabilities;
import org.openqa.selenium.remote.RemoteWebDriver;

import java.util.HashMap;
import java.util.Map;

public class DriverSingleton {
    private static WebDriver driver;

    private DriverSingleton() { }

    public static WebDriver getDriver() {
        if (driver == null) {
            String browser = System.getProperty("browser");
            if (browser == null) {
                browser = "chrome";
            }

            switch (browser) {
                case "firefox": {
                    WebDriverManager.firefoxdriver().setup();
                    driver = new FirefoxDriver();
                    break;
                }
                case "edge": {
                    WebDriverManager.edgedriver().setup();
                    driver = new EdgeDriver();
                    break;
                }
                case "ie": {
                    WebDriverManager.iedriver().setup();
                    driver = new InternetExplorerDriver();
                    break;
                }
                default: {
                    ChromeOptions options = new ChromeOptions();
                    options.setCapability("acceptInsecureCerts", true);
                    driver = new ChromeDriver(options);
                    break;
                }
            }
            driver.manage().window().maximize();
        }
        return driver;
    }


    public static void closeDriver() {
        driver.quit();
        driver = null;
    }
}