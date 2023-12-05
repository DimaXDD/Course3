package page;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.openqa.selenium.JavascriptExecutor;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;

import java.time.Duration;

public class NewsletterPage extends BasePage {
    private final Logger log = LogManager.getLogger();

    @FindBy(xpath = "//*[@id=\'footer\']/div[2]/div[1]/div/div/div/div/div/div/div[2]/form/div/div[1]/input")
    private WebElement emailInput;

    @FindBy(xpath = "//*[@id=\'footer\']/div[2]/div[1]/div/div/div/div/div/div/div[2]/form/div/div[3]/input")
    private WebElement checkButton;

    @FindBy(xpath = "//*[@id=\'footer\']/div[2]/div[1]/div/div/div/div/div/div/div[2]/form/div/div[2]/input")
    private WebElement submitButton;

    public NewsletterPage(WebDriver driver) {
        super(driver);
        PageFactory.initElements(this.driver, this);
    }

    public NewsletterPage testNewsletterShop (String email) throws InterruptedException {
        JavascriptExecutor js = (JavascriptExecutor) driver;
        long scrollHeight = (long) js.executeScript("return document.documentElement.scrollHeight");
        long scrollTo = (long) (scrollHeight * 0.7);
        js.executeScript("window.scrollTo(0, arguments[0]);", scrollTo);
        emailInput.sendKeys(email);
        log.info("Email send");
        checkButton.click();
        log.info("CheckButton clicked");
        submitButton.click();
        log.info("Submit clicked");

        WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(50));
        wait.until(ExpectedConditions.urlToBe("https://cp.unisender.com/ru/error_subscribe"));

        return this;
    }

}
