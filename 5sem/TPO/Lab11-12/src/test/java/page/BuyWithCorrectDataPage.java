package page;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;

import java.time.Duration;

public class BuyWithCorrectDataPage extends BasePage {
    private final Logger log = LogManager.getLogger();

    @FindBy(xpath = "//*[@id=\'ORDER_PROP_1\']")
    private WebElement fio;

    @FindBy(xpath = "//*[@id=\'ORDER_PROP_3\']")
    private WebElement phone;

    @FindBy(xpath = "//*[@id=\'ORDER_PROP_2\']")
    private WebElement email;

    @FindBy(xpath = "//*[@id=\'ORDER_PROP_7\']")
    private WebElement destination;

    @FindBy(xpath = "//*[@id=\'tab1\']/form/div/div[3]/div/a")
    private WebElement submitButton;

    @FindBy(xpath = "//*[@id=\'content\']/div[3]/div/div/div/div/div/div/div[3]/div/div/div[1]/p[contains(text(), 'успешно создан')]")
    private WebElement successMessage;

    public BuyWithCorrectDataPage(WebDriver driver) {
        super(driver);
        PageFactory.initElements(this.driver, this);
    }

    public void buyingWithCorrectData(String fioInput,
                                      String phoneInput,
                                      String emailInput,
                                      String destinationInput) throws InterruptedException {
        fio.clear();
        fio.sendKeys(fioInput);
        log.info("FIO is input");
        phone.clear();
        phone.sendKeys(phoneInput);
        log.info("Phone is input");
        email.clear();
        email.sendKeys(emailInput);
        log.info("Email is input");
        destination.clear();
        destination.sendKeys(destinationInput);
        log.info("Destination is input");
        Thread.sleep(4000);
        submitButton.click();
        log.info("Submit button is clicked");
        Thread.sleep(3000);
    }
}
