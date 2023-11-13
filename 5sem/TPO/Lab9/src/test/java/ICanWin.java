import org.openqa.selenium.chrome.ChromeOptions;
import org.testng.annotations.AfterMethod;
import org.testng.annotations.BeforeMethod;
import org.testng.annotations.Test;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;

public class ICanWin {
    private WebDriver driver;
    private PasteBinPage pasteBinPage;

    @BeforeMethod
    public void setUp() {
        ChromeOptions options = new ChromeOptions();
        options.setCapability("acceptInsecureCerts", true);
        driver = new ChromeDriver(options);
        pasteBinPage = new PasteBinPage(driver);
    }

    @Test
    public void createNewPasteTest() {
        pasteBinPage.openPage("https://pastebin.com");
        pasteBinPage.setCode("Hello from WebDriver");
        pasteBinPage.setExpiration("10 Minutes");
        pasteBinPage.setPasteName("helloweb");
    }

    @AfterMethod
    public void tearDown() {
        driver.quit();
    }

}
