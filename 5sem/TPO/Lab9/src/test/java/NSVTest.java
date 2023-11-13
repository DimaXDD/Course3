import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeOptions;
import org.openqa.selenium.interactions.Actions;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;
import org.testng.Assert;
import org.testng.annotations.AfterMethod;
import org.testng.annotations.BeforeMethod;
import org.testng.annotations.Test;

import javax.swing.plaf.TableHeaderUI;

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
        WebElement searchResult = driver.findElement(By.xpath("//*[@id=\'content\']/div[4]/div/div/div/div[1]/div/div[2]/div[4]/div/div[1]/div[1]")); // если вдруг, то некст элемент //*[@id="content"]/div[4]/div/div/div/div[1]/div/div[2]/div[4]/div/div[1]/div[2]
        Thread.sleep(5000);
        Assert.assertTrue(searchResult.isDisplayed());
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
        WebElement textReuslt = driver.findElement(By.xpath("//*[@id=\'comp_5c11fd50eca000304bc4c3616bab9880\']/div/div[2]/div"));
        Assert.assertTrue(textReuslt.isDisplayed());
    }

    @Test
    public void findIPhoneWithSomeStats() throws InterruptedException {
        WebElement catalogButton = driver.findElement(By.xpath("//*[@id=\'header\']/div/noindex/div/div/div/div/div/nav/div/table/tbody/tr/td[1]/div/a"));
        Actions actions = new Actions(driver);
        actions.moveToElement(catalogButton).perform();
        WebElement targetElement = driver.findElement(By.xpath("//*[@id=\'header\']/div/noindex/div/div/div/div/div/nav/div/table/tbody/tr/td[1]/div/ul/li[2]/ul/li[1]/a/span"));
        targetElement.click();
        WebElement colorSelect = driver.findElement(By.xpath("//*[@id=\'content\']/div[4]/div[3]/div/noindex/div/form/div[15]/div[1]"));
        colorSelect.click();
        WebElement greenColor = driver.findElement(By.xpath("//*[@id=\'content\']/div[4]/div[3]/div/noindex/div/form/div[15]/div[2]/div[1]/label[5]/span/span"));
        greenColor.click();
        Thread.sleep(2000);
        WebElement submitButton = driver.findElement(By.xpath("//*[@id=\'modef\']/a"));
        submitButton.click();
        WebElement searchResult = driver.findElement(By.xpath("//*[@id=\'sortdefault\']/div[1]/div[1]"));
        Assert.assertTrue(searchResult.isDisplayed());
        Thread.sleep(5000);
    }

    @AfterMethod
    public void tearDown() {

        driver.quit();
    }
}
