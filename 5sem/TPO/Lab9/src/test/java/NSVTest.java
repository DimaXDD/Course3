import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeOptions;
import org.testng.annotations.AfterMethod;
import org.testng.annotations.BeforeMethod;
import org.testng.annotations.Test;

public class NSVTest {
    private WebDriver driver;

    @BeforeMethod
    public void setUp() throws InterruptedException {
        // Обычное driver = new ChromeDriver не работало, по кд хром выбрасывал проверку
        // на бота\робота, код ниже работает
        // UPD: хотя это зависит от сайта, на многих есть такая проверка)

        ChromeOptions options = new ChromeOptions();
        options.setCapability("acceptInsecureCerts", true);
        driver = new ChromeDriver(options);
        driver.get("https://nsv.by");
    }
    @Test
    public void searchPhone() throws InterruptedException {
        WebElement searchInput = driver.findElement(By.id("title-search-input_fixed"));
        searchInput.sendKeys("IPhone 13");
        WebElement searchBtn = driver.findElement(By.xpath("//*[@id='subserch']"));
        searchBtn.click();
        Thread.sleep(5000);
    }


    @Test
    public void callForm() throws InterruptedException {
        WebElement callButton = driver.findElement(By.xpath("//*[@id=\'ClickCallBack\']"));
        callButton.click();
        Thread.sleep(3000);
        WebElement nameField = driver.findElement(By.xpath("//*[@id=\'comp_5c11fd50eca000304bc4c3616bab9880\']/div/form/div[1]/div[1]/input"));
        nameField.sendKeys("Дмитрий");
        WebElement phoneField = driver.findElement(By.xpath("//*[@id=\'comp_5c11fd50eca000304bc4c3616bab9880\']/div/form/div[1]/div[2]/input"));
        phoneField.sendKeys("111111111");
        WebElement submitButton = driver.findElement(By.xpath("//*[@id=\'FormCall\']"));
        submitButton.click();
        Thread.sleep(5000);
    }

    @Test
    public void findIPhoneWithSomeStats() throws InterruptedException {
        WebElement catalogButton = driver.findElement(By.xpath("//*[@id=\'header\']/div/noindex/div/div/div/div/div/nav/div/table/tbody/tr/td[1]/div/a"));
        catalogButton.click();
        Thread.sleep(5000);
    }

    @AfterMethod
    public void tearDown() {

        driver.quit();
    }
}
