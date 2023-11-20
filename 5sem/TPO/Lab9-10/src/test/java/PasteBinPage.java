import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.ui.WebDriverWait;

import java.time.Duration;

public class PasteBinPage {
    private WebDriver driver;
    private WebDriverWait wait;

    public PasteBinPage(WebDriver driver) {
        this.driver = driver;
        this.wait = new WebDriverWait(driver, Duration.ofSeconds(10));
    }

    public void openPage(String url) {
        driver.navigate().to(url);
    }

    public void setCode(String code) {
        WebElement codeTextArea = driver.findElement(By.id("postform-text"));
        codeTextArea.sendKeys(code);
    }

    public void setExpiration(String expiration) {
        driver.findElement(By.id("select2-postform-expiration-container")).click();
        driver.findElement(By.xpath("//li[text()='10 Minutes']")).click();
    }

    public void setBash() {
        driver.findElement(By.id("select2-postform-format-container")).click();
        driver.findElement(By.xpath("//li[text()='Bash']")).click();
    }

    public void setPasteName(String name) {
        WebElement pasteNameInput = driver.findElement(By.id("postform-name"));
        pasteNameInput.sendKeys(name);
        driver.findElement(By.xpath("//*[@id=\"w0\"]/div[5]/div[1]/div[10]/button")).click();
    }

    public void createNewPaste() {
        WebElement createButton = driver.findElement(By.id("submit"));
        createButton.click();
    }
}
