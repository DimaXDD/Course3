import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.interactions.Actions;

public class NSVPage {
    private WebDriver driver;

    public NSVPage(WebDriver driver) {
        this.driver = driver;
    }

    public void searchPhone(String phoneName) throws InterruptedException {
        WebElement searchInput = driver.findElement(By.id("title-search-input_fixed"));
        searchInput.sendKeys(phoneName);
        WebElement searchButton = driver.findElement(By.xpath("//*[@id='subserch']"));
        searchButton.click();
        Thread.sleep(5000);
    }

    public void callForm(String name, String phone) throws InterruptedException {
        WebElement callButton = driver.findElement(By.xpath("//*[@id='ClickCallBack']"));
        callButton.click();
        Thread.sleep(3000);
        WebElement nameField = driver.findElement(By.xpath("//*[@id='comp_5c11fd50eca000304bc4c3616bab9880']/div/form/div[1]/div[1]/input"));
        nameField.sendKeys(name);
        WebElement phoneField = driver.findElement(By.xpath("//*[@id='comp_5c11fd50eca000304bc4c3616bab9880']/div/form/div[1]/div[2]/input"));
        phoneField.sendKeys(phone);
        WebElement submitButton = driver.findElement(By.xpath("//*[@id='FormCall']"));
        submitButton.click();
        Thread.sleep(20000);
    }

    public void findIPhoneWithSomeStats() throws InterruptedException {
        WebElement catalogButton = driver.findElement(By.xpath("//*[@id='header']/div/noindex/div/div/div/div/div/nav/div/table/tbody/tr/td[1]/div/a"));
        Actions actions = new Actions(driver);
        actions.moveToElement(catalogButton).perform();
        WebElement targetElement = driver.findElement(By.xpath("//*[@id='header']/div/noindex/div/div/div/div/div/nav/div/table/tbody/tr/td[1]/div/ul/li[2]/ul/li[1]/a/span"));
        targetElement.click();
        WebElement colorSelect = driver.findElement(By.xpath("//*[@id='content']/div[4]/div[3]/div/noindex/div/form/div[15]/div[1]"));
        colorSelect.click();
        WebElement greenColor = driver.findElement(By.xpath("//*[@id='content']/div[4]/div[3]/div/noindex/div/form/div[15]/div[2]/div[1]/label[5]/span/span"));
        greenColor.click();
        Thread.sleep(10000);
        WebElement submitButton = driver.findElement(By.xpath("//*[@id='modef']/a"));
        submitButton.click();
        Thread.sleep(5000);
    }
}