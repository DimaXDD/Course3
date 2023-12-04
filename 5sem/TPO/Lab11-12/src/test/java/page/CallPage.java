package page;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.PageFactory;

public class CallPage extends BasePage {
    private final Logger log = LogManager.getLogger();

    @FindBy(xpath = "//*[@id=\'ClickCallBack\']")
    private WebElement callForm;

    @FindBy(xpath = "//*[@id=\'comp_5c11fd50eca000304bc4c3616bab9880\']/div/form/div[1]/div[1]/input")
    private WebElement nameInput;

    @FindBy(xpath = "//*[@id=\"comp_5c11fd50eca000304bc4c3616bab9880\"]/div/form/div[1]/div[2]/input")
    private WebElement phoneInput;

    @FindBy(xpath = "//*[@id=\'FormCall\']")
    private WebElement submitButton;

    public CallPage(WebDriver driver) {
        super(driver);
        PageFactory.initElements(this.driver, this);
    }

    public void fillCallForm(String name, String phone) throws InterruptedException {
        callForm.click();
        Thread.sleep(1000);
        nameInput.sendKeys(name);
        log.info("Name send");
        phoneInput.sendKeys(phone);
        log.info("Phone send");
        submitButton.click();
        log.info("Submit button click");
    }
}
