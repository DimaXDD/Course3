package page;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;

public class EFeedbackPage extends BasePage {
    private final Logger log = LogManager.getLogger();

    @FindBy(xpath = "//*[@id='comp_1cf76415d2375b677e1eb29bec3b6ea0']/div[3]/div/div/div/form/div[1]/div[1]/input")
    private WebElement fioInput;

    @FindBy(xpath = "//*[@id='comp_1cf76415d2375b677e1eb29bec3b6ea0']/div[3]/div/div/div/form/div[1]/div[2]/textarea")
    private WebElement addressInput;

    @FindBy(xpath = "//*[@id='comp_1cf76415d2375b677e1eb29bec3b6ea0']/div[3]/div/div/div/form/div[1]/div[3]/input")
    private WebElement phoneNumberInput;

    @FindBy(xpath = "//*[@id='comp_1cf76415d2375b677e1eb29bec3b6ea0']/div[3]/div/div/div/form/div[1]/div[4]/input")
    private WebElement emailInput;

    @FindBy(xpath = "//*[@id='comp_1cf76415d2375b677e1eb29bec3b6ea0']/div[3]/div/div/div/form/div[1]/div[5]/textarea")
    private WebElement messageInput;

    @FindBy(xpath = "//*[@id='comp_1cf76415d2375b677e1eb29bec3b6ea0']/div[3]/div/div/div/form/div[2]/input")
    private WebElement submitButton;

    public EFeedbackPage(WebDriver driver) {
        super(driver);
        PageFactory.initElements(this.driver, this);
    }

    public void openFeedbackPage() {
        driver.navigate().to("https://nsv.by/company/obrashchenie/");
    }

    public void fillFeedbackForm(String fio, String address, String phoneNumber, String email, String message) {
        fioInput.sendKeys(fio);
        log.info("FIO send");
        addressInput.sendKeys(address);
        log.info("Address send");
        phoneNumberInput.sendKeys(phoneNumber);
        log.info("Phone number send");
        emailInput.sendKeys(email);
        log.info("Email send");
        messageInput.sendKeys(message);
        log.info("Message send");
    }

    public void submitFeedbackForm() {
        submitButton.click();
    }
}
