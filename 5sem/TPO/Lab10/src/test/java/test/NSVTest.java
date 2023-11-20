package test;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeOptions;
import org.testng.Assert;
import org.testng.annotations.AfterMethod;
import org.testng.annotations.BeforeMethod;
import org.testng.annotations.Test;
import page.NSVPage;

public class NSVTest {
    private WebDriver driver;
    private NSVPage nsvPage;

    @BeforeMethod
    public void setUp() throws InterruptedException {
        ChromeOptions options = new ChromeOptions();
        options.setCapability("acceptInsecureCerts", true);
        driver = new ChromeDriver(options);
        driver.get("https://nsv.by");
        nsvPage = new NSVPage(driver);
    }

    @Test
    public void searchPhone() throws InterruptedException {
        nsvPage.searchPhone("IPhone 13");
        Assert.assertTrue(driver.findElement(By.xpath("//*[@id='content']/div[4]/div/div/div/div[1]/div/div[2]/div[4]/div/div[1]/div[1]")).isDisplayed());
    }
    @Test
    public void callForm() throws InterruptedException {
        nsvPage.callForm("Дмитрий", "291233211");
        Assert.assertTrue(driver.findElement(By.xpath("//*[@id=\'comp_5c11fd50eca000304bc4c3616bab9880\']/div/div[2]/div")).isDisplayed());
    }

    @Test
    public void findIPhoneWithSomeStats() throws InterruptedException {
        nsvPage.findIPhoneWithSomeStats();
        Assert.assertTrue(driver.findElement(By.xpath("//*[@id='sortdefault']/div[1]/div[1]")).isDisplayed());
    }

    @AfterMethod
    public void tearDown() {
        driver.quit();
    }
}
