package tests;

import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;
import org.testng.Assert;
import org.testng.annotations.AfterMethod;
import org.testng.annotations.BeforeMethod;
import org.testng.annotations.Test;
import pages.ICanWinTestPage;

public class ICanWinTest {
    private WebDriver driver;

    @BeforeMethod(alwaysRun = true)
    public void driverSetup() {
        driver = new ChromeDriver();
    }

    @Test
    public void tryNewPateCreated() {
        ICanWinTestPage iCanWinTestPage = new ICanWinTestPage(driver);
        iCanWinTestPage.openPage();
        iCanWinTestPage.writeNewText("Artsiom");
        iCanWinTestPage.chooseExpiration("1 Day");
        iCanWinTestPage.writeName("Artsy");
        String oldUrl = driver.getCurrentUrl();
        iCanWinTestPage.clickCreateNewPasteButton();
        Assert.assertNotEquals(oldUrl, driver.getCurrentUrl());
    }

    @AfterMethod(alwaysRun = true)
    public void browserClose() {
        driver.quit();
    }
}
