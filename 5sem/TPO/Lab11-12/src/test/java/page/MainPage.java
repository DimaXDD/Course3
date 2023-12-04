package page;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.interactions.Actions;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;

public class MainPage extends BasePage {
    private final Logger log = LogManager.getLogger();

    public MainPage(WebDriver driver) {
        super(driver);
        PageFactory.initElements(driver, this);
    }

    public MainPage open() {
        driver.navigate().to("https://nsv.by");
        log.info("Main page is opened");
        return this;
    }

    public String getUrl() {
        return driver.getCurrentUrl();
    }
}
