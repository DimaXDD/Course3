package test;

import driver.DriverSingleton;
import org.openqa.selenium.WebDriver;
import org.testng.annotations.AfterMethod;
import org.testng.annotations.BeforeMethod;
import org.testng.annotations.Listeners;
import util.TestListener;

import java.net.MalformedURLException;

@Listeners({TestListener.class})
public class CommonConditions {
    protected WebDriver driver;

    @BeforeMethod
    public void setUp() throws MalformedURLException {
        driver = DriverSingleton.getDriver();
    }

    @AfterMethod()
    public void stopBrowser() {
        DriverSingleton.closeDriver();
    }
}
